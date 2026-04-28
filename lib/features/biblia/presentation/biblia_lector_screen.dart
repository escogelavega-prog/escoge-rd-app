import 'package:escoge/features/biblia/widgets/biblia_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              _RoyalReaderHeader(
                title:
                    '${chapterData.bookDisplay.toUpperCase()} $chapterNumber',
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                  children: [
                    _RoyalReaderPanel(
                      chapterData: chapterData,
                      chapterNumber: chapterNumber,
                    ),
                    const SizedBox(height: 18),
                    _RoyalNoteCard(
                      title: 'Reflexión breve',
                      icon: Icons.auto_awesome_rounded,
                      content: chapterData.reflection,
                    ),
                    const SizedBox(height: 14),
                    _RoyalActionButton(
                      title: 'Nota Teológica (Católica)',
                      icon: Icons.description_outlined,
                      primary: true,
                    ),
                    const SizedBox(height: 12),
                    _RoyalActionButton(
                      title: 'Nota de Estudio',
                      icon: Icons.edit_note_rounded,
                      primary: false,
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
class _RoyalReaderHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _RoyalReaderHeader({
    required this.title,
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
            color: Colors.black.withValues(alpha: 0.28),
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
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.star_rounded,
              color: Color(0xFFF2E2A7),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// PANEL REAL CATEDRAL
// =========================
class _RoyalReaderPanel extends StatelessWidget {
  final BibliaReaderChapterData chapterData;
  final int chapterNumber;

  const _RoyalReaderPanel({
    required this.chapterData,
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF063D67),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 2.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
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
            padding: const EdgeInsets.fromLTRB(26, 78, 26, 26),
            child: Column(
              children: [
                Text(
                  '${chapterData.bookDisplay.toUpperCase()} $chapterNumber',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFF0DEAA),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  chapterData.sectionTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    color: const Color(0xFFE1C56F),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 20),
                ...chapterData.verses.map(
                  (verse) => _VerseText(
                    verseNumber: verse.number,
                    text: verse.text,
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
// TEXTO REAL TIPO BIBLIA
// =========================
class _VerseText extends StatelessWidget {
  final int verseNumber;
  final String text;

  const _VerseText({
    required this.verseNumber,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.cormorantGaramond(
            color: const Color(0xFFF2E4BB),
            fontSize: 18.8,
            height: 1.48,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: '$verseNumber ',
              style: GoogleFonts.cormorantGaramond(
                color: const Color(0xFFD4AF37),
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                height: 1.48,
              ),
            ),
            TextSpan(
              text: text,
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// REFLEXIÓN
// =========================
class _RoyalNoteCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _RoyalNoteCard({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF052B47),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.34),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFE1C56F),
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              color: const Color(0xFFF3E2AE),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              color: const Color(0xFFF4E7BF),
              fontSize: 17,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// BOTONES
// =========================
class _RoyalActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool primary;

  const _RoyalActionButton({
    required this.title,
    required this.icon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final asset = primary
        ? 'assets/biblia/btn_primario_dorado.png'
        : 'assets/biblia/btn_secundario_outline.png';

    return SizedBox(
      height: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.fill,
            errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(
                color:
                    primary ? const Color(0xFFA7832D) : const Color(0xFF052B47),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFD4AF37),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: primary ? Colors.white : const Color(0xFFE1C56F),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cormorantGaramond(
                      color: primary ? Colors.white : const Color(0xFFF2E2AA),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.auto_awesome,
                  color: primary
                      ? Colors.white.withValues(alpha: 0.75)
                      : const Color(0xFFE1C56F),
                  size: 18,
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
// MOCK DATA
// =========================
class BibliaReaderChapterData {
  final String bookDisplay;
  final String sectionTitle;
  final String chapterTitle;
  final List<BibliaReaderVerse> verses;
  final String reflection;

  const BibliaReaderChapterData({
    required this.bookDisplay,
    required this.sectionTitle,
    required this.chapterTitle,
    required this.verses,
    required this.reflection,
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
    return BibliaReaderChapterData(
      bookDisplay: bookName,
      sectionTitle: 'Nuevo Testamento',
      chapterTitle: '$bookName $chapterNumber',
      verses: const [
        BibliaReaderVerse(
          number: 1,
          text: 'En el principio creó Dios el cielo y la tierra.',
        ),
        BibliaReaderVerse(
          number: 2,
          text:
              'La tierra era caos y confusión, y oscuridad por encima del abismo.',
        ),
        BibliaReaderVerse(
          number: 3,
          text: 'Dijo Dios: “Haya luz”, y hubo luz.',
        ),
        BibliaReaderVerse(
          number: 4,
          text:
              'Vio Dios que la luz estaba bien, y separó Dios la luz de la oscuridad.',
        ),
        BibliaReaderVerse(
          number: 5,
          text: 'Llamó Dios a la luz “día”, y a la oscuridad llamó “noche”.',
        ),
      ],
      reflection:
          'La Palabra de Dios merece una experiencia visual solemne, contemplativa y profundamente reverente.',
    );
  }
}
