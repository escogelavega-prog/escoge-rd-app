import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeticionCategoryChip extends StatelessWidget {
  const PeticionCategoryChip({
    super.key,
    required this.categoria,
  });

  final String categoria;

  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _gold.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        categoria,
        style: GoogleFonts.poppins(
          color: _gold,
          fontSize: 12.4,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}
