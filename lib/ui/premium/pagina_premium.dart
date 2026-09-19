import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Plan Premium.
class PaginaPremium extends StatefulWidget {
  const PaginaPremium({super.key});

  @override
  State<PaginaPremium> createState() => _EstadoPaginaPremium();
}

class _EstadoPaginaPremium extends State<PaginaPremium> {
  bool _verPremium = true;

  static const _beneficios = [
    'Traducciones ilimitadas',
    'Diccionario ampliado: 200+ palabras y señas',
    'Historial completo de traducciones',
    'Nuevas señas y actualizaciones',
    'Acceso empresarial',
    'Soporte técnico prioritario',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.blanco,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Expanded(
                  child: Text(
                    'Planes',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: ColoresApp.amarilloSuave,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Text('⭐', style: TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'SeñasApp Premium',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'Accede a todas las funciones sin límites',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColoresApp.textoAyuda),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Text('Gratuito', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('50', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                        Text('palabras', style: TextStyle(color: ColoresApp.textoAyuda)),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, color: ColoresApp.textoAyuda),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ColoresApp.azul,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Text('Premium', style: TextStyle(color: ColoresApp.blanco, fontWeight: FontWeight.w600)),
                        Text('200+', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ColoresApp.blanco)),
                        Text('palabras y señas', style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _TabPlan(
                      etiqueta: 'Gratuito',
                      activo: !_verPremium,
                      alPulsar: () => setState(() => _verPremium = false),
                    ),
                  ),
                  Expanded(
                    child: _TabPlan(
                      etiqueta: 'Premium',
                      activo: _verPremium,
                      alPulsar: () => setState(() => _verPremium = true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [ColoresApp.azul, ColoresApp.azulOscuro],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _verPremium ? '\$12.900 /mes COP' : '\$0 /mes COP',
                    style: const TextStyle(
                      color: ColoresApp.blanco,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...(_verPremium
                          ? _beneficios
                          : [
                              '50 señas incluidas',
                              'Traductor básico',
                              'Palabras frecuentes',
                            ])
                      .map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              b,
                              style: const TextStyle(color: ColoresApp.blanco),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_verPremium)
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Premium activado (demo)')),
                  );
                },
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [ColoresApp.naranja, ColoresApp.naranjaClaro],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Obtener Premium',
                    style: TextStyle(
                      color: ColoresApp.blanco,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabPlan extends StatelessWidget {
  const _TabPlan({
    required this.etiqueta,
    required this.activo,
    required this.alPulsar,
  });

  final String etiqueta;
  final bool activo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: activo ? ColoresApp.blanco : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          etiqueta,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: activo ? ColoresApp.negro : ColoresApp.textoAyuda,
          ),
        ),
      ),
    );
  }
}
