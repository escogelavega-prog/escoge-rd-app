import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/widgets/premium_menu_card.dart';
import 'package:escoge/features/retiros/domain/retiro_item.dart';
import 'package:escoge/features/retiros/presentation/inscripcion_fds_screen.dart'
    as retiro_fds;
import 'package:escoge/features/retiros/presentation/inscripcion_screen.dart'
    as retiro_local;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetiroDetalleScreen extends StatefulWidget {
  final RetiroItem retiro;

  const RetiroDetalleScreen({
    super.key,
    required this.retiro,
  });

  @override
  State<RetiroDetalleScreen> createState() => _RetiroDetalleScreenState();
}

class _RetiroDetalleScreenState extends State<RetiroDetalleScreen> {
  bool _inscripcionEnviada = false;

  RetiroItem get retiro => widget.retiro;

  String get _retiroId => retiro.id;

  Future<void> _openInscripcion() async {
    final Widget destination = retiro.tipoFormulario == 'fds'
        ? retiro_fds.InscripcionFDSScreen(
            diocesis: retiro.diocesis,
            retiroId: _retiroId,
            retiroNombre: retiro.titulo,
          )
        : retiro_local.InscripcionScreen(
            diocesis: retiro.diocesis,
            retiroId: _retiroId,
            retiroNombre: retiro.titulo,
          );

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final result = await navigator.push(
      MaterialPageRoute(builder: (_) => destination),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _inscripcionEnviada = true;
      });

      messenger.showSnackBar(
        SnackBar(
          content: const Text('Tu inscripción fue enviada correctamente.'),
          backgroundColor: AppColors.primaryBlue,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
      bottomNavigationBar: _BottomInscripcionBar(
        yaInscrito: _inscripcionEnviada,
        onTap: _openInscripcion,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 130 + bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RetiroHeroCard(retiro: retiro),
            const SizedBox(height: 14),
            if (_inscripcionEnviada) ...[
              const _InscripcionExitosaBanner(),
              const SizedBox(height: 12),
            ],
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
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Participación',
              child: _InscripcionSectionInline(
                yaInscrito: _inscripcionEnviada,
                onTap: _openInscripcion,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                ),
              ),
              child: Text(
                'Este retiro puede marcar un antes y un después en tu vida espiritual.',
                style: GoogleFonts.lora(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InscripcionExitosaBanner extends StatelessWidget {
  const _InscripcionExitosaBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tu solicitud ya fue enviada. El equipo organizador podrá contactarte pronto.',
              style: GoogleFonts.poppins(
                fontSize: 13.2,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
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
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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
                      AppColors.primaryBlue.withValues(alpha: 0.14),
                      AppColors.primaryBlue.withValues(alpha: 0.88),
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
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      _HeroMetaChip(
                        icon: Icons.location_on_rounded,
                        text: retiro.ciudad,
                      ),
                      _HeroMetaChip(
                        icon: Icons.calendar_today_rounded,
                        text: retiro.fecha,
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

class _HeroMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroMetaChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
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
        _InfoRow(
          icon: Icons.calendar_month_rounded,
          label: 'Fecha',
          text: retiro.fecha,
        ),
        const SizedBox(height: 12),
        _InfoRow(
          icon: Icons.location_on_rounded,
          label: 'Ciudad',
          text: retiro.ciudad,
        ),
        const SizedBox(height: 12),
        _InfoRow(
          icon: Icons.home_work_outlined,
          label: 'Lugar',
          text: retiro.lugar,
        ),
        const SizedBox(height: 12),
        _InfoRow(
          icon: Icons.church_rounded,
          label: 'Diócesis',
          text: retiro.diocesis,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
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
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == recomendaciones.length - 1 ? 0 : 12,
              ),
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
                      entry.value,
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

class _InscripcionSectionInline extends StatelessWidget {
  final bool yaInscrito;
  final VoidCallback onTap;

  const _InscripcionSectionInline({
    required this.yaInscrito,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumMenuCard(
      icon:
          yaInscrito ? Icons.verified_rounded : Icons.app_registration_rounded,
      title: yaInscrito ? 'Solicitud enviada' : 'Inscribirme',
      subtitle: yaInscrito
          ? 'Tu participación ya fue solicitada para este encuentro.'
          : 'Completa tu formulario para reservar tu participación en este encuentro.',
      onTap: onTap,
    );
  }
}

class _BottomInscripcionBar extends StatelessWidget {
  final bool yaInscrito;
  final VoidCallback onTap;

  const _BottomInscripcionBar({
    required this.yaInscrito,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  yaInscrito
                      ? 'Tu solicitud ya fue enviada.'
                      : '¿Listo para vivir esta experiencia?',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                yaInscrito ? 'VER FORMULARIO' : 'INSCRIBIRME',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
