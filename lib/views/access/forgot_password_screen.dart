import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un correo electrónico válido.'),
        ),
      );
      return;
    }
    final controller = context.read<AppController>();
    final success = await controller.resetPassword(email);
    if (!mounted) return;
    if (success) {
      setState(() => sent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.authError ??
                'Error al enviar el correo de recuperación.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final isLoading = controller.isAuthLoading;

    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Recuperar contraseña',
          showBack: true,
          backFallback: '/login',
        ),
        body: SingleChildScrollView(
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
                    ? 'Revisa tu bandeja de entrada en ${_emailController.text}. Hemos enviado el enlace para restablecer tu contraseña.'
                    : 'Ingresa tu correo electrónico y te enviaremos un enlace seguro para restablecer tu contraseña.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              if (!sent) ...[
                TextFormField(
                  controller: _emailController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: isLoading ? null : _handleReset,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Enviar enlace'),
                ),
              ],
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => navigateBack(context, '/login'),
                child: const Text('Volver a iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
