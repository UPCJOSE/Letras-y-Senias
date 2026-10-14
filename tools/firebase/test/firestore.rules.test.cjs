const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require('@firebase/rules-unit-testing');
const {
  collection,
  doc,
  getDoc,
  getDocs,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
} = require('firebase/firestore');

let environment;
const profile = (uid, email, role = 'individual') => ({
  displayName: uid,
  email,
  role,
  active: true,
  plan: 'free',
  preferences: {
    darkMode: false,
    highContrast: false,
    notifications: true,
    playbackSpeed: 1,
  },
  createdAt: serverTimestamp(),
  updatedAt: serverTimestamp(),
});

test.before(async () => {
  environment = await initializeTestEnvironment({
    projectId: 'demo-senasapp',
    firestore: {
      rules: fs.readFileSync(path.resolve(__dirname, '../../../firestore.rules'), 'utf8'),
    },
  });
});

test.after(async () => {
  await environment.cleanup();
});

test.beforeEach(async () => {
  await environment.clearFirestore();
  await environment.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, 'users/person-a'), {
      displayName: 'Persona A', email: 'a@example.test', role: 'individual', active: true,
    });
    await setDoc(doc(db, 'users/person-b'), {
      displayName: 'Persona B', email: 'b@example.test', role: 'individual', active: true,
    });
    await setDoc(doc(db, 'users/admin-a'), {
      displayName: 'Admin A', email: 'admin@example.test', role: 'admin', active: true,
    });
    await setDoc(doc(db, 'signs/validated'), {
      term: 'Hola', status: 'validated', active: true,
    });
    await setDoc(doc(db, 'signs/draft'), {
      term: 'Borrador', status: 'draft', active: false,
    });
    await setDoc(doc(db, 'translations/history-a'), {
      userId: 'person-a', originalText: 'Hola', createdAt: new Date(),
    });
    await setDoc(doc(db, 'translations/history-b'), {
      userId: 'person-b', originalText: 'Ayuda', createdAt: new Date(),
    });
  });
});

test('una persona solo crea perfil propio y no puede escalar su rol', async () => {
  const db = environment.authenticatedContext('person-a', {
    email: 'a@example.test',
  }).firestore();
  const newUserDb = environment.authenticatedContext('person-c', {
    email: 'c@example.test',
  }).firestore();
  await assertSucceeds(
    setDoc(doc(newUserDb, 'users/person-c'), profile('person-c', 'c@example.test')),
  );
  const escalationDb = environment.authenticatedContext('person-d', {
    email: 'd@example.test',
  }).firestore();
  await assertFails(
    setDoc(
      doc(escalationDb, 'users/person-d'),
      profile('person-d', 'd@example.test', 'admin'),
    ),
  );
  await assertFails(updateDoc(doc(db, 'users/person-a'), { role: 'admin' }));
  await assertFails(getDoc(doc(db, 'users/person-b')));
});

test('un administrador puede crear perfiles persona y admin; una persona no', async () => {
  const adminDb = environment.authenticatedContext('admin-a').firestore();
  await assertSucceeds(
    setDoc(doc(adminDb, 'users/person-created-by-admin'),
      profile('person-created-by-admin', 'new-person@example.test')),
  );
  await assertSucceeds(
    setDoc(doc(adminDb, 'users/admin-created-by-admin'),
      profile('admin-created-by-admin', 'new-admin@example.test', 'admin')),
  );

  const personDb = environment.authenticatedContext('person-a').firestore();
  await assertFails(
    setDoc(doc(personDb, 'users/another-admin'),
      profile('another-admin', 'another-admin@example.test', 'admin')),
  );
});

test('una persona puede guardar solo preferencias permitidas', async () => {
  const db = environment.authenticatedContext('person-a', {
    email: 'a@example.test',
  }).firestore();
  await assertSucceeds(updateDoc(doc(db, 'users/person-a'), {
    preferences: { darkMode: true, highContrast: false, notifications: true, playbackSpeed: 1.5 },
    updatedAt: serverTimestamp(),
  }));
  await assertFails(updateDoc(doc(db, 'users/person-a'), {
    preferences: { darkMode: true, playbackSpeed: 9 },
    updatedAt: serverTimestamp(),
  }));
});

test('el historial es privado y no se pueden insertar traducciones ajenas', async () => {
  const db = environment.authenticatedContext('person-a', {
    email: 'a@example.test',
  }).firestore();
  const validTranslation = {
    userId: 'person-a', originalText: 'Hola', normalizedText: 'hola',
    signs: [], missingWords: [], spelling: [], signCount: 0,
    hasMissingWords: false, createdAt: serverTimestamp(),
  };
  await assertSucceeds(setDoc(doc(db, 'translations/new-a'), validTranslation));
  await assertFails(getDoc(doc(db, 'translations/history-b')));
  await assertFails(setDoc(doc(db, 'translations/new-b'), {
    ...validTranslation, userId: 'person-b',
  }));
});

test('solo señas publicadas se leen públicamente y solo admin escribe catálogo', async () => {
  const personDb = environment.authenticatedContext('person-a').firestore();
  const visible = query(
    collection(personDb, 'signs'),
    where('status', '==', 'validated'),
    where('active', '==', true),
  );
  const result = await assertSucceeds(getDocs(visible));
  if (result.size !== 1) throw new Error('Solo se esperaba leer la seña validada.');
  await assertFails(getDoc(doc(personDb, 'signs/draft')));
  await assertFails(setDoc(doc(personDb, 'signs/not-allowed'), { status: 'draft' }));

  const adminDb = environment.authenticatedContext('admin-a').firestore();
  await assertSucceeds(setDoc(doc(adminDb, 'signs/managed'), { status: 'draft' }));
  await assertSucceeds(getDocs(collection(adminDb, 'users')));
});

test('el catálogo validado es público y el historial requiere dueño o admin', async () => {
  const anonymousDb = environment.unauthenticatedContext().firestore();
  const personDb = environment.authenticatedContext('person-a').firestore();
  await assertSucceeds(getDoc(doc(anonymousDb, 'signs/validated')));
  await assertFails(getDoc(doc(anonymousDb, 'translations/history-a')));
  await assertSucceeds(getDoc(doc(personDb, 'translations/history-a')));
});

test('los medios exigen HTTPS Cloudinary y solo admin puede modificarlos', async () => {
  const personDb = environment.authenticatedContext('person-a').firestore();
  const adminDb = environment.authenticatedContext('admin-a').firestore();
  const media = {
    provider: 'cloudinary', type: 'imageSequence',
    frameUrls: ['https://res.cloudinary.com/demo/image/upload/hello_1.jpg'],
    frameDurationMs: 167, dataset: 'LSC70', datasetVersion: '2', subset: 'LSC70W',
    sourceLabel: 'Hello', participantId: 'Per01', license: 'CC BY 4.0',
    attribution: 'LSC70 v2 DOI',
  };
  await assertFails(updateDoc(doc(personDb, 'signs/validated'), { media }));
  await assertFails(setDoc(doc(adminDb, 'signs/bad-media'), {
    status: 'draft', active: false, media: { ...media, frameUrls: ['http://example.com/frame.jpg'] },
  }));
  await assertSucceeds(updateDoc(doc(adminDb, 'signs/validated'), { media }));
  await assertSucceeds(getDoc(doc(environment.unauthenticatedContext().firestore(), 'signs/validated')));
});
