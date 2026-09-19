import 'package:flutter/material.dart';
import 'package:movi/model/sesion_usuario.dart';
import 'package:movi/ui/aplicacion.dart';

/// Suscripción + login mock con Google (como el mockup React).
class PaginaSuscripcion extends StatefulWidget {
  const PaginaSuscripcion({
    super.key,
    required this.sesion,
    required this.alIniciarSesion,
    required this.alCerrarSesion,
  });

  final SesionUsuario? sesion;
  final ValueChanged<SesionUsuario> alIniciarSesion;
  final VoidCallback alCerrarSesion;

  @override
  State<PaginaSuscripcion> createState() => _EstadoPaginaSuscripcion();
}

class _EstadoPaginaSuscripcion extends State<PaginaSuscripcion> {
  String? _plan; // gratis | pro

  @override
  Widget build(BuildContext context) {
    if (widget.sesion != null) {
      return _SesionActiva(
        sesion: widget.sesion!,
        alCerrar: () {
          setState(() => _plan = null);
          widget.alCerrarSesion();
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      children: [
        const Center(child: Text('🌟', style: TextStyle(fontSize: 40))),
        const SizedBox(height: 8),
        const Text(
          'Elige tu plan',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: ColoresApp.azul,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Aprende LSC a tu ritmo, sin barreras',
          textAlign: TextAlign.center,
          style: TextStyle(color: ColoresApp.textoAyuda),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TarjetaPlan(
                titulo: 'Gratis',
                precio: '\$0',
                beneficios: const [
                  '50 señas incluidas',
                  'Traductor básico',
                  'Palabras frecuentes',
                  'Sin lecciones',
                ],
                destacado: false,
                seleccionado: _plan == 'gratis',
                alPulsar: () => setState(() => _plan = 'gratis'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TarjetaPlan(
                titulo: 'Pro',
                precio: '\$12',
                beneficios: const [
                  'Todo lo del plan Gratis',
                  '200+ señas en el catálogo',
                  'Lecciones y quizzes',
                  'Progreso con XP',
                ],
                destacado: true,
                seleccionado: _plan == 'pro',
                alPulsar: () => setState(() => _plan = 'pro'),
              ),
            ),
          ],
        ),
        if (_plan != null) ...[
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Continúa con tu cuenta de Google para activar tu plan $_plan',
            textAlign: TextAlign.center,
            style: const TextStyle(color: ColoresApp.textoAyuda, fontSize: 13),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              final esAdmin = _plan == 'pro';
              widget.alIniciarSesion(
                SesionUsuario(
                  correo: esAdmin ? 'admin@lsc.edu.co' : 'usuario@gmail.com',
                  nombre: esAdmin ? 'Admin LSC' : 'Usuario',
                  rol: esAdmin ? 'admin' : 'user',
                ),
              );
            },
            icon: const Icon(Icons.g_mobiledata, size: 28, color: ColoresApp.azul),
            label: const Text('Continuar con Google'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColoresApp.negroSuave,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: ColoresApp.borde, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Al continuar aceptas los Términos de Uso y la Política de Privacidad de LSC App.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: ColoresApp.textoAyuda),
          ),
        ],
      ],
    );
  }
}

class _SesionActiva extends StatelessWidget {
  const _SesionActiva({required this.sesion, required this.alCerrar});

  final SesionUsuario sesion;
  final VoidCallback alCerrar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ColoresApp.blanco,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColoresApp.verde, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 8),
              const Text(
                '¡Sesión activa!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: ColoresApp.verde,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bienvenido, ${sesion.nombre}. Plan ${sesion.esAdmin ? "Pro (Admin)" : "Gratis"} activo.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: ColoresApp.textoAyuda),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColoresApp.azulSuave,
                      child: Text(
                        sesion.nombre[0],
                        style: const TextStyle(
                          color: ColoresApp.azul,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sesion.correo,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            sesion.esAdmin
                                ? 'Administrador · Pro'
                                : 'Usuario · Gratis',
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
              if (sesion.esAdmin) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColoresApp.azulSuave,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColoresApp.azulClaro),
                  ),
                  child: const Text(
                    '🔐 Tienes acceso a Admin CMS y Base Vectorial en el menú.',
                    style: TextStyle(fontSize: 12, color: ColoresApp.azul),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextButton(
                onPressed: alCerrar,
                child: const Text('← Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaPlan extends StatelessWidget {
  const _TarjetaPlan({
    required this.titulo,
    required this.precio,
    required this.beneficios,
    required this.destacado,
    required this.seleccionado,
    required this.alPulsar,
  });

  final String titulo;
  final String precio;
  final List<String> beneficios;
  final bool destacado;
  final bool seleccionado;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: seleccionado ? ColoresApp.azulSuave : ColoresApp.blanco,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado || destacado
                ? ColoresApp.azul
                : ColoresApp.borde,
            width: seleccionado || destacado ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (destacado)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ColoresApp.azul,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'RECOMENDADO',
                  style: TextStyle(
                    fontSize: 9,
                    color: ColoresApp.blanco,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (seleccionado)
                  const Icon(Icons.check_circle, color: ColoresApp.azul, size: 20),
              ],
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: precio,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: destacado ? ColoresApp.azul : ColoresApp.negro,
                    ),
                  ),
                  const TextSpan(
                    text: '/mes',
                    style: TextStyle(fontSize: 12, color: ColoresApp.textoAyuda),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...beneficios.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destacado ? '✓ ' : '• ',
                      style: TextStyle(
                        color: destacado
                            ? ColoresApp.azul
                            : ColoresApp.textoAyuda,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
