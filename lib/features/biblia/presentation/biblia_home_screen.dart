import 'dart:ui';

import 'package:escoge/features/biblia/widgets/biblia_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BibliaHomeScreen extends StatefulWidget {
  const BibliaHomeScreen({super.key});

  @override
  State<BibliaHomeScreen> createState() => _BibliaHomeScreenState();
}

enum _BibliaTestamento {
  antiguo,
  nuevo,
}

class _BibliaHomeScreenState extends State<BibliaHomeScreen> {
  _BibliaTestamento _selected = _BibliaTestamento.nuevo;

  final List<_BibliaGroup> _nuevoTestamento = const [
    _BibliaGroup(
      title: 'Evangelios',
      books: [
        _BibliaBook(title: 'MATEO', icon: Icons.pets_rounded),
        _BibliaBook(title: 'MARCOS', icon: Icons.pets_rounded),
        _BibliaBook(title: 'LUCAS', icon: Icons.wine_bar_rounded),
        _BibliaBook(title: 'JUAN', icon: Icons.auto_awesome_rounded),
      ],
    ),
    _BibliaGroup(
      title: 'Historia',
      books: [
        _BibliaBook(title: 'HECHOS', icon: Icons.menu_book_rounded),
      ],
    ),
    _BibliaGroup(
      title: 'Cartas Paulinas',
      books: [
        _BibliaBook(title: 'Rm', icon: Icons.book_rounded),
        _BibliaBook(title: '1 Co', icon: Icons.book_rounded),
        _BibliaBook(title: '2 Co', icon: Icons.book_rounded),
        _BibliaBook(title: 'Gál', icon: Icons.book_rounded),
        _BibliaBook(title: 'Ef', icon: Icons.book_rounded),
        _BibliaBook(title: 'Flp', icon: Icons.book_rounded),
        _BibliaBook(title: 'Col', icon: Icons.book_rounded),
        _BibliaBook(title: '1 Ts', icon: Icons.book_rounded),
        _BibliaBook(title: '2 Ts', icon: Icons.book_rounded),
        _BibliaBook(title: '1 Tm', icon: Icons.book_rounded),
        _BibliaBook(title: '2 Tm', icon: Icons.book_rounded),
        _BibliaBook(title: 'Tit', icon: Icons.book_rounded),
        _BibliaBook(title: 'Flm', icon: Icons.book_rounded),
      ],
    ),
    _BibliaGroup(
      title: 'Cartas Católicas',
      books: [
        _BibliaBook(title: 'Hb', icon: Icons.book_rounded),
        _BibliaBook(title: 'St', icon: Icons.book_rounded),
        _BibliaBook(title: '1 Pe', icon: Icons.book_rounded),
        _BibliaBook(title: '2 Pe', icon: Icons.book_rounded),
        _BibliaBook(title: '1 Jn', icon: Icons.book_rounded),
        _BibliaBook(title: '2 Jn', icon: Icons.book_rounded),
        _BibliaBook(title: '3 Jn', icon: Icons.book_rounded),
        _BibliaBook(title: 'Jds', icon: Icons.book_rounded),
      ],
    ),
    _BibliaGroup(
      title: 'Apocalipsis',
      books: [
        _BibliaBook(title: 'Apocalipsis', icon: Icons.book_rounded),
      ],
    ),
  ];

