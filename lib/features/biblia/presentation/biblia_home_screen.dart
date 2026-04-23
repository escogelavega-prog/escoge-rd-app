import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/biblia/widgets/biblia_background.dart';
import 'package:escoge/features/biblia/widgets/biblia_header.dart';
import 'package:escoge/features/biblia/widgets/biblia_panel.dart';
import 'package:escoge/features/biblia/widgets/biblia_primary_button.dart';
import 'package:escoge/features/biblia/widgets/biblia_secondary_button.dart';
import 'package:escoge/features/biblia/widgets/biblia_section_title.dart';

class BibliaHomeScreen extends StatelessWidget {
  const BibliaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BibliaBackground(
        child: SafeArea(
          child: Column(
            children: [
              BibliaHeader(
                title: 'Santa Biblia',
                subtitle: 'Palabra viva para el alma',
                onBack: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: BibliaSectionTitle(
                          title: 'Antiguo y Nuevo Testamento',
                        ),
                      ),
                      BibliaPanel(
                        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'La Sagrada Escritura contiene la historia de la salvación y la revelación de Dios para su pueblo.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                color: const Color(0xFFF6E7B8),
                                fontSize: 15,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 22),
                            BibliaPrimaryButton(
                              text: 'Antiguo Testamento',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const BibliaPlaceholderScreen(
                                      title: 'Antiguo Testamento',
                                      subtitle:
                                          'Próxima pantalla: grupos y libros',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            BibliaPrimaryButton(
                              text: 'Nuevo Testamento',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const BibliaPlaceholderScreen(
                                      title: 'Nuevo Testamento',
                                      subtitle:
                                          'Próxima pantalla: evangelios, cartas y más',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Selecciona el testamento para comenzar el recorrido por libros, capítulos y lectura.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color:
                                    const Color(0xFFE3D3A0).withOpacity(0.92),
                                fontSize: 12.5,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      BibliaPanel(
                        margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Accesos rápidos',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cormorantGaramond(
                                color: const Color(0xFFF4DFA3),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            BibliaSecondaryButton(
                              text: 'Favoritos',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Favoritos estará disponible en la siguiente fase.'),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            BibliaSecondaryButton(
                              text: 'Notas',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Notas estará disponible en la siguiente fase.'),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            BibliaSecondaryButton(
                              text: 'Continuar lectura',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Continuar lectura estará disponible en la siguiente fase.'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '“Lámpara es tu palabra para mis pasos, luz en mi sendero.”',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lora(
                            color: const Color(0xFFF4DFA3).withOpacity(0.95),
                            fontSize: 15,
                            height: 1.7,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Salmo 119, 105',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFD4AF37),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 20),
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
}

class BibliaPlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const BibliaPlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BibliaBackground(
        child: SafeArea(
          child: Column(
            children: [
              BibliaHeader(
                title: title,
                subtitle: subtitle,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Center(
                  child: BibliaPanel(
                    height: 260,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Esta pantalla será conectada en el siguiente paso con la navegación real del módulo Biblia.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lora(
                            color: const Color(0xFFF6E7B8),
                            fontSize: 16,
                            height: 1.7,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
