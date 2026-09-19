import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/empresa/pagina_importar_usuarios.dart';
import 'package:movi/ui/empresa/pagina_usuarios_empresa.dart';

/// Dashboard empresarial (mockup SeñasApp).
class PaginaDashboardEmpresa extends StatelessWidget {
  const PaginaDashboardEmpresa({super.key});

  @override
  Widget build(BuildContext context) {
    const metricas = [
      ('Usuarios activos', '127', '👥', Color(0xFFEFF6FF), ColoresApp.azulOscuro),
      ('Traducciones mes', '4.582', '📊', ColoresApp.verdeSuave, Color(0xFF15803D)),
      ('Señas accedidas', '892', '🤟', Color(0xFFF3E8FF), Color(0xFF7E22CE)),
      ('Tiempo promedio', '3.2s', '⚡', Color(0xFFFFF7ED), Color(0xFFC2410C)),
    ];

    const actividad = [
      ('María Rodríguez', '14 traducciones', 'Hace 5 min'),
      ('Carlos López', 'Accedió al diccionario', 'Hace 22 min'),
      ('Ana Torres', '2 traducciones', 'Hace 1h'),
    ];

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.paddingOf(context).top + 12,
              16,
              20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1D4ED8),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _botonHeader(
                      Icons.arrow_back,
                      () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    _botonHeader(Icons.notifications_none, () {}),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Panel empresarial',
                  style: TextStyle(
                    color: Color(0xFFBFDBFE),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'SeñasApp Empresas',
                  style: TextStyle(
                    color: ColoresApp.blanco,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: ColoresApp.verde,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Licencia activa',
                    style: TextStyle(
                      color: ColoresApp.blanco,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: metricas
                      .map(
                        (m) => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ColoresApp.blanco,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: ColoresApp.borde),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: m.$4,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(m.$3, style: const TextStyle(fontSize: 18)),
                              ),
                              const Spacer(),
                              Text(
                                m.$2,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: m.$5,
                                ),
                              ),
                              Text(
                                m.$1,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ColoresApp.textoAyuda,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PaginaUsuariosEmpresa(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.groups_outlined, size: 22),
                            SizedBox(height: 6),
                            Text('Gestionar usuarios', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PaginaImportarUsuarios(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColoresApp.negroSuave,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(color: ColoresApp.borde),
                          backgroundColor: ColoresApp.blanco,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.upload_file_outlined, size: 22),
                            SizedBox(height: 6),
                            Text('Importar Excel', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColoresApp.blanco,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ColoresApp.borde),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ACTIVIDAD RECIENTE',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          color: ColoresApp.textoAyuda,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...actividad.map(
                        (a) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: ColoresApp.azulSuave,
                                child: Text(
                                  a.$1[0],
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
                                      a.$1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      a.$2,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: ColoresApp.textoAyuda,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                a.$3,
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
        ],
      ),
    );
  }

  Widget _botonHeader(IconData icono, VoidCallback alPulsar) {
    return Material(
      color: const Color(0x33FFFFFF),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icono, color: ColoresApp.blanco, size: 20),
        ),
      ),
    );
  }
}
