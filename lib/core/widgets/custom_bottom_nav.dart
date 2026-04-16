import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/core/theme/app_colors.dart';

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
                    final isActive = currentIndex == index;

                    return Expanded(
                      child: _NavButton(
                        item: item,
                        isActive: isActive,
                        onTap: () => onTap(index),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 78,
              child: _GlassNavCapsule(
                active: currentIndex == 4,
                child: _NavButton(
                  item: perfilItem,
                  isActive: currentIndex == 4,
                  onTap: () => onTap(4),
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
      duration: const Duration(milliseconds: 220),
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color:
            (active ? AppColors.navBackgroundActive : AppColors.navBackground)
                .withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.navBorder.withValues(alpha: 0.60),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.gold.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: isActive ? AppColors.gold : AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.gold : AppColors.darkTextSecondary,
                height: 1.0,
              ),
            ),
          ],
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
