# SeñasApp

Prototipo móvil en Flutter para traducir texto a una secuencia controlada de señas de Lengua de Señas Colombiana mediante un avatar 2D.

## Avance actual

- Flutter web y Android inicializados.
- Arquitectura MVC con `provider` y navegación con `go_router`.
- 18 rutas navegables: splash, onboarding, autenticación, traductor, diccionario, perfil y administración.
- Motor local de normalización, coincidencia por frases, sugerencias y deletreo.
- Catálogo demostrativo de 36 términos.
- Tema claro, oscuro y alto contraste.
- Datos locales de demostración. Firebase y Rive todavía no están conectados.

## Ejecutar en Chrome

```powershell
C:\Users\garav\development\flutter\bin\flutter.bat pub get
C:\Users\garav\development\flutter\bin\flutter.bat run -d chrome
```

## Verificar

```powershell
C:\Users\garav\development\flutter\bin\flutter.bat analyze
C:\Users\garav\development\flutter\bin\flutter.bat test
C:\Users\garav\development\flutter\bin\flutter.bat build web
```

## Estado de las integraciones

Las pantallas usan datos locales para permitir una revisión visual inmediata. Los botones que requerirán Firebase muestran estados de demostración y no crean cuentas ni escriben información externa. El avatar actual es un marcador visual y debe reemplazarse por un archivo Rive validado en LSC.

Consulta [CONTRIBUTING.md](CONTRIBUTING.md) para el flujo de trabajo del equipo.
