import 'package:movi/model/entrada_sena.dart';

/// Diccionario de señas del mockup (texto → seña).
class ServicioDiccionario {
  static const List<String> categorias = [
    'Todos',
    'Saludos',
    'Familia',
    'Números',
    'Colores',
    'Verbos',
    'Emociones',
  ];

  static const Map<String, EntradaSena> _catalogo = {
    'hola': EntradaSena(
      clave: 'hola',
      emoji: '👋',
      categoria: 'Saludos',
      rutaVideo: 'hola',
    ),
    'gracias': EntradaSena(
      clave: 'gracias',
      emoji: '🙏',
      categoria: 'Saludos',
      rutaVideo: 'gracias',
    ),
    'por_favor': EntradaSena(
      clave: 'por_favor',
      emoji: '🤲',
      categoria: 'Saludos',
      rutaVideo: 'por_favor',
    ),
    'buenos_dias': EntradaSena(
      clave: 'buenos_dias',
      emoji: '🌅',
      categoria: 'Saludos',
      rutaVideo: 'buenos_dias',
    ),
    'adios': EntradaSena(
      clave: 'adios',
      emoji: '👋',
      categoria: 'Saludos',
      rutaVideo: 'adios',
    ),
    'familia': EntradaSena(
      clave: 'familia',
      emoji: '👨‍👩‍👧‍👦',
      categoria: 'Familia',
      rutaVideo: 'familia',
    ),
    'madre': EntradaSena(
      clave: 'madre',
      emoji: '👩',
      categoria: 'Familia',
      rutaVideo: 'madre',
    ),
    'padre': EntradaSena(
      clave: 'padre',
      emoji: '👨',
      categoria: 'Familia',
      rutaVideo: 'padre',
    ),
    'hermano': EntradaSena(
      clave: 'hermano',
      emoji: '🧑',
      categoria: 'Familia',
      rutaVideo: 'hermano',
    ),
    'hermana': EntradaSena(
      clave: 'hermana',
      emoji: '👧',
      categoria: 'Familia',
      rutaVideo: 'hermana',
    ),
    'uno': EntradaSena(
      clave: 'uno',
      emoji: '1️⃣',
      categoria: 'Números',
      rutaVideo: 'uno',
    ),
    'dos': EntradaSena(
      clave: 'dos',
      emoji: '2️⃣',
      categoria: 'Números',
      rutaVideo: 'dos',
    ),
    'tres': EntradaSena(
      clave: 'tres',
      emoji: '3️⃣',
      categoria: 'Números',
      rutaVideo: 'tres',
    ),
    'rojo': EntradaSena(
      clave: 'rojo',
      emoji: '🔴',
      categoria: 'Colores',
      rutaVideo: 'rojo',
    ),
    'azul': EntradaSena(
      clave: 'azul',
      emoji: '🔵',
      categoria: 'Colores',
      rutaVideo: 'azul',
    ),
    'verde': EntradaSena(
      clave: 'verde',
      emoji: '🟢',
      categoria: 'Colores',
      rutaVideo: 'verde',
    ),
    'comer': EntradaSena(
      clave: 'comer',
      emoji: '🍽️',
      categoria: 'Verbos',
      rutaVideo: 'comer',
    ),
    'agua': EntradaSena(
      clave: 'agua',
      emoji: '💧',
      categoria: 'Verbos',
      rutaVideo: 'agua',
    ),
    'ayuda': EntradaSena(
      clave: 'ayuda',
      emoji: '🆘',
      categoria: 'Verbos',
      rutaVideo: 'ayuda',
    ),
    'amor': EntradaSena(
      clave: 'amor',
      emoji: '❤️',
      categoria: 'Emociones',
      rutaVideo: 'amor',
    ),
  };

  String normalizar(String texto) {
    return texto.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }

  EntradaSena? buscarPorPalabra(String palabra) {
    return _catalogo[normalizar(palabra)];
  }

  List<EntradaSena> obtenerTodas() => _catalogo.values.toList();

  List<EntradaSena> filtrar({
    String categoria = 'Todos',
    String busqueda = '',
  }) {
    final q = busqueda.trim().toLowerCase();
    return _catalogo.values.where((s) {
      final okCat = categoria == 'Todos' || s.categoria == categoria;
      final okBusqueda = q.isEmpty ||
          s.clave.contains(q) ||
          s.categoria.toLowerCase().contains(q) ||
          s.palabraVisible.contains(q);
      return okCat && okBusqueda;
    }).toList();
  }

  int get cantidad => _catalogo.length;
}
