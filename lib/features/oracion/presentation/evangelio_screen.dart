import 'package:escoge/features/oracion/presentation/evangelio_action_row.dart';
import 'package:escoge/features/oracion/presentation/evangelio_content_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/oracion_header.dart';
import '../widgets/evangelio_feature_image.dart';

class EvangelioScreen extends StatelessWidget {
  const EvangelioScreen({super.key});

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color deepBlue = Color(0xFF081B4B);
  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlue,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF081B4B), Color(0xFF0B1E66)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              /// HEADER
              OracionHeader(
                title: 'Evangelio del Día',
                subtitle: 'Un momento para escuchar la voz de Dios',
                onBackTap: () => Navigator.pop(context),
              ),

              /// CONTENIDO
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F6FB),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// IMAGEN (más protagonista)
                        const EvangelioFeatureImage(
                          imagePath: 'assets/images/evangelio_biblia.png',
                        ),

                        const SizedBox(height: 26),

                        /// CONTENIDO PRINCIPAL
                        const EvangelioContentCard(
                          fecha: 'Jueves 25 de Abril, 2026',
                          cita: 'Juan 15, 9-17',
                          introduccion:
                              'En aquel tiempo, Jesús dijo a sus discípulos:',
                          cuerpo:
                              '“Como el Padre me ama, así los amo yo. Permanezcan en mi amor. '
                              'Si cumplen mis mandamientos, permanecen en mi amor; lo mismo que yo '
                              'cumplo los mandamientos de mi Padre y permanezco en su amor.”',
                          destacado:
                              '“Yo los he amado a ustedes, como mi Padre me ha amado. '
                              'Permanezcan en mi amor.”',
                        ),

                        const SizedBox(height: 28),

                        /// ACCIONES
                        EvangelioActionRow(
                          onReminderTap: () {},
                          onLecturasTap: () {
                            Navigator.pop(context);
                          },
                        ),

                        const SizedBox(height: 36),

                        /// REFLEXIÓN (más elegante)
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 28,
                              decoration: BoxDecoration(
                                color: gold,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Reflexión',
                              style: GoogleFonts.lora(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: primaryBlue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .04),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Text(
                            'Esta lectura nos invita a permanecer en el amor de Cristo, '
                            'no como una idea abstracta, sino como una forma concreta de vivir. '
                            'Amar, obedecer y permanecer unidos a Dios transforma el corazón.',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              height: 1.8,
                              color: const Color(0xFF49516B),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
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
