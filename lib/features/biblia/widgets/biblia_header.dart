import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BibliaHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;
  final String frameAsset;
  final EdgeInsetsGeometry margin;
  final double height;

  const BibliaHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.frameAsset = 'assets/images/biblia/frame_lector_superior.png',
    this.margin = const EdgeInsets.fromLTRB(16, 8, 16, 0),
    this.height = 148,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              frameAsset,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF082447).withOpacity(0.94),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.70),
                      width: 1.2,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: onBack != null
                            ? _HeaderCircleButton(
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: onBack!,
                              )
                            : const SizedBox.shrink(),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cormorantGaramond(
                                color: const Color(0xFFF7E7B5),
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                            if (subtitle != null && subtitle!.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  subtitle!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lora(
                                    color: const Color(0xFFE5D09A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: trailing ?? const SizedBox.shrink(),
                      ),
                    ],
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

class _HeaderCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderCircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: onTap,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF082447).withOpacity(0.72),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.35),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFF3D27A),
            size: 18,
          ),
        ),
      ),
    );
  }
}
