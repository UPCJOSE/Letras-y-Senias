import 'package:flutter/material.dart';
import 'package:movi/ui/ajustes/pagina_ajustes.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/historial/pagina_historial.dart';
import 'package:movi/ui/premium/pagina_premium.dart';

/// Mi perfil (mockup SeñasApp).
class PaginaPerfil extends StatelessWidget {
  const PaginaPerfil({super.key});

  void _ir(BuildContext context, Widget pagina) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => pagina));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const Text(
          'Mi perfil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: ColoresApp.negro,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [ColoresApp.azul, ColoresApp.azulOscuro],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ColoresApp.blanco.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Text('👩', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ana Gómez',
                      style: TextStyle(
                        color: ColoresApp.blanco,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'ana@ejemplo.com',
                      style: TextStyle(
                        color: ColoresApp.blanco.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColoresApp.blanco.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Plan Gratuito',
                        style: TextStyle(
                          color: ColoresApp.blanco,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Row(
          children: [
            Expanded(child: _Stat('42', 'Señas vistas')),
            SizedBox(width: 10),
            Expanded(child: _Stat('8', 'Días activa')),
            SizedBox(width: 10),
            Expanded(child: _Stat('127', 'Traducciones')),
          ],
        ),
        const SizedBox(height: 16),
        Material(
          color: ColoresApp.blanco,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: ColoresApp.borde),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _FilaMenu(
                icono: Icons.history,
                titulo: 'Historial de traducciones',
                subtitulo: '127 traducciones realizadas',
                alPulsar: () => _ir(context, const PaginaHistorial()),
              ),
              const Divider(height: 1),
              _FilaMenu(
                icono: Icons.settings_outlined,
                titulo: 'Ajustes',
                subtitulo: 'Notificaciones, accesibilidad, privacidad',
                alPulsar: () => _ir(context, const PaginaAjustes()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _ir(context, const PaginaPremium()),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [ColoresApp.naranja, ColoresApp.naranjaClaro],
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: ColoresApp.blanco),
                SizedBox(width: 8),
                Text(
                  'Actualizar a Premium',
                  style: TextStyle(
                    color: ColoresApp.blanco,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sesión cerrada (demo UI)')),
            );
          },
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
          style: OutlinedButton.styleFrom(
            foregroundColor: ColoresApp.negroSuave,
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: ColoresApp.borde),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColoresApp.borde),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: ColoresApp.azul,
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

class _FilaMenu extends StatelessWidget {
  const _FilaMenu({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.alPulsar,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: alPulsar,
      leading: Icon(icono, color: ColoresApp.azul),
      title: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitulo,
        style: const TextStyle(fontSize: 12, color: ColoresApp.textoAyuda),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
