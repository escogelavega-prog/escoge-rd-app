import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItemData> _items = [
    _NavItemData(
      asset: 'assets/icons/home.png',
      label: 'Inicio',
    ),
    _NavItemData(
      asset: 'assets/icons/contenido.png',
      label: 'Oración',
    ),
    _NavItemData(
      asset: 'assets/icons/retiros.png',
      label: 'Retiros',
    ),
    _NavItemData(
      asset: 'assets/icons/inscripcion.png',
      label: 'Contenido',
    ),
    _NavItemData(
      asset: 'assets/icons/perfil.png',
      label: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 74,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.navBackground,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.navBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.34),
                  blurRadius: 28,
                  spreadRadius: -6,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: AppColors.lumenGold.withValues(alpha: 0.08),
                  blurRadius: 22,
                  spreadRadius: -8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(
                _items.length,
                (index) {
                  final item = _items[index];

                  return _BottomNavItem(
                    index: index,
                    asset: item.asset,
                    label: item.label,
                    isActive: currentIndex == index,
                    onTap: onTap,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final int index;
  final String asset;
  final String label;
  final bool isActive;
  final ValueChanged<int> onTap;

  const _BottomNavItem({
    required this.index,
    required this.asset,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(24),
          splashColor: AppColors.lumenGold.withValues(alpha: 0.08),
          highlightColor: AppColors.lumenGold.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isActive ? AppColors.navBackgroundActive : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    isActive ? AppColors.glassStrokeGold : Colors.transparent,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isActive ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.lumenGold.withValues(alpha: 0.14)
                          : Colors.transparent,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.lumenGold.withValues(
                                  alpha: 0.18,
                                ),
                                blurRadius: 16,
                                spreadRadius: -3,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Image.asset(
                        asset,
                        width: 21,
                        height: 21,
                        fit: BoxFit.contain,
                        color: isActive
                            ? AppColors.lumenGoldBright
                            : AppColors.lumenTextMuted,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.circle_outlined,
                            size: 21,
                            color: isActive
                                ? AppColors.lumenGoldBright
                                : AppColors.lumenTextMuted,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: GoogleFonts.poppins(
                    fontSize: 9.6,
                    height: 1,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: isActive ? 0.1 : 0,
                    color: isActive
                        ? AppColors.lumenGoldSoft
                        : AppColors.lumenTextMuted,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _NavItemData {
  final String asset;
  final String label;

  const _NavItemData({
    required this.asset,
    required this.label,
  });
}
