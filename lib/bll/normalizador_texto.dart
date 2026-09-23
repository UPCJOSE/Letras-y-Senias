/// Deja el texto listo para buscar en el catálogo (sin acentos ni signos).
String normalizarTexto(String texto) {
  var t = texto.toLowerCase();
  const acentos = {
    'á': 'a',
    'é': 'e',
    'í': 'i',
    'ó': 'o',
    'ú': 'u',
    'ü': 'u',
  };
  for (final entrada in acentos.entries) {
    t = t.replaceAll(entrada.key, entrada.value);
  }
  t = t.replaceAll(RegExp(r'[^a-zñ0-9]+'), ' ');
  return t.replaceAll(RegExp(r'\s+'), ' ').trim();
}
