# Trabajo colaborativo

Cada integrante debe trabajar desde su propia cuenta de GitHub. No se deben compartir contraseñas, tokens ni alterar el autor de commits para simular participación.

## Flujo recomendado

1. El propietario invita a cada integrante desde **Settings > Collaborators**.
2. Cada persona clona el repositorio e identifica Git con su propio nombre y correo:

   ```bash
   git config user.name "Nombre real"
   git config user.email "correo-vinculado-a-github@example.com"
   ```

3. Cada integrante crea una rama desde `main`:

   ```bash
   git switch -c feature/nombre-corto
   ```

4. Realiza una tarea concreta, ejecuta `flutter analyze` y `flutter test`, y crea commits pequeños.
5. Publica la rama y abre un Pull Request. Otro integrante revisa antes de combinarlo.

## Reparto sugerido para el lunes

| Integrante | Rama | Aporte real sugerido |
| --- | --- | --- |
| Integrante 1 | `feature/auth-validation` | Validaciones y mensajes de Login, Registro y Recuperar contraseña |
| Integrante 2 | `feature/dictionary-filters` | Búsqueda, categorías y estados vacíos del diccionario |
| Integrante 3 | `feature/profile-history` | Perfil, ajustes, historial y estados vacíos |
| Integrante 4 | `feature/accessibility-qa` | Pruebas de tamaños, contraste, textos y navegación en Chrome |

No se debe asignar a una persona una rama ya terminada únicamente para que la vuelva a confirmar. Su commit debe contener un cambio verificable propio.