  final List<_BibliaGroup> _antiguoTestamento = const [
    _BibliaGroup(
      title: 'Pentateuco',
      books: [
        _BibliaBook(title: 'GÉNESIS', icon: Icons.menu_book_rounded),
        _BibliaBook(title: 'ÉXODO', icon: Icons.menu_book_rounded),
        _BibliaBook(title: 'LEVÍTICO', icon: Icons.menu_book_rounded),
        _BibliaBook(title: 'NÚMEROS', icon: Icons.menu_book_rounded),
        _BibliaBook(title: 'DEUTERONOMIO', icon: Icons.menu_book_rounded),
      ],
    ),
    _BibliaGroup(
      title: 'Históricos',
      books: [
        _BibliaBook(title: 'JOSUÉ', icon: Icons.book_rounded),
        _BibliaBook(title: 'JUECES', icon: Icons.book_rounded),
        _BibliaBook(title: 'RUT', icon: Icons.book_rounded),
        _BibliaBook(title: '1 SAMUEL', icon: Icons.book_rounded),
        _BibliaBook(title: '2 SAMUEL', icon: Icons.book_rounded),
        _BibliaBook(title: '1 REYES', icon: Icons.book_rounded),
        _BibliaBook(title: '2 REYES', icon: Icons.book_rounded),
      ],
    ),
    _BibliaGroup(
      title: 'Sapienciales',
      books: [
        _BibliaBook(title: 'JOB', icon: Icons.book_rounded),
        _BibliaBook(title: 'SALMOS', icon: Icons.music_note_rounded),
        _BibliaBook(title: 'PROVERBIOS', icon: Icons.book_rounded),
        _BibliaBook(title: 'ECLESIASTÉS', icon: Icons.book_rounded),
        _BibliaBook(title: 'CANTAR', icon: Icons.favorite_rounded),
      ],
    ),
    _BibliaGroup(
      title: 'Profetas',
      books: [
        _BibliaBook(title: 'ISAÍAS', icon: Icons.book_rounded),
        _BibliaBook(title: 'JEREMÍAS', icon: Icons.book_rounded),
        _BibliaBook(title: 'EZEQUIEL', icon: Icons.book_rounded),
        _BibliaBook(title: 'DANIEL', icon: Icons.book_rounded),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final groups = _selected == _BibliaTestamento.nuevo
        ? _nuevoTestamento
        : _antiguoTestamento;

    return Scaffold(
      body: BibliaBackground(
        child: SafeArea(
          child: Column(
            children: [
              _BibliaRoyalHeader(
                title: _selected == _BibliaTestamento.nuevo
                    ? 'EL NUEVO TESTAMENTO'
                    : 'EL ANTIGUO TESTAMENTO',
                onBack: () => Navigator.of(context).maybePop(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _TestamentSelector(
                  selected: _selected,
                  onChanged: (value) {
                    setState(() => _selected = value);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 92),
                  physics: const BouncingScrollPhysics(),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return _BibliaGroupSection(
                      group: groups[index],
                      onBookTap: (book) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BibliaPlaceholderScreen(
                              title: book.title,
                              subtitle: _selected == _BibliaTestamento.nuevo
                                  ? 'Nuevo Testamento'
                                  : 'Antiguo Testamento',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BibliaBottomBar(),
    );
  }
}

// =========================
// HEADER
// =========================
class _BibliaRoyalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _BibliaRoyalHeader({
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      child: Row(
        children: [
          _RoundGoldButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                color: const Color(0xFFE8D08A),
                fontSize: 29,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _TestamentSelector extends StatelessWidget {
  final _BibliaTestamento selected;
  final ValueChanged<_BibliaTestamento> onChanged;

  const _TestamentSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TestamentTab(
            label: 'ANTIGUO TESTAMENTO',
            selected: selected == _BibliaTestamento.antiguo,
            onTap: () => onChanged(_BibliaTestamento.antiguo),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TestamentTab(
            label: 'NUEVO TESTAMENTO',
            selected: selected == _BibliaTestamento.nuevo,
            onTap: () => onChanged(_BibliaTestamento.nuevo),
          ),
        ),
      ],
    );
  }
}

class _TestamentTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TestamentTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final asset = selected
        ? 'assets/biblia/btn_primario_dorado.png'
        : 'assets/biblia/btn_secundario_outline.png';

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFB8932F)
                      : const Color(0xFF062C45),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFFE4C56E),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cormorantGaramond(
                  color: selected ? Colors.white : const Color(0xFFE7D29A),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// GROUPS
// =========================
class _BibliaGroupSection extends StatelessWidget {
  final _BibliaGroup group;
  final ValueChanged<_BibliaBook> onBookTap;

  const _BibliaGroupSection({
    required this.group,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DecoratedSectionTitle(title: group.title),
        const SizedBox(height: 8),
        ...group.books.map(
          (book) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _BookButton(
              book: book,
              onTap: () => onBookTap(book),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _DecoratedSectionTitle extends StatelessWidget {
  final String title;

  const _DecoratedSectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SeparatorImage(flipped: false)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: GoogleFonts.cormorantGaramond(
              color: const Color(0xFFE4C56E),
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
        Expanded(child: _SeparatorImage(flipped: true)),
      ],
    );
  }
}

class _SeparatorImage extends StatelessWidget {
  final bool flipped;

  const _SeparatorImage({
    required this.flipped,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/biblia/separador_seccion.png',
      height: 20,
      fit: BoxFit.fill,
      errorBuilder: (_, __, ___) => Container(
        height: 1,
        color: const Color(0xFFD4AF37).withValues(alpha: 0.55),
      ),
    );

    if (!flipped) return image;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(-1.0, 1.0),
      child: image,
    );
  }
}

class _BookButton extends StatelessWidget {
  final _BibliaBook book;
  final VoidCallback onTap;

  const _BookButton({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF07385A).withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFD8BE70).withValues(alpha: 0.88),
                  width: 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.26),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.36),
                      ),
                    ),
                    child: Icon(
                      book.icon,
                      color: const Color(0xFFE6CB7B),
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        color: const Color(0xFFF3E3B0),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        height: 1,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFFE6CB7B).withValues(alpha: 0.8),
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// BOTTOM BAR
// =========================
class _BibliaBottomBar extends StatelessWidget {
  const _BibliaBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFF05283E).withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _BibliaBottomItem(
              icon: Icons.star_rounded,
              label: 'Favoritos',
              onTap: () => _soon(context, 'Favoritos'),
            ),
            _BibliaBottomItem(
              icon: Icons.note_alt_rounded,
              label: 'Notas',
              onTap: () => _soon(context, 'Notas'),
            ),
            _BibliaBottomItem(
              icon: Icons.settings_rounded,
              label: 'Configuración',
              onTap: () => _soon(context, 'Configuración'),
            ),
          ],
        ),
      ),
    );
  }

  static void _soon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title estará disponible en la siguiente fase.'),
      ),
    );
  }
}

class _BibliaBottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BibliaBottomItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFFE2C56F),
              size: 25,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.cormorantGaramond(
                color: const Color(0xFFE8D08A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// COMMON
// =========================
class _RoundGoldButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundGoldButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
          border: Border.all(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.34),
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFE8D08A),
          size: 20,
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
              _ReaderHeader(
                title: '$title 1',
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                  child: _ReaderPanel(
                    title: '$title 1',
                    subtitle: subtitle,
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

class _ReaderHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _ReaderHeader({
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFA3843B).withValues(alpha: 0.92),
        border: Border.all(
          color: const Color(0xFFE1C26C).withValues(alpha: 0.65),
        ),
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
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.star_rounded,
              color: Color(0xFFE8D08A),
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderPanel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ReaderPanel({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF06375B),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 20,
            right: 20,
            child: Image.asset(
              'assets/biblia/frame_lector_superior.png',
              height: 88,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  color: const Color(0xFFF3E3B0),
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  color: const Color(0xFFE2C56F),
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '1 En el principio creó Dios el cielo y la tierra.\n\n'
                '2 La tierra era caos y confusión, y oscuridad por encima del abismo.\n\n'
                '3 Dijo Dios: “Haya luz”, y hubo luz.\n\n'
                '4 Vio Dios que la luz estaba bien, y separó Dios la luz de la oscuridad.\n\n'
                '5 Llamó Dios a la luz “día”, y a la oscuridad llamó “noche”.',
                style: GoogleFonts.cormorantGaramond(
                  color: const Color(0xFFEDE1BE),
                  fontSize: 23,
                  height: 1.36,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BibliaGroup {
  final String title;
  final List<_BibliaBook> books;

  const _BibliaGroup({
    required this.title,
    required this.books,
  });
}

class _BibliaBook {
  final String title;
  final IconData icon;

  const _BibliaBook({
    required this.title,
    required this.icon,
  });
}
