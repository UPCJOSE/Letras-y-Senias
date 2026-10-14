'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { cloudinaryPublicId, discoverSequences, identifyImagePath, TARGETS } = require('../lib/lsc70-assets.cjs');

function createDataset(root, targets = TARGETS, participants = ['Per1']) {
  for (const target of targets) {
    for (const participant of participants) {
      for (let index = 1; index <= 6; index += 1) {
        const folder = path.join(root, target.subset, participant, target.datasetFolder);
        fs.mkdirSync(folder, { recursive: true });
        fs.writeFileSync(path.join(folder, `${participant}_${target.datasetFolder}_${index - 1}.jpg`), 'fixture');
      }
    }
  }
}

test('detecta piloto completo, mantiene participante y ordena los seis fotogramas', (t) => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'lsc70-assets-'));
  t.after(() => fs.rmSync(root, { recursive: true, force: true }));
  createDataset(root, TARGETS, ['Per2', 'Per10']);

  const result = discoverSequences(root);
  assert.deepEqual(result.issues, []);
  assert.equal(result.sequences.length, 32);
  assert.equal(result.sequences.find((item) => item.term === 'Hola').participantId, 'Per2');
  assert.equal(result.sequences.find((item) => item.term === 'Buenas').sourceLabel, 'BUENAS');
  assert.deepEqual(
    result.sequences[0].frames.map((frame) => frame.index),
    [0, 1, 2, 3, 4, 5],
  );
  assert.equal(result.sequences.find((item) => item.sourceLabel === 'Ñ').datasetFolder, 'NN');
  assert.equal(result.sequences.filter((item) => item.kind === 'letter').length, 27);
});

test('reporta las secuencias ausentes y no inventa fotogramas', (t) => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'lsc70-assets-'));
  t.after(() => fs.rmSync(root, { recursive: true, force: true }));
  createDataset(root, TARGETS.slice(1, 3));

  const result = discoverSequences(root);
  assert.equal(result.sequences.length, 2);
  assert.equal(result.issues.length, 30);
});

test('genera public IDs estables y namespaced por dataset, seña y participante', () => {
  assert.equal(
    cloudinaryPublicId({ subset: 'LSC70W', sourceLabel: 'Hello', participantId: 'Per7' }, 3),
    'senasapp/lsc70/v2/LSC70W/hello/per7/frame_03',
  );
  assert.equal(
    cloudinaryPublicId({ subset: 'LSC70AN', sourceLabel: 'Ñ', datasetFolder: 'NN', participantId: 'Per07' }, 1),
    'senasapp/lsc70/v2/LSC70AN/nn/per07/frame_01',
  );
});

test('interpreta las etiquetas y nombres originales del ZIP LSC70 v2', () => {
  assert.deepEqual(
    identifyImagePath('LSC70/LSC70W/Per01/BUENAS/Per01_BUENOS_0.jpg'),
    { subset: 'LSC70W', sourceLabel: 'BUENAS', participantId: 'Per01', index: 0 },
  );
  assert.deepEqual(
    identifyImagePath('LSC70/LSC70AN/Per01/NN/Per01_NN_5.jpg'),
    { subset: 'LSC70AN', sourceLabel: 'Ñ', participantId: 'Per01', index: 5 },
  );
});
