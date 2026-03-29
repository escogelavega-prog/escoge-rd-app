import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/retiros/domain/retiro_item.dart';
import 'package:escoge/features/retiros/presentation/inscripcion_screen.dart'
    as retiro_local;
import 'package:escoge/features/retiros/presentation/inscripcion_fds_screen.dart'
    as retiro_fds;
import 'package:escoge/widgets/premium_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetiroDetalleScreen extends StatelessWidget {
  final RetiroItem retiro;

  const RetiroDetalleScreen({
    super.key,
    required this.retiro,
  });

  String get _retiroId => '${retiro.titulo}_${retiro.ciudad}_${retiro.fecha}'
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^a-z0-9_áéíóúñ-]'), '');

  @override
  Widget build(BuildContext context) {
    final bottomSpace = 24 + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detalle del retiro',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(12, 10, 12, bottomSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RetiroHeroCard(retiro: retiro),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Descripción',
              child: _DescripcionContent(descripcion: retiro.descripcion),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Información general',
              child: _InfoGeneralContent(retiro: retiro),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Recomendaciones',
              child: _RecomendacionesContent(
                recomendaciones: retiro.recomendaciones,
              ),
            ),
            const SizedBox(height: 16),
            _InscripcionSection(
              retiro: retiro,
              retiroId: _retiroId,
            ),
          ],
        ),
      ),
    );
  }
}

class _RetiroHeroCard extends StatelessWidget {
  final RetiroItem retiro;

  const _RetiroHeroCard({required this.retiro});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                retiro.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primaryBlue.withValues(alpha: 0.18),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryBlue.withValues(alpha: 0.16),
                      AppColors.primaryBlue.withValues(alpha: 0.84),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  retiro.categoria,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    retiro.titulo,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${retiro.ciudad} · ${retiro.fecha}',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DescripcionContent extends StatelessWidget {
  final String descripcion;

  const _DescripcionContent({required this.descripcion});

  @override
  Widget build(BuildContext context) {
    return Text(
      descripcion,
      style: GoogleFonts.poppins(
        fontSize: 14,
        height: 1.7,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _InfoGeneralContent extends StatelessWidget {
  final RetiroItem retiro;

  const _InfoGeneralContent({required this.retiro});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(icon: Icons.calendar_month_rounded, text: retiro.fecha),
        const SizedBox(height: 12),
        _InfoRow(icon: Icons.location_on_rounded, text: retiro.ciudad),
        const SizedBox(height: 12),
        _InfoRow(icon: Icons.home_work_outlined, text: retiro.lugar),
        const SizedBox(height: 12),
        _InfoRow(
          icon: Icons.church_rounded,
          text: 'Diócesis: ${retiro.diocesis}',
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FC),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 22,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecomendacionesContent extends StatelessWidget {
  final List<String> recomendaciones;

  const _RecomendacionesContent({required this.recomendaciones});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recomendaciones
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 22,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.poppins(
                        fontSize: 13.8,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InscripcionSection extends StatelessWidget {
  final RetiroItem retiro;
  final String retiroId;

  const _InscripcionSection({
    required this.retiro,
    required this.retiroId,
  });

  @override
  Widget build(BuildContext context) {
    void openInscripcion() {
      final ciudad = retiro.ciudad.trim().toLowerCase();

      final Widget destination = ciudad == 'la vega'
          ? retiro_local.InscripcionScreen(
              diocesis: retiro.diocesis,
              retiroId: retiroId,
              retiroNombre: retiro.titulo,
            )
          : retiro_fds.InscripcionFdsScreen(
              diocesis: retiro.diocesis,
              retiroId: retiroId,
              retiroNombre: retiro.titulo,
            );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participación',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        PremiumMenuCard(
          icon: Icons.app_registration_rounded,
          title: 'Inscribirme',
          subtitle:
              'Completa tu formulario para reservar tu participación en este encuentro.',
          onTap: openInscripcion,
        ),
      ],
    );
  }
}
