import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mainItems = <_NavItemData>[
      const _NavItemData(icon: Icons.home_rounded, label: 'Inicio'),
      const _NavItemData(icon: Icons.auto_awesome_rounded, label: 'Oración'),
      const _NavItemData(icon: Icons.groups_rounded, label: 'Retiros'),
      const _NavItemData(icon: Icons.grid_view_rounded, label: 'Contenido'),
    ];

    const perfilItem = _NavItemData(
      icon: Icons.person_rounded,
      label: 'Perfil',
    );

    return Container(
      color: AppColors.navShell,
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _GlassNavCapsule(
                child: Row(
                  children: List.generate(mainItems.length, (index) {
                    final item = mainItems[index];
                    return Expanded(
                      child: _PressableNavButton(
                        item: item,
                        isActive: currentIndex == index,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onTap(index);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: _GlassNavCapsule(
                active: currentIndex == 4,
                child: _PressableNavButton(
                  item: perfilItem,
                  isActive: currentIndex == 4,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(4);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassNavCapsule extends StatelessWidget {
  final Widget child;
  final bool active;

  const _GlassNavCapsule({
    required this.child,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color:
            (active ? AppColors.navBackgroundActive : AppColors.navBackground)
                .withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.white.withValues(alpha: 0.04),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.34),
            blurRadius: 24,
            spreadRadius: -10,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.lumenPurpleGlow.withValues(alpha: 0.16),
            blurRadius: 18,
            spreadRadius: -8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PressableNavButton extends StatefulWidget {
  final _NavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  const _PressableNavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_PressableNavButton> createState() => _PressableNavButtonState();
}

class _PressableNavButtonState extends State<_PressableNavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : (isActive ? 1.05 : 1),
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.lumenGold.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.lumenGold.withValues(alpha: 0.22),
                      blurRadius: 18,
                      spreadRadius: -6,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppColors.lumenGold.withValues(alpha: 0.18)
                      : Colors.transparent,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.lumenGold.withValues(alpha: 0.25),
                            blurRadius: 16,
                            spreadRadius: -6,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.item.icon,
                  size: isActive ? 22 : 20,
                  color: isActive
                      ? AppColors.lumenGoldBright
                      : AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                style: GoogleFonts.poppins(
                  fontSize: isActive ? 11 : 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.lumenGoldBright
                      : AppColors.darkTextSecondary,
                  height: 1.0,
                ),
                child: Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.label,
  });
}
