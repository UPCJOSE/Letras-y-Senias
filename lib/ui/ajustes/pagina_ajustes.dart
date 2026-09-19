import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Ajustes de la app.
class PaginaAjustes extends StatefulWidget {
  const PaginaAjustes({super.key});

  @override
  State<PaginaAjustes> createState() => _EstadoPaginaAjustes();
}

class _EstadoPaginaAjustes extends State<PaginaAjustes> {
  bool _notificaciones = true;
  bool _altoContraste = false;
  bool _temaOscuro = false;
  double _velocidad = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: ColoresApp.blanco,
                    side: const BorderSide(color: ColoresApp.borde),
                  ),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ajustes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _seccion('NOTIFICACIONES'),
            _tarjeta(
              child: SwitchListTile(
                value: _notificaciones,
                onChanged: (v) => setState(() => _notificaciones = v),
                activeTrackColor: ColoresApp.azul,
                secondary: const CircleAvatar(
                  backgroundColor: ColoresApp.azulSuave,
                  child: Icon(Icons.notifications, color: ColoresApp.azul),
                ),
                title: const Text(
                  'Notificaciones push',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Novedades y actualizaciones'),
              ),
            ),
            const SizedBox(height: 16),
            _seccion('VELOCIDAD DE REPRODUCCIÓN'),
            _tarjeta(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [0.5, 1.0, 1.5].map((v) {
                    final activo = _velocidad == v;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => setState(() => _velocidad = v),
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: activo
                                  ? ColoresApp.azul
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${v}x',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: activo
                                    ? ColoresApp.blanco
                                    : ColoresApp.negroSuave,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _seccion('ACCESIBILIDAD'),
            _tarjeta(
              child: Column(
                children: [
                  SwitchListTile(
                    value: _altoContraste,
                    onChanged: (v) => setState(() => _altoContraste = v),
                    activeTrackColor: ColoresApp.azul,
                    secondary: const Icon(Icons.contrast),
                    title: const Text(
                      'Alto contraste',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('Mejora la legibilidad del texto'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _temaOscuro,
                    onChanged: (v) => setState(() => _temaOscuro = v),
                    activeTrackColor: ColoresApp.azul,
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text(
                      'Tema oscuro',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('Reduce el brillo de la pantalla'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _seccion('PRIVACIDAD'),
            _tarjeta(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text(
                      'Política de privacidad',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('Cómo usamos tus datos'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text(
                      'Términos y condiciones',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('Condiciones de uso del servicio'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: Colors.red),
                    title: const Text(
                      'Eliminar mi cuenta',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: const Text('Acción permanente e irreversible'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccion(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          t,
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            color: ColoresApp.textoAyuda,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _tarjeta({required Widget child}) {
    return Material(
      color: ColoresApp.blanco,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: ColoresApp.borde),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
