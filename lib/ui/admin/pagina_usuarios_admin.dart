import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/empresa/pagina_usuarios_empresa.dart';

/// Listado admin: empresas + usuarios individuales.
class PaginaUsuariosAdmin extends StatefulWidget {
  const PaginaUsuariosAdmin({super.key});

  @override
  State<PaginaUsuariosAdmin> createState() => _EstadoPaginaUsuariosAdmin();
}

class _EstadoPaginaUsuariosAdmin extends State<PaginaUsuariosAdmin> {
  final _busqueda = TextEditingController();

  static const _empresas = [
    ('Clínica Erasmo Ltda.', 25),
    ('Banco de Bogotá', 42),
    ('Colegio San Ignacio', 18),
  ];

  static const _individuales = [
    ('Andrés López', 'andres@email.com', 'Sep 2026'),
    ('Camila Torres', 'camila@email.com', 'Ago 2026'),
    ('Sebastián Ruiz', 'sebastian@email.com', 'Ago 2026'),
    ('Valentina Castro', 'valentina@email.com', 'Jul 2026'),
  ];

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtro = _busqueda.text.trim().toLowerCase();
    final empresas = _empresas
        .where((e) => filtro.isEmpty || e.$1.toLowerCase().contains(filtro))
        .toList();
    final individuales = _individuales
        .where(
          (u) =>
              filtro.isEmpty ||
              u.$1.toLowerCase().contains(filtro) ||
              u.$2.toLowerCase().contains(filtro),
        )
        .toList();

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
              decoration: const BoxDecoration(
                color: ColoresApp.blanco,
                border: Border(bottom: BorderSide(color: ColoresApp.borde)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Usuarios',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _busqueda,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar usuario o empresa...',
                  prefixIcon:
                      const Icon(Icons.search, color: ColoresApp.textoAyuda),
                  filled: true,
                  fillColor: ColoresApp.blanco,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ColoresApp.borde),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ColoresApp.borde),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _seccionTitulo('Empresas', empresas.length, ColoresApp.azulSuave, ColoresApp.azulOscuro),
                  const SizedBox(height: 8),
                  ...empresas.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: ColoresApp.blanco,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PaginaUsuariosEmpresa(
                                  nombreEmpresa: e.$1,
                                  totalUsuarios: e.$2,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ColoresApp.borde),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: ColoresApp.azul,
                                  child: Text(
                                    e.$1[0],
                                    style: const TextStyle(
                                      color: ColoresApp.blanco,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.$1,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${e.$2} usuarios inscritos',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: ColoresApp.textoAyuda,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: ColoresApp.textoAyuda,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _seccionTitulo(
                    'Usuarios individuales',
                    individuales.length,
                    const Color(0xFFF1F5F9),
                    ColoresApp.negroSuave,
                  ),
                  const SizedBox(height: 8),
                  ...individuales.map(
                    (u) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: ColoresApp.blanco,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ColoresApp.borde),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFF1F5F9),
                            child: Text(
                              u.$1[0],
                              style: const TextStyle(
                                color: ColoresApp.negroSuave,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  u.$1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  u.$2,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: ColoresApp.textoAyuda,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            u.$3,
                            style: const TextStyle(
                              fontSize: 11,
                              color: ColoresApp.borde,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccionTitulo(
    String titulo,
    int total,
    Color badgeBg,
    Color badgeFg,
  ) {
    return Row(
      children: [
        Text(
          titulo.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
            color: ColoresApp.textoAyuda,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(child: Divider()),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$total',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: badgeFg,
            ),
          ),
        ),
      ],
    );
  }
}
