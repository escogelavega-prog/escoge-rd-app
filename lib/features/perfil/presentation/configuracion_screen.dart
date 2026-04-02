import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/settings_profile_preview_card.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_tile.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key, String? userName, String? userEmail})
    : userName = userName ?? 'Invitado Escoge',
      userEmail = userEmail ?? 'usuario@escoge.app';

  final String userName;
  final String userEmail;

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool _notificaciones = true;
  bool _recordatorios = true;
  bool _modoOscuro = false;

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1736A2);
  static const Color accentBlue = Color(0xFF2A49B8);
  static const Color softBackground = Color(0xFFF3F6FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      body: Stack(
        children: [
          _buildTopBackground(),
          SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              children: [
                _buildHeader(context),
                const SizedBox(height: 26),
                SettingsProfilePreviewCard(
                  userName: widget.userName,
                  userEmail: widget.userEmail,
                ),
                const SizedBox(height: 28),
                const SettingsSectionTitle(
                  title: 'Preferencias',
                  subtitle: 'Personaliza tu experiencia dentro de Escoge',
                ),
                const SizedBox(height: 14),
                SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notificaciones',
                  subtitle: 'Activa avisos sobre retiros y novedades',
                  trailing: Switch(
                    value: _notificaciones,
                    onChanged: (value) {
                      setState(() {
                        _notificaciones = value;
                      });
                    },
                    activeThumbColor: primaryBlue,
                  ),
                ),
                const SizedBox(height: 14),
                SettingsTile(
                  icon: Icons.alarm_outlined,
                  title: 'Recordatorios espirituales',
                  subtitle: 'Recibe avisos para oración y reflexión diaria',
                  trailing: Switch(
                    value: _recordatorios,
                    onChanged: (value) {
                      setState(() {
                        _recordatorios = value;
                      });
                    },
                    activeThumbColor: primaryBlue,
                  ),
                ),
                const SizedBox(height: 14),
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Modo oscuro',
                  subtitle: 'Preparado para futura implementación visual',
                  trailing: Switch(
                    value: _modoOscuro,
                    onChanged: (value) {
                      setState(() {
                        _modoOscuro = value;
                      });
                    },
                    activeThumbColor: primaryBlue,
                  ),
                ),
                const SizedBox(height: 28),
                const SettingsSectionTitle(
                  title: 'Cuenta y acceso',
                  subtitle: 'Gestiona tu perfil, seguridad y sesión',
                ),
                const SizedBox(height: 14),
                const SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Editar perfil',
                  subtitle: 'Actualiza nombre, correo y datos personales',
                ),
                const SizedBox(height: 14),
                const SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Seguridad',
                  subtitle: 'Configura acceso, contraseña y autenticación',
                ),
                const SizedBox(height: 14),
                const SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Acerca de Escoge RD',
                  subtitle: 'Información de la aplicación y versión beta',
                ),
                const SizedBox(height: 14),
                const SettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Cerrar sesión',
                  subtitle: 'Salir de tu cuenta de forma segura',
                  isDanger: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBackground() {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, secondaryBlue, accentBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuración',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Preferencias y ajustes personales',
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
