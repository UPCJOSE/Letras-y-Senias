# AGENTS.md — SeñasApp

Este archivo es la guía operativa para cualquier agente o desarrollador que trabaje en este repositorio. Debe leerse antes de modificar el proyecto.

## 1. Descripción del producto

SeñasApp es una aplicación móvil académica que busca facilitar la comunicación entre personas oyentes y la comunidad sorda colombiana. La aplicación recibe texto en español y consulta señas publicadas en Firestore. El piloto visual usa secuencias fotográficas del dataset LSC70 v2 alojadas en Cloudinary; no crea ni simula un avatar.

El producto no debe presentarse como un intérprete certificado ni como un traductor automático completo de la gramática LSC. El MVP utiliza un diccionario controlado, coincidencias de palabras o frases, sugerencias ante errores y deletreo cuando no existe una seña disponible.

## 2. Fuente de verdad del diseño

Orden de prioridad para decisiones visuales y funcionales:

1. Instrucciones actuales del usuario.
2. Versión 4 del mockup de Figma de SeñasApp.
3. Los ajustes posteriores escritos para recuperar contraseña, historial, ajustes, Premium y panel administrativo.
4. La presentación `SeñasApp(corregido).pptx` como contexto académico y de negocio.

Cuando la presentación contradiga el mockup actualizado, prevalece Figma; las decisiones posteriores del usuario sobre LSC70 y la ausencia de avatar prevalecen sobre los dibujos de avatar del mockup. El usuario decidió que la app no debe usar catálogos, animaciones ni imágenes locales de prueba. La traducción consume exclusivamente señas publicadas en Firestore; el contenido visual viene de URL remotas configuradas, no de assets empaquetados.

Decisión vigente del usuario: SeñasApp tiene únicamente los roles `individual` y `admin`. El rol empresarial y sus flujos quedan descartados aunque aparezcan en versiones anteriores de Figma o de la presentación (ver sección 16 para el registro detallado).

Enlace de referencia:

`https://www.figma.com/make/pjmcWdkLG8BGp1E2smLEcd/Se%25C3%25B1asApp-dise%25C3%25B1o-m%25C3%25B3vil`

## 3. Alcance actual

La fase visual LSC70 está implementada en traducción, deletreo, diccionario e historial. Firestore guarda metadatos y Cloudinary sirve fotogramas JPG por HTTPS. El piloto comprende Hola, Buenas (alias Bueno/Bien), Días, Tarde, Noche y A–Z más Ñ. El cargador firmado `tools/cloudinary/` lee el ZIP sin extraerlo, sube los recursos por API y genera el manifiesto que se importa desde el panel admin. No hay respaldo visual dentro de Flutter. La síntesis de voz queda como fase posterior, todavía no implementada.

El usuario indicó que ya realizó la carga y comprobó los flujos principales. Esto no sustituye una verificación de las URL, documentos y estados del proyecto Firebase/Cloudinary actualmente conectado: no declarar el piloto remoto completo o lingüísticamente validado sin comprobarlo. La prueba externa de generar un avatar que hiciera «Hola» no reprodujo la seña fielmente y añadió movimientos; esa vía se descartó para el contenido de traducción (sección 10).

Fuera del alcance de esta fase:

- Módulo empresarial/corporativo, licencias institucionales, importación Excel y rol `companyAdmin`.
- Cloud Functions e invitaciones. El primer administrador se configura una sola vez desde Firebase Console o la herramienta local; luego el admin puede crear cuentas desde la aplicación.
- Audio, síntesis de voz y archivos de voz.
- Carga de medios desde Flutter y cualquier secreto de Cloudinary dentro de Flutter, web, APK o Firebase.
- Cobros o suscripciones reales.
- Despliegue a producción, migración remota del catálogo y bootstrap del primer administrador sin autorización operativa expresa.
- Firma del APK de entrega.

## 4. Estado implementado

