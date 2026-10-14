const test = require('node:test');
const assert = require('node:assert/strict');
const { normalizeEmail } = require('../lib/admin-helpers.cjs');

test('normalizes the administrator email without changing its identity', () => {
  assert.equal(normalizeEmail('  Persona@Correo.COM '), 'persona@correo.com');
  assert.equal(normalizeEmail(null), '');
});
