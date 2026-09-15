import 'package:flutter/material.dart';
import 'package:movi/service/servicio_palabras.dart';
import 'package:movi/ui/admin/pestanas/pestana_palabras.dart';
import 'package:movi/ui/admin/pestanas/pestana_senas.dart';
import 'package:movi/ui/aplicacion.dart';

/// Panel administrador (CMS) con pestañas Señas y Palabras.
class PaginaAdmin extends StatefulWidget {
  const PaginaAdmin({super.key});

  @override
  State<PaginaAdmin> createState() => _EstadoPaginaAdmin();
}

class _EstadoPaginaAdmin extends State<PaginaAdmin>
    with SingleTickerProviderStateMixin {
  late final TabController _controladorPestanas;
  final ServicioPalabras _servicioPalabras = ServicioPalabras();

  @override
  void initState() {
    super.initState();
    _controladorPestanas = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controladorPestanas.dispose();
    super.dispose();
  }

  void _refrescar() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _CabeceraAdmin(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _controladorPestanas,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: ColoresApp.azul,
                  unselectedLabelColor: ColoresApp.textoAyuda,
                  indicator: BoxDecoration(
                    color: ColoresApp.blanco,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColoresApp.azul.withValues(alpha: 0.3)),
                  ),
                  tabs: const [
                    Tab(text: 'Señas'),
                    Tab(text: 'Palabras'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _controladorPestanas,
                children: [
                  const PestanaSenas(),
                  PestanaPalabras(
                    servicio: _servicioPalabras,
                    alCambiar: _refrescar,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CabeceraAdmin extends StatelessWidget {
  const _CabeceraAdmin();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ColoresApp.azul,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.settings, color: ColoresApp.blanco),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panel Administrador',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.negro,
                  ),
                ),
                Text(
                  'LSC CMS · admin@lsc.edu.co',
                  style: TextStyle(fontSize: 12, color: ColoresApp.textoAyuda),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: Color(0xFF2E7D32)),
                SizedBox(width: 6),
                Text(
                  'Sesión activa',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