- Proyecto Flutter para Web y Android.
- Material Design 3.
- Diseño web centrado en un lienzo móvil de máximo 430 px.
- Arquitectura MVC ligera.
- `provider` para estado compartido.
- `go_router` para navegación: `StatefulShellRoute.indexedStack` conserva el estado de Inicio, Traducir, Diccionario y Perfil; las rutas secundarias usan una transición breve y permiten regresar.
- Autenticación con Firebase Auth (correo/contraseña), recuperación, perfil Firestore y sesión. El rol se lee desde `users/{uid}.role`; no se usan custom claims.
- Conexión opcional a Auth/Firestore Emulator, solo debug y con flag explícito.
- Temas claro, oscuro y alto contraste.
- 17 rutas navegables.
- Diccionario consultado exclusivamente desde Firestore; el seed local antiguo de 36 términos fue retirado.
- Normalización que preserva Ñ, coincidencia por frases y alias, sugerencias y deletreo con letras publicadas.
- Modelo opcional de medios LSC70, manifiesto administrativo con vista previa y reproductor de secuencias remotas sin fallback local.
- Gestión del diccionario con botón «Validar todas» para publicar en lote señas pendientes con medio LSC70 utilizable, después de una confirmación explícita de revisión humana; no constituye validación lingüística automática.
- Panel administrativo sin menú lateral; acceso directo a Personas y Diccionario. El detalle del diccionario se presenta como hoja ajustada al ancho móvil, y Deletreo dispone de cabecera y regreso al origen.
- Diccionario público, historial, preferencias, listado de personas y métricas conectados a Firestore.
- Reglas e índices Firestore para acceso por dueño y administrador; no existe backend Cloud Functions.
- Pruebas Flutter y pruebas de reglas con Firebase Emulator Suite.
- La traducción no contiene un catálogo ni medios locales de respaldo. Solo reconoce señas activas y validadas en Firestore.

La pantalla informa cuando falta un medio remoto o falla la URL. La atribución, licencia y trazabilidad por participante se documentan en `docs/LSC70_CONTENT.md`. Firebase Storage no se utiliza; el proyecto permanece compatible con Spark.

## 5. Arquitectura

```text
lib/
├── app.dart
├── firebase_options.dart
├── main.dart
├── controllers/
│   └── app_controller.dart
├── repositories/
│   ├── user_repository.dart
│   ├── sign_repository.dart
│   └── translation_repository.dart
├── models/
│   └── app_models.dart
├── routes/
│   └── app_router.dart
├── services/
│   ├── auth_service.dart
│   ├── firebase_app_check_service.dart
│   ├── firebase_emulator_settings.dart
│   ├── lsc70_manifest_service.dart
│   ├── shared_latest_stream.dart
│   └── translation_service.dart
├── shared/widgets/
│   ├── app_widgets.dart
│   └── lsc70_player.dart
├── theme/
│   └── app_theme.dart
└── views/
    ├── access_screens.dart
    ├── core_screens.dart
    ├── management_screens.dart
    └── profile_screens.dart
```

Responsabilidades:

- `models`: estructuras de datos sin widgets.
- `views`: composición visual y eventos de interfaz.
- `controllers`: estado y coordinación de flujos.
- `services`: lógica reutilizable independiente de la interfaz.
- `routes`: registro central de navegación.
- `theme`: colores, tipografía y estilos globales.
- `shared/widgets`: componentes reutilizables.

Las vistas no deben acceder directamente a Firebase. La autenticación actual entra por `AuthService` y es coordinada desde `AppController`; las futuras conexiones deben conservar esta separación mediante servicios y repositorios.

## 6. Rutas actuales

