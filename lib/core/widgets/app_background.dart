import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final String background;
  final Widget child;
  final double overlayOpacity;
  final List<Color>? gradientColors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final bool useSafeArea;

  const AppBackground({
    super.key,
    required this.background,
    required this.child,
    this.overlayOpacity = 0.20,
    this.gradientColors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          background,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: const Color(0xFFF3F5FB),
            );
          },
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: gradientColors ??
                  [
                    Colors.black.withValues(alpha: overlayOpacity * 0.55),
                    Colors.black.withValues(alpha: overlayOpacity),
                    Colors.black.withValues(alpha: overlayOpacity * 1.15),
                  ],
            ),
          ),
        ),
        child,
      ],
    );

    if (!useSafeArea) return content;

    return SafeArea(child: content);
  }
}
