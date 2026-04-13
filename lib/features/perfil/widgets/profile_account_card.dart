import 'package:escoge/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAccountCard extends StatelessWidget {
  const ProfileAccountCard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.estadoEspiritual,
    required this.role,
    required this.onOpenSettings,
    required this.onLogout,
    this.showLiturgiaSeed = false,
    this.onOpenLiturgiaSeed,
  });

  final String userName;
  final String userEmail;
  final String estadoEspiritual;
  final String role;
  final VoidCallback onOpenSettings;
  final VoidCallback onLogout;
  final bool showLiturgiaSeed;
  final VoidCallback? onOpenLiturgiaSeed;

  static const Color _cardColor = Colors.white;
  static const Color _borderColor = Color(0xFFE7EAF3);
  static const Color _titleColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);
  static const Color _primaryBlue = Color(0xFF0B1E66);
  static const Color _secondaryBlue = Color(0xFF1736B6);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _danger = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _cardColor.withOpacity(0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cuenta',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Administra tu perfil, tu sesión y herramientas disponibles según tu nivel de acceso.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: _subtitleColor,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileInfoTile(
            icon: Icons.person_rounded,
            iconColor: _secondaryBlue,
            title: 'Nombre',
            subtitle: userName.isEmpty ? 'No definido' : userName,
          ),
          const SizedBox(height: 12),
          _ProfileInfoTile(
            icon: Icons.email_rounded,
            iconColor: _secondaryBlue,
            title: 'Correo',
            subtitle: userEmail.isEmpty ? 'No definido' : userEmail,
          ),
          const SizedBox(height: 12),
          _ProfileInfoTile(
            icon: Icons.auto_awesome_rounded,
            iconColor: _gold,
            title: 'Estado espiritual',
            subtitle: estadoEspiritual.isEmpty
                ? 'Caminando con propósito ✨'
                : estadoEspiritual,
          ),
          const SizedBox(height: 12),
          _ProfileInfoTile(
            icon: Icons.verified_user_rounded,
            iconColor: _primaryBlue,
            title: 'Rol del usuario',
            subtitle: role.isEmpty ? 'usuario' : role,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Acciones',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 12),
          _ProfileActionTile(
            icon: Icons.settings_rounded,
            iconColor: _primaryBlue,
            title: 'Configuración',
            subtitle: 'Ajustes generales de la cuenta',
            onTap: onOpenSettings,
          ),
          if (showLiturgiaSeed && onOpenLiturgiaSeed != null) ...[
            const SizedBox(height: 12),
            _ProfileActionTile(
              icon: Icons.cloud_upload_rounded,
              iconColor: _gold,
              title: 'Cargar liturgia',
              subtitle: 'Herramienta exclusiva de superadmin',
              onTap: onOpenLiturgiaSeed!,
              isHighlighted: true,
            ),
          ],
          const SizedBox(height: 12),
          _ProfileActionTile(
            icon: Icons.logout_rounded,
            iconColor: _danger,
            title: 'Cerrar sesión',
            subtitle: 'Salir de tu cuenta actual',
            onTap: onLogout,
            isDanger: true,
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8ECF4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 22,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
    this.isHighlighted = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDanger
        ? const Color(0xFFFEF2F2)
        : isHighlighted
            ? const Color(0xFFFFFBEB)
            : const Color(0xFFF8FAFC);

    final borderColor = isDanger
        ? const Color(0xFFFECACA)
        : isHighlighted
            ? const Color(0xFFFDE68A)
            : const Color(0xFFE8ECF4);

    final titleColor =
        isDanger ? const Color(0xFFB91C1C) : const Color(0xFF111827);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 22,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: const Color(0xFF6B7280),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