| Ruta | Pantalla |
| --- | --- |
| `/splash` | Presentación inicial de la marca |
| `/onboarding` | Onboarding de tres pasos |
| `/login` | Inicio de sesión |
| `/register` | Registro de una cuenta personal |
| `/forgot-password` | Recuperación de contraseña |
| `/home` | Inicio y accesos rápidos |
| `/translate` | Traducción consultando el diccionario de Firestore |
| `/not-found` | Sugerencias para una palabra no encontrada |
| `/spelling` | Deletreo letra por letra |
| `/dictionary` | Diccionario y categorías |
| `/profile` | Perfil y accesos del usuario |
| `/history` | Historial de traducciones |
| `/settings` | Preferencias y accesibilidad |
| `/premium` | Comparación informativa de planes |
| `/admin` | Dashboard administrador |
| `/admin/users` | Gestión de personas registradas |
| `/admin/dictionary` | Gestión del diccionario |

### Rutas descartadas

La ruta `/admin/avatar-editor` se retiró porque sus controles eran locales y no generaban ni reproducían animaciones reales. No volver a enlazar ese prototipo.

Las siguientes rutas pertenecían a la versión anterior con rol de empresa y fueron retiradas formalmente de `lib/routes/app_router.dart`:

| Ruta anterior | Pantalla anterior | Estado actual |
| --- | --- | --- |
| `/company` | `CompanyDashboardScreen` | Descartada y fuera de rutas |
| `/company/users` | `CompanyUsersScreen` | Descartada y fuera de rutas |
| `/company/import` | `ImportUsersScreen` | Descartada y fuera de rutas |
| `/admin/company-users` | `CompanyUsersScreen` (empresa) | Descartada y fuera de rutas |

Ningún agente o desarrollador debe restaurar estas rutas ni añadir enlaces hacia ellas.

Toda pantalla nueva debe registrarse en `lib/routes/app_router.dart`. Las cuatro secciones principales pertenecen a `StatefulShellRoute.indexedStack`; su barra inferior permanece visible y conserva el estado de cada sección. Se debe utilizar `context.go` para cambiar una sección principal y `context.push` para abrir una pantalla secundaria que permita regresar. Un acceso directo a Deletreo sin traducción activa redirige a Traducir.

## 7. Identidad visual

Colores principales:

- Azul: `#2563EB`.
- Blanco: `#FFFFFF`.
- Fondo gris claro: `#F5F7FA`.
- Verde de confirmación: `#22C55E`.
- Texto oscuro: `#102A43`.

Reglas visuales:

- Mantener Material Design 3.
- Usar esquinas redondeadas entre 16 y 24 px.
- Conservar espacios amplios y jerarquía clara.
- Priorizar iconos outline.
- Mantener tamaños táctiles mínimos de aproximadamente 48 px.
- Evitar introducir otra identidad, gradientes excesivos o componentes que no pertenezcan al sistema actual.
- En escritorio, centrar la app como un dispositivo móvil; no reproducir el panel lateral de Figma porque pertenece a la herramienta de prototipado.
- En Android, permitir que la interfaz use todo el ancho disponible.
- Todos los textos visibles deben estar en español.

Los tokens de color y el tema viven en `lib/theme/app_theme.dart`. No duplicar colores principales directamente en múltiples vistas si pueden añadirse a `AppColors`.

## 8. Reglas funcionales del prototipo

