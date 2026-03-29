import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/retiros/domain/retiro_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'retiro_detalle_screen.dart';

class RetirosScreen extends StatefulWidget {
  const RetirosScreen({super.key});

  @override
  State<RetirosScreen> createState() => _RetirosScreenState();
}

class _RetirosScreenState extends State<RetirosScreen> {
  String _selectedDiocesis = 'Todas';
  bool _animateIn = false;

  final List<String> _diocesis = const [
    'Todas',
    'La Vega',
    'Santo Domingo',
    'Santiago',
    'San Francisco',
  ];

  final List<RetiroItem> _retiros = const [
    RetiroItem(
      categoria: 'Retiro Espiritual',
      titulo: 'Renacer en la Fe',
      ciudad: 'La Vega',
      fecha: '2 - 11 mayo, 2026',
      diocesis: 'La Vega',
      imagePath: 'assets/images/capilla.png',
      descripcion:
          'Un fin de semana de encuentro con Dios, reflexión personal, comunidad y crecimiento espiritual.',
      lugar: 'Casa de encuentro diocesana',
      recomendaciones: [
        'Llenar la ficha personalmente.',
        'Proporcionar datos reales y legibles.',
        'Estar atento a la confirmación del coordinador.',
        'Llevar lo indicado por el equipo organizador.',
      ],
    ),
    RetiroItem(
      categoria: 'Retiro de Jóvenes',
      titulo: 'Encuentro con Cristo',
      ciudad: 'Santo Domingo',
      fecha: '25 - 27 junio, 2026',
      diocesis: 'Santo Domingo',
      imagePath: 'assets/images/banner.png',
      descripcion:
          'Una experiencia de fe dirigida a jóvenes que desean reencontrarse con Dios y fortalecer su camino espiritual.',
      lugar: 'Centro juvenil arquidiocesano',
      recomendaciones: [
        'Llevar identificación personal.',
        'Completar correctamente el formulario.',
        'Estar atento a la llamada de confirmación.',
        'Seguir las orientaciones del equipo de retiro.',
      ],
    ),
    RetiroItem(
      categoria: 'Retiro Familiar',
      titulo: 'Unidos en el Señor',
      ciudad: 'Santiago',
      fecha: '8 - 10 julio, 2026',
      diocesis: 'Santiago',
      imagePath: 'assets/images/capilla.png',
      descripcion:
          'Un espacio para fortalecer la vida familiar, compartir en comunidad y crecer juntos en la fe.',
      lugar: 'Casa pastoral familiar',
      recomendaciones: [
        'Llevar artículos personales necesarios.',
        'Mantener datos de contacto actualizados.',
        'Confirmar asistencia con anticipación.',
        'Seguir las indicaciones del retiro.',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _animateIn = true;
        });
      }
    });
  }

  List<RetiroItem> get _filteredRetiros {
    if (_selectedDiocesis == 'Todas') {
      return _retiros;
    }
    return _retiros.where((r) => r.diocesis == _selectedDiocesis).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = 100 + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                'assets/backgrounds/espiritual.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _AnimatedEntrance(
                  visible: _animateIn,
                  delay: 0,
                  child: const _RetirosTopArea(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16, 18, 16, bottomSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AnimatedEntrance(
                          visible: _animateIn,
                          delay: 120,
                          child: const _SectionHeader(
                            title: 'Filtrar por diócesis',
                            subtitle:
                                'Selecciona una diócesis para explorar los retiros disponibles.',
                          ),
                        ),
                        const SizedBox(height: 14),
                        _AnimatedEntrance(
                          visible: _animateIn,
                          delay: 180,
                          child: SizedBox(
                            height: 44,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(right: 8),
                              scrollDirection: Axis.horizontal,
                              itemCount: _diocesis.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final item = _diocesis[index];
                                final isSelected = item == _selectedDiocesis;

                                return _FilterChipPremium(
                                  label: item,
                                  isSelected: isSelected,
                                  onTap: () {
                                    setState(() {
                                      _selectedDiocesis = item;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _AnimatedEntrance(
                          visible: _animateIn,
                          delay: 240,
                          child: const _SectionHeader(
                            title: 'Próximos retiros',
                            subtitle:
                                'Renueva tu fe y tu corazón con experiencias espirituales vivas.',
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...List.generate(_filteredRetiros.length, (index) {
                          final retiro = _filteredRetiros[index];

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  index == _filteredRetiros.length - 1 ? 0 : 16,
                            ),
                            child: _AnimatedEntrance(
                              visible: _animateIn,
                              delay: 300 + (index * 70),
                              child: _RetiroCardPremium(
                                retiro: retiro,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => RetiroDetalleScreen(
                                            retiro: retiro,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedEntrance extends StatelessWidget {
  final bool visible;
  final int delay;
  final Widget child;

  const _AnimatedEntrance({
    required this.visible,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 650 + delay);

    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: duration,
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.08),
        duration: duration,
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}

class _RetirosTopArea extends StatelessWidget {
  const _RetirosTopArea();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1E66), Color(0xFF1639A6)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                image: const DecorationImage(
                  image: AssetImage('assets/backgrounds/espiritual.png'),
                  fit: BoxFit.cover,
                  opacity: 0.14,
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x33FFFFFF), Color(0x11000000)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.04),
                              Colors.black.withValues(alpha: 0.10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      child: Row(
                        children: [
                          Container(
                            height: 62,
                            width: 62,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.94),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.church_rounded,
                                      color: AppColors.primaryBlue,
                                      size: 28,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'RETIROS',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                height: 1,
                              ),
                            ),
                          ),
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.18),
                              ),
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/capilla.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 180,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFDAA04E), Color(0xFF6B3E13)],
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.08),
                            Colors.black.withValues(alpha: 0.48),
                          ],
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
                          'Próximos retiros',
                          style: GoogleFonts.lora(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Renueva tu fe y tu corazón',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.96),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}

class _FilterChipPremium extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipPremium({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color:
                  isSelected
                      ? AppColors.primaryBlue
                      : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.primaryBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RetiroCardPremium extends StatefulWidget {
  final RetiroItem retiro;
  final VoidCallback? onTap;

  const _RetiroCardPremium({required this.retiro, this.onTap});

  @override
  State<_RetiroCardPremium> createState() => _RetiroCardPremiumState();
}

class _RetiroCardPremiumState extends State<_RetiroCardPremium> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final retiro = widget.retiro;

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(22),
                  ),
                  child: Image.asset(
                    retiro.imagePath,
                    width: 110,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          width: 110,
                          height: 120,
                          color: AppColors.primaryBlue.withValues(alpha: 0.10),
                          child: const Icon(
                            Icons.church_rounded,
                            color: AppColors.primaryBlue,
                            size: 28,
                          ),
                        ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          retiro.titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          retiro.descripcion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                retiro.ciudad,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 13,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                retiro.fecha,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.primaryBlue,
              fontSize: 18.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
