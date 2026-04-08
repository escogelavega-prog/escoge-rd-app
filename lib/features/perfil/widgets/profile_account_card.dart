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
  static const Color gold = Color(0xFFD4AF37);

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
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),

        /// CARD PRINCIPAL
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
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
              const SizedBox(height: 16),
              _buildDivider(),
              const SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.email_outlined,
                title: 'Correo electrónico',
                value: userEmail,
              ),
              const SizedBox(height: 16),
              _buildDivider(),
              const SizedBox(height: 16),
              _buildEstadoRow(
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.08),
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
              const SizedBox(height: 3),
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

  /// 👇 FILA ESPECIAL PARA EL ESTADO ESPIRITUAL (ESTO ELEVA TODO)
  Widget _buildEstadoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: gold.withOpacity(0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: gold, size: 20),
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
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: gold.withOpacity(0.18),
                  ),
                ),
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.black.withOpacity(0.06),
    );
  }
}
