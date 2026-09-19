import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Importar usuarios desde Excel/CSV (mockup).
class PaginaImportarUsuarios extends StatefulWidget {
  const PaginaImportarUsuarios({super.key});

  @override
  State<PaginaImportarUsuarios> createState() => _EstadoPaginaImportarUsuarios();
}

class _EstadoPaginaImportarUsuarios extends State<PaginaImportarUsuarios> {
  bool _subido = false;

  static const _vistaPrevia = [
    ('Juan Pérez', 'juan@empresa.com', 'Recepción'),
    ('Laura Gómez', 'laura@empresa.com', 'Contabilidad'),
    ('Diego Ríos', 'diego@empresa.com', 'Logística'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.blanco,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
              decoration: const BoxDecoration(
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
                    'Importar usuarios',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  Material(
                    color: ColoresApp.azulSuave,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: () => setState(() => _subido = true),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: ColoresApp.azulClaro,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: ColoresApp.azulSuave,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.upload_rounded,
                                color: ColoresApp.azul,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Subir archivo Excel',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '.xlsx o .csv · Hasta 500 usuarios',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColoresApp.textoAyuda,
                              ),
                            ),
                            if (_subido) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: ColoresApp.verde,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 16,
                                      color: ColoresApp.blanco,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'usuarios_empresa.xlsx',
                                      style: TextStyle(
                                        color: ColoresApp.blanco,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_subido) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'VISTA PREVIA · 3 USUARIOS',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.textoAyuda,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: ColoresApp.borde),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Nombre',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: ColoresApp.textoAyuda,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Correo',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: ColoresApp.textoAyuda,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Cargo',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: ColoresApp.textoAyuda,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ..._vistaPrevia.map(
                            (r) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: ColoresApp.borde),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      r.$1,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      r.$2,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: ColoresApp.textoAyuda,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      r.$3,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('3 usuarios importados (demo)'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Importar 3 usuarios'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
