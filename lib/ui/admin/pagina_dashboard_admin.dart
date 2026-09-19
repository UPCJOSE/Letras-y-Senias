import 'package:flutter/material.dart';
import 'package:movi/ui/admin/pagina_editor_avatar.dart';
import 'package:movi/ui/admin/pagina_gestion_diccionario.dart';
import 'package:movi/ui/admin/pagina_usuarios_admin.dart';
import 'package:movi/ui/aplicacion.dart';

/// Dashboard del administrador del sistema.
class PaginaDashboardAdmin extends StatefulWidget {
  const PaginaDashboardAdmin({super.key});

  @override
  State<PaginaDashboardAdmin> createState() => _EstadoPaginaDashboardAdmin();
}

class _EstadoPaginaDashboardAdmin extends State<PaginaDashboardAdmin> {
  bool _menuAbierto = false;

  @override
  Widget build(BuildContext context) {
    const metricas = [
      ('Usuarios registrados', '2.841', '👤', '+23 hoy'),
      ('Empresas activas', '47', '🏢', '+2 esta semana'),
      ('Nuevas señas', '132', '🤟', '+8 este mes'),
      ('Sin traducción', '214', '⚠️', 'Requieren revisión'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.paddingOf(context).top + 12,
                  16,
                  20,
                ),
                color: ColoresApp.adminFondo,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _botonOscuro(
                          Icons.arrow_back,
                          () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        _botonOscuro(
                          Icons.menu,
                          () => setState(() => _menuAbierto = true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Panel de control',
                      style: TextStyle(
                        color: ColoresApp.textoAyuda,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Administrador',
                      style: TextStyle(
                        color: ColoresApp.blanco,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'SeñasApp · Sistema interno',
                      style: TextStyle(
                        color: ColoresApp.textoAyuda,
                        fontSize: 12,
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
                      childAspectRatio: 1.05,
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
                                  Text(m.$3, style: const TextStyle(fontSize: 22)),
                                  const SizedBox(height: 8),
                                  Text(
                                    m.$2,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    m.$1,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ColoresApp.textoAyuda,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    m.$4,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
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
                            'ACCIONES RÁPIDAS',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w600,
                              color: ColoresApp.textoAyuda,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _accionRapida(
                                  color: ColoresApp.azulSuave,
                                  textoColor: ColoresApp.azulOscuro,
                                  icono: Icons.menu_book_outlined,
                                  etiqueta: 'Gestionar Diccionario',
                                  alPulsar: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PaginaGestionDiccionario(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _accionRapida(
                                  color: const Color(0xFFF3E8FF),
                                  textoColor: const Color(0xFF7E22CE),
                                  icono: Icons.person_outline,
                                  etiqueta: 'Editor de Avatar',
                                  alPulsar: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PaginaEditorAvatar(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: _accionRapida(
                              color: const Color(0xFFF8FAFC),
                              textoColor: ColoresApp.negroSuave,
                              icono: Icons.groups_outlined,
                              etiqueta:
                                  'Gestionar Usuarios (empresas e individuales)',
                              alPulsar: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const PaginaUsuariosAdmin(),
                                  ),
                                );
                              },
                              horizontal: true,
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
          if (_menuAbierto) _drawerLateral(context),
        ],
      ),
    );
  }

  Widget _drawerLateral(BuildContext context) {
    final items = [
      (Icons.groups_outlined, 'Usuarios', () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PaginaUsuariosAdmin()),
        );
      }),
      (Icons.business_outlined, 'Empresas', () {}),
      (Icons.menu_book_outlined, 'Diccionario', () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PaginaGestionDiccionario()),
        );
      }),
      (Icons.grid_view_outlined, 'Categorías', () {}),
      (Icons.star_outline, 'Suscripciones', () {}),
    ];

    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _menuAbierto = false),
        child: Container(
          color: Colors.black54,
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 260,
                height: double.infinity,
                color: ColoresApp.adminFondo,
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.paddingOf(context).top + 24,
                  16,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: ColoresApp.azul,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin',
                              style: TextStyle(
                                color: ColoresApp.blanco,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'admin@senasapp.co',
                              style: TextStyle(
                                color: ColoresApp.textoAyuda,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    ...items.map(
                      (item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(item.$1, color: ColoresApp.textoAyuda),
                        title: Text(
                          item.$2,
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          setState(() => _menuAbierto = false);
                          item.$3();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _accionRapida({
    required Color color,
    required Color textoColor,
    required IconData icono,
    required String etiqueta,
    required VoidCallback alPulsar,
    bool horizontal = false,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: horizontal
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icono, color: textoColor, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        etiqueta,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textoColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Icon(icono, color: textoColor, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      etiqueta,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textoColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _botonOscuro(IconData icono, VoidCallback alPulsar) {
    return Material(
      color: const Color(0x1AFFFFFF),
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
