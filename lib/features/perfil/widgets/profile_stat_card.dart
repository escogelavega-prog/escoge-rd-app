import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.isTextValue = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool isTextValue;

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color textPrimary = Color(0xFF16213E);
  static const Color textSecondary = Color(0xFF6D7693);
  static const Color cardBorder = Color(0xFFE7ECF7);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF3FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primaryBlue, size: 21),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: isTextValue ? 18 : 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
