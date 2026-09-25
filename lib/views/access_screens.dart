import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/app_models.dart';
import '../shared/widgets/app_widgets.dart';
import '../theme/app_theme.dart';

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
      'Escribe una palabra o frase y nuestro avatar 2D la interpretará.',
      '🤟',
    ),
    (
      'Encuentra palabras similares',
      'Reconocemos errores de escritura y proponemos opciones del diccionario.',
      '🔎',
    ),
    (
      'Úsala como persona o institución',
      'Conecta usuarios, empresas y servicios en una misma plataforma.',
      '🏫',
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
                          child: Text(
                            item.$3,
                            style: const TextStyle(fontSize: 96),
                          ),
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
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePassword = true;
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(28),
          children: [
            const SizedBox(height: 28),
            const Text('🤟', style: TextStyle(fontSize: 42)),
            const SizedBox(height: 18),
            Text(
              'Qué gusto verte',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Continúa tu camino para comunicar e incluir.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 36),
            const TextField(
              key: Key('login-email'),
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.mail_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/forgot-password'),
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Iniciar sesión'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go('/home'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: const Text('Continuar como invitado'),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Aún no tienes cuenta?'),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Crear cuenta'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vista de demostración',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cambia de rol para revisar los paneles sin Firebase.',
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<AppRole>(
                      segments: const [
                        ButtonSegment(
                          value: AppRole.individual,
                          label: Text('Persona'),
                        ),
                        ButtonSegment(
                          value: AppRole.companyAdmin,
                          label: Text('Empresa'),
                        ),
                        ButtonSegment(
                          value: AppRole.admin,
                          label: Text('Admin'),
                        ),
                      ],
                      selected: {context.watch<AppController>().role},
                      onSelectionChanged: (value) =>
                          context.read<AppController>().setRole(value.first),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool company = false;
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: const SenasHeader(title: 'Crear cuenta', showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Empieza a comunicar sin barreras',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text('Individual'),
                icon: Icon(Icons.person_outline),
              ),
              ButtonSegment(
                value: true,
                label: Text('Empresa'),
                icon: Icon(Icons.business_outlined),
              ),
            ],
            selected: {company},
            onSelectionChanged: (value) =>
                setState(() => company = value.first),
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Nombre completo',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          if (company) ...[
            const SizedBox(height: 14),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nombre de la empresa',
                prefixIcon: Icon(Icons.business_outlined),
              ),
            ),
          ],
          const SizedBox(height: 14),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: 14),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 14),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirmar contraseña',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(company ? '/company' : '/home'),
            child: const Text('Crear cuenta'),
          ),
        ],
      ),
    ),
  );
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool sent = false;
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: const SenasHeader(title: 'Recuperar contraseña', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 18),
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.paleBlue,
              child: Icon(
                sent ? Icons.mark_email_read_outlined : Icons.lock_reset,
                size: 38,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              sent ? 'Enlace enviado' : 'Restablece tu acceso',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              sent
                  ? 'Revisa tu correo. El enlace de demostración expirará en 30 minutos.'
                  : 'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            if (!sent) ...[
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => setState(() => sent = true),
                child: const Text('Enviar enlace'),
              ),
            ],
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Volver a iniciar sesión'),
            ),
          ],
        ),
      ),
    ),
  );
}
