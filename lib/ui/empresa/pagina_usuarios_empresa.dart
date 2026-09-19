import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Gestión / listado de usuarios de una empresa.
class PaginaUsuariosEmpresa extends StatefulWidget {
  final String? nombreEmpresa;
  final int? totalUsuarios;

  const PaginaUsuariosEmpresa({
    super.key,
    this.nombreEmpresa,
    this.totalUsuarios,
  });

  @override
  State<PaginaUsuariosEmpresa> createState() => _EstadoPaginaUsuariosEmpresa();
}

class _EstadoPaginaUsuariosEmpresa extends State<PaginaUsuariosEmpresa> {
  final _busqueda = TextEditingController();

  static const _empleados = [
    ('María Rodríguez', 'Recepción', 'maria@empresa.com', true),
    ('Carlos López', 'Recursos Humanos', 'carlos@empresa.com', true),
    ('Ana Torres', 'Atención al Cliente', 'ana@empresa.com', false),
    ('Luis Vargas', 'Seguridad', 'luis@empresa.com', true),
    ('Sara Jiménez', 'Caja', 'sara@empresa.com', true),
  ];

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.nombreEmpresa ?? 'Usuarios de la empresa';
    final filtro = _busqueda.text.trim().toLowerCase();
    final lista = _empleados
        .where((e) => filtro.isEmpty || e.$1.toLowerCase().contains(filtro))
        .toList();

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Añadir usuario (demo)')),
          );
        },
        backgroundColor: ColoresApp.azul,
        child: const Icon(Icons.add, color: ColoresApp.blanco),
      ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: ColoresApp.negro,
                          ),
                        ),
                        if (widget.nombreEmpresa != null)
                          Text(
                            '${widget.totalUsuarios ?? lista.length} usuarios inscritos',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColoresApp.textoAyuda,
                            ),
                          ),
                      ],
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
                  hintText: 'Buscar empleado...',
                  prefixIcon: const Icon(Icons.search, color: ColoresApp.textoAyuda),
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
            if (widget.nombreEmpresa != null)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MIEMBROS DE LA EMPRESA',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoAyuda,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                itemCount: lista.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final e = lista[i];
                  final conCorreo = widget.nombreEmpresa != null;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: ColoresApp.blanco,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColoresApp.borde),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: ColoresApp.azulSuave,
                          child: Text(
                            e.$1[0],
                            style: const TextStyle(
                              color: ColoresApp.azulOscuro,
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
                                e.$1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              if (conCorreo)
                                Text(
                                  e.$3,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: ColoresApp.textoAyuda,
                                  ),
                                ),
                              Text(
                                e.$2,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: conCorreo
                                      ? ColoresApp.azul
                                      : ColoresApp.textoAyuda,
                                  fontWeight: conCorreo
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: e.$4
                                ? ColoresApp.verdeSuave
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            e.$4 ? 'activo' : 'inactivo',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: e.$4
                                  ? const Color(0xFF15803D)
                                  : ColoresApp.textoAyuda,
                            ),
                          ),
                        ),
                        if (!conCorreo) ...[
                          const SizedBox(width: 6),
                          IconButton(
                            onPressed: () {},
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFF1F5F9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
