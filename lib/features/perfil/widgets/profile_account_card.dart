import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAccountCard extends StatelessWidget {
  const ProfileAccountCard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.estadoEspiritual,
  });

  final String userName;
  final String userEmail;
  final String estadoEspiritual;

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color textPrimary = Color(0xFF16213E);
  static const Color textSecondary = Color(0xFF6D7693);
  static const Color cardBorder = Color(0xFFE7ECF7);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuenta',
          style: GoogleFonts.poppins(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Información personal y estado actual',
          style: GoogleFonts.poppins(
            color: textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
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
            children: [
              _buildInfoRow(
                icon: Icons.badge_outlined,
                title: 'Nombre visible',
                value: userName,
              ),
              const SizedBox(height: 14),
              _buildDivider(),
              const SizedBox(height: 14),
              _buildInfoRow(
                icon: Icons.email_outlined,
                title: 'Correo electrónico',
                value: userEmail,
              ),
              const SizedBox(height: 14),
              _buildDivider(),
              const SizedBox(height: 14),
              _buildInfoRow(
                icon: Icons.favorite_outline,
                title: 'Estado espiritual',
                value: estadoEspiritual,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: primaryBlue, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: cardBorder);
  }
}
