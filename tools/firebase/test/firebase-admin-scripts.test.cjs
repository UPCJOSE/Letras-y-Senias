const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const path = require('node:path');
const test = require('node:test');
const { initializeApp } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');
const { getFirestore } = require('firebase-admin/firestore');

const projectId = 'demo-senasapp';
const root = path.resolve(__dirname, '..');
let app;
let auth;
let db;

test.before(async () => {
  if (!process.env.FIREBASE_AUTH_EMULATOR_HOST) {
    throw new Error('La prueba requiere Firebase Auth Emulator.');
  }
  if (!process.env.FIRESTORE_EMULATOR_HOST) {
    throw new Error('La prueba requiere Firestore Emulator.');
  }
  app = initializeApp({ projectId }, 'firebase-admin-scripts-test');
  auth = getAuth(app);
  db = getFirestore(app);
});

test.after(async () => {
  if (!app) return;
  for (const collectionName of ['users', 'signs', 'categories']) {
    const snapshot = await db.collection(collectionName).get();
    if (snapshot.empty) continue;
    const batch = db.batch();
    for (const document of snapshot.docs) batch.delete(document.ref);
    await batch.commit();
  }
  const users = await auth.listUsers();
  if (users.users.length > 0) {
    await auth.deleteUsers(users.users.map((user) => user.uid));
  }
  await app.delete();
});

function runScript(script, args) {
  const result = spawnSync(
    process.execPath,
    [path.join(root, 'scripts', script), `--project=${projectId}`, ...args],
    { cwd: root, encoding: 'utf8', env: process.env, timeout: 30000 },
  );
  if (result.error) throw result.error;
  assert.equal(result.status, 0, result.stderr || result.stdout);
  return result.stdout;
}

test('bootstrap no escribe en vista previa y asigna admin solo al aplicarlo', async () => {
  const email = 'spark-admin@example.test';
  const user = await auth.createUser({
    email,
    emailVerified: true,
    displayName: 'Admin de prueba',
  });
  const profileRef = db.collection('users').doc(user.uid);
  await profileRef.set({ displayName: 'Nombre existente', role: 'individual' });

  const preview = runScript('bootstrap-admin.cjs', [`--email=${email}`]);
  assert.match(preview, /Vista previa/);
  assert.equal((await profileRef.get()).data().role, 'individual');

  runScript('bootstrap-admin.cjs', [`--email=${email}`, '--apply']);
  const profile = (await profileRef.get()).data();
  assert.equal(profile.role, 'admin');
  assert.equal(profile.displayName, 'Nombre existente');
});
