# Movi — Traductor y aprendizaje de LSC

Aplicación móvil en **Flutter** para apoyar el aprendizaje de la **Lengua de Señas Colombiana (LSC)**.

Proyecto académico — Ingeniería de Sistemas (UPC).

---

## ¿Qué queremos construir?

Una app **inclusiva y accesible**, pensada como apoyo educativo (no como intérprete oficial).

El núcleo de la **Fase 1** es un **traductor de texto → señas**:

1. La persona escribe (o más adelante graba voz) en español.
2. Pulsa **Traducir**.
3. La app busca la palabra/frase en un **diccionario propio**.
4. Si existe, muestra el **video de la seña** en el panel superior.

> La app **no inventa señas**. Solo muestra las que estén en nuestro catálogo (videos validados).

Más adelante (fases siguientes) se pueden sumar lecciones tipo Duolingo, quiz, progreso y, en el futuro, cámara para señas → texto.

---

## Enfoque del equipo

| Principio | Cómo lo aplicamos |
|-----------|-------------------|
| Empezar simple | Primero UI y traductor; cámara e IA después |
| POO y separación de capas | Carpetas `ui`, `model` y `service` — nada de meter todo en `main.dart` |
| Flutter | Una sola base para Android e iOS, alineado al curso |
| Contenido realista | Prototipo con 30–50 señas; meta sólida ~100–200 |
| Traducción controlada | No es automática al escribir: el usuario pulsa **Traducir** |

### Flujo de la pantalla actual

```
┌─────────────────────────┐
│  Señas (videos aquí)    │  ← panel superior
├─────────────────────────┤
│  Campo de texto         │  ← tocas → se abre el teclado
│  [Traducir]  [Grabar]   │  ← Grabar: voz → texto (futuro)
└─────────────────────────┘
```

- **Panel Señas:** ahí se reproducirán los videos del diccionario.
- **Texto:** entrada manual con teclado móvil.
- **Traducir:** dispara la búsqueda en el diccionario.
- **Grabar:** reservado para grabar voz y transcribir a texto.

---

## Estado actual

UI móvil **SeñasApp** (mockup nuevo):

- Barra inferior: **Inicio** · **Diccionario** · **Perfil**
- FAB menú hamburguesa con navegación a todas las pantallas del diseño
- Inicio: traducir al instante, accesos rápidos, historial
- Diccionario LSC: búsqueda, filtros y tarjetas de señas
- Perfil: stats, historial, ajustes, Premium y cerrar sesión

---

## Arquitectura (`lib/`)

Seguimos POO y lo visto en clase: **UI**, **modelo** y **servicio** separados.

```
lib/
├── main.dart
├── model/
│   ├── entrada_sena.dart
│   └── concepto_palabra.dart       # Concepto + lista de alias
├── service/
│   ├── servicio_diccionario.dart
│   └── servicio_palabras.dart      # Añadir alias (memoria / demo)
└── ui/
    ├── aplicacion.dart
    ├── shell/
    │   └── pagina_principal.dart   # Nav: Traductor | Admin CMS
    ├── traductor/ ...
    └── admin/
        ├── pagina_admin.dart
        ├── pestanas/
        │   ├── pestana_senas.dart      # + Añadir Seña
        │   └── pestana_palabras.dart   # + Añadir alias
        └── widgets/
            ├── dialogo_nueva_sena.dart
            ├── dialogo_anadir_alias.dart
            └── tarjeta_concepto.dart
```

| Capa | Responsabilidad |
|------|-----------------|
| `ui/` | Pantallas y widgets (lo que ve el usuario) |
| `model/` | Datos (ej. `EntradaSena`, `ConceptoPalabra`) |
| `service/` | Lógica de negocio (diccionario, alias, etc.) |

---

## Cómo ejecutar

Requisitos: [Flutter](https://docs.flutter.dev/get-started/install) instalado.

```bash
cd Proyecto_movi
flutter pub get
flutter run
```

Para probar teclado y experiencia móvil, preferible **emulador Android** o un **celular físico**. En Chrome el teclado se comporta distinto.

---

## Plan por fases

| Fase | Entregable | Estado |
|------|------------|--------|
| 1 | UI del traductor + diccionario texto → señas | UI en progreso |
| 2 | Lecciones, ejercicios y progreso | Pendiente |
| 3 | Cámara: señas → texto | Futuro |
| 4 | Avatar 3D / IA generativa | Investigación futura |

---

## Documentación del equipo

- Resumen del enfoque: `RESUMEN_PROYECTO_LSC.pdf`
- Mockup inicial: carpeta `Mockup/`

---

## Pitch corto

> Desarrollamos una aplicación móvil que enseña Lengua de Señas Colombiana mediante un traductor de texto a señas con videos validados, con lecciones y progreso gamificado planificados, y reconocimiento por cámara como línea de investigación futura.
