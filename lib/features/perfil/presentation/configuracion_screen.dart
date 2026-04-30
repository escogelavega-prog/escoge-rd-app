import 'dart:ui';

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

  static const Color lumenGold = Color(0xFFD4AF37);
  static const Color darkBackground = Color(0xFF060B16);
  static const Color darkCard = Color(0xFF111827);

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
          backgroundColor: darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Cerrar sesión',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            '¿Deseas salir de tu cuenta en Escoge RD?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: lumenGold,
                foregroundColor: Colors.black,
              ),
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
        backgroundColor: darkCard,
        content: Text('$title estará disponible próximamente.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/bg_primary.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.14),
                    const Color(0xFF09111F).withValues(alpha: 0.55),
                    const Color(0xFF060B16).withValues(alpha: 0.94),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.55),
                  radius: 1.05,
                  colors: [
                    lumenGold.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
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
                    const SizedBox(height: 28),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: SettingsProfilePreviewCard(
                          userName: userData['userName'] as String,
                          userEmail: userData['userEmail'] as String,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const SettingsSectionTitle(
                      title: 'Preferencias',
                      subtitle:
                          'Personaliza tu experiencia espiritual dentro de Escoge',
                    ),
                    const SizedBox(height: 16),
                    SettingsTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notificaciones',
                      subtitle: 'Avisos sobre retiros y novedades',
                      trailing: Switch(
                        value: _notificaciones,
                        activeThumbColor: lumenGold,
                        onChanged: (value) {
                          setState(() {
                            _notificaciones = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    SettingsTile(
                      icon: Icons.alarm_outlined,
                      title: 'Recordatorios espirituales',
                      subtitle: 'Oración, reflexión y acompañamiento diario',
                      trailing: Switch(
                        value: _recordatorios,
                        activeThumbColor: lumenGold,
                        onChanged: (value) {
                          setState(() {
                            _recordatorios = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Modo oscuro',
                      subtitle: 'Preparado para futuras mejoras visuales',
                      trailing: Switch(
                        value: _modoOscuro,
                        activeThumbColor: lumenGold,
                        onChanged: (value) {
                          setState(() {
                            _modoOscuro = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    const SettingsSectionTitle(
                      title: 'Cuenta y acceso',
                      subtitle:
                          'Gestiona tu perfil, seguridad y administración',
                    ),
                    const SizedBox(height: 16),
                    SettingsTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Editar perfil',
                      subtitle: 'Actualiza tus datos personales',
                      onTap: () => _showComingSoon('Editar perfil'),
                    ),
                    const SizedBox(height: 14),
                    SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Seguridad',
                      subtitle: 'Contraseña y autenticación',
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
                            subtitle: 'Opciones para equipos de servicio',
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
                            subtitle: 'Vista global de diócesis',
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
                      subtitle: 'Información general',
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: lumenGold.withValues(alpha: 0.24),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuración',
                style: GoogleFonts.lora(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Preferencias, seguridad y ajustes personales',
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 12.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
