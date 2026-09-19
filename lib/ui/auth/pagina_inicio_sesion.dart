import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/auth/pagina_recuperar_clave.dart';
import 'package:movi/ui/auth/pagina_registro.dart';
import 'package:movi/ui/shell/pagina_principal.dart';

/// Inicio de sesión (mockup SeñasApp).
class PaginaInicioSesion extends StatefulWidget {
  const PaginaInicioSesion({super.key});

  @override
  State<PaginaInicioSesion> createState() => _EstadoPaginaInicioSesion();
}

class _EstadoPaginaInicioSesion extends State<PaginaInicioSesion> {
  final _correo = TextEditingController();
  final _clave = TextEditingController();

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _irPrincipal() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PaginaPrincipal()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.blanco,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
              decoration: const BoxDecoration(
                color: ColoresApp.azul,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0x33FFFFFF),
                    child: Text('🎓', style: TextStyle(fontSize: 32)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'SeñasApp',
                    style: TextStyle(
                      color: ColoresApp.blanco,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Bienvenido de nuevo',
                    style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 15),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                children: [
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
                    decoration: _campo('hola@ejemplo.com'),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'CONTRASEÑA',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 0.8,
                      color: ColoresApp.textoAyuda,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _clave,
                    obscureText: true,
                    decoration: _campo('••••••••'),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PaginaRecuperarClave(),
                          ),
                        );
                      },
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _irPrincipal,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: const Text('Iniciar sesión'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaginaRegistro(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ColoresApp.azul,
                      minimumSize: const Size.fromHeight(52),
                      side: const BorderSide(color: ColoresApp.azul, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text('Registrarse'),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('o', style: TextStyle(color: ColoresApp.textoAyuda)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _irPrincipal,
                    style: TextButton.styleFrom(
                      backgroundColor: ColoresApp.azulSuave,
                      foregroundColor: ColoresApp.negroSuave,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text('Continuar como invitado'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _campo(String pista) {
    return InputDecoration(
      hintText: pista,
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
