import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/domain/app_roles.dart';
import 'package:escoge/features/auth/presentation/widgets/role_guard.dart';

import '../widgets/settings_profile_preview_card.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/settings_tile.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final AuthService _authService = AuthService();

  bool _notificaciones = true;
  bool _recordatorios = true;
  bool _modoOscuro = false;

  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1736A2);
  static const Color accentBlue = Color(0xFF2A49B8);
  static const Color softBackground = Color(0xFFF3F6FD);

  Future<Map<String, dynamic>> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return {
        'userName': 'Invitado Escoge',
        'userEmail': 'usuario@escoge.app',
      };
    }

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(currentUser.uid)
        .get();

    final data = doc.data() ?? <String, dynamic>{};

    final userName = (data['nombre'] ?? '').toString().trim();
    final userEmail =
        (data['email'] ?? currentUser.email ?? '').toString().trim();

    return {
      'userName': userName.isEmpty ? 'Invitado Escoge' : userName,
      'userEmail': userEmail.isEmpty ? 'usuario@escoge.app' : userEmail,
    };
  }

  Future<void> _confirmSignOut() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Cerrar sesión'),
          content: const Text(
            '¿Deseas salir de tu cuenta en Escoge RD?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    try {
      await _authService.signOut();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo cerrar la sesión: $e'),
        ),
      );
    }
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title estará disponible próximamente.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      body: Stack(
        children: [
          _buildTopBackground(),
          SafeArea(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _loadUserData(),
              builder: (context, snapshot) {
                final userData = snapshot.data ??
                    {
                      'userName': 'Invitado Escoge',
                      'userEmail': 'usuario@escoge.app',
                    };

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 26),
                    SettingsProfilePreviewCard(
                      userName: userData['userName'] as String,
                      userEmail: userData['userEmail'] as String,
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
                    SettingsTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Editar perfil',
                      subtitle: 'Actualiza nombre, correo y datos personales',
                      onTap: () => _showComingSoon('Editar perfil'),
                    ),
                    const SizedBox(height: 14),
                    SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Seguridad',
                      subtitle: 'Configura acceso, contraseña y autenticación',
                      onTap: () => _showComingSoon('Seguridad'),
                    ),
                    RoleGuard(
                      minRole: AppRoles.diocesano,
                      child: Column(
                        children: [
                          const SizedBox(height: 14),
                          SettingsTile(
                            icon: Icons.build_circle_outlined,
                            title: 'Herramientas internas',
                            subtitle:
                                'Opciones especiales para equipos de servicio',
                            onTap: () =>
                                _showComingSoon('Herramientas internas'),
                          ),
                        ],
                      ),
                    ),
                    RoleGuard(
                      minRole: AppRoles.diocesano,
                      child: Column(
                        children: [
                          const SizedBox(height: 14),
                          SettingsTile(
                            icon: Icons.event_note_outlined,
                            title: 'Gestión de retiros',
                            subtitle: 'Administrar eventos y participantes',
                            onTap: () => _showComingSoon('Gestión de retiros'),
                          ),
                        ],
                      ),
                    ),
                    RoleGuard(
                      minRole: AppRoles.nacional,
                      child: Column(
                        children: [
                          const SizedBox(height: 14),
                          SettingsTile(
                            icon: Icons.public_outlined,
                            title: 'Panel nacional',
                            subtitle: 'Vista global de diócesis y actividades',
                            onTap: () => _showComingSoon('Panel nacional'),
                          ),
                        ],
                      ),
                    ),
                    RoleGuard(
                      minRole: AppRoles.superadmin,
                      child: Column(
                        children: [
                          const SizedBox(height: 14),
                          SettingsTile(
                            icon: Icons.admin_panel_settings_outlined,
                            title: 'Panel superadmin',
                            subtitle: 'Control total de la plataforma',
                            onTap: () => _showComingSoon('Panel superadmin'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Acerca de Escoge RD',
                      subtitle: 'Información general de la aplicación',
                      onTap: () => _showComingSoon('Acerca de Escoge RD'),
                    ),
                    const SizedBox(height: 14),
                    SettingsTile(
                      icon: Icons.logout_rounded,
                      title: 'Cerrar sesión',
                      subtitle: 'Salir de tu cuenta de forma segura',
                      isDanger: true,
                      onTap: _confirmSignOut,
                    ),
                  ],
                );
              },
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
