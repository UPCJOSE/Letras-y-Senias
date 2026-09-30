# AGENTS.md — SeñasApp

Este archivo es la guía operativa para cualquier agente o desarrollador que trabaje en este repositorio. Debe leerse antes de modificar el proyecto.

## 1. Descripción del producto

SeñasApp es una aplicación móvil académica que busca facilitar la comunicación entre personas oyentes y la comunidad sorda colombiana. La aplicación recibe texto en español y presenta una secuencia controlada de señas de Lengua de Señas Colombiana (LSC) mediante un avatar 2D.

El producto no debe presentarse como un intérprete certificado ni como un traductor automático completo de la gramática LSC. El MVP utiliza un diccionario controlado, coincidencias de palabras o frases, sugerencias ante errores y deletreo cuando no existe una seña disponible.

## 2. Fuente de verdad del diseño

Orden de prioridad para decisiones visuales y funcionales:

1. Instrucciones actuales del usuario.
2. Versión 4 del mockup de Figma de SeñasApp.
3. Los ajustes posteriores escritos para recuperar contraseña, historial, ajustes, Premium y panel administrativo.
4. La presentación `SeñasApp(corregido).pptx` como contexto académico y de negocio.

Cuando la presentación contradiga el mockup actualizado, prevalece Figma. En particular, el producto actualizado utiliza un avatar 2D y no videos de personas reales.

Decisión vigente del usuario: SeñasApp tiene únicamente los roles `individual` y `admin`. El rol empresarial y sus flujos quedan descartados aunque aparezcan en versiones anteriores de Figma o de la presentación (ver sección 16 para el registro detallado).

Enlace de referencia:

`https://www.figma.com/make/pjmcWdkLG8BGp1E2smLEcd/Se%25C3%25B1asApp-dise%25C3%25B1o-m%25C3%25B3vil`

## 3. Alcance actual

La fase actual cubre únicamente:

- Vistas completas y coherentes con el mockup.
- Navegación funcional entre pantallas.
- Comportamientos visuales locales.
- Datos de demostración para poder recorrer los flujos.
- Validación visual en Chrome con apariencia móvil.

Fuera del alcance actual:

- Módulo empresarial y corporativo: gestión de empresas, licencias institucionales, importación masiva por Excel (.xlsx), métricas B2B y roles empresariales (`companyAdmin`).
- Firestore, Storage, Functions y App Check.
- Generación, carga o edición real de archivos Rive.
- Pagos o suscripciones reales.
- Permisos y guardas de seguridad definitivos.
- Generación y firma del APK de entrega.

No agregar estas integraciones hasta que el usuario indique expresamente que comienza su fase de conexión.

## 4. Estado implementado

- Proyecto Flutter para Web y Android.
- Material Design 3.
- Diseño web centrado en un lienzo móvil de máximo 430 px.
- Arquitectura MVC ligera.
- `provider` para estado compartido.
- `go_router` para navegación.
- Autenticación con Firebase Auth (correo y contraseña) para registro, inicio de sesión y recuperación, gestionada desde `AuthService` y coordinada por `AppController`.
- Temas claro, oscuro y alto contraste.
- 18 rutas navegables.
- Catálogo local demostrativo de 36 términos.
- Normalización de texto, coincidencia por frases, alias, sugerencias y deletreo local.
- Pantallas para personas y administración global con datos simulados.
- Nueve pruebas automatizadas.
- Compilación web release verificada.

El avatar que aparece actualmente es una representación visual construida con widgets de Flutter. Debe considerarse un marcador temporal hasta la futura integración de Rive.

## 5. Arquitectura