- Premium es únicamente informativo y no cambia el plan del usuario.
- El login no permite seleccionar roles. El rol se lee de `users/{uid}.role` en Firestore; una persona no puede cambiar su propio rol. Un administrador autenticado puede crear cuentas `individual` o `admin` desde Gestión de personas.
- Registro personal, inicio/cierre de sesión, recuperación, perfil y preferencias usan Firebase Auth/Firestore.
- El dashboard administrador tampoco debe contener una acción llamada “Estadísticas”.
- La aplicación reconoce únicamente los roles `individual` y `admin`. Queda prohibido reintroducir `companyAdmin` o figuras corporativas.
- El registro público crea exclusivamente cuentas personales (`/register`); no contiene selectores de tipo de cuenta ni campos para empresa. El rol administrador no se puede seleccionar allí.
- El perfil del usuario (`/profile`) no muestra opciones ni enlaces a paneles empresariales.
- El administrador consulta las personas registradas (`/admin/users`), crea cuentas personales o administrativas y gestiona el diccionario y sus categorías. No administra organizaciones, cupos ni empresas.
- El dashboard administrador (`/admin`) presenta métricas de personas registradas y traducciones globales; no incluye tarjetas de empresas ni gestión institucional.
- La importación masiva de usuarios vía Excel (.xlsx) está descartada del prototipo.
- El onboarding (`/onboarding`) no hace alusión a empresas o instituciones.
- No usar perfiles, métricas, traducciones ni usuarios ficticios como fallback silencioso. Mostrar estados vacíos, carga o error.
- El historial guarda la entrada y señas resueltas por Firestore, por usuario autenticado. Invitados no escriben datos remotos.
- El antiguo seed local de 36 términos fue retirado. El manifiesto LSC70 crea entradas nuevas como borradores; el diccionario público muestra solo señas activas y validadas. No borrar documentos remotos preexistentes al importar.
- No hay invitaciones. Un administrador autenticado puede crear cuentas `individual` y `admin`; el alta no cambia la sesión actual.
- Para probar Auth/Firestore sin tocar el proyecto real, usar `USE_FIREBASE_EMULATORS=true` en debug. En release este modo falla de forma cerrada.
- App Check está configurado en cliente para web/Android; sus claves de proveedor y enforcement requieren preparación explícita en Firebase Console.
- El panel administrador no usa menú lateral: presenta las métricas y los accesos directos a personas y diccionario. Las categorías se gestionan desde el diccionario y Premium se consulta desde Perfil.
- Gestión del diccionario permite validar en lote las señas pendientes que tengan un medio LSC70 utilizable. Requiere confirmación expresa de revisión LSC; no publica borradores sin recurso visual ni verifica lingüísticamente las señas por sí sola.
- Las pantallas secundarias de administración deben conservar el regreso al panel; la cabecera del panel permite volver al Perfil incluso al abrir `/admin` directamente.

## 9. Motor local de traducción

La implementación actual está en `lib/services/translation_service.dart`.

Comportamiento actual:

1. Convierte el texto a minúsculas.
2. Elimina tildes, signos y espacios repetidos.
3. Reduce repeticiones evidentes como `holaaa`.
4. Busca primero frases de varias palabras.
5. Busca palabras y alias exactos.
6. Calcula sugerencias mediante distancia de Levenshtein.
7. Prepara deletreo si no encuentra coincidencias.

La lógica de coincidencia se ejecuta en el cliente sobre el catálogo publicado que llega de Firestore; «local» no significa catálogo ni medios locales de respaldo. No añadir Gemini ni otro modelo generativo para inventar señas. No describir este motor como traducción gramatical completa a LSC.

## 10. Medios visuales LSC70 y siguiente fase

### Decisión vigente: secuencias originales LSC70 en Cloudinary

No crear avatar. Usar las fotografías originales de LSC70 v2, sin archivos multimedia locales. Cloudinary sirve los JPG; Firestore mantiene las URL y metadatos.

### Resultado de la prueba con avatar generado

El usuario probó generar la seña «Hola» con un avatar mediante Google Flow/Veo y reportó que la seña no concordaba y que el video hacía movimientos de más. El material generado no se incorpora al diccionario, no sustituye LSC70 y no debe presentarse como una seña correcta. No seguir esta vía para generar automáticamente señas de la app sin una nueva decisión expresa y revisión competente en LSC. Un personaje decorativo para marca u onboarding sería una decisión visual distinta: no sería el reproductor de traducciones ni está implementado actualmente.

#### Alternativas externas exploradas

Se revisaron las plataformas sugeridas para evitar crear el personaje desde cero. Ninguna se integra actualmente como reproductor de SeñasApp:

| Opción | Hallazgo | Decisión para SeñasApp |
| --- | --- | --- |
| [Sign.mt / Rylo Translate](https://sign.mt/) | La interfaz pública muestra inglés, alemán y francés y el proyecto describe una cadena de texto a SignWriting/poses/video. Su documentación advierte que el enfoque de glosas no expresa toda la gramática de una lengua de señas; los modelos más recientes aparecen como vista previa de investigación no disponible al público. No se encontró soporte LSC ni un SDK Flutter listo para integrar. | No usar como motor LSC ni como dependencia del MVP. Puede servir para investigación académica, no como contenido validado. |
| [Hand Talk](https://api-docs.handtalk.me/v1/en/introduction) | El SDK documentado ofrece Libras y ASL, no LSC; es JavaScript/WebGL y necesita un token de acceso recibido mediante contrato. El hecho de que la app de consumo sea gratuita no hace gratuita ni integrable su API para este proyecto. | Descartar para el MVP por idioma, plataforma y acceso. |
| [SignLanguageAI.com](https://www.signlanguageai.com/) | La herramienta pública se centra en ASL e inglés y ofrece una secuencia de palabras/diccionario desde su propio sitio. No se encontró un SDK o API pública para incorporarla a Flutter ni soporte de LSC. | Útil solo como referencia de experiencia de usuario; no integrar ni reutilizar sus señas. |
| [Viggle](https://viggle.ai/pricing) | El plan web gratuito anuncia hasta cinco videos diarios; es una herramienta de generación/transferencia de movimiento, no de traducción. Su API es un flujo aparte con créditos iniciales, trabajos asíncronos y almacenamiento propio de los resultados. La transferencia visual no certifica la precisión de manos, expresiones ni significado lingüístico. | Se puede probar únicamente para producir clips piloto fuera de la app, con material propio o con permiso y revisión competente en LSC. No depender de su API ni presentar clips como traducción correcta sin validar. |
| [Dataset LSC70 v2](https://data.mendeley.com/datasets/9ssyn8tff5/2) | LSC70W incluye `Hello`, `Good`, `Days`, `Afternoon` y `Night`; LSC70AN incluye 27 letras con Ñ. Licencia CC BY 4.0. | Integrado en la app para secuencias remotas Cloudinary; `tools/cloudinary/` sube el piloto con API firmada y entrega el manifiesto para importación como borrador. |
| Diccionario y videos públicos de [INSOR](https://educativo.insor.gov.co/diccionario/) | Es una fuente de consulta de LSC; que un video sea público no implica automáticamente permiso para descargarlo, modificarlo o redistribuirlo dentro de la app. | Usar como referencia y solicitar permiso antes de incorporar sus archivos. |

El contrato del reproductor y la importación se describen en `docs/LSC70_CONTENT.md`. Atribución: Muñoz Galindez, Villota Coral y Vargas Cañas, *Data in Brief* 58 (2025), CC BY 4.0, DOI `10.1016/j.dib.2024.111213`; dataset DOI `10.17632/9ssyn8tff5.2`. El artículo y la licencia no reemplazan la revisión competente de LSC.

#### Guardado de señas generadas o consultadas

- No generar ni guardar automáticamente un clip distinto por cada texto de usuario en el servidor: una API externa puede costar, cambiar o fallar y no hay un generador LSC verificado disponible para el MVP.
- No incluir clips, fotogramas ni avatares de prueba dentro de `assets/`.
- No presentar controles de reproducción si el documento de Firestore no tiene un recurso remoto utilizable.
- Firebase Cloud Storage requiere Blaze y no está disponible bajo Spark. Mientras el proyecto siga en Spark, cualquier recurso multimedia debe alojarse en un servicio remoto ya aprobado por el usuario; no inventar una URL ni subir contenido a terceros.

Estado de la fase visual:

1. El cliente consulta señas `validated` y `active` desde Firestore; las letras usan `kind: letter`.
2. El utilitario Node local sube el piloto con credenciales de `tools/cloudinary/.env` (ignorado por Git) y genera el manifiesto; el administrador lo revisa/importa. Documentos nuevos quedan como borradores y los existentes solo reciben `media`.
3. El reproductor ordena los fotogramas, reproduce solo por acción, permite pausa/reinicio/velocidad y detiene recursos al salir. No hay fallback local.
4. No publicar una seña hasta documentar participante, fuente, licencia y revisión competente.

La síntesis de voz en español queda para otra fase; no generar ni almacenar audios.

## 11. Comandos del proyecto

En esta máquina Flutter está instalado en:

`C:\Users\garav\development\flutter`

Comandos de PowerShell:

```powershell
C:\Users\garav\development\flutter\bin\flutter.bat pub get
C:\Users\garav\development\flutter\bin\flutter.bat run -d chrome
C:\Users\garav\development\flutter\bin\flutter.bat analyze
C:\Users\garav\development\flutter\bin\flutter.bat test
C:\Users\garav\development\flutter\bin\flutter.bat build web --release
npm --prefix tools/firebase install
npm --prefix tools/firebase test
npm --prefix tools/firebase run test:rules
npm --prefix tools/firebase run test:scripts
npm --prefix tools/firebase run emulators:start
C:\Users\garav\development\flutter\bin\flutter.bat run -d chrome --dart-define=USE_FIREBASE_EMULATORS=true
```

La configuración del proyecto Firebase se encuentra en `firebase.json`. App Check para Chrome en desarrollo usa un token de depuración que debe registrarse en Firebase Console; en release web se pasa `--dart-define=FIREBASE_WEB_RECAPTCHA_SITE_KEY=...`.

Antes de entregar cambios se debe ejecutar, como mínimo:

1. `flutter analyze`.
2. `flutter test`.
3. Revisión visual de las pantallas modificadas en Chrome.

## 12. Pruebas

Las pruebas actuales están en `test/`.

- Mantener pruebas para normalización, coincidencias, sugerencias y deletreo con fixtures explícitos; no usar un catálogo local de fallback.
- Mantener pruebas del reproductor remoto, manifiesto, navegación y validación por lote; una prueba local no demuestra que las URL de Cloudinary o los documentos remotos del proyecto activo sean correctos.
- Ejecutar `npm --prefix tools/firebase run test:rules` para verificar privacidad, roles, catálogo e historial con Firestore Emulator.
- Agregar una prueba de widget cuando una modificación cambie un flujo importante.
- No corregir una prueba eliminándola sin justificar por qué dejó de representar el comportamiento esperado.
- Revisar desbordamientos a 390 × 844 y también en ventanas de menor altura.

## 13. Reglas de Git y colaboración

El usuario se encarga de los commits. Los agentes no deben crear commits, modificar autores, hacer `push`, abrir Pull Requests ni reescribir el historial salvo petición explícita posterior.

También se debe cumplir lo siguiente:

- No usar cuentas ajenas ni compartir credenciales.
- No crear commits desde varias identidades para aparentar colaboración.
- Cada colaborador debe aportar cambios reales desde su cuenta y rama.
- No descartar cambios existentes del usuario.
- No ejecutar `git reset --hard`, `git checkout --` ni operaciones destructivas sin autorización explícita.
- Se permite consultar `git status` y `git diff` para revisar el trabajo.

Existe una guía adicional en `CONTRIBUTING.md`.

## 14. Criterio de finalización de una vista

Una vista se considera terminada cuando:

- Respeta el mockup y los tokens visuales existentes.
- Se adapta al lienzo móvil sin overflow.
- Tiene navegación de entrada y salida.
- Presenta estados normales, vacíos y errores con información clara; no incluir modos o datos de demostración en la app.
- No introduce servicios, credenciales ni fuentes de medios adicionales a Firebase y Cloudinary sin autorización.
- `flutter analyze` no reporta problemas.
- Las pruebas existentes continúan aprobando.
- Fue revisada visualmente en Chrome.

## 15. Decisiones que requieren consultar al usuario

Consultar antes de:

- Cambiar la identidad visual o apartarse de Figma.
- Eliminar o fusionar pantallas existentes.
- Desplegar rules o índices a Firebase; escribir datos del catálogo en un proyecto remoto; ejecutar el bootstrap administrativo.
- Integrar el runtime de animación elegido, síntesis de voz, almacenamiento de medios o pagos reales.
- Modificar el modelo de roles.
- Crear repositorios remotos o publicar el código.
- Crear commits o modificar el historial de Git.

Para ajustes visuales menores, correcciones de navegación y mejoras de accesibilidad coherentes con estas reglas, avanzar directamente y verificar el resultado.

## 16. Registro de eliminación del módulo empresarial

Este apartado formaliza y documenta la eliminación definitiva de la funcionalidad empresarial dentro del proyecto SeñasApp.

### 16.1. Razón del cambio

En las fases tempranas de diseño y en la presentación académica inicial (`SeñasApp(corregido).pptx`) se exploró un modelo B2B para colegios, clínicas y empresas, que requería administración de cupos institucionales, importación de empleados y gestión corporativa.

Se tomó la decisión firme de descartar por completo este modelo para enfocar SeñasApp en su misión central: una herramienta accesible, directa y ágil orientada a la interacción entre personas particulares y el aprendizaje de la Lengua de Señas Colombiana (LSC).

### 16.2. Detalle de cambios efectuados en el proyecto

1. **Modelos de datos (`lib/models/app_models.dart`)**:
   - Se removió `companyAdmin` del enum `AppRole` (quedando exclusivamente `individual` y `admin`).
   - Se eliminó la clase de modelo `CompanySummary`.

2. **Enrutamiento (`lib/routes/app_router.dart`)**:
   - Se eliminaron formalmente las 4 rutas empresariales: `/company`, `/company/users`, `/company/import` y `/admin/company-users`.
    - El enrutador quedó consolidado en 17 rutas principales.

3. **Flujos de acceso y autenticación (`lib/views/access_screens.dart`)**:
   - `OnboardingScreen`: La tercera pantalla ("Úsala como persona o institución / Conecta usuarios, empresas y servicios...") fue sustituida por "Una herramienta para comunicar y aprender / Consulta el diccionario y guarda tus traducciones recientes".
   - `LoginScreen`: Se eliminó la opción `Empresa` del selector de roles.
   - `RegisterScreen`: Se removió el selector de tipo de cuenta y el campo "Nombre de la empresa". Toda cuenta creada en el flujo público es de tipo personal.

4. **Flujos de perfil (`lib/views/profile_screens.dart`)**:
   - Se eliminó el acceso condicional a "Panel empresarial" para usuarios con rol de empresa.

5. **Flujos de administración (`lib/views/management_screens.dart`)**:
   - `AdminDashboardScreen`: Se sustituyó la tarjeta de estadística "Empresas (18)" por "Traducciones (4.860)". Se renombró "Usuarios (1.284)" a "Personas (1.284)". El acceso rápido "Gestionar usuarios (Empresas e individuales)" cambió a "Gestionar personas (Personas registradas)".
   - `AdminUsersScreen`: Se retiró por completo la sección de empresas asociadas (`Clínica Erasmo Ltda.`, `Banco de Bogotá`, `Colegio San Ignacio`) y ahora lista únicamente personas individuales.

   Las cifras entre paréntesis y los nombres de empresas de este registro son ejemplos de la interfaz antigua, no datos actuales. Las métricas vigentes se consultan en Firestore.

### 16.3. Limpieza del código residual

- Se eliminaron de `lib/views/management_screens.dart` las clases huérfanas `CompanyDashboardScreen`, `CompanyUsersScreen` e `ImportUsersScreen`, junto con sus datos y componentes auxiliares.
- `CONTRIBUTING.md` ya no propone ramas ni tareas relacionadas con empresas o importación masiva.
- Ningún agente o desarrollador debe reincorporar estos flujos ni añadir nuevos enlaces, modelos o rutas corporativas.
