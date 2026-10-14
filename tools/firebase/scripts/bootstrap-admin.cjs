const { getAuth } = require('firebase-admin/auth');
const { FieldValue, getFirestore } = require('firebase-admin/firestore');
const { initializeFirebaseAdminApp } = require('../lib/firebase-admin-app.cjs');
const { normalizeEmail } = require('../lib/admin-helpers.cjs');

function argument(name) {
  const prefix = `--${name}=`;
  return process.argv.find((value) => value.startsWith(prefix))?.slice(prefix.length);
}

async function main() {
  const email = normalizeEmail(argument('email'));
  const projectId = argument('project');
  const apply = process.argv.includes('--apply');
  if (!email || !projectId) {
    throw new Error(
      'Uso: npm run bootstrap:admin -- --project=ID --email=CORREO [--apply]',
    );
  }
  const app = initializeFirebaseAdminApp(projectId, 'bootstrap-admin', [
    'auth',
    'firestore',
  ]);
  try {
    const auth = getAuth(app);
    const db = getFirestore(app);
    const user = await auth.getUserByEmail(email);
    if (user.emailVerified !== true) {
      throw new Error('Verifica primero el correo de la cuenta que será administrador.');
    }
    const profileRef = db.collection('users').doc(user.uid);
    const profile = await profileRef.get();
    if (profile.exists && profile.data().active === false) {
      throw new Error('La cuenta está desactivada y no puede ser promovida.');
    }

    if (!apply) {
      console.log(
      `Vista previa: se asignaría role=admin al perfil de la cuenta verificada indicada en ${projectId}. No se escribió ningún dato.`,
      );
      console.log('Agrega --apply para confirmar esta operación puntual.');
      return;
    }

    const timestamp = FieldValue.serverTimestamp();
    if (profile.exists) {
      await profileRef.update({ role: 'admin', updatedAt: timestamp });
    } else {
      await profileRef.set({
        displayName: user.displayName || '',
        email,
        role: 'admin',
        active: true,
        plan: 'free',
        preferences: {
          darkMode: false,
          highContrast: false,
          notifications: true,
          playbackSpeed: 1,
        },
        createdAt: timestamp,
        updatedAt: timestamp,
      });
    }
    console.log('Administrador inicial configurado en users/{uid}.role.');
  } finally {
    await app.delete();
  }
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