```text
lib/
├── app.dart
├── firebase_options.dart
├── main.dart
├── controllers/
│   └── app_controller.dart
├── models/
│   └── app_models.dart
├── routes/
│   └── app_router.dart
├── services/
│   ├── auth_service.dart
│   └── translation_service.dart
├── shared/widgets/
│   └── app_widgets.dart
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

Las vistas no deben contener acceso directo a Firebase cuando se inicie la siguiente fase. Las futuras conexiones deben entrar por servicios y repositorios, coordinados desde controladores.

## 6. Rutas actuales

| Ruta | Pantalla |
| --- | --- |
| `/splash` | Presentación inicial de la marca |
| `/onboarding` | Onboarding de tres pasos |
| `/login` | Inicio de sesión y selector de rol demo |
| `/register` | Registro de una cuenta personal |
| `/forgot-password` | Recuperación de contraseña |
| `/home` | Inicio y accesos rápidos |
| `/translate` | Traductor y reproducción del avatar |
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
| `/admin/avatar-editor` | Editor demostrativo del avatar |

### Rutas descartadas (Módulo empresarial eliminado)

Las siguientes rutas pertenecían a la versión anterior con rol de empresa y fueron retiradas formalmente de `lib/routes/app_router.dart`:

| Ruta anterior | Pantalla anterior | Estado actual |
| --- | --- | --- |
| `/company` | `CompanyDashboardScreen` | Descartada y fuera de rutas |
| `/company/users` | `CompanyUsersScreen` | Descartada y fuera de rutas |
| `/company/import` | `ImportUsersScreen` | Descartada y fuera de rutas |
| `/admin/company-users` | `CompanyUsersScreen` (empresa) | Descartada y fuera de rutas |

Ningún agente o desarrollador debe restaurar estas rutas ni añadir enlaces hacia ellas.

Toda pantalla nueva debe registrarse en `lib/routes/app_router.dart`. Se debe utilizar `context.go` para cambiar una sección principal y `context.push` para abrir una pantalla secundaria que permita regresar.

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
- El selector de rol del login existe para navegar por la demostración y solo alterna entre `Persona` (`individual`) y `Admin` (`admin`).
- Los formularios no crean cuentas reales todavía.
- El editor de avatar modifica controles locales, pero no genera animaciones.
- El dashboard administrador tampoco debe contener una acción llamada “Estadísticas”.
- La aplicación reconoce únicamente los roles `individual` y `admin`. Queda prohibido reintroducir `companyAdmin` o figuras corporativas.
- El registro público crea exclusivamente cuentas personales (`/register`); no contiene selectores de tipo de cuenta ni campos para empresa. El rol administrador no se puede seleccionar allí.
- El perfil del usuario (`/profile`) no muestra opciones ni enlaces a paneles empresariales.
- El administrador gestiona personas registradas (`/admin/users`), diccionario, categorías y metadatos del avatar. No administra organizaciones, cupos ni empresas.
- El dashboard administrador (`/admin`) presenta métricas de personas registradas y traducciones globales; no incluye tarjetas de empresas ni gestión institucional.
- La importación masiva de usuarios vía Excel (.xlsx) está descartada del prototipo.
- El onboarding (`/onboarding`) no hace alusión a empresas o instituciones.
- Toda función no conectada debe comunicar claramente que es una demostración y nunca simular silenciosamente una escritura real.
- El historial demostrativo conserva siete entradas agrupadas por fecha.
- El panel administrador utiliza un menú lateral deslizable además de sus accesos rápidos.
- El menú lateral debe cerrarse antes de navegar y sus destinos secundarios deben conservar el regreso al panel administrador.

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

No añadir Gemini ni otro modelo generativo durante la fase de vistas. No describir este motor como traducción gramatical completa a LSC.

## 10. Futuras conexiones previstas

Cuando el usuario autorice la fase de integración, la arquitectura deberá admitir:

- Firebase Auth para correo y contraseña.
- Roles `individual` y `admin`.
- Colecciones `users`, `categories`, `signs` y `translations`.
- Historial real por usuario.
- Reglas que impidan el escalamiento del rol `individual` a `admin`.
- Avatar base en `assets/rive/avatar.riv` con una `animationKey` por seña.
- No crear colecciones ni modelos en Firestore para empresas (`companies`, `organizations`, `licenses`).
- No diseñar esquemas multi-inquilino (multi-tenant) ni esquemas de licencias institucionales.

El rol `admin` nunca debe estar disponible en el registro público.

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
```

Antes de entregar cambios se debe ejecutar, como mínimo:

1. `flutter analyze`.
2. `flutter test`.
3. Revisión visual de las pantallas modificadas en Chrome.

## 12. Pruebas

Las pruebas actuales están en `test/`.

- Mantener pruebas para normalización, coincidencias, sugerencias y deletreo.
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
- Presenta estados normales, vacíos y de demostración cuando correspondan.
- No depende todavía de una conexión externa.
- `flutter analyze` no reporta problemas.
- Las pruebas existentes continúan aprobando.
- Fue revisada visualmente en Chrome.

## 15. Decisiones que requieren consultar al usuario

Consultar antes de:

- Cambiar la identidad visual o apartarse de Figma.
- Eliminar o fusionar pantallas existentes.
- Comenzar Firebase, Rive, pagos o importación real.
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
   - El enrutador quedó consolidado en 18 rutas principales.

3. **Flujos de acceso y autenticación (`lib/views/access_screens.dart`)**:
   - `OnboardingScreen`: La tercera pantalla ("Úsala como persona o institución / Conecta usuarios, empresas y servicios...") fue sustituida por "Una herramienta para comunicar y aprender / Consulta el diccionario, reproduce señas y guarda tus traducciones recientes".
   - `LoginScreen`: Se eliminó la opción `Empresa` del selector demostrativo de roles.
   - `RegisterScreen`: Se removió el selector de tipo de cuenta y el campo "Nombre de la empresa". Toda cuenta creada en el flujo público es de tipo personal.

4. **Flujos de perfil (`lib/views/profile_screens.dart`)**:
   - Se eliminó el acceso condicional a "Panel empresarial" para usuarios con rol de empresa.

5. **Flujos de administración (`lib/views/management_screens.dart`)**:
   - `AdminDashboardScreen`: Se sustituyó la tarjeta de estadística "Empresas (18)" por "Traducciones (4.860)". Se renombró "Usuarios (1.284)" a "Personas (1.284)". El acceso rápido "Gestionar usuarios (Empresas e individuales)" cambió a "Gestionar personas (Personas registradas)".
   - `AdminUsersScreen`: Se retiró por completo la sección de empresas asociadas (`Clínica Erasmo Ltda.`, `Banco de Bogotá`, `Colegio San Ignacio`) y ahora lista únicamente personas individuales.

### 16.3. Directrices para agentes sobre código residual

- En `lib/views/management_screens.dart`, las clases `CompanyDashboardScreen`, `CompanyUsersScreen` e `ImportUsersScreen` quedaron huérfanas al retirarse sus rutas. Queda registrado que no forman parte de la arquitectura activa y ningún agente o desarrollador debe reincorporarlas ni enlazarlas.
- En la documentación de apoyo (`README.md` y `CONTRIBUTING.md`), cualquier mención remanente a "empresa" o a ramas de trabajo como `feature/company-users` corresponde a vestigios históricos que deben considerarse obsoletos y alinearse con esta directiva.

