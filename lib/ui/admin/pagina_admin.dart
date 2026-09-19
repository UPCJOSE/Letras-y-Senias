import 'package:flutter/material.dart';
import 'package:movi/service/servicio_palabras.dart';
import 'package:movi/ui/admin/pestanas/pestana_palabras.dart';
import 'package:movi/ui/admin/pestanas/pestana_senas.dart';
import 'package:movi/ui/aplicacion.dart';

/// Panel administrador (CMS) — diseño del mockup.
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
    _controladorPestanas = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controladorPestanas.dispose();
    super.dispose();
  }

  void _refrescar() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: ColoresApp.azul,
              unselectedLabelColor: ColoresApp.textoAyuda,
              indicator: BoxDecoration(
                color: ColoresApp.blanco,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColoresApp.azul.withValues(alpha: 0.35),
                ),
              ),
              tabs: const [
                Tab(text: 'Señas'),
                Tab(text: 'Palabras'),
                Tab(text: 'Usuarios'),
                Tab(text: 'Estadísticas'),
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
              const _PestanaUsuarios(),
              const _PestanaEstadisticas(),
            ],
          ),
        ),
      ],
    );
  }
}

class _CabeceraAdmin extends StatelessWidget {
  const _CabeceraAdmin();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
              color: ColoresApp.verdeSuave,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: ColoresApp.verde),
                SizedBox(width: 6),
                Text(
                  'Sesión activa',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColoresApp.verde,
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

class _PestanaUsuarios extends StatelessWidget {
  const _PestanaUsuarios();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Row(
          children: [
            Expanded(child: _StatUsuario('1.284', 'Usuarios totales')),
            SizedBox(width: 8),
            Expanded(child: _StatUsuario('73', 'Activos hoy')),
            SizedBox(width: 8),
            Expanded(child: _StatUsuario('48', 'Suscriptores Pro')),
          ],
        ),
        const SizedBox(height: 16),
        ...[
          ('A', 'Ana Pérez', 'ana@mail.com', 'Pro'),
          ('L', 'Luis Gómez', 'luis@mail.com', 'Gratis'),
          ('M', 'María Ruiz', 'maria@mail.com', 'Pro'),
        ].map(
          (u) => Card(
            elevation: 0,
            color: ColoresApp.blanco,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: ColoresApp.borde),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: ColoresApp.azulSuave,
                child: Text(
                  u.$1,
                  style: const TextStyle(
                    color: ColoresApp.azul,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(u.$2),
              subtitle: Text(u.$3),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: u.$4 == 'Pro'
                      ? ColoresApp.amarilloSuave
                      : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  u.$4,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: u.$4 == 'Pro'
                        ? const Color(0xFFF9A825)
                        : ColoresApp.textoAyuda,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatUsuario extends StatelessWidget {
  const _StatUsuario(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColoresApp.borde),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColoresApp.negro,
            ),
          ),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: ColoresApp.textoAyuda),
          ),
        ],
      ),
    );
  }
}

class _PestanaEstadisticas extends StatelessWidget {
  const _PestanaEstadisticas();

  @override
  Widget build(BuildContext context) {
    const datos = [
      ('Hola', 0.82),
      ('Gracias', 0.71),
      ('Familia', 0.55),
      ('Agua', 0.40),
      ('Amor', 0.29),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColoresApp.blanco,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ColoresApp.borde),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Señas más buscadas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.negro,
                ),
              ),
              const SizedBox(height: 16),
              ...datos.map(
                (d) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(d.$1)),
                          Text('${(d.$2 * 100).round()}%'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: d.$2,
                          minHeight: 8,
                          backgroundColor: ColoresApp.borde,
                          color: ColoresApp.azul,
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
    );
  }
}
