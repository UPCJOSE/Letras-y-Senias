import 'package:flutter/material.dart';
import 'package:movi/ui/admin/pagina_dashboard_admin.dart';
import 'package:movi/ui/admin/pagina_editor_avatar.dart';
import 'package:movi/ui/admin/pagina_gestion_diccionario.dart';
import 'package:movi/ui/admin/pagina_usuarios_admin.dart';
import 'package:movi/ui/ajustes/pagina_ajustes.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/auth/pagina_inicio_sesion.dart';
import 'package:movi/ui/auth/pagina_onboarding.dart';
import 'package:movi/ui/auth/pagina_recuperar_clave.dart';
import 'package:movi/ui/auth/pagina_registro.dart';
import 'package:movi/ui/auth/pagina_splash.dart';
import 'package:movi/ui/deletreo/pagina_deletreo.dart';
import 'package:movi/ui/empresa/pagina_dashboard_empresa.dart';
import 'package:movi/ui/empresa/pagina_importar_usuarios.dart';
import 'package:movi/ui/empresa/pagina_usuarios_empresa.dart';
import 'package:movi/ui/historial/pagina_historial.dart';
import 'package:movi/ui/premium/pagina_premium.dart';
import 'package:movi/ui/sugerencias/pagina_palabra_no_encontrada.dart';
import 'package:movi/ui/traduccion/pagina_traduccion_lsc.dart';

class OpcionMenu {
  final String titulo;
  final VoidCallback? alPulsar;
  const OpcionMenu(this.titulo, {this.alPulsar});
}

Future<void> mostrarMenuHamburguesa(
  BuildContext context, {
  required ValueChanged<int> irAPestana,
}) {
  void ir(Widget pagina) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => pagina));
  }

  void irPestana(int i) {
    Navigator.of(context).pop();
    irAPestana(i);
  }

  final opciones = <OpcionMenu>[
    OpcionMenu('Splash', alPulsar: () => ir(const PaginaSplash())),
    OpcionMenu('Onboarding', alPulsar: () => ir(const PaginaOnboarding())),
    OpcionMenu('Inicio de sesión', alPulsar: () => ir(const PaginaInicioSesion())),
    OpcionMenu('Recuperar contraseña', alPulsar: () => ir(const PaginaRecuperarClave())),
    OpcionMenu('Registro', alPulsar: () => ir(const PaginaRegistro())),
    OpcionMenu('Inicio', alPulsar: () => irPestana(0)),
    OpcionMenu(
      'Traducción',
      alPulsar: () => ir(
        const PaginaTraduccionLsc(
          texto: 'Hola, necesito ayuda',
          senasDetectadas: ['Hola', 'Necesitar', 'Ayuda'],
        ),
      ),
    ),
    OpcionMenu(
      'Palabra no encontrada',
      alPulsar: () => ir(const PaginaPalabraNoEncontrada()),
    ),
    OpcionMenu('Deletreo', alPulsar: () => ir(const PaginaDeletreo())),
    OpcionMenu('Diccionario', alPulsar: () => irPestana(1)),
    OpcionMenu('Perfil', alPulsar: () => irPestana(2)),
    OpcionMenu('Historial de traducciones', alPulsar: () => ir(const PaginaHistorial())),
    OpcionMenu('Ajustes', alPulsar: () => ir(const PaginaAjustes())),
    OpcionMenu('Plan Premium', alPulsar: () => ir(const PaginaPremium())),
    OpcionMenu('Dashboard Empresa', alPulsar: () => ir(const PaginaDashboardEmpresa())),
    OpcionMenu('Gestión de usuarios', alPulsar: () => ir(const PaginaUsuariosEmpresa())),
    OpcionMenu('Importar usuarios', alPulsar: () => ir(const PaginaImportarUsuarios())),
    OpcionMenu('Dashboard Admin', alPulsar: () => ir(const PaginaDashboardAdmin())),
    OpcionMenu('Usuarios (Admin)', alPulsar: () => ir(const PaginaUsuariosAdmin())),
    OpcionMenu(
      'Usuarios de empresa',
      alPulsar: () => ir(const PaginaUsuariosEmpresa(nombreEmpresa: 'Hospital Central')),
    ),
    OpcionMenu('Gestión Diccionario', alPulsar: () => ir(const PaginaGestionDiccionario())),
    OpcionMenu('Editor de Avatar', alPulsar: () => ir(const PaginaEditorAvatar())),
  ];

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: ColoresApp.blanco,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColoresApp.borde,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'NAVEGAR A PANTALLA',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w600,
                        color: ColoresApp.textoAyuda,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3.2,
                    ),
                    itemCount: opciones.length,
                    itemBuilder: (context, i) {
                      final op = opciones[i];
                      return Material(
                        color: ColoresApp.azulSuave,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: op.alPulsar,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                op.titulo,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: ColoresApp.negroSuave,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
