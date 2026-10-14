'use strict';

const fs = require('node:fs');
const path = require('node:path');
const cloudinary = require('cloudinary').v2;
const { cloudinaryPublicId, discoverSequences } = require('../lib/lsc70-assets.cjs');
const { discoverSequencesInZip } = require('../lib/lsc70-zip.cjs');

const TOOL_ROOT = path.resolve(__dirname, '..');

function loadLocalEnv() {
  const envPath = path.join(TOOL_ROOT, '.env');
  if (!fs.existsSync(envPath)) return;
  for (const rawLine of fs.readFileSync(envPath, 'utf8').split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith('#')) continue;
    const separator = line.indexOf('=');
    if (separator < 1) continue;
    const name = line.slice(0, separator).trim();
    const value = line.slice(separator + 1).trim().replace(/^(['"])(.*)\1$/, '$2');
    if (!process.env[name]) process.env[name] = value;
  }
}

function parseArgs(args) {
  const options = { apply: false, source: null };
  for (let index = 0; index < args.length; index += 1) {
    if (args[index] === '--apply') options.apply = true;
    else if (args[index] === '--source') options.source = args[++index] ?? null;
    else if (args[index] === '--help' || args[index] === '-h') options.help = true;
    else throw new Error(`Argumento no reconocido: ${args[index]}`);
  }
  return options;
}

function loadCredentials() {
  loadLocalEnv();
  const credentials = {
    cloudName: process.env.CLOUDINARY_CLOUD_NAME?.trim(),
    apiKey: process.env.CLOUDINARY_API_KEY?.trim(),
    apiSecret: process.env.CLOUDINARY_API_SECRET?.trim(),
  };
  const missing = Object.entries(credentials).filter(([, value]) => !value).map(([key]) => key);
  if (missing.length) {
    throw new Error(`Completa las tres variables de Cloudinary en tools/cloudinary/.env (faltan: ${missing.join(', ')}).`);
  }
  cloudinary.config({
    cloud_name: credentials.cloudName,
    api_key: credentials.apiKey,
    api_secret: credentials.apiSecret,
    secure: true,
  });
}

async function uploadFrame(filePath, publicId) {
  try {
    const result = await cloudinary.uploader.upload(filePath, {
      public_id: publicId,
      overwrite: false,
      unique_filename: false,
      use_filename: false,
      resource_type: 'image',
      format: 'jpg',
    });
    return result.secure_url;
  } catch (error) {
    if (error.http_code !== 409 && error.name !== 'Already exists') throw error;
    const existing = await cloudinary.api.resource(publicId, { resource_type: 'image' });
    return existing.secure_url;
  }
}

async function uploadZipFrame(zipfile, entry, publicId) {
  try {
    return await new Promise((resolve, reject) => {
      zipfile.openReadStream(entry, (streamError, source) => {
        if (streamError) return reject(streamError);
        const destination = cloudinary.uploader.upload_stream({
          public_id: publicId,
          overwrite: false,
          unique_filename: false,
          use_filename: false,
          resource_type: 'image',
          format: 'jpg',
        }, (uploadError, result) => {
          if (uploadError) reject(uploadError);
          else resolve(result.secure_url);
        });
        source.on('error', (error) => destination.destroy(error));
        destination.on('error', reject);
        source.pipe(destination);
      });
    });
  } catch (error) {
    if (error.http_code !== 409 && error.name !== 'Already exists') throw error;
    const existing = await cloudinary.api.resource(publicId, { resource_type: 'image' });
    return existing.secure_url;
  }
}

async function run(options) {
  if (options.help || !options.source) {
    console.log('Uso: node scripts/upload-lsc70.cjs --source <carpeta-extraida> [--apply]');
    console.log('Sin --apply solo muestra la vista previa y no escribe en Cloudinary.');
    return;
  }

  const sourcePath = path.resolve(options.source);
  const isZip = fs.statSync(sourcePath).isFile() && /\.zip$/i.test(sourcePath);
  const discovered = isZip
    ? await discoverSequencesInZip(sourcePath)
    : discoverSequences(sourcePath);
  const { sequences, issues, zipfile } = discovered;
  try {
  console.log(`Secuencias detectadas: ${sequences.length}/32; fotogramas: ${sequences.length * 6}/192.`);
  for (const entry of sequences) {
    console.log(`- ${entry.term.padEnd(8)} ${entry.subset}/${entry.sourceLabel} · ${entry.participantId} · ${entry.frames.length} cuadros`);
  }
  if (issues.length) {
    for (const issue of issues) console.error(`FALTA: ${issue}`);
    throw new Error('La vista previa está incompleta. No se ha iniciado ninguna subida.');
  }
  if (!options.apply) {
    console.log('\nVista previa completa. Revisa selección y participante; añade --apply para subir las imágenes.');
    return;
  }

  loadCredentials();
  const entries = [];
  let uploaded = 0;
  for (const entry of sequences) {
    const frameUrls = [];
    for (let index = 0; index < entry.frames.length; index += 1) {
      const publicId = cloudinaryPublicId(entry, index + 1);
      const frame = entry.frames[index];
      const url = zipfile
        ? await uploadZipFrame(zipfile, frame.entry, publicId)
        : await uploadFrame(frame.filePath, publicId);
      frameUrls.push(url);
      uploaded += 1;
      if (uploaded % 12 === 0 || uploaded === 192) {
        console.log(`Subidos/reutilizados ${uploaded}/192 fotogramas.`);
      }
    }
    entries.push({
      term: entry.term,
      animationKey: entry.animationKey,
      ...(entry.aliases ? { aliases: entry.aliases } : {}),
      kind: entry.subset === 'LSC70AN' ? 'letter' : 'word',
      category: entry.subset === 'LSC70AN' ? 'Alfabeto' : 'LSC70',
      subset: entry.subset,
      sourceLabel: entry.sourceLabel,
      participantId: entry.participantId,
      frameDurationMs: 167,
      frameUrls,
    });
  }

  const outputDirectory = path.join(TOOL_ROOT, 'output');
  fs.mkdirSync(outputDirectory, { recursive: true });
  const manifestPath = path.join(outputDirectory, 'lsc70-v2-cloudinary-manifest.json');
  fs.writeFileSync(manifestPath, `${JSON.stringify({ entries }, null, 2)}\n`, 'utf8');
  console.log(`\nManifiesto guardado en: ${manifestPath}`);
  console.log('Siguiente paso: importar ese JSON desde Gestión del diccionario en SeñasApp.');
  } finally {
    if (zipfile) zipfile.close();
  }
}

if (require.main === module) {
  run(parseArgs(process.argv.slice(2))).catch((error) => {
    console.error(`Error: ${error.message}`);
    process.exitCode = 1;
  });
}

module.exports = { loadCredentials, parseArgs, run };
