import 'package:escoge/core/widgets/premium_menu_card.dart';
import 'package:escoge/core/widgets/section_title.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:escoge/features/oracion/presentation/oracion_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.onOpenOracion,
    this.onOpenRetiros,
    this.onOpenContenido,
    this.onOpenEvangelio,
    this.onOpenLecturas,
    this.onOpenHistoria,
    this.onOpenPerfil,
  });

  final VoidCallback? onOpenOracion;
  final VoidCallback? onOpenRetiros;
  final VoidCallback? onOpenContenido;
  final VoidCallback? onOpenEvangelio;
  final VoidCallback? onOpenLecturas;
  final VoidCallback? onOpenHistoria;
  final VoidCallback? onOpenPerfil;

  static const Color softBackground = Color(0xFFF4F6FB);
  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1A3DAB);
  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue, secondaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(34),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopBar(onOpenPerfil: onOpenPerfil),
                      const SizedBox(height: 22),
                      Text(
                        'Bienvenido a Escoge RD',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 56,
                        height: 3,
                        decoration: BoxDecoration(
                          color: gold,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Vive una experiencia espiritual con contenido diario, oración y retiros transformadores.',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 14.5,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroCard(
                    onOpenContenido: onOpenContenido,
                    onOpenRetiros: onOpenRetiros,
                  ),
                  const SizedBox(height: 28),
                  const SectionTitle(
                    title: 'Camina en la fe',
                    subtitle:
                        'Accede a los espacios principales para orar, leer y crecer espiritualmente.',
                  ),
                  const SizedBox(height: 16),
                  PremiumMenuCard(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Oración',
                    subtitle:
                        'Accede al rosario, evangelio y espacios de encuentro espiritual.',
                    onTap: () {
                      if (onOpenEvangelio != null) {
                        onOpenEvangelio!();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OracionScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  PremiumMenuCard(
                    icon: Icons.menu_book_rounded,
                    title: 'Evangelio del Día',
                    subtitle:
                        'Reflexiona con la Palabra de Dios y su mensaje para hoy.',
                    onTap: () {
                      if (onOpenEvangelio != null) {
                        onOpenEvangelio!();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EvangelioScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  PremiumMenuCard(
                    icon: Icons.library_books_outlined,
                    title: 'Lecturas del Día',
                    subtitle:
                        'Consulta las lecturas litúrgicas diarias y profundiza en ellas.',
                    onTap: () {
                      if (onOpenLecturas != null) {
                        onOpenLecturas!();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LecturasScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  PremiumMenuCard(
                    icon: Icons.account_balance_outlined,
                    title: 'Historia del Movimiento',
                    subtitle:
                        'Conoce el origen, misión y recorrido espiritual de Escoge.',
                    onTap: onOpenHistoria ?? onOpenContenido,
                  ),
                  const SizedBox(height: 28),
                  const SectionTitle(
                    title: 'Próximos retiros',
                    subtitle:
                        'Descubre experiencias disponibles y completa tu inscripción.',
                  ),
                  const SizedBox(height: 16),
                  PremiumMenuCard(
                    icon: Icons.event_available_rounded,
                    title: 'Ver retiros disponibles',
                    subtitle:
                        'Consulta fechas, lugares y detalles de cada retiro.',
                    onTap: onOpenRetiros,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key, this.onOpenPerfil});

  final VoidCallback? onOpenPerfil;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          child: const Icon(
            Icons.church_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Movimiento Escoge',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 17.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'República Dominicana',
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: .78),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onOpenPerfil,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            child: Text(
              'Perfil',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    this.onOpenContenido,
    this.onOpenRetiros,
  });

  final VoidCallback? onOpenContenido;
  final VoidCallback? onOpenRetiros;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/espiritual.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.48),
                      Colors.black.withValues(alpha: 0.76),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 230),
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Text(
                      'Experiencia espiritual',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Hoy puedes comenzar un nuevo encuentro',
                    style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Explora contenido espiritual y prepárate para vivir un retiro inolvidable.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroButton(
                          label: 'Contenido',
                          filled: true,
                          onTap: onOpenContenido,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _HeroButton(
                          label: 'Retiros',
                          filled: false,
                          onTap: onOpenRetiros,
                        ),
                      ),
                    ],
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

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.label,
    required this.filled,
    this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback? onTap;

  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Material(
        color: filled ? gold : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: filled
                  ? null
                  : Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: filled ? const Color(0xFF1A2340) : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
