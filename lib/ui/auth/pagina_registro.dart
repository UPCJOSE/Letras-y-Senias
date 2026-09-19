import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Registro / Crear cuenta.
class PaginaRegistro extends StatefulWidget {
  const PaginaRegistro({super.key});

  @override
  State<PaginaRegistro> createState() => _EstadoPaginaRegistro();
}

class _EstadoPaginaRegistro extends State<PaginaRegistro> {
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  final _confirmar = TextEditingController();
  String _tipo = 'Usuario';

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _clave.dispose();
    _confirmar.dispose();
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
                  'Crear cuenta',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _etiqueta('NOMBRE COMPLETO'),
            TextField(
              controller: _nombre,
              decoration: _campo('Ana Gómez'),
            ),
            const SizedBox(height: 16),
            _etiqueta('CORREO ELECTRÓNICO'),
            TextField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              decoration: _campo('ana@ejemplo.com'),
            ),
            const SizedBox(height: 16),
            _etiqueta('CONTRASEÑA'),
            TextField(
              controller: _clave,
              obscureText: true,
              decoration: _campo('••••••••'),
            ),
            const SizedBox(height: 16),
            _etiqueta('CONFIRMAR CONTRASEÑA'),
            TextField(
              controller: _confirmar,
              obscureText: true,
              decoration: _campo('••••••••'),
            ),
            const SizedBox(height: 18),
            _etiqueta('TIPO DE CUENTA'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TipoCuenta(
                    icono: Icons.person_outline,
                    etiqueta: 'Usuario',
                    activo: _tipo == 'Usuario',
                    alPulsar: () => setState(() => _tipo = 'Usuario'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TipoCuenta(
                    icono: Icons.business_center_outlined,
                    etiqueta: 'Empresa',
                    activo: _tipo == 'Empresa',
                    alPulsar: () => setState(() => _tipo = 'Empresa'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cuenta $_tipo creada (demo)')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _etiqueta(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          t,
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 0.8,
            color: ColoresApp.textoAyuda,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

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

class _TipoCuenta extends StatelessWidget {
  const _TipoCuenta({
    required this.icono,
    required this.etiqueta,
    required this.activo,
    required this.alPulsar,
  });

  final IconData icono;
  final String etiqueta;
  final bool activo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: activo ? ColoresApp.azul : ColoresApp.borde,
            width: activo ? 1.5 : 1,
          ),
          color: activo ? ColoresApp.azulSuave : ColoresApp.blanco,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              color: activo ? ColoresApp.azul : ColoresApp.textoAyuda,
            ),
            const SizedBox(width: 6),
            Text(
              etiqueta,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: activo ? ColoresApp.azul : ColoresApp.textoAyuda,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
