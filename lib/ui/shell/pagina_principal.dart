import 'package:flutter/material.dart';
import 'package:movi/model/sesion_usuario.dart';
import 'package:movi/ui/admin/pagina_admin.dart';
import 'package:movi/ui/palabras/pagina_palabras.dart';
import 'package:movi/ui/shell/widgets/cabecera_lsc.dart';
import 'package:movi/ui/shell/widgets/navegacion_superior.dart';
import 'package:movi/ui/suscripcion/pagina_suscripcion.dart';
import 'package:movi/ui/traductor/pagina_traductor.dart';
import 'package:movi/ui/vectorial/pagina_vectorial.dart';

/// Shell LSC App: cabecera + nav + contenido (port del mockup React).
class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _EstadoPaginaPrincipal();
}

class _EstadoPaginaPrincipal extends State<PaginaPrincipal> {
  int _indice = 0;
  SesionUsuario? _sesion;

  void _iniciarSesion(SesionUsuario s) {
    setState(() {
      _sesion = s;
      _indice = 4; // suscripción para ver confirmación
    });
  }

  void _cerrarSesion() {
    setState(() {
      _sesion = null;
      if (_indice == 2 || _indice == 3) _indice = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      const PaginaTraductor(),
      const PaginaPalabras(),
      const PaginaVectorial(),
      const PaginaAdmin(),
      PaginaSuscripcion(
        sesion: _sesion,
        alIniciarSesion: _iniciarSesion,
        alCerrarSesion: _cerrarSesion,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            CabeceraLsc(sesion: _sesion),
            NavegacionSuperior(
              indice: _indice,
              alCambiar: (i) => setState(() => _indice = i),
            ),
            Expanded(
              child: IndexedStack(
                index: _indice,
                children: paginas,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
