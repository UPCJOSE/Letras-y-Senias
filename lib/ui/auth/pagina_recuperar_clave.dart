import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Recuperar contraseña.
class PaginaRecuperarClave extends StatefulWidget {
  const PaginaRecuperarClave({super.key});

  @override
  State<PaginaRecuperarClave> createState() => _EstadoPaginaRecuperarClave();
}

class _EstadoPaginaRecuperarClave extends State<PaginaRecuperarClave> {
  final _correo = TextEditingController();

  @override
  void dispose() {
    _correo.dispose();
    super.dispose();
  }

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
                  style: IconButton.styleFrom(
                    backgroundColor: ColoresApp.fondo,
                    side: const BorderSide(color: ColoresApp.borde),
                  ),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Recuperar contraseña',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ColoresApp.azulSuave,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Text('🔒', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 18),
            const Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: ColoresApp.negro,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa tu correo electrónico y te enviaremos un enlace '
              'para restablecer tu contraseña.',
              style: TextStyle(
                fontSize: 14,
                color: ColoresApp.textoAyuda,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'CORREO ELECTRÓNICO',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 0.8,
                color: ColoresApp.textoAyuda,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'hola@ejemplo.com',
                filled: true,
                fillColor: ColoresApp.blanco,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: ColoresApp.borde),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: ColoresApp.borde),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: ColoresApp.azul, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enlace enviado (demo)')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: const Text('Enviar enlace'),
            ),
            const SizedBox(height: 14),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver a Iniciar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
