# Carga del piloto LSC70 a Cloudinary

Esta herramienta administrativa local sube a Cloudinary las imágenes originales seleccionadas de LSC70 v2 y genera un manifiesto compatible con el importador del diccionario de SeñasApp. La API secret solo se lee en este proceso Node local; nunca se compila ni se envía a Flutter, Chrome, Android o Firebase.

## Preparación

1. Descarga LSC70 v2 desde [Mendeley Data](https://data.mendeley.com/datasets/9ssyn8tff5/2). Puedes indicar directamente el ZIP; el utilitario lee y transmite solo los fotogramas seleccionados, sin extraer ni copiar el dataset al proyecto.
2. En Cloudinary Console > Dashboard, completa `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY` y `CLOUDINARY_API_SECRET` en este directorio, en el archivo `.env` ignorado por Git. No compartas el API secret por chat.
3. Desde esta carpeta ejecuta `npm install` una sola vez.

## Vista previa y carga

Primero ejecuta la vista previa (no carga ni modifica nada):

```powershell
node scripts/upload-lsc70.cjs --source "C:\Users\garav\Downloads\LSC70.zip"
```

La vista previa debe encontrar 32 secuencias con seis fotogramas: Hola, Buenas (alias de búsqueda Bueno/Bien), Días, Tarde, Noche, A–Z y Ñ. El ZIP usa las etiquetas `HOLA`, `BUENAS`, `DIAS`, `TARDES`, `NOCHES`; la carpeta `NN` corresponde a Ñ. Si falta una etiqueta o la organización del ZIP difiere, se detiene sin subir archivos y explica qué no pudo emparejar.

Cuando la vista previa esté completa, autoriza la subida:

```powershell
node scripts/upload-lsc70.cjs --source "C:\Users\garav\Downloads\LSC70.zip" --apply
```

La herramienta usa IDs estables bajo `senasapp/lsc70/v2/`, no sobrescribe medios existentes y puede reanudarse si una subida se interrumpe. Al terminar guarda `output/lsc70-v2-cloudinary-manifest.json`. Ese manifiesto contiene URL públicas y metadatos de atribución, no secretos ni imágenes.

En SeñasApp, inicia sesión como administrador, abre Gestión del diccionario > Importar manifiesto y pega el contenido generado. La importación crea términos faltantes como borradores; no publica ni valida las señas automáticamente. No escribe en Firestore directamente.

## Seguridad y alcance

- `tools/cloudinary/.env` y `tools/cloudinary/output/` están excluidos de Git.
- Las imágenes fuente se leen desde el ZIP/carpeta que indiques y se transmiten desde memoria; el script no extrae ni copia medios al proyecto.
- No elimina recursos de Cloudinary ni sobrescribe IDs existentes.
- Si el `public_id` ya existe, reutiliza la URL actual del recurso.
- No carga recursos ausentes o ambiguos. Revisa la trazabilidad de participante y fuente antes de publicar.
- Los JPG son recursos públicos para que el diccionario los pueda mostrar. Mantén la atribución CC BY 4.0 y el aviso de que el material requiere revisión competente en LSC.
