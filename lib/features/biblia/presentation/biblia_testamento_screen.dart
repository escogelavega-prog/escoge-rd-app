import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/biblia/presentation/biblia_libro_capitulos_screen.dart';
import 'package:escoge/features/biblia/widgets/biblia_background.dart';

class BibliaTestamentoScreen extends StatelessWidget {
  final String testamentName;
  final List<BibliaBookGroup> groups;

  const BibliaTestamentoScreen({
    super.key,
    required this.testamentName,
    required this.groups,
  });

  factory BibliaTestamentoScreen.antiguo({Key? key}) {
    return BibliaTestamentoScreen(
      key: key,
      testamentName: 'EL ANTIGUO TESTAMENTO CATÓLICO',
      groups: BibliaStaticData.antiguoTestamento,
    );
  }

  factory BibliaTestamentoScreen.nuevo({Key? key}) {
    return BibliaTestamentoScreen(
      key: key,
      testamentName: 'EL NUEVO TESTAMENTO CATÓLICO',
      groups: BibliaStaticData.nuevoTestamento,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BibliaBackground(
        child: SafeArea(
          child: Column(
            children: [
              _RoyalTestamentHeader(
                title: testamentName,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                  children: [
                    _RoyalIntroPanel(totalGroups: groups.length),
                    const SizedBox(height: 18),
                    ...groups.map(
                      (group) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _RoyalGroupSection(group: group),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _RoyalBottomActions(),
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

class _RoyalTestamentHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _RoyalTestamentHeader({
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _RoyalIntroPanel extends StatelessWidget {
  final int totalGroups;

  const _RoyalIntroPanel({
    required this.totalGroups,
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
            padding: const EdgeInsets.fromLTRB(24, 82, 24, 24),
            child: Column(
              children: [
                Text(
                  'Biblioteca Sagrada',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFF0DEAA),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$totalGroups secciones disponibles',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    color: const Color(0xFFE1C56F),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Selecciona un libro y continúa el recorrido espiritual dentro del canon bíblico.',
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

class _RoyalGroupSection extends StatelessWidget {
  final BibliaBookGroup group;

  const _RoyalGroupSection({
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoyalSectionDivider(title: group.name),
        const SizedBox(height: 12),
        ...group.books.map(
          (book) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RoyalBookButton(book: book),
          ),
        ),
      ],
    );
  }
}

class _RoyalSectionDivider extends StatelessWidget {
  final String title;

  const _RoyalSectionDivider({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    Widget ornament(bool flipped) {
      final image = Image.asset(
        'assets/biblia/separador_seccion.png',
        height: 18,
        fit: BoxFit.fill,
        errorBuilder: (_, __, ___) => Container(
          height: 1,
          color: const Color(0xFFD4AF37),
        ),
      );

      if (!flipped) return image;

      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
        child: image,
      );
    }

    return Row(
      children: [
        Expanded(child: ornament(false)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: GoogleFonts.cormorantGaramond(
              color: const Color(0xFFE8C56A),
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(child: ornament(true)),
      ],
    );
  }
}

class _RoyalBookButton extends StatelessWidget {
  final BibliaBookItem book;

  const _RoyalBookButton({
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BibliaLibroCapitulosScreen(book: book),
          ),
        );
      },
      child: SizedBox(
        height: 74,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  _RoyalBookIcon(icon: book.icon),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      book.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        color: const Color(0xFFF5E7BE),
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${book.chapterCount}',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFF2E2AA),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'cap.',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xFFE1C56F),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFE8C56A),
                    size: 26,
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

class _RoyalBookIcon extends StatelessWidget {
  final IconData icon;

  const _RoyalBookIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.36),
        ),
      ),
      child: Icon(
        icon,
        color: const Color(0xFFF3D27A),
        size: 24,
      ),
    );
  }
}

class _RoyalBottomActions extends StatelessWidget {
  const _RoyalBottomActions();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _RoyalQuickAction(
          icon: Icons.star_rounded,
          title: 'Favoritos',
        ),
        SizedBox(height: 10),
        _RoyalQuickAction(
          icon: Icons.note_alt_rounded,
          title: 'Notas',
        ),
      ],
    );
  }
}

class _RoyalQuickAction extends StatelessWidget {
  final IconData icon;
  final String title;

  const _RoyalQuickAction({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF052B47).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFE8C56A),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.cormorantGaramond(
                color: const Color(0xFFF5E7BE),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFE8C56A),
          ),
        ],
      ),
    );
  }
}

// =========================
// DATA MODELS
// =========================

class BibliaBookGroup {
  final String name;
  final List<BibliaBookItem> books;

  const BibliaBookGroup({
    required this.name,
    required this.books,
  });
}

class BibliaBookItem {
  final String name;
  final String shortName;
  final int chapterCount;
  final IconData icon;

  const BibliaBookItem({
    required this.name,
    required this.shortName,
    required this.chapterCount,
    required this.icon,
  });

  String get displayName => name.toUpperCase();
}

// =========================
// STATIC DATA
// =========================

class BibliaStaticData {
  static const List<BibliaBookGroup> antiguoTestamento = [
    BibliaBookGroup(
      name: 'Pentateuco',
      books: [
        BibliaBookItem(
          name: 'Génesis',
          shortName: 'Gn',
          chapterCount: 50,
          icon: Icons.auto_stories_rounded,
        ),
        BibliaBookItem(
          name: 'Éxodo',
          shortName: 'Ex',
          chapterCount: 40,
          icon: Icons.menu_book_rounded,
        ),
        BibliaBookItem(
          name: 'Levítico',
          shortName: 'Lv',
          chapterCount: 27,
          icon: Icons.book_outlined,
        ),
        BibliaBookItem(
          name: 'Números',
          shortName: 'Nm',
          chapterCount: 36,
          icon: Icons.library_books_outlined,
        ),
        BibliaBookItem(
          name: 'Deuteronomio',
          shortName: 'Dt',
          chapterCount: 34,
          icon: Icons.import_contacts_rounded,
        ),
      ],
    ),
    BibliaBookGroup(
      name: 'Históricos',
      books: [
        BibliaBookItem(
          name: 'Josué',
          shortName: 'Jos',
          chapterCount: 24,
          icon: Icons.shield_outlined,
        ),
        BibliaBookItem(
          name: 'Jueces',
          shortName: 'Jc',
          chapterCount: 21,
          icon: Icons.gavel_rounded,
        ),
        BibliaBookItem(
          name: 'Rut',
          shortName: 'Rt',
          chapterCount: 4,
          icon: Icons.favorite_border_rounded,
        ),
        BibliaBookItem(
          name: '1 Samuel',
          shortName: '1 Sam',
          chapterCount: 31,
          icon: Icons.castle_outlined,
        ),
        BibliaBookItem(
          name: '2 Samuel',
          shortName: '2 Sam',
          chapterCount: 24,
          icon: Icons.castle_outlined,
        ),
      ],
    ),
    BibliaBookGroup(
      name: 'Sapienciales',
      books: [
        BibliaBookItem(
          name: 'Job',
          shortName: 'Job',
          chapterCount: 42,
          icon: Icons.psychology_alt_outlined,
        ),
        BibliaBookItem(
          name: 'Salmos',
          shortName: 'Sal',
          chapterCount: 150,
          icon: Icons.music_note_rounded,
        ),
        BibliaBookItem(
          name: 'Proverbios',
          shortName: 'Prov',
          chapterCount: 31,
          icon: Icons.lightbulb_outline_rounded,
        ),
        BibliaBookItem(
          name: 'Eclesiastés',
          shortName: 'Ecl',
          chapterCount: 12,
          icon: Icons.hourglass_bottom_rounded,
        ),
      ],
    ),
    BibliaBookGroup(
      name: 'Profetas',
      books: [
        BibliaBookItem(
          name: 'Isaías',
          shortName: 'Is',
          chapterCount: 66,
          icon: Icons.wb_twilight_outlined,
        ),
        BibliaBookItem(
          name: 'Jeremías',
          shortName: 'Jer',
          chapterCount: 52,
          icon: Icons.local_fire_department_outlined,
        ),
        BibliaBookItem(
          name: 'Ezequiel',
          shortName: 'Ez',
          chapterCount: 48,
          icon: Icons.visibility_outlined,
        ),
        BibliaBookItem(
          name: 'Daniel',
          shortName: 'Dn',
          chapterCount: 14,
          icon: Icons.stars_rounded,
        ),
      ],
    ),
  ];

  static const List<BibliaBookGroup> nuevoTestamento = [
    BibliaBookGroup(
      name: 'Evangelios',
      books: [
        BibliaBookItem(
          name: 'Mateo',
          shortName: 'Mt',
          chapterCount: 28,
          icon: Icons.auto_stories_rounded,
        ),
        BibliaBookItem(
          name: 'Marcos',
          shortName: 'Mc',
          chapterCount: 16,
          icon: Icons.menu_book_rounded,
        ),
        BibliaBookItem(
          name: 'Lucas',
          shortName: 'Lc',
          chapterCount: 24,
          icon: Icons.local_drink_rounded,
        ),
        BibliaBookItem(
          name: 'Juan',
          shortName: 'Jn',
          chapterCount: 21,
          icon: Icons.auto_awesome_rounded,
        ),
      ],
    ),
    BibliaBookGroup(
      name: 'Historia',
      books: [
        BibliaBookItem(
          name: 'Hechos',
          shortName: 'Hch',
          chapterCount: 28,
          icon: Icons.account_balance_rounded,
        ),
      ],
    ),
    BibliaBookGroup(
      name: 'Cartas Paulinas',
      books: [
        BibliaBookItem(
          name: 'Romanos',
          shortName: 'Rm',
          chapterCount: 16,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: '1 Corintios',
          shortName: '1 Co',
          chapterCount: 16,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: '2 Corintios',
          shortName: '2 Co',
          chapterCount: 13,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: 'Gálatas',
          shortName: 'Ga',
          chapterCount: 6,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: 'Efesios',
          shortName: 'Ef',
          chapterCount: 6,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: 'Filipenses',
          shortName: 'Flp',
          chapterCount: 4,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: 'Colosenses',
          shortName: 'Col',
          chapterCount: 4,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: '1 Tesalonicenses',
          shortName: '1 Ts',
          chapterCount: 5,
          icon: Icons.book_rounded,
        ),
      ],
    ),
    BibliaBookGroup(
      name: 'Cartas Católicas',
      books: [
        BibliaBookItem(
          name: 'Santiago',
          shortName: 'St',
          chapterCount: 5,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: '1 Pedro',
          shortName: '1 Pe',
          chapterCount: 5,
          icon: Icons.book_rounded,
        ),
        BibliaBookItem(
          name: '1 Juan',
          shortName: '1 Jn',
          chapterCount: 5,
          icon: Icons.book_rounded,
        ),
      ],
    ),
    BibliaBookGroup(
      name: 'Apocalipsis',
      books: [
        BibliaBookItem(
          name: 'Apocalipsis',
          shortName: 'Ap',
          chapterCount: 22,
          icon: Icons.bolt_rounded,
        ),
      ],
    ),
  ];
}
