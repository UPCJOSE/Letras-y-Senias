import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../theme/app_theme.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: SenasHeader(
        title: 'Plan Premium',
        showBack: true,
        backFallback: context.read<AppController>().isAuthenticated
            ? '/profile'
            : '/home',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blue, Color(0xFF6D5CE7)],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              children: [
                Icon(Icons.workspace_premium, color: Colors.white, size: 46),
                SizedBox(height: 12),
                Text(
                  'Amplía tu forma de comunicar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Comparación informativa para el MVP académico',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: const [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '50',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.muted,
                          ),
                        ),
                        Text('palabras gratis', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: AppColors.blue),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '200+',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.blue,
                          ),
                        ),
                        Text('con Premium', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _PlanCard(
            title: 'Gratuito',
            price: r'$0 COP',
            features: const [
              'Diccionario de 50 palabras',
              'Traducciones básicas',
              'Historial reciente',
            ],
          ),
          const SizedBox(height: 12),
          _PlanCard(
            title: 'Premium',
            price: r'$14.900 COP / mes',
            highlighted: true,
            features: const [
              'Diccionario de 200+ palabras y señas',
              'Traducciones ilimitadas',
              'Historial completo',
              'Nuevas señas y actualizaciones',
            ],
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Premium es informativo en esta versión.'),
              ),
            ),
            child: const Text('Obtener Premium'),
          ),
        ],
      ),
    ),
  );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.features,
    this.highlighted = false,
  });
  final String title;
  final String price;
  final List<String> features;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => Card(
    color: highlighted ? AppColors.paleBlue : null,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: highlighted ? AppColors.blueDark : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Expanded(child: Text(feature)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
