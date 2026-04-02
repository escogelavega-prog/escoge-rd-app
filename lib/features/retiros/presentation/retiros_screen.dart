import 'package:escoge/features/retiros/data/services/retiros_service.dart';
import 'package:escoge/features/retiros/domain/retiro_item.dart';
import 'package:escoge/features/retiros/presentation/retiro_detalle_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetirosScreen extends StatelessWidget {
  const RetirosScreen({super.key});

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1736A2);
  static const Color gold = Color(0xFFD4AF37);
  static const Color softBackground = Color(0xFFF3F6FD);
  static const Color textPrimary = Color(0xFF1B2559);
  static const Color textSecondary = Color(0xFF667085);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue, secondaryBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Retiros',
                        style: GoogleFonts.lora(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Encuentros para vivir, renovar y profundizar la fe.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _HeroRetirosCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -14),
              child: Container(
                decoration: const BoxDecoration(
                  color: softBackground,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _SectionHeader(
                        title: 'Próximos retiros',
                        subtitle:
                            'Explora las experiencias disponibles y entra a más detalles cuando estén publicadas.',
                      ),
                      SizedBox(height: 16),
                      _RetirosList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroRetirosCard extends StatelessWidget {
  const _HeroRetirosCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: RetirosScreen.gold.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Camino y encuentro',
              style: GoogleFonts.poppins(
                color: RetirosScreen.gold,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Vive una experiencia que transforme tu corazón',
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 25,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Aquí podrás descubrir próximos encuentros, fines de semana espirituales y retiros organizados por Escoge.',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.88),
              fontSize: 13.5,
              height: 1.65,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: RetirosScreen.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: RetirosScreen.textSecondary,
            fontSize: 13,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RetirosList extends StatelessWidget {
  const _RetirosList();

  @override
  Widget build(BuildContext context) {
    final service = RetirosService();

    return StreamBuilder<List<RetiroItem>>(
      stream: service.escucharRetirosActivos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingCard();
        }

        if (snapshot.hasError) {
          return _MessageCard(
            icon: Icons.cloud_off_rounded,
            title: 'No se pudieron cargar los retiros',
            subtitle:
                'Verifica tu conexión o revisa que la colección retiros exista en Firestore.',
          );
        }

        final retiros = snapshot.data ?? const <RetiroItem>[];

        if (retiros.isEmpty) {
          return _MessageCard(
            icon: Icons.event_busy_rounded,
            title: 'Aún no hay retiros disponibles',
            subtitle:
                'La pantalla ya está corregida. Ahora solo faltaría que existan documentos publicados dentro de la colección retiros.',
          );
        }

        return Column(
          children: retiros.map((retiro) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _RetiroCard(retiro: retiro),
            );
          }).toList(),
        );
      },
    );
  }
}

class _RetiroCard extends StatelessWidget {
  final RetiroItem retiro;

  const _RetiroCard({required this.retiro});

  String _recortarTexto(String value, {int max = 160}) {
    if (value.length <= max) return value;
    return '${value.substring(0, max).trim()}...';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RetiroDetalleScreen(retiro: retiro),
            ),
          );
        },
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (retiro.categoria.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: RetirosScreen.gold.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    retiro.categoria,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8A6A00),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (retiro.categoria.isNotEmpty) const SizedBox(height: 12),
              Text(
                retiro.titulo,
                style: GoogleFonts.lora(
                  color: RetirosScreen.textPrimary,
                  fontSize: 23,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _recortarTexto(retiro.descripcion.isEmpty
                    ? 'Próximamente más detalles de esta experiencia.'
                    : retiro.descripcion),
                style: GoogleFonts.poppins(
                  color: RetirosScreen.textSecondary,
                  fontSize: 13.5,
                  height: 1.65,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (retiro.fecha.isNotEmpty)
                    _MetaChip(
                      icon: Icons.calendar_month_rounded,
                      text: retiro.fecha,
                    ),
                  if (retiro.lugar.isNotEmpty || retiro.ciudad.isNotEmpty)
                    _MetaChip(
                      icon: Icons.location_on_outlined,
                      text: retiro.lugar.isNotEmpty
                          ? retiro.lugar
                          : retiro.ciudad,
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: RetirosScreen.primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Más información',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
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

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: RetirosScreen.primaryBlue.withOpacity(0.07),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: RetirosScreen.primaryBlue,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: RetirosScreen.primaryBlue,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            color: RetirosScreen.primaryBlue,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando retiros...',
            style: GoogleFonts.poppins(
              color: RetirosScreen.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MessageCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 38,
            color: RetirosScreen.primaryBlue,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: RetirosScreen.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: RetirosScreen.textSecondary,
              fontSize: 13,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
