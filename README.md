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

**Solo frontend / UI** del traductor (mockup implementado).

- Pantalla blanca, botones azules y detalles negros.
- Panel de señas con estado vacío y placeholder al traducir.
- Campo de texto con teclado en móvil.
- `model` y `service` existen como esqueleto para la siguiente fase (sin lógica real aún).

---

## Arquitectura (`lib/`)

Seguimos POO y lo visto en clase: **UI**, **modelo** y **servicio** separados.

```
lib/
├── main.dart                          # Solo arranca la app
├── model/
│   └── entrada_sena.dart              # Entrada del diccionario (palabra + video)
├── service/
│   └── servicio_diccionario.dart      # Búsqueda en el catálogo (por implementar)
└── ui/
    ├── aplicacion.dart                # MaterialApp, tema y colores
    └── traductor/
        ├── pagina_traductor.dart
        └── widgets/
            ├── panel_video_senas.dart
            ├── barra_controles_video.dart
            └── panel_entrada_texto.dart
```

| Capa | Responsabilidad |
|------|-----------------|
| `ui/` | Pantallas y widgets (lo que ve el usuario) |
| `model/` | Datos (ej. `EntradaSena`) |
| `service/` | Lógica de negocio (diccionario, más adelante voz, etc.) |

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
