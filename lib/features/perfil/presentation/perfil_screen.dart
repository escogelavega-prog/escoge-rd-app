import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_spacing.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/domain/app_roles.dart';
import 'package:escoge/features/perfil/presentation/configuracion_screen.dart';
import 'package:escoge/features/perfil/widgets/profile_account_card.dart';
import 'package:escoge/features/perfil/widgets/profile_header.dart';
import 'package:escoge/features/perfil/widgets/profile_hero_card.dart';
import 'package:escoge/features/perfil/widgets/profile_reflection_card.dart';
import 'package:escoge/features/perfil/widgets/profile_stats_section.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(currentUser.uid)
        .get();

    final data = doc.data() ?? <String, dynamic>{};

    int safeInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return 0;
    }

    return {
      'uid': currentUser.uid,
      'nombre': (data['nombre'] ?? '').toString().trim(),
      'email': (data['email'] ?? currentUser.email ?? '').toString().trim(),
      'estadoEspiritual':
          (data['estadoEspiritual'] ?? 'Caminando con propósito ✨')
              .toString()
              .trim(),
      'role': (data['role'] ?? AppRoles.joven).toString().trim(),
      'diocesisNombre': (data['diocesisNombre'] ?? '').toString().trim(),
      'isActive': data['isActive'] ?? true,
      'profileCompleted': data['profileCompleted'] ?? false,
      'retirosCount': safeInt(data['retirosCount']),
      'oracionesCount': safeInt(data['oracionesCount']),
      'diasCamino': safeInt(data['diasCamino']),
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
            '¿Deseas cerrar tu sesión en Escoge RD?',
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

  void _openConfiguracion() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ConfiguracionScreen(),
      ),
    );
  }

  String _resolveDisplayName(Map<String, dynamic>? data) {
    if (data == null) return 'Usuario';
    final name = (data['nombre'] ?? '').toString().trim();
    return name.isEmpty ? 'Usuario' : name;
  }

  String _resolveDisplayEmail(Map<String, dynamic>? data) {
    if (data == null) return '';
    return (data['email'] ?? '').toString().trim();
  }

  String _resolveSpiritualState(Map<String, dynamic>? data) {
    if (data == null) return 'Caminando con propósito ✨';
    final value = (data['estadoEspiritual'] ?? '').toString().trim();
    return value.isEmpty ? 'Caminando con propósito ✨' : value;
  }

  String _resolveRole(Map<String, dynamic>? data) {
    if (data == null) return AppRoles.joven;
    final value = (data['role'] ?? AppRoles.joven).toString().trim();
    return AppRoles.isValid(value) ? value : AppRoles.joven;
  }

  String _resolveDiocesis(Map<String, dynamic>? data) {
    if (data == null) return '';
    return (data['diocesisNombre'] ?? '').toString().trim();
  }

  int _resolveRetirosCount(Map<String, dynamic>? data) {
    if (data == null) return 0;
    final value = data['retirosCount'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  int _resolveOracionesCount(Map<String, dynamic>? data) {
    if (data == null) return 0;
    final value = data['oracionesCount'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  int _resolveDiasCamino(Map<String, dynamic>? data) {
    if (data == null) return 0;
    final value = data['diasCamino'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  String _roleLabel(String role) {
    return AppRoles.label(role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        background: AppBackgrounds.perfil,
        overlayOpacity: 0.10,
        useSafeArea: false,
        child: SafeArea(
          bottom: false,
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _loadUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final userData = snapshot.data;
              final userName = _resolveDisplayName(userData);
              final userEmail = _resolveDisplayEmail(userData);
              final estadoEspiritual = _resolveSpiritualState(userData);
              final role = _resolveRole(userData);
              final diocesisNombre = _resolveDiocesis(userData);
              final retirosCount = _resolveRetirosCount(userData);
              final oracionesCount = _resolveOracionesCount(userData);
              final diasCamino = _resolveDiasCamino(userData);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: ProfileHeader(),
                        ),
                        const SizedBox(width: 12),
                        Material(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _openConfiguracion,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.settings_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Material(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _confirmSignOut,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ProfileHeroCard(
                      userName: userName,
                      userEmail: userEmail,
                      estadoEspiritual: estadoEspiritual,
                    ),
                    if (diocesisNombre.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_city_outlined,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Diócesis: $diocesisNombre',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    ProfileStatsSection(
                      retiros: retirosCount,
                      oraciones: oracionesCount,
                      dias: diasCamino,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ProfileAccountCard(
                      userName: userName,
                      userEmail: userEmail,
                      estadoEspiritual: estadoEspiritual,
                      role: role,
                      onOpenSettings: _openConfiguracion,
                      onLogout: _confirmSignOut,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Rol actual: ${_roleLabel(role)}',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const ProfileReflectionCard(),
                    const SizedBox(height: AppSpacing.xl + 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}