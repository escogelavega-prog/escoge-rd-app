import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:escoge/app/session_gate.dart';
import 'package:escoge/core/theme/app_spacing.dart';
import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/domain/app_roles.dart';
import 'package:escoge/features/oracion/presentation/admin/liturgia_seed_screen.dart';
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

    final userRef =
        FirebaseFirestore.instance.collection('usuarios').doc(currentUser.uid);

    final doc = await userRef.get();
    final data = doc.data() ?? <String, dynamic>{};

    int safeInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return 0;
    }

    final nombre = (data['nombre'] ?? '').toString().trim();
    final email = (data['email'] ?? currentUser.email ?? '').toString().trim();
    final estadoEspiritual =
        (data['estadoEspiritual'] ?? 'Caminando con propósito ✨')
            .toString()
            .trim();
    final role = (data['role'] ?? AppRoles.joven).toString().trim();
    final diocesisNombre = (data['diocesisNombre'] ?? '').toString().trim();
    final retirosCount = safeInt(data['retirosCount']);
    var oracionesCount = safeInt(data['oracionesCount']);
    var diasCamino = safeInt(data['diasCamino']);

    final diasCaminoCalculados = _calcularDiasCamino(
      _resolverFechaInicio(data, currentUser),
    );

    // Reconciliación productiva de días de camino:
    // si no está guardado o está en 0, se calcula y se persiste.
    if (diasCamino <= 0 && diasCaminoCalculados > 0) {
      diasCamino = diasCaminoCalculados;
      await userRef.set(
        {
          'diasCamino': diasCamino,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }

    // Reconciliación productiva de oraciones:
    // si el contador está en 0, revisa cuántas peticiones reales tiene el usuario
    // y corrige Firestore automáticamente.
    if (oracionesCount <= 0) {
      final peticionesQuery = await FirebaseFirestore.instance
          .collection('peticiones')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      final totalReal = peticionesQuery.docs.length;

      if (totalReal > 0) {
        oracionesCount = totalReal;

        await userRef.set(
          {
            'oracionesCount': totalReal,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }
    }

    return {
      'uid': currentUser.uid,
      'nombre': nombre,
      'email': email,
      'estadoEspiritual': estadoEspiritual,
      'role': role,
      'diocesisNombre': diocesisNombre,
      'retirosCount': retirosCount,
      'oracionesCount': oracionesCount,
      'diasCamino': diasCamino,
    };
  }

  DateTime? _resolverFechaInicio(
    Map<String, dynamic> data,
    User currentUser,
  ) {
    final createdAt = data['createdAt'];

    if (createdAt is Timestamp) {
      return createdAt.toDate();
    }

    return currentUser.metadata.creationTime;
  }

  int _calcularDiasCamino(DateTime? fechaInicio) {
    if (fechaInicio == null) return 0;

    final inicio = DateTime(
      fechaInicio.year,
      fechaInicio.month,
      fechaInicio.day,
    );

    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    final diferencia = hoy.difference(inicio).inDays;
    return diferencia < 0 ? 0 : diferencia + 1;
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

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const SessionGate(),
        ),
        (route) => false,
      );
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

  void _openLiturgiaSeed(String role) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiturgiaSeedScreen(
          userRole: role,
        ),
      ),
    );
  }

  String _resolveDisplayName(Map<String, dynamic>? data) {
    final name = (data?['nombre'] ?? '').toString().trim();
    return name.isEmpty ? 'Usuario' : name;
  }

  String _resolveDisplayEmail(Map<String, dynamic>? data) {
    return (data?['email'] ?? '').toString().trim();
  }

  String _resolveSpiritualState(Map<String, dynamic>? data) {
    final value = (data?['estadoEspiritual'] ?? '').toString().trim();
    return value.isEmpty ? 'Caminando con propósito ✨' : value;
  }

  String _resolveRole(Map<String, dynamic>? data) {
    final value = (data?['role'] ?? AppRoles.joven).toString().trim();
    return AppRoles.isValid(value) ? value : AppRoles.joven;
  }

  String _resolveDiocesis(Map<String, dynamic>? data) {
    return (data?['diocesisNombre'] ?? '').toString().trim();
  }

  int _resolveCount(Map<String, dynamic>? data, String key) {
    final value = data?[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  String _roleLabel(String role) {
    return AppRoles.label(role);
  }

  bool _isSuperAdmin(String role) {
    return role.trim().toLowerCase() == 'superadmin';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/form.png',
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          SafeArea(
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
                final roleLabel = _roleLabel(role);
                final diocesisNombre = _resolveDiocesis(userData);

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
                      const ProfileHeader(),
                      const SizedBox(height: AppSpacing.lg),
                      ProfileHeroCard(
                        userName: userName,
                        userEmail: userEmail,
                        estadoEspiritual: estadoEspiritual,
                        diocesisNombre: diocesisNombre,
                        roleLabel: roleLabel,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ProfileStatsSection(
                        retiros: _resolveCount(userData, 'retirosCount'),
                        oraciones: _resolveCount(userData, 'oracionesCount'),
                        dias: _resolveCount(userData, 'diasCamino'),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ProfileAccountCard(
                        userName: userName,
                        userEmail: userEmail,
                        estadoEspiritual: estadoEspiritual,
                        role: role,
                        onOpenSettings: _openConfiguracion,
                        onLogout: _confirmSignOut,
                        showLiturgiaSeed: _isSuperAdmin(role),
                        onOpenLiturgiaSeed: () => _openLiturgiaSeed(role),
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
        ],
      ),
    );
  }
}
