'use strict';

const fs = require('node:fs');
const path = require('node:path');

const WORDS = [
  { subset: 'LSC70W', datasetFolder: 'HOLA', sourceLabel: 'HOLA', term: 'Hola', animationKey: 'hola' },
  { subset: 'LSC70W', datasetFolder: 'BUENAS', sourceLabel: 'BUENAS', term: 'Buenas', animationKey: 'buenas', aliases: ['Bueno', 'Bien'] },
  { subset: 'LSC70W', datasetFolder: 'DIAS', sourceLabel: 'DIAS', term: 'Días', animationKey: 'dias' },
  { subset: 'LSC70W', datasetFolder: 'TARDES', sourceLabel: 'TARDES', term: 'Tarde', animationKey: 'tarde', aliases: ['Tardes'] },
  { subset: 'LSC70W', datasetFolder: 'NOCHES', sourceLabel: 'NOCHES', term: 'Noche', animationKey: 'noche', aliases: ['Noches'] },
];

const LETTERS = [...'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ'].map((letter) => ({
  subset: 'LSC70AN',
  datasetFolder: letter === 'Ñ' ? 'NN' : letter,
  sourceLabel: letter,
  term: letter,
  animationKey: letter,
}));

const TARGETS = [...WORDS, ...LETTERS];

function normalize(value) {
  return value
    .normalize('NFC')
    .replace(/[^\p{L}\p{N}]/gu, '')
    .toLocaleLowerCase('en');
}

function findSubset(parts) {
  const normalized = parts.map(normalize);
  if (normalized.includes('lsc70w')) return 'LSC70W';
  if (normalized.includes('lsc70an')) return 'LSC70AN';
  return null;
}

function findParticipant(parts, basename) {
  const text = [...parts, basename].join('/');
  const match = text.match(/(?:^|[\\/_-])per\s*(\d+)(?=[\\/_-]|[a-zñ0-9])/i)
    ?? basename.match(/^per\s*(\d+)/i);
  return match ? `Per${match[1]}` : null;
}

function labelFromName(segment, subset) {
  const value = normalize(segment.replace(/\.[^.]+$/, ''));
  const target = TARGETS.find((entry) => entry.subset === subset &&
    [entry.datasetFolder, entry.sourceLabel, entry.term, ...(entry.aliases ?? [])]
      .some((label) => value === normalize(label)));
  if (target) return target.sourceLabel;
  const filenameMatch = value.match(/^per\d+([a-zñ]+)\d+$/i);
  if (!filenameMatch) return null;
  const label = filenameMatch[1].toLocaleUpperCase('es');
  return TARGETS.find((entry) => entry.subset === subset &&
    [entry.datasetFolder, entry.sourceLabel, entry.term, ...(entry.aliases ?? [])]
      .some((candidate) => normalize(candidate) === normalize(label)))?.sourceLabel ?? null;
}

function frameIndex(basename) {
  const match = basename.replace(/\.[^.]+$/, '').match(/(\d+)$/);
  return match ? Number(match[1]) : null;
}

function walkImages(root) {
  const results = [];
  const pending = [root];
  while (pending.length) {
    const current = pending.pop();
    for (const item of fs.readdirSync(current, { withFileTypes: true })) {
      const fullPath = path.join(current, item.name);
      if (item.isDirectory()) pending.push(fullPath);
      else if (/\.jpe?g$/i.test(item.name)) results.push(fullPath);
    }
  }
  return results;
}

function identifyImagePath(relativePath) {
  const normalizedPath = relativePath.replace(/\\/g, '/');
  const relativeParts = normalizedPath.split('/').filter(Boolean);
  if (relativeParts.length < 2) return null;
  const subset = findSubset(relativeParts);
  if (!subset) return null;
  const basename = relativeParts.at(-1);
  if (!/\.jpe?g$/i.test(basename)) return null;
  const participantId = findParticipant(relativeParts, basename);
  if (!participantId) return null;

  let sourceLabel = null;
  for (const part of relativeParts.slice(0, -1)) {
    sourceLabel = labelFromName(part, subset);
    if (sourceLabel) break;
  }
  sourceLabel ??= labelFromName(basename, subset);
  if (!sourceLabel) return null;
  const index = frameIndex(basename);
  if (index === null) return null;
  return { subset, sourceLabel, participantId, index };
}

function selectSequences(groups) {
  const chosen = [];
  const issues = [];
  for (const target of TARGETS) {
    const candidates = [...groups.entries()]
      .filter(([key]) => key.startsWith(`${target.subset}|${target.sourceLabel}|`))
      .map(([key, frames]) => ({
        participantId: key.split('|')[2],
        frames: frames.sort((a, b) => a.index - b.index),
      }))
      .filter(({ frames }) => new Set(frames.map((frame) => frame.index)).size >= 6)
      .sort((a, b) => a.participantId.localeCompare(b.participantId, undefined, { numeric: true }));

    if (candidates.length === 0) {
      issues.push(`${target.subset}/${target.datasetFolder}: no se encontró participante con seis fotogramas`);
      continue;
    }
    const selected = candidates[0];
    const firstSix = selected.frames.slice(0, 6);
    chosen.push({
      ...target,
      kind: target.subset === 'LSC70AN' ? 'letter' : 'word',
      participantId: selected.participantId,
      frames: firstSix,
    });
  }
  return { sequences: chosen, issues };
}

function discoverSequences(sourceRoot) {
  const root = path.resolve(sourceRoot);
  if (!fs.existsSync(root) || !fs.statSync(root).isDirectory()) {
    throw new Error(`No existe una carpeta de dataset válida: ${root}`);
  }

  const groups = new Map();
  for (const filePath of walkImages(root)) {
    const identity = identifyImagePath(path.relative(root, filePath));
    if (!identity) continue;
    const { subset, sourceLabel, participantId, index } = identity;
    const key = `${subset}|${sourceLabel}|${participantId}`;
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push({ filePath, index });
  }
  return selectSequences(groups);
}

function cloudinaryPublicId(entry, frameNumber) {
  const label = normalize(entry.datasetFolder ?? entry.sourceLabel);
  const participant = entry.participantId.toLocaleLowerCase('en');
  return `senasapp/lsc70/v2/${entry.subset}/${label}/${participant}/frame_${String(frameNumber).padStart(2, '0')}`;
}

module.exports = {
  TARGETS,
  cloudinaryPublicId,
  discoverSequences,
  identifyImagePath,
  selectSequences,
  normalize,
};
