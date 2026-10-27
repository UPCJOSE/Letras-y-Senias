# SeñasApp

Aplicación Flutter web y Android para consultar en Firebase un diccionario controlado de Lengua de Señas Colombiana (LSC). No es un intérprete certificado ni traduce toda la gramática LSC. La reproducción visual usa secuencias fotográficas LSC70 alojadas en Cloudinary, referenciadas por Firestore.

## Estado en Firebase Spark

- Firebase Auth para registro personal, inicio de sesión y recuperación.
- Firestore para perfiles, preferencias, categorías, señas, traducciones e historial.
- App Check configurado en el cliente; se puede usar sin Blaze.
- Sin Cloud Functions ni invitaciones por correo. Las conversaciones se comparten mediante un código temporal de seis caracteres. Los roles se leen desde `users/{uid}.role` en Firestore.
- El registro público siempre crea `individual`; un administrador autenticado puede crear cuentas `individual` o `admin` desde Gestión de personas.
- La app no incluye un catálogo local de respaldo: solo consulta señas de Firestore con `status: validated` y `active: true`.
- La app no empaqueta videos ni fotogramas de señas. Firestore almacena metadatos y URL HTTPS públicas de Cloudinary. Las URLs se agregan desde Gestión del diccionario con un manifiesto JSON; la app no sube medios ni contiene secretos de Cloudinary.
- Firebase Storage no está disponible en Spark; usarlo requiere Blaze. Por eso el MVP no sube ni descarga videos desde Storage.
- El antiguo seed de 36 palabras no corresponde a LSC70 y fue retirado. No existe catálogo local de respaldo.
- La lectura de voz sigue siendo opcional.

Spark ofrece cuotas gratuitas limitadas para Firestore, pero no permite desplegar Cloud Functions. El proyecto usa la base de datos predeterminada; no se deben crear bases adicionales ni activar servicios que pidan facturación.

## Conversación compartida

Las personas autenticadas pueden crear una sala y compartir su código de seis caracteres con alguien que tenga el perfil de comunicación opuesto (oyente/sorda). Los mensajes se guardan en `conversations/{code}/messages`; la otra persona puede leerlos como texto y consultar las señas disponibles en el diccionario publicado de Firestore. Estos mensajes no se agregan al historial normal de traducciones.

El perfil de comunicación se elige al registrarse o desde la pantalla de conversación para cuentas existentes; es independiente del rol `individual`/`admin`. La función requiere las reglas locales de `firestore.rules`. Estas reglas no se despliegan automáticamente: revisa sus cambios y solicita autorización antes de desplegarlas en Firebase.

## Ejecutar la app

Para conectar el proyecto Firebase real:

```powershell
C:\Users\garav\development\flutter\bin\flutter.bat pub get
C:\Users\garav\development\flutter\bin\flutter.bat run -d chrome
```

Esta opción puede leer o escribir en el proyecto real según la acción y las reglas desplegadas. App Check de desarrollo imprime un token de depuración; no lo subas al repositorio y regístralo en Firebase Console solo si habilitaste enforcement.

## Emuladores opcionales para desarrollo

Instala las herramientas locales y arranca Auth y Firestore Emulator en una terminal:

```powershell
npm --prefix tools/firebase install
npm --prefix tools/firebase run emulators:start
```

En otra terminal, ejecuta la app en Chrome con la conexión local habilitada:

```powershell
C:\Users\garav\development\flutter\bin\flutter.bat run -d chrome --dart-define=USE_FIREBASE_EMULATORS=true
```

El flag solo funciona en debug. Chrome y escritorio usan `127.0.0.1`; el emulador Android usa `10.0.2.2`. La configuración actual no expone los emuladores a la red local, por lo que no se debe usar con un teléfono físico sin configurar primero un enlace de red seguro.

En modo emulador, App Check no se activa porque Auth y Firestore locales no validan App Check remoto. En modo debug con Firebase real se usa el proveedor de depuración; en release web configura la clave pública reCAPTCHA:

```powershell
C:\Users\garav\development\flutter\bin\flutter.bat build web --release --dart-define=FIREBASE_WEB_RECAPTCHA_SITE_KEY=CLAVE_PUBLICA_RECAPTCHA
```

## Firebase Console y roles

Confirma que el proveedor de correo/contraseña está habilitado y que existe la base predeterminada de Firestore. Las reglas de `firestore.rules` y los índices se mantienen en el proyecto, pero no se publican automáticamente; revisa el efecto antes de desplegarlos porque las reglas cambian el acceso a los documentos existentes.

Para el primer administrador (solo una vez), crea una cuenta personal, verifica el correo y deja que la app cree su perfil. En Firebase Console abre Firestore, entra en `users`, abre el documento cuyo ID es el UID de esa cuenta y cambia `role` de `individual` a `admin`. También puedes usar la herramienta local con permisos autorizados; el comando es de vista previa y no escribe sin `--apply`:

```powershell
npm --prefix tools/firebase run bootstrap:admin -- --project=senasapp-a0515 --email=CORREO_VERIFICADO
```

Tras revisar que el proyecto y correo sean correctos, agrega `--apply` para asignar `role: admin` en `users/{uid}`. No se usan custom claims. Después de configurar este primer administrador, podrá crear cuentas Persona o Administrador desde la app. El usuario debe iniciar sesión para que la app lea su rol actualizado.

## Medios LSC70

El piloto visual comprende cinco señas del subconjunto LSC70W y las 27 letras del subconjunto LSC70AN, incluida Ñ. Consulta `docs/LSC70_CONTENT.md` para atribución y trazabilidad, y `tools/cloudinary/README.md` para preparar las credenciales locales, previsualizar y subir los recursos con la API de Cloudinary. El proceso genera un manifiesto para importar desde Gestión del diccionario; los registros nuevos quedan como borrador. La disponibilidad real depende de completar la carga y revisar las señas con una persona competente en LSC.

En Gestión del diccionario, el administrador puede usar **Validar todas** para publicar en un lote las entradas pendientes con medio LSC70 válido, después de confirmar que ya revisó su correspondencia con LSC. Las entradas sin recurso visual permanecen como borrador. La acción no realiza una revisión lingüística automática.

## Verificación

Desde la raíz:

```powershell
C:\Users\garav\development\flutter\bin\flutter.bat analyze
C:\Users\garav\development\flutter\bin\flutter.bat test
C:\Users\garav\development\flutter\bin\flutter.bat build web --release
```

Pruebas locales de Node y reglas:

```powershell
npm --prefix tools/firebase test
npm --prefix tools/firebase run test:rules
npm --prefix tools/firebase run test:scripts
```

`test:rules` usa Firestore Emulator y no despliega reglas ni modifica Firebase real.

## Decisiones vigentes

- Roles únicos: `individual` y `admin`; el registro público nunca permite escoger `admin`.
- Los administradores crean cuentas Persona o Administrador desde el panel; el registro público no permite escoger el rol.
- No hay empresas, licencias institucionales, carga Excel ni colecciones empresariales.
- Los datos remotos existentes se conservan; no se borran invitaciones antiguas aunque ya no se utilicen.
- El usuario se encarga de los commits; no se crean commits automáticamente.

Consulta [AGENTS.md](AGENTS.md) y [CONTRIBUTING.md](CONTRIBUTING.md) para las reglas del proyecto y la colaboración.
