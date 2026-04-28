import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/biblia/presentation/biblia_lector_screen.dart';
import 'package:escoge/features/biblia/presentation/biblia_testamento_screen.dart';
import 'package:escoge/features/biblia/widgets/biblia_background.dart';

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
              _RoyalBookHeader(
                title: book.name.toUpperCase(),
                shortName: book.shortName,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                  children: [
                    _RoyalBookIntroPanel(
                      book: book,
                    ),
                    const SizedBox(height: 18),
                    _RoyalSectionDivider(
                      title: '${book.chapterCount} capítulos',
                    ),
                    const SizedBox(height: 14),
                    _RoyalChapterGrid(
                      chapters: chapters,
                      book: book,
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

// =========================
// HEADER REAL
// =========================
class _RoyalBookHeader extends StatelessWidget {
  final String title;
  final String shortName;
  final VoidCallback onBack;

  const _RoyalBookHeader({
    required this.title,
    required this.shortName,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 4),
      decoration: BoxDecoration(
        color: const Color(0xFFA7832D),
        border: Border.all(
          color: const Color(0xFFE5C86E),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Text(
              shortName,
              style: GoogleFonts.cormorantGaramond(
                color: const Color(0xFFF4E3AF),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// PANEL INTRO
// =========================
class _RoyalBookIntroPanel extends StatelessWidget {
  final BibliaBookItem book;

  const _RoyalBookIntroPanel({
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF063D67),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 18,
            right: 18,
            child: Image.asset(
              'assets/biblia/frame_lector_superior.png',
              height: 88,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 82, 24, 24),
            child: Column(
              children: [
                Text(
                  book.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFF0DEAA),
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${book.chapterCount} capítulos disponibles',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    color: const Color(0xFFE1C56F),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Selecciona un capítulo y continúa el recorrido espiritual dentro de ${book.name}.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    color: const Color(0xFFF4E7BF),
                    fontSize: 18,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// DIVISOR
// =========================
class _RoyalSectionDivider extends StatelessWidget {
  final String title;

  const _RoyalSectionDivider({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Image.asset(
            'assets/biblia/separador_seccion.png',
            height: 18,
            fit: BoxFit.fill,
            errorBuilder: (_, __, ___) => Container(
              height: 1,
              color: const Color(0xFFD4AF37),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: GoogleFonts.cormorantGaramond(
              color: const Color(0xFFE1C56F),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(-1.0, 1.0),
            child: Image.asset(
              'assets/biblia/separador_seccion.png',
              height: 18,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(
                height: 1,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =========================
// GRID REAL
// =========================
class _RoyalChapterGrid extends StatelessWidget {
  final List<int> chapters;
  final BibliaBookItem book;

  const _RoyalChapterGrid({
    required this.chapters,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: chapters.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.18,
      ),
      itemBuilder: (context, index) {
        final chapter = chapters[index];

        return _RoyalChapterButton(
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
  }
}

// =========================
// BOTÓN CAPÍTULO REAL
// =========================
class _RoyalChapterButton extends StatelessWidget {
  final int chapter;
  final VoidCallback onTap;

  const _RoyalChapterButton({
    required this.chapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/biblia/btn_secundario_outline.png',
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF052B47),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Capítulo',
                    style: GoogleFonts.cormorantGaramond(
                      color: const Color(0xFFE1C56F),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$chapter',
                    style: GoogleFonts.cinzel(
                      color: const Color(0xFFF2E2AA),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
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
