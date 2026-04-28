import 'dart:ui';

import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/biblia/presentation/biblia_home_screen.dart';
import 'package:escoge/features/contenido/presentation/catecismo_screen.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/reflexiones_screen.dart';
import 'package:escoge/features/oracion/presentation/rosario_screen.dart';
import 'package:escoge/features/oracion/presentation/santo_del_dia_screen.dart';
import 'package:escoge/features/peticiones/presentation/peticiones_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ContenidoScreen extends StatelessWidget {
  const ContenidoScreen({super.key});

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
        subtitle: 'Mensajes breves para alimentar el alma.',
        iconPath: 'assets/icons/reflexion.png',
        onTap: () => _open(context, const ReflexionesScreen()),
      ),
      _ContenidoItem(
        title: 'Catecismo',
        subtitle: 'Doctrina y enseñanza de la Iglesia.',
        iconPath: 'assets/icons/catequesis.png',
        onTap: () => _open(context, const CatecismoScreen()),
      ),
      _ContenidoItem(
        title: 'Biblia',
        subtitle: 'Accede a la Sagrada Escritura.',
        iconPath: 'assets/icons/biblia.png',
        onTap: () => _open(context, const BibliaHomeScreen()),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: _ContenidoHero(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: _IntroCard(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ContenidoCard(item: items[index]),
                childCount: items.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.88,
              ),
            ),
          ),
        ],
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

class _ContenidoHero extends StatelessWidget {
  const _ContenidoHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppBackgrounds.contenido,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.screenGradient,
                ),
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.30),
                  AppColors.lumenBackground.withValues(alpha: 0.98),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.24),
                      border: Border.all(
                        color: AppColors.lumenGold.withValues(alpha: 0.42),
                      ),
                    ),
                    child: Icon(
                      PhosphorIcons.books(PhosphorIconsStyle.light),
                      color: AppColors.lumenGoldBright,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Biblioteca espiritual',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.lumenTextPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Contenido',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Espiritualidad, formación y encuentro con Dios',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.lumenTextSecondary,
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _GlassShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lumenGold.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.lumenGold.withValues(alpha: 0.26),
              ),
            ),
            child: Icon(
              PhosphorIcons.sparkle(PhosphorIconsStyle.light),
              color: AppColors.lumenGoldBright,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Accede a recursos espirituales y formativos cuidadosamente organizados para acompañar tu oración, tu formación cristiana y tu vida diaria.',
              style: GoogleFonts.poppins(
                color: AppColors.lumenTextSecondary,
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

  const _ContenidoCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassShell(
      onTap: item.onTap,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Stack(
        children: [
          Positioned(
            top: -28,
            right: -26,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.lumenGold.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconFrame(iconPath: item.iconPath),
              const Spacer(),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lora(
                  color: AppColors.lumenTextPrimary,
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
                  color: AppColors.lumenTextMuted,
                  fontSize: 11.8,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Entrar',
                    style: GoogleFonts.poppins(
                      color: AppColors.lumenGoldBright,
                      fontSize: 12.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    PhosphorIcons.arrowUpRight(PhosphorIconsStyle.light),
                    color: AppColors.lumenGoldBright,
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconFrame extends StatelessWidget {
  final String iconPath;

  const _IconFrame({
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.lumenGold.withValues(alpha: 0.10),
        border: Border.all(
          color: AppColors.lumenGold.withValues(alpha: 0.24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lumenGold.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: -8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          iconPath,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          color: null,
          errorBuilder: (_, __, ___) {
            return Icon(
              PhosphorIcons.imageBroken(PhosphorIconsStyle.light),
              color: AppColors.lumenGoldBright,
              size: 24,
            );
          },
        ),
      ),
    );
  }
}

class _GlassShell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const _GlassShell({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.lumenCard.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.glassStroke.withValues(alpha: 0.82),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 24,
                spreadRadius: -8,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: AppColors.lumenGold.withValues(alpha: 0.08),
        highlightColor: AppColors.lumenGold.withValues(alpha: 0.04),
        child: content,
      ),
    );
  }
}

class _ContenidoItem {
  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback onTap;

  const _ContenidoItem({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.onTap,
  });
}
