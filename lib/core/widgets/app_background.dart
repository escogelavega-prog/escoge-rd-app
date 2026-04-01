import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🎨 Fondo base
        Container(
          color: AppColors.background,
        ),

        // 🌫️ Gradiente superior (halo espiritual)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryBlue.withOpacity(0.06),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // ✨ Luz radial suave (centro)
        Positioned(
          top: -80,
          left: -60,
          right: -60,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.8,
                colors: [
                  AppColors.gold.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 📄 Contenido
        child,
      ],
    );
  }
}
