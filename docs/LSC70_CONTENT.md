# Contenido LSC70 para SeñasApp

## Alcance y fuente

Se utilizará LSC70 versión 2, de Muñoz Galindez, Villota Coral y Vargas Cañas, publicado en *Data in Brief* (2025), DOI `10.1016/j.dib.2024.111213`, con licencia CC BY 4.0. La versión de datos es [Mendeley Data 2](https://data.mendeley.com/datasets/9ssyn8tff5/2). El artículo informa que LSC70W contiene palabras comunes y LSC70AN contiene el alfabeto de 27 letras, incluida Ñ. Cada seña se representa con seis fotogramas JPG. En el ZIP de v2 las categorías de palabras se guardan en carpetas `HOLA`, `BUENAS`, `DIAS`, `TARDES`, `NOCHES`; las letras A–Z usan su carpeta y la Ñ usa `NN`. En palabras, el nombre del archivo puede diferir ligeramente del nombre de la carpeta (por ejemplo, `BUENAS`/`BUENOS`), así que la trazabilidad conserva la etiqueta de carpeta.

LSC70W se describe en el artículo con las glosas inglesas `Hello`, `Good`, `Days`, `Afternoon` y `Night`, mientras que el ZIP etiqueta las carpetas con las formas `HOLA`, `BUENAS`, `DIAS`, `TARDES` y `NOCHES`. Se mostrarán como **Hola**, **Buenas** (alias de búsqueda: Bueno/Bien), **Días**, **Tarde** y **Noche**. No se deben confundir estas señas individuales con una traducción completa de frases compuestas. LSC70AN contiene A–Z y Ñ; se incorporarán solo las 27 letras del alfabeto.

## Trazabilidad de medios

Antes de importar cada entrada, registrar el participante real y conservar sus fotogramas en orden. No mezclar participantes en una secuencia. El administrador pega las URLs HTTPS de Cloudinary en un manifiesto; Cloudinary no se escribe desde Flutter. Todas las entradas nuevas quedan como borrador, sin publicación automática.

| Término visible | Subconjunto | Etiqueta original | Participante | Estado de revisión LSC |
| --- | --- | --- | --- | --- |
| Hola | LSC70W | HOLA | El cargador selecciona un participante completo de forma determinista | Demostrativo; requiere revisión competente |
| Buenas (alias Bueno/Bien) | LSC70W | BUENAS | El cargador selecciona un participante completo de forma determinista | Demostrativo; requiere revisión competente |
| Días | LSC70W | DIAS | El cargador selecciona un participante completo de forma determinista | Demostrativo; requiere revisión competente |
| Tarde | LSC70W | TARDES | El cargador selecciona un participante completo de forma determinista | Demostrativo; requiere revisión competente |
| Noche | LSC70W | NOCHES | El cargador selecciona un participante completo de forma determinista | Demostrativo; requiere revisión competente |
| A–Z y Ñ | LSC70AN | Carpeta de la letra; Ñ se guarda como NN | El cargador selecciona un participante completo por letra | Demostrativo; verificar con referencia competente |

La atribución visible será: `Muñoz Galindez, Villota Coral y Vargas Cañas, LSC70 v2, Data in Brief 58 (2025), CC BY 4.0, DOI: 10.1016/j.dib.2024.111213; dataset DOI: 10.17632/9ssyn8tff5.2`. Los medios individuales deben conservar en Firestore `subset`, `sourceLabel`, `participantId`, `datasetVersion`, licencia y atribución. El artículo es referencia académica, no certificación de la interpretación de cada imagen.

## Formato del manifiesto

El panel espera `{ "entries": [...] }`, máximo 200 entradas por lote. Cada elemento requiere `term`, `animationKey`, `subset`, `sourceLabel`, `participantId` y `frameUrls` (1–6 URL Cloudinary). `kind` se infiere como `letter` para LSC70AN y `word` para LSC70W. Usar claves únicas como `lsc70w_hello` y `lsc70an_n`; `frameDurationMs` por omisión es 167 ms. URLs deben apuntar a JPG originales públicos de `res.cloudinary.com`, sin transformaciones automáticas.

Ejemplo de estructura (reemplazar identificadores y URLs por los archivos que realmente se seleccionen; los valores ilustrativos no son recursos válidos):

```json
{
  "entries": [
    {
      "term": "Hola",
      "animationKey": "hello",
      "subset": "LSC70W",
      "sourceLabel": "Hello",
      "participantId": "identificador-original-del-participante",
      "frameDurationMs": 167,
      "frameUrls": [
        "https://res.cloudinary.com/CUENTA/image/upload/RUTA/Hello_1.jpg",
        "https://res.cloudinary.com/CUENTA/image/upload/RUTA/Hello_2.jpg"
      ]
    }
  ]
}
```

El importador comprueba claves y términos duplicados dentro del manifiesto, número/forma de las URLs y genera una vista previa. Si la `animationKey` coincide con más de un documento existente, rechaza el lote para evitar una asociación ambigua. Si coincide con uno, solo actualiza el mapa `media`; si no, crea un documento borrador.

## Carga automatizada a Cloudinary

El utilitario administrativo local vive en `tools/cloudinary/`. Lee el ZIP de LSC70 v2 sin extraerlo, selecciona una secuencia de seis cuadros para cada una de las cinco palabras y las 27 letras, y transmite los originales con la API firmada de Cloudinary. El `public_id` estable sigue `senasapp/lsc70/v2/<subconjunto>/<etiqueta>/<participante>/frame_XX`; si ya existe, reutiliza su URL para permitir reanudar una carga parcial.

Las credenciales se guardan únicamente en `tools/cloudinary/.env`, ignorado por Git. `CLOUDINARY_API_SECRET` nunca se pone en la app ni se comparte. El modo por defecto es una vista previa; `--apply` es obligatorio para subir. Al completar genera `tools/cloudinary/output/lsc70-v2-cloudinary-manifest.json`, que el administrador puede importar desde la pantalla de gestión del diccionario. La herramienta no escribe directamente en Firestore ni publica los borradores.

El ZIP completo de Mendeley pesa aproximadamente 990 MB comprimidos; por eso se leen y suben solo los 192 fotogramas del piloto y la app no incluye el ZIP ni imágenes del dataset en `assets/`.

## Límites de producto

No es traducción automática de la gramática LSC. No se incluyen clips locales, avatares ni audio. El reproductor requiere conexión a Internet y URLs accesibles; si Cloudinary falla, no hay fallback local. Los usuarios deben poder ver la atribución y que la seña está pendiente de revisión.
