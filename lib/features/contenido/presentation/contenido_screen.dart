import 'dart:ui';
import 'package:escoge/features/biblia/presentation/biblia_home_screen.dart';
import 'package:escoge/features/contenido/presentation/catecismo_screen.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/reflexiones_screen.dart';
import 'package:escoge/features/oracion/presentation/rosario_screen.dart';
import 'package:escoge/features/oracion/presentation/santo_del_dia_screen.dart';
import 'package:escoge/features/peticiones/presentation/peticiones_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContenidoScreen extends StatelessWidget {
  const ContenidoScreen({super.key});

  static const Color _bgTop = Color(0xFF08142E);
  static const Color _bgBottom = Color(0xFF0D1F4F);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _offWhite = Color(0xFFEDE7D9);
  static const Color _softWhite = Color(0xFFBFC6D9);

  @override
  Widget build(BuildContext context) {
    final items = <_ContenidoItem>[
      _ContenidoItem(
        title: 'Santo Rosario',
        subtitle: 'Ora con recogimiento y paz interior.',
        iconPath: 'assets/icons/rosario.png',
        onTap: () => _open(context, const RosarioScreen()),
      ),
      _ContenidoItem(
        title: 'Santo del día',
        subtitle: 'Conoce el testimonio que inspira hoy.',
        iconPath: 'assets/icons/santo.png',
        onTap: () => _open(context, const SantoDelDiaScreen()),
      ),
      _ContenidoItem(
        title: 'Peticiones',
        subtitle: 'Presenta tus intenciones y acompaña en oración.',
        iconPath: 'assets/icons/peticiones.png',
        onTap: () => _open(context, const PeticionesScreen()),
      ),
      _ContenidoItem(
        title: 'Evangelio',
        subtitle: 'Medita la Palabra del día con profundidad.',
        iconPath: 'assets/icons/evangelio.png',
        onTap: () => _open(context, const EvangelioScreen()),
      ),
      _ContenidoItem(
        title: 'Reflexiones',
        subtitle: 'Encuentra mensajes breves para alimentar el alma.',
        iconPath: 'assets/icons/reflexion.png',
        onTap: () => _open(context, const ReflexionesScreen()),
      ),
      _ContenidoItem(
        title: 'Catecismo',
        subtitle: 'Profundiza en la doctrina y enseñanza de la Iglesia.',
        iconPath: 'assets/icons/catequesis.png',
        onTap: () => _open(context, const CatecismoScreen()),
      ),
      _ContenidoItem(
        title: 'Biblia',
        subtitle: 'Accede a la Sagrada Escritura y alimenta tu fe.',
        iconPath: 'assets/icons/biblia.png',
        onTap: () => _open(context, const BibliaHomeScreen()),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: _PremiumHeader(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                  child: _IntroCard(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ContenidoCard(item: items[index]),
                    childCount: items.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.86,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: screen,
        ),
      ),
    );
  }
}

class _PremiumHeader extends StatelessWidget {
  const _PremiumHeader();

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _offWhite = Color(0xFFEDE7D9);
  static const Color _softWhite = Color(0xFFBFC6D9);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: .10),
                Colors.white.withValues(alpha: .04),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: .09),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .14),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _gold.withValues(alpha: .12),
                  border: Border.all(
                    color: _gold.withValues(alpha: .34),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: _gold,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contenido',
                      style: GoogleFonts.lora(
                        color: _offWhite,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Espiritualidad, formación y encuentro con Dios',
                      style: GoogleFonts.poppins(
                        color: _softWhite,
                        fontSize: 12.8,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
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

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _offWhite = Color(0xFFEDE7D9);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: .045),
        border: Border.all(
          color: Colors.white.withValues(alpha: .08),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _gold.withValues(alpha: .10),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: _gold,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Accede a recursos espirituales y formativos cuidadosamente organizados para acompañar tu oración, tu formación cristiana y tu vida diaria.',
              style: GoogleFonts.poppins(
                color: _offWhite.withValues(alpha: .92),
                fontSize: 13,
                height: 1.55,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContenidoCard extends StatelessWidget {
  final _ContenidoItem item;

  const _ContenidoCard({required this.item});

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _offWhite = Color(0xFFEDE7D9);
  static const Color _softWhite = Color(0xFFBFC6D9);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: .085),
                  Colors.white.withOpacity(0.040),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.09),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IconFrame(iconPath: item.iconPath),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lora(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: _softWhite,
                    fontSize: 11.8,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'Entrar',
                      style: GoogleFonts.poppins(
                        color: _gold,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: _gold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconFrame extends StatelessWidget {
  final String iconPath;

  const _IconFrame({required this.iconPath});

  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: _gold.withOpacity(0.10),
        border: Border.all(
          color: _gold.withOpacity(0.24),
          width: 1,
        ),
      ),
      child: Center(
        child: Image.asset(
          iconPath,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          color: _gold,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.image_not_supported_outlined,
              color: _gold,
              size: 24,
            );
          },
        ),
      ),
    );
  }
}

class _ContenidoItem {
  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback onTap;

  _ContenidoItem({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.onTap,
  });
}
