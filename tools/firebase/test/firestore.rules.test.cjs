const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require('@firebase/rules-unit-testing');
const {
  addDoc,
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

test('el tipo de comunicación es opcional, válido y lo edita su dueño', async () => {
  const db = environment.authenticatedContext('person-a', {
    email: 'a@example.test',
  }).firestore();
  await environment.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), 'users/person-a'), {
      ...profile('person-a', 'a@example.test'),
      createdAt: new Date(),
      updatedAt: new Date(),
    });
  });
  const newDb = environment.authenticatedContext('person-c', {
    email: 'c@example.test',
  }).firestore();
  await assertSucceeds(
    setDoc(doc(newDb, 'users/person-c'), {
      ...profile('person-c', 'c@example.test'),
      communicationProfile: 'deaf',
    }),
  );
  const invalidDb = environment.authenticatedContext('person-d', {
    email: 'd@example.test',
  }).firestore();
  await assertFails(
    setDoc(doc(invalidDb, 'users/person-d'), {
      ...profile('person-d', 'd@example.test'),
      communicationProfile: 'otro',
    }),
  );
  await assertSucceeds(
    updateDoc(doc(db, 'users/person-a'), {
      communicationProfile: 'hearing',
      updatedAt: serverTimestamp(),
    }),
  );
  await assertFails(
    updateDoc(doc(db, 'users/person-a'), {
      communicationProfile: 'robot',
      updatedAt: serverTimestamp(),
    }),
  );
});

const waitingConversation = (hostId, hostProfile = 'hearing') => ({
  code: 'ABC234',
  hostId,
  hostName: hostId,
  hostProfile,
  guestId: null,
  guestName: '',
  guestProfile: null,
  participantIds: [hostId],
  status: 'waiting',
  createdAt: serverTimestamp(),
  updatedAt: serverTimestamp(),
});

test('las conversaciones se crean con código válido y solo se leen por ID', async () => {
  const hostDb = environment.authenticatedContext('person-a').firestore();
  const otherDb = environment.authenticatedContext('person-b').firestore();
  const anonymousDb = environment.unauthenticatedContext().firestore();
  await assertSucceeds(
    setDoc(
      doc(hostDb, 'conversations/ABC234'),
      waitingConversation('person-a'),
    ),
  );
  await assertFails(
    setDoc(doc(hostDb, 'conversations/ABC235'), {
      ...waitingConversation('person-b'),
      code: 'ABC235',
    }),
  );
  await assertFails(
    setDoc(doc(hostDb, 'conversations/abc236'), {
      ...waitingConversation('person-a'),
      code: 'abc236',
    }),
  );
  await assertSucceeds(getDoc(doc(otherDb, 'conversations/ABC234')));
  await assertFails(getDoc(doc(anonymousDb, 'conversations/ABC234')));
  await assertFails(getDocs(collection(otherDb, 'conversations')));
});

test('solo una persona de otro tipo puede unirse y la sala admite dos', async () => {
  const hostDb = environment.authenticatedContext('person-a').firestore();
  await setDoc(
    doc(hostDb, 'conversations/ABC234'),
    waitingConversation('person-a'),
  );
  const join = (uid, guestProfile) => ({
    guestId: uid,
    guestName: uid,
    guestProfile,
    participantIds: ['person-a', uid],
    status: 'active',
    updatedAt: serverTimestamp(),
  });
  const sameTypeDb = environment.authenticatedContext('person-b').firestore();
  await assertFails(
    updateDoc(
      doc(sameTypeDb, 'conversations/ABC234'),
      join('person-b', 'hearing'),
    ),
  );
  const impersonatorDb = environment.authenticatedContext('person-b').firestore();
  await assertFails(
    updateDoc(doc(impersonatorDb, 'conversations/ABC234'), {
      ...join('person-b', 'deaf'),
      guestId: 'person-x',
    }),
  );
  const guestDb = environment.authenticatedContext('person-b').firestore();
  await assertSucceeds(
    updateDoc(
      doc(guestDb, 'conversations/ABC234'),
      join('person-b', 'deaf'),
    ),
  );
  const thirdDb = environment.authenticatedContext('person-c').firestore();
  await assertFails(
    updateDoc(doc(thirdDb, 'conversations/ABC234'), {
      guestId: 'person-c',
      guestName: 'person-c',
      guestProfile: 'deaf',
      participantIds: ['person-a', 'person-b', 'person-c'],
      status: 'active',
      updatedAt: serverTimestamp(),
    }),
  );
});

test('los mensajes son privados de la sala, exigen sala activa y no se editan', async () => {
  await environment.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), 'conversations/ABC234'), {
      ...waitingConversation('person-a'),
      guestId: 'person-b',
      guestName: 'person-b',
      guestProfile: 'deaf',
      participantIds: ['person-a', 'person-b'],
      status: 'active',
      createdAt: new Date(),
      updatedAt: new Date(),
    });
  });
  const message = (uid, profile = 'hearing') => ({
    senderId: uid,
    senderName: uid,
    senderProfile: profile,
    text: 'Hola',
    createdAt: serverTimestamp(),
  });
  const hostDb = environment.authenticatedContext('person-a').firestore();
  const guestDb = environment.authenticatedContext('person-b').firestore();
  const outsiderDb = environment.authenticatedContext('person-c').firestore();
  const messages = (db) => collection(db, 'conversations/ABC234/messages');
  await assertSucceeds(addDoc(messages(hostDb), message('person-a')));
  await assertSucceeds(
    addDoc(messages(guestDb), message('person-b', 'deaf')),
  );
  await assertFails(addDoc(messages(hostDb), message('person-b')));
  await assertFails(
    addDoc(messages(hostDb), { ...message('person-a'), text: '' }),
  );
  await assertFails(
    addDoc(messages(hostDb), {
      ...message('person-a'),
      text: 'x'.repeat(1001),
    }),
  );
  await assertFails(addDoc(messages(outsiderDb), message('person-c')));
  await assertSucceeds(getDocs(messages(guestDb)));
  await assertFails(getDocs(messages(outsiderDb)));

  await assertSucceeds(
    updateDoc(doc(hostDb, 'conversations/ABC234'), {
      status: 'closed',
      updatedAt: serverTimestamp(),
    }),
  );
  await assertFails(addDoc(messages(hostDb), message('person-a')));
  await assertFails(
    updateDoc(doc(outsiderDb, 'conversations/ABC234'), {
      status: 'closed',
      updatedAt: serverTimestamp(),
    }),
  );
});
