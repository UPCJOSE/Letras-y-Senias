import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/app_widgets.dart';
import '../../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  static const _pages = [
    (
      'Traduce texto a Lengua de Señas Colombiana',
      'Escribe una palabra o frase para consultar las señas disponibles.',
      Icons.sign_language,
    ),
    (
      'Entendemos palabras similares y errores de escritura',
      'Nuestra búsqueda inteligente corrige errores tipográficos y sugiere las señas correctas.',
      Icons.search,
    ),
    (
      'Una herramienta para comunicar y aprender',
      'Consulta el diccionario y guarda tus traducciones recientes.',
      Icons.menu_book_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Omitir'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 160,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.paleBlue, AppColors.lavender],
                            ),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Icon(item.$3, size: 78, color: AppColors.blue),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          item.$1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item.$2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(4),
                    height: 7,
                    width: _page == index ? 28 : 7,
                    decoration: BoxDecoration(
                      color: _page == index
                          ? AppColors.blue
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_page == 2) {
                    context.go('/login');
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOut,
                    );
                  }
                },
                child: Text(_page == 2 ? 'Comenzar' : 'Siguiente'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
