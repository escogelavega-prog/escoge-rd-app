import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/biblia/presentation/biblia_lector_screen.dart';
import 'package:escoge/features/biblia/presentation/biblia_testamento_screen.dart';
import 'package:escoge/features/biblia/widgets/biblia_background.dart';
import 'package:escoge/features/biblia/widgets/biblia_header.dart';
import 'package:escoge/features/biblia/widgets/biblia_panel.dart';
import 'package:escoge/features/biblia/widgets/biblia_section_title.dart';

class BibliaLibroCapitulosScreen extends StatelessWidget {
  final BibliaBookItem book;

  const BibliaLibroCapitulosScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final chapters =
        List<int>.generate(book.chapterCount, (index) => index + 1);

    return Scaffold(
      body: BibliaBackground(
        child: SafeArea(
          child: Column(
            children: [
              BibliaHeader(
                title: book.name,
                subtitle: 'Selecciona un capítulo',
                onBack: () => Navigator.of(context).pop(),
                trailing: _BookBadge(shortName: book.shortName),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: BibliaSectionTitle(
                  title: '${book.chapterCount} capítulos disponibles',
                ),
              ),
              BibliaPanel(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Explora cada capítulo de ${book.name} y continúa el recorrido de lectura con una experiencia visual unificada.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(
                        color: const Color(0xFFF6E7B8),
                        fontSize: 14.5,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BibliaPanel(
                  margin: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount =
                          _resolveCrossAxisCount(constraints.maxWidth);

                      return GridView.builder(
                        itemCount: chapters.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.02,
                        ),
                        itemBuilder: (context, index) {
                          final chapter = chapters[index];
                          return _ChapterCard(
                            chapter: chapter,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BibliaLectorScreen(
                                    bookName: book.name,
                                    shortName: book.shortName,
                                    chapterNumber: chapter,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _resolveCrossAxisCount(double width) {
    if (width >= 900) return 6;
    if (width >= 700) return 5;
    if (width >= 520) return 4;
    return 3;
  }
}

class _ChapterCard extends StatelessWidget {
  final int chapter;
  final VoidCallback onTap;

  const _ChapterCard({
    required this.chapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0A264E).withOpacity(0.94),
                const Color(0xFF081C39).withOpacity(0.98),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.42),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                right: 10,
                child: Opacity(
                  opacity: 0.18,
                  child: Image.asset(
                    'assets/images/biblia/icon_arrow_right.png',
                    width: 16,
                    height: 16,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Capítulo',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFE4D4A3),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$chapter',
                      style: GoogleFonts.cormorantGaramond(
                        color: const Color(0xFFF4DFA3),
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookBadge extends StatelessWidget {
  final String shortName;

  const _BookBadge({
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
