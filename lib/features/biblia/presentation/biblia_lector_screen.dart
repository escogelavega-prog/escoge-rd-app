import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/biblia/widgets/biblia_background.dart';
import 'package:escoge/features/biblia/widgets/biblia_header.dart';
import 'package:escoge/features/biblia/widgets/biblia_panel.dart';
import 'package:escoge/features/biblia/widgets/biblia_primary_button.dart';
import 'package:escoge/features/biblia/widgets/biblia_secondary_button.dart';
import 'package:escoge/features/biblia/widgets/biblia_section_title.dart';

class BibliaLectorScreen extends StatelessWidget {
  final String bookName;
  final String shortName;
  final int chapterNumber;

  const BibliaLectorScreen({
    super.key,
    required this.bookName,
    required this.shortName,
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    final chapterData = BibliaReaderMockData.getChapter(
      bookName: bookName,
      chapterNumber: chapterNumber,
    );

    return Scaffold(
      body: BibliaBackground(
        child: SafeArea(
          child: Column(
            children: [
              BibliaHeader(
                title: bookName,
                subtitle: 'Capítulo $chapterNumber',
                onBack: () => Navigator.of(context).pop(),
                trailing: _ReaderBadge(shortName: shortName),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: BibliaSectionTitle(
                  title: chapterData.sectionTitle,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      BibliaPanel(
                        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${chapterData.bookDisplay} $chapterNumber',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD4AF37),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              chapterData.chapterTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cormorantGaramond(
                                color: const Color(0xFFF4DFA3),
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ...chapterData.verses.map(
                              (verse) => Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _VerseText(
                                  verseNumber: verse.number,
                                  text: verse.text,
                                ),
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
                              'Reflexión breve',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cormorantGaramond(
                                color: const Color(0xFFF4DFA3),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              chapterData.reflection,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                color: const Color(0xFFF6E7B8),
                                fontSize: 14.5,
                                height: 1.7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: BibliaPrimaryButton(
                          text: 'Nota Teológica (Católica)',
                          onTap: () {
                            _showInfoSheet(
                              context,
                              title: 'Nota Teológica (Católica)',
                              content: chapterData.theologicalNote,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: BibliaSecondaryButton(
                          text: 'Nota de Estudio',
                          onTap: () {
                            _showInfoSheet(
                              context,
                              title: 'Nota de Estudio',
                              content: chapterData.studyNote,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: BibliaSecondaryButton(
                          text: 'Compartir',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'La opción de compartir se conectará en la siguiente fase.',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
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

  void _showInfoSheet(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF071C38),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      color: const Color(0xFFF4DFA3),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    content,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.lora(
                      color: const Color(0xFFF6E7B8),
                      fontSize: 15,
                      height: 1.8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VerseText extends StatelessWidget {
  final int verseNumber;
  final String text;

  const _VerseText({
    required this.verseNumber,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$verseNumber  ',
            style: GoogleFonts.poppins(
              color: const Color(0xFFD4AF37),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              height: 1.9,
            ),
          ),
          TextSpan(
            text: text,
            style: GoogleFonts.lora(
              color: const Color(0xFFF6E7B8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.9,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderBadge extends StatelessWidget {
  final String shortName;

  const _ReaderBadge({
    required this.shortName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF082447).withOpacity(0.72),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.35),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        shortName,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: const Color(0xFFF3D27A),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class BibliaReaderChapterData {
  final String bookDisplay;
  final String sectionTitle;
  final String chapterTitle;
  final List<BibliaReaderVerse> verses;
  final String reflection;
  final String theologicalNote;
  final String studyNote;

  const BibliaReaderChapterData({
    required this.bookDisplay,
    required this.sectionTitle,
    required this.chapterTitle,
    required this.verses,
    required this.reflection,
    required this.theologicalNote,
    required this.studyNote,
  });
}

class BibliaReaderVerse {
  final int number;
  final String text;

  const BibliaReaderVerse({
    required this.number,
    required this.text,
  });
}

class BibliaReaderMockData {
  static BibliaReaderChapterData getChapter({
    required String bookName,
    required int chapterNumber,
  }) {
    if (bookName.toLowerCase() == 'mateo' && chapterNumber == 5) {
      return const BibliaReaderChapterData(
        bookDisplay: 'Mateo',
        sectionTitle: 'Sermón del Monte',
        chapterTitle: 'Las Bienaventuranzas',
        verses: [
          BibliaReaderVerse(
            number: 1,
            text:
                'Al ver la multitud, Jesús subió al monte; se sentó, y se le acercaron sus discípulos.',
          ),
          BibliaReaderVerse(
            number: 2,
            text: 'Entonces comenzó a hablar y les enseñaba diciendo:',
          ),
          BibliaReaderVerse(
            number: 3,
            text:
                'Bienaventurados los pobres de espíritu, porque de ellos es el Reino de los cielos.',
          ),
          BibliaReaderVerse(
            number: 4,
            text:
                'Bienaventurados los que lloran, porque ellos serán consolados.',
          ),
          BibliaReaderVerse(
            number: 5,
            text:
                'Bienaventurados los mansos, porque ellos heredarán la tierra.',
          ),
          BibliaReaderVerse(
            number: 6,
            text:
                'Bienaventurados los que tienen hambre y sed de justicia, porque ellos quedarán saciados.',
          ),
          BibliaReaderVerse(
            number: 7,
            text:
                'Bienaventurados los misericordiosos, porque ellos alcanzarán misericordia.',
          ),
          BibliaReaderVerse(
            number: 8,
            text:
                'Bienaventurados los limpios de corazón, porque ellos verán a Dios.',
          ),
          BibliaReaderVerse(
            number: 9,
            text:
                'Bienaventurados los que trabajan por la paz, porque ellos serán llamados hijos de Dios.',
          ),
          BibliaReaderVerse(
            number: 10,
            text:
                'Bienaventurados los perseguidos por causa de la justicia, porque de ellos es el Reino de los cielos.',
          ),
        ],
        reflection:
            'Cristo presenta el camino de la verdadera felicidad. No es una felicidad superficial, sino una vida transformada por la humildad, la misericordia, la justicia y la comunión con Dios.',
        theologicalNote:
            'Las Bienaventuranzas ocupan un lugar central en la espiritualidad cristiana. La tradición católica las entiende como retrato del mismo Cristo y como programa de vida para el discípulo. En ellas, el Señor invierte la lógica del mundo y revela la grandeza de quienes viven abiertos a la gracia, a la verdad y al amor de Dios.',
        studyNote:
            'Este pasaje abre el Sermón del Monte. Observa que Jesús no solo da mandatos: primero revela quiénes son verdaderamente dichosos ante Dios. Puedes estudiar este texto relacionándolo con Isaías, los Salmos y el llamado a la santidad en el Nuevo Testamento.',
      );
    }

    return BibliaReaderChapterData(
      bookDisplay: bookName,
      sectionTitle: 'Lectura Bíblica',
      chapterTitle: '$bookName $chapterNumber',
      verses: [
        BibliaReaderVerse(
          number: 1,
          text:
              'Este capítulo será conectado con la fuente de datos real en la siguiente fase del módulo Biblia.',
        ),
        BibliaReaderVerse(
          number: 2,
          text:
              'Por ahora, esta pantalla ya representa la estructura oficial del lector premium: cabecera, título, versículos, reflexión y notas complementarias.',
        ),
        BibliaReaderVerse(
          number: 3,
          text:
              'Cuando conectemos la data real, aquí se mostrarán los versículos exactos del libro y capítulo seleccionados.',
        ),
      ],
      reflection:
          'La Palabra de Dios merece una experiencia de lectura clara, contemplativa y profundamente ordenada.',
      theologicalNote:
          'Esta sección servirá para explicar el sentido doctrinal, espiritual y eclesial del pasaje leído, con enfoque católico.',
      studyNote:
          'Esta sección permitirá ampliar contexto histórico, literario y pastoral del texto bíblico, facilitando una lectura más profunda.',
    );
  }
}
