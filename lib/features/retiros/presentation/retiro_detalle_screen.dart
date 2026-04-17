import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/widgets/app_background.dart';
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
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _softGold = Color(0xFFE8C76A);
  static const Color _deepBlue = Color(0xFF0B1E66);

  bool _inscripcionEnviada = false;
  bool _abriendoInscripcion = false;

  RetiroItem get retiro => widget.retiro;

  String get _retiroId => retiro.id;

  bool get _esFds {
    final tipo = retiro.tipoFormulario.trim().toLowerCase();
    return tipo == 'fds' || tipo.contains('fds');
  }

  Future<void> _openInscripcion() async {
    if (_abriendoInscripcion) return;

    setState(() {
      _abriendoInscripcion = true;
    });

    try {
      final Widget destination = _esFds
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

      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => destination),
      );

      if (!mounted) return;

      final fueExitosa =
          result == true || result == 'success' || result == 'ok';

      if (fueExitosa) {
        setState(() {
          _inscripcionEnviada = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tu inscripción fue enviada correctamente.'),
            backgroundColor: _deepBlue,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No se pudo abrir el formulario de inscripción.',
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _abriendoInscripcion = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: _BottomInscripcionBar(
        yaInscrito: _inscripcionEnviada,
        cargando: _abriendoInscripcion,
        onTap: _openInscripcion,
      ),
      body: AppBackground(
        background: AppBackgrounds.home,
        overlayOpacity: 0.26,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.14),
                      _deepBlue.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.42),
                      Colors.black.withValues(alpha: 0.64),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16, 10, 16, 130 + bottomPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetalleTopBar(
                      onBack: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 18),
                    _RetiroHeroCard(retiro: retiro),
                    const SizedBox(height: 16),
                    if (_inscripcionEnviada) ...[
                      const _InscripcionExitosaBanner(),
                      const SizedBox(height: 14),
                    ],
                    _SectionCard(
                      title: 'Descripción',
                      child:
                          _DescripcionContent(descripcion: retiro.descripcion),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'Información general',
                      child: _InfoGeneralContent(retiro: retiro),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'Recomendaciones',
                      child: _RecomendacionesContent(
                        recomendaciones: retiro.recomendaciones,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'Participación',
                      child: _InscripcionSectionInline(
                        yaInscrito: _inscripcionEnviada,
                        cargando: _abriendoInscripcion,
                        onTap: _openInscripcion,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        'Este retiro puede marcar un antes y un después en tu vida espiritual.',
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: _softGold,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetalleTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _DetalleTopBar({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Detalle del retiro',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _InscripcionExitosaBanner extends StatelessWidget {
  const _InscripcionExitosaBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: RetiroDetalleScreenStateColors.gold.withValues(alpha: 0.20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color:
                  RetiroDetalleScreenStateColors.gold.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: RetiroDetalleScreenStateColors.gold,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tu solicitud ya fue enviada. El equipo organizador podrá contactarte pronto.',
              style: GoogleFonts.poppins(
                fontSize: 13.2,
                color: Colors.white.withValues(alpha: 0.84),
                height: 1.5,
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

  const _RetiroHeroCard({
    required this.retiro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                retiro.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: RetiroDetalleScreenStateColors.deepBlue
                      .withValues(alpha: 0.30),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.35, 0.70, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.16),
                      RetiroDetalleScreenStateColors.deepBlue
                          .withValues(alpha: 0.34),
                      RetiroDetalleScreenStateColors.deepBlue
                          .withValues(alpha: 0.62),
                      Colors.black.withValues(alpha: 0.84),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  retiro.categoria,
                  style: GoogleFonts.poppins(
                    fontSize: 11.8,
                    fontWeight: FontWeight.w700,
                    color: RetiroDetalleScreenStateColors.deepBlue,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    retiro.titulo,
                    style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      if (retiro.ciudad.trim().isNotEmpty)
                        _HeroMetaChip(
                          icon: Icons.location_on_rounded,
                          text: retiro.ciudad,
                        ),
                      if (retiro.fecha.trim().isNotEmpty)
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
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: RetiroDetalleScreenStateColors.softGold,
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
              color: RetiroDetalleScreenStateColors.softGold,
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

  const _DescripcionContent({
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      descripcion,
      style: GoogleFonts.poppins(
        fontSize: 14,
        height: 1.7,
        color: Colors.white.withValues(alpha: 0.82),
      ),
    );
  }
}

class _InfoGeneralContent extends StatelessWidget {
  final RetiroItem retiro;

  const _InfoGeneralContent({
    required this.retiro,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (retiro.fecha.trim().isNotEmpty) ...[
          _InfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'Fecha',
            text: retiro.fecha,
          ),
          const SizedBox(height: 12),
        ],
        if (retiro.ciudad.trim().isNotEmpty) ...[
          _InfoRow(
            icon: Icons.location_on_rounded,
            label: 'Ciudad',
            text: retiro.ciudad,
          ),
          const SizedBox(height: 12),
        ],
        if (retiro.lugar.trim().isNotEmpty) ...[
          _InfoRow(
            icon: Icons.home_work_outlined,
            label: 'Lugar',
            text: retiro.lugar,
          ),
          const SizedBox(height: 12),
        ],
        if (retiro.diocesis.trim().isNotEmpty)
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
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: RetiroDetalleScreenStateColors.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 22,
            color: RetiroDetalleScreenStateColors.softGold,
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
                  color: RetiroDetalleScreenStateColors.softGold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w500,
                  height: 1.45,
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

  const _RecomendacionesContent({
    required this.recomendaciones,
  });

  @override
  Widget build(BuildContext context) {
    if (recomendaciones.isEmpty) {
      return Text(
        'No hay recomendaciones disponibles por el momento.',
        style: GoogleFonts.poppins(
          fontSize: 13.8,
          height: 1.55,
          color: Colors.white.withValues(alpha: 0.78),
        ),
      );
    }

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
                    color: RetiroDetalleScreenStateColors.softGold,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.poppins(
                        fontSize: 13.8,
                        height: 1.55,
                        color: Colors.white.withValues(alpha: 0.80),
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
  final bool cargando;
  final VoidCallback onTap;

  const _InscripcionSectionInline({
    required this.yaInscrito,
    required this.cargando,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumMenuCard(
      icon:
          yaInscrito ? Icons.verified_rounded : Icons.app_registration_rounded,
      title: yaInscrito
          ? 'Solicitud enviada'
          : cargando
              ? 'Abriendo formulario...'
              : 'Inscribirme',
      subtitle: yaInscrito
          ? 'Tu participación ya fue solicitada para este encuentro.'
          : 'Completa tu formulario para reservar tu participación en este encuentro.',
      onTap: cargando ? null : onTap,
      showArrow: !cargando,
    );
  }
}

class _BottomInscripcionBar extends StatelessWidget {
  final bool yaInscrito;
  final bool cargando;
  final VoidCallback onTap;

  const _BottomInscripcionBar({
    required this.yaInscrito,
    required this.cargando,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom),
      decoration: BoxDecoration(
        color: const Color(0xFF09174F).withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
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
                    color: Colors.white,
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
              onPressed: cargando ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: RetiroDetalleScreenStateColors.gold,
                foregroundColor: RetiroDetalleScreenStateColors.deepBlue,
                elevation: 0,
                disabledBackgroundColor:
                    RetiroDetalleScreenStateColors.gold.withValues(alpha: 0.45),
                disabledForegroundColor:
                    RetiroDetalleScreenStateColors.deepBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: cargando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: RetiroDetalleScreenStateColors.deepBlue,
                      ),
                    )
                  : Text(
                      yaInscrito ? 'YA INSCRITO' : 'INSCRIBIRME',
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

class RetiroDetalleScreenStateColors {
  static const Color gold = Color(0xFFD4AF37);
  static const Color softGold = Color(0xFFE8C76A);
  static const Color deepBlue = Color(0xFF0B1E66);
}
