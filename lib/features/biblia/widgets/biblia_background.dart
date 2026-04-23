import 'package:flutter/material.dart';

class BibliaBackground extends StatelessWidget {
  final Widget child;
  final String backgroundAsset;
  final List<Widget>? overlays;

  const BibliaBackground({
    super.key,
    required this.child,
    this.backgroundAsset = 'assets/images/biblia/panel_lector.png',
    this.overlays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF020B16),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF020B16),
                        Color(0xFF041A33),
                        Color(0xFF061F3D),
                        Color(0xFF020B16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.26),
                    Colors.black.withOpacity(0.14),
                    Colors.black.withOpacity(0.30),
                  ],
                ),
              ),
            ),
          ),
          if (overlays != null) ...overlays!,
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
