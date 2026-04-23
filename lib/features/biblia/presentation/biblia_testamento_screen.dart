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
              _TopBar(
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        testamentName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xFFE8C56A),
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...groups.map(
                      (group) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _SectionBlock(group: group),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _BottomQuickActions(),
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

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _TopBar({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 6),
      child: Row(
        children: [
          _CircleActionButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0A1E3A).withOpacity(0.82),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.30),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE7C666),
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final BibliaBookGroup group;

  const _SectionBlock({
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OrnamentalSectionTitle(title: group.name),
        const SizedBox(height: 10),
        ...group.books.map(
          (book) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _BookRow(book: book),
          ),
        ),
      ],
    );
  }
}

class _OrnamentalSectionTitle extends StatelessWidget {
  final String title;

  const _OrnamentalSectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _OrnamentLine()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              color: const Color(0xFFE8C56A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        const Expanded(child: _OrnamentLine(isReversed: true)),
      ],
    );
  }
}

class _OrnamentLine extends StatelessWidget {
  final bool isReversed;

  const _OrnamentLine({
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    final ornament = Image.asset(
      'assets/images/biblia/separador_seccion.png',
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return Container(
          height: 14,
          alignment: Alignment.center,
          child: Container(
            height: 1.2,
            color: const Color(0xFFD4AF37).withOpacity(0.55),
          ),
        );
      },
    );

    return SizedBox(
      height: 16,
      child:
          isReversed ? Transform.flip(flipX: true, child: ornament) : ornament,
    );
  }
}

class _BookRow extends StatelessWidget {
  final BibliaBookItem book;

  const _BookRow({
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BibliaLibroCapitulosScreen(book: book),
            ),
          );
        },
        child: Ink(
          height: 74,
          decoration: BoxDecoration(
            color: const Color(0xFF08264B).withOpacity(0.94),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.70),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.22),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              _BookIcon(icon: book.icon),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  book.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cormorantGaramond(
                    color: const Color(0xFFF5E7BE),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/biblia/icon_arrow_right.png',
                width: 22,
                height: 22,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFE8C56A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookIcon extends StatelessWidget {
  final IconData icon;

  const _BookIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.40),
          width: 1,
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

class _BottomQuickActions extends StatelessWidget {
  const _BottomQuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuickActionRow(
          icon: Icons.star_rounded,
          title: 'Favoritos',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Favoritos estará disponible en la siguiente fase.'),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        _QuickActionRow(
          icon: Icons.note_rounded,
          title: 'Notas',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notas estará disponible en la siguiente fase.'),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFE8C56A),
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cormorantGaramond(
                    color: const Color(0xFFF5E7BE),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFFE8C56A),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
