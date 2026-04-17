import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvangelioFeatureImage extends StatelessWidget {
  const EvangelioFeatureImage({
    super.key,
    required this.imagePath,
    this.title = 'Palabra que ilumina tu día',
    this.subtitle = 'Encuentra paz, guía y reflexión en el evangelio de hoy.',
    this.heroTag,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.14),
            colorBlendMode: BlendMode.darken,
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.26),
                    Colors.black.withValues(alpha: 0.60),
                    Colors.black.withValues(alpha: 0.82),
                  ],
                  stops: const [0.0, 0.28, 0.68, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.65),
                  radius: 1.10,
                  colors: [
                    AppColors.lumenGold.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 18, end: 0),
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: AnimatedOpacity(
                    opacity: value == 0 ? 1 : 0.98,
                    duration: const Duration(milliseconds: 520),
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Text(
                      'Evangelio diario',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: GoogleFonts.lora(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13.4,
                      fontWeight: FontWeight.w500,
                      height: 1.52,
                      color: AppColors.white.withValues(alpha: 0.88),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 62,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.lumenGold,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lumenGold.withValues(alpha: 0.24),
                          blurRadius: 14,
                          spreadRadius: -6,
                          offset: const Offset(0, 6),
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

    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 30,
            spreadRadius: -10,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: heroTag == null
          ? image
          : Hero(
              tag: heroTag!,
              child: image,
            ),
    );
  }
}
