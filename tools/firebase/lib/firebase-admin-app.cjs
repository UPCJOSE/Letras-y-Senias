const { applicationDefault, initializeApp } = require('firebase-admin/app');

function initializeFirebaseAdminApp(projectId, name, requiredEmulators) {
  const emulatorVariables = {
    auth: 'FIREBASE_AUTH_EMULATOR_HOST',
    firestore: 'FIRESTORE_EMULATOR_HOST',
  };

  if (projectId.startsWith('demo-')) {
    const unavailable = requiredEmulators.filter(
      (service) => !process.env[emulatorVariables[service]],
    );
    if (unavailable.length > 0) {
      throw new Error(
        `El proyecto demo requiere emuladores activos: ${unavailable.join(', ')}.`,
      );
    }
    return initializeApp({ projectId }, name);
  }

  return initializeApp({ credential: applicationDefault(), projectId }, name);
}

module.exports = { initializeFirebaseAdminApp };
