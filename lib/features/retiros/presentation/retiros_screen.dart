import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/core/widgets/app_card.dart';

import 'package:escoge/features/retiros/data/services/retiros_service.dart';
import 'package:escoge/features/retiros/domain/retiro_item.dart';
import 'package:escoge/features/retiros/presentation/retiro_detalle_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetirosScreen extends StatelessWidget {
  const RetirosScreen({super.key});

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        background: AppBackgrounds.home,
        overlayOpacity: 0.20,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _Header(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: const _HeroRetirosCard(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
                  child: Text(
                    'Próximos retiros',
                    style: GoogleFonts.lora(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                  child: Text(
                    'Explora las experiencias disponibles y entra a más detalles.',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                  child: const _RetirosList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Retiros',
      style: GoogleFonts.lora(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

class _HeroRetirosCard extends StatelessWidget {
  const _HeroRetirosCard();

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: RetirosScreen.gold.withOpacity(0.18),
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
              fontSize: 24,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Encuentros espirituales, fines de semana y experiencias profundas dentro del camino Escoge.',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
        ],
      ),
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
          return const _MessageCard(
            title: 'Error cargando retiros',
            subtitle: 'Verifica tu conexión o configuración de Firebase.',
          );
        }

        final retiros = snapshot.data ?? [];

        if (retiros.isEmpty) {
          return const _MessageCard(
            title: 'Aún no hay retiros',
            subtitle: 'Cuando existan en Firebase aparecerán aquí.',
          );
        }

        return Column(
          children: retiros.map((r) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _RetiroCard(retiro: r),
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

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      borderRadius: 26,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RetiroDetalleScreen(retiro: retiro),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (retiro.categoria.isNotEmpty)
            Text(
              retiro.categoria,
              style: GoogleFonts.poppins(
                color: RetirosScreen.gold,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            retiro.titulo,
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            retiro.descripcion,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [
              if (retiro.fecha.isNotEmpty)
                _MetaChip(icon: Icons.calendar_today, text: retiro.fecha),
              if (retiro.ciudad.isNotEmpty)
                _MetaChip(icon: Icons.location_on, text: retiro.ciudad),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: RetirosScreen.gold),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _MessageCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
