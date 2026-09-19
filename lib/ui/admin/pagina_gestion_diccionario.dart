import 'package:flutter/material.dart';
import 'package:movi/ui/admin/pagina_editor_avatar.dart';
import 'package:movi/ui/aplicacion.dart';

/// Formulario para crear/publicar una seña en el diccionario.
class PaginaGestionDiccionario extends StatelessWidget {
  const PaginaGestionDiccionario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.blanco,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: ColoresApp.borde)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Gestionar Diccionario',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ColoresApp.azulSuave,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColoresApp.azulClaro),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nueva seña',
                          style: TextStyle(
                            color: ColoresApp.azul,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Completa el formulario y edita el avatar para crear una seña',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColoresApp.negroSuave,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'PALABRA',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoAyuda,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const TextField(decoration: InputDecoration(hintText: 'Ej: Bienvenido')),
                  const SizedBox(height: 16),
                  const Text(
                    'CATEGORÍA',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoAyuda,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const TextField(decoration: InputDecoration(hintText: 'Saludos')),
                  const SizedBox(height: 16),
                  const Text(
                    'DESCRIPCIÓN',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoAyuda,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Descripción de la seña y su contexto de uso',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'AVATAR DE LA SEÑA',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoAyuda,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ColoresApp.borde,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: ColoresApp.azulSuave,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.accessibility_new,
                            size: 48,
                            color: ColoresApp.azul,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sin keyframes definidos',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: ColoresApp.negroSuave,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PaginaEditorAvatar(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Abrir editor de avatar'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Borrador guardado (demo)'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            foregroundColor: ColoresApp.negroSuave,
                            side: const BorderSide(color: ColoresApp.borde),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Guardar borrador'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Seña publicada (demo)'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Publicar seña'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
