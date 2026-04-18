import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/features/contenido/presentation/catecismo_screen.dart';

class ContenidoScreen extends StatelessWidget {
  const ContenidoScreen({super.key});

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1A3DAB);
  static const Color gold = Color(0xFFD4AF37);
  static const Color softWhite = Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildCatecismoHero(context),
                  const SizedBox(height: 28),
                  _buildSectionHeader(
                    title: 'Accesos principales',
                    subtitle:
                        'Abre lo más importante de tu recorrido espiritual.',
                  ),
                  const SizedBox(height: 16),
                  _buildQuickAccessList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/fondo_uniforme.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(color: const Color(0xFF091538));
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: .18),
                Colors.black.withValues(alpha: .28),
                Colors.black.withValues(alpha: 0.38),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contenido',
          style: GoogleFonts.lora(
            color: softWhite,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explora formación, oración y recursos para tu crecimiento espiritual.',
          style: GoogleFonts.poppins(
            color: softWhite.withValues(alpha: 0.88),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildCatecismoHero(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CatecismoScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: .14),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.16),
              Colors.white.withValues(alpha: 0.08),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .22),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGlassIcon(
              assetPath: 'assets/icons/catecismo.png',
              size: 28,
              boxSize: 62,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catecismo',
                    style: GoogleFonts.lora(
                      color: softWhite,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Profundiza en la doctrina católica con una experiencia organizada, clara y visualmente integrada con el resto de la app.',
                    style: GoogleFonts.poppins(
                      color: softWhite.withValues(alpha: 0.82),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.black.withValues(alpha: .16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 18,
                          color: gold.withValues(alpha: 0.95),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Entrar a Catecismo',
                          style: GoogleFonts.poppins(
                            color: softWhite.withValues(alpha: .92),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lora(
            color: softWhite,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: softWhite.withValues(alpha: 0.82),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessList(BuildContext context) {
    final items = <_ContenidoItem>[
      _ContenidoItem(
        title: 'Santo Rosario',
        subtitle: 'Accede al rezo guiado y acompaña tu oración diaria.',
        assetPath: 'assets/icons/rosario.png',
        onTap: () {
          // Navigator.pushNamed(context, '/rosario');
        },
      ),
      _ContenidoItem(
        title: 'Santo del Día',
        subtitle: 'Descubre la memoria o celebración del día.',
        assetPath: 'assets/icons/santo_dia.png',
        onTap: () {
          // Navigator.pushNamed(context, '/santo-del-dia');
        },
      ),
      _ContenidoItem(
        title: 'Peticiones',
        subtitle: 'Comparte intenciones y acompaña en oración.',
        assetPath: 'assets/icons/peticiones.png',
        onTap: () {
          // Navigator.pushNamed(context, '/peticiones');
        },
      ),
      _ContenidoItem(
        title: 'Evangelio',
        subtitle: 'Lee y medita el Evangelio correspondiente al día.',
        assetPath: 'assets/icons/evangelio.png',
        onTap: () {
          // Navigator.pushNamed(context, '/evangelio');
        },
      ),
      _ContenidoItem(
        title: 'Reflexiones',
        subtitle: 'Encuentra pensamientos y mensajes para tu vida espiritual.',
        assetPath: 'assets/icons/reflexiones.png',
        onTap: () {
          // Navigator.pushNamed(context, '/reflexiones');
        },
      ),
    ];

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildAccessCard(item),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAccessCard(_ContenidoItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: item.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.14),
              Colors.white.withValues(alpha: 0.07),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .20),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildGlassIcon(
              assetPath: item.assetPath,
              size: 26,
              boxSize: 58,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.lora(
                      color: softWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.poppins(
                      color: softWhite.withValues(alpha: 0.78),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: softWhite.withValues(alpha: 0.65),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassIcon({
    required String assetPath,
    required double size,
    required double boxSize,
  }) {
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: gold.withValues(alpha: 0.12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            return Icon(
              Icons.broken_image_outlined,
              size: size,
              color: gold,
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
  final String assetPath;
  final VoidCallback onTap;

  _ContenidoItem({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.onTap,
  });
}
