'use strict';

const path = require('node:path');
const yauzl = require('yauzl');
const { identifyImagePath, selectSequences } = require('./lsc70-assets.cjs');

function openZip(zipPath) {
  return new Promise((resolve, reject) => {
    yauzl.open(path.resolve(zipPath), {
      lazyEntries: true,
      autoClose: false,
      decodeStrings: true,
      validateEntrySizes: true,
    }, (error, zipfile) => error ? reject(error) : resolve(zipfile));
  });
}

async function discoverSequencesInZip(zipPath) {
  const zipfile = await openZip(zipPath);
  try {
    const groups = new Map();
    await new Promise((resolve, reject) => {
      zipfile.on('error', reject);
      zipfile.on('end', resolve);
      zipfile.on('entry', (entry) => {
        try {
          if (!entry.fileName.endsWith('/')) {
            const identity = identifyImagePath(entry.fileName);
            if (identity) {
              const { subset, sourceLabel, participantId, index } = identity;
              const key = `${subset}|${sourceLabel}|${participantId}`;
              if (!groups.has(key)) groups.set(key, []);
              groups.get(key).push({ entry, index });
            }
          }
          zipfile.readEntry();
        } catch (error) {
          reject(error);
        }
      });
      zipfile.readEntry();
    });
    return { ...selectSequences(groups), zipfile };
  } catch (error) {
    zipfile.close();
    throw error;
  }
}

module.exports = { discoverSequencesInZip };
