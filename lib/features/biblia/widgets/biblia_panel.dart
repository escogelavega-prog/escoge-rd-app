import 'package:flutter/material.dart';

class BibliaPanel extends StatelessWidget {
  final Widget child;
  final String panelAsset;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double? height;

  const BibliaPanel({
    super.key,
    required this.child,
    this.panelAsset = 'assets/images/biblia/panel_lector.png',
    this.margin = const EdgeInsets.fromLTRB(16, 14, 16, 14),
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget panel = Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            panelAsset,
            fit: BoxFit.fill,
            errorBuilder: (_, __, ___) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF082447).withOpacity(0.92),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.62),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ],
    );

    return Container(
      margin: margin,
      height: height,
      child: height != null
          ? panel
          : IntrinsicHeight(
              child: panel,
            ),
    );
  }
}
