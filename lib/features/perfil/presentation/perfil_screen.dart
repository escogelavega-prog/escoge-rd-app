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

  bool _isReconciling = false;
  bool _didInitialReconciliation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reconciliarDatosUsuario();
    });
  }

  Future<void> _reconciliarDatosUsuario() async {
    if (_isReconciling || _didInitialReconciliation) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _isReconciling = true;

    try {
      final userRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(currentUser.uid);

      final doc = await userRef.get();
      final data = doc.data() ?? <String, dynamic>{};

      await _reconciliarDiasCamino(
        userRef: userRef,
        data: data,
        currentUser: currentUser,
      );

      await _reconciliarOraciones(
        userRef: userRef,
        data: data,
        currentUser: currentUser,
      );

      await _reconciliarRachaOracion(
        userRef: userRef,
        data: data,
      );

      await _reconciliarRetiros(
        userRef: userRef,
        data: data,
        currentUser: currentUser,
      );

      _didInitialReconciliation = true;
    } catch (_) {
      // No rompemos la UI si alguna reconciliación falla.
    } finally {
      _isReconciling = false;
    }
  }

  Future<void> _reconciliarDiasCamino({
    required DocumentReference<Map<String, dynamic>> userRef,
    required Map<String, dynamic> data,
    required User currentUser,
  }) async {
    final diasCaminoActual = _safeInt(data['diasCamino']);
    final diasCaminoCalculados = _calcularDiasCamino(
      _resolverFechaInicio(data, currentUser),
    );

    if (diasCaminoActual <= 0 && diasCaminoCalculados > 0) {
      await userRef.set(
        {
          'diasCamino': diasCaminoCalculados,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<void> _reconciliarOraciones({
    required DocumentReference<Map<String, dynamic>> userRef,
    required Map<String, dynamic> data,
    required User currentUser,
  }) async {
    final oracionesCountActual = _safeInt(data['oracionesCount']);

    if (oracionesCountActual > 0) return;

    final peticionesSnapshot =
        await FirebaseFirestore.instance.collection('peticiones').get();

    int totalOraciones = 0;

    for (final peticionDoc in peticionesSnapshot.docs) {
      final unionDoc = await peticionDoc.reference
          .collection('unidos')
          .doc(currentUser.uid)
          .get();

      if (unionDoc.exists) {
        totalOraciones++;
      }
    }

    if (totalOraciones > 0) {
      await userRef.set(
        {
          'oracionesCount': totalOraciones,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<void> _reconciliarRachaOracion({
    required DocumentReference<Map<String, dynamic>> userRef,
    required Map<String, dynamic> data,
  }) async {
    final rachaActual = _safeInt(data['rachaOracionDias']);
    final ultimaFecha = _resolverUltimaOracionFecha(data);

    if (rachaActual <= 0) return;

    if (ultimaFecha == null) {
      await userRef.set(
        {
          'rachaOracionDias': 0,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return;
    }

    final ultima = DateTime(
      ultimaFecha.year,
      ultimaFecha.month,
      ultimaFecha.day,
    );

    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    final diferencia = hoy.difference(ultima).inDays;

    if (diferencia > 1) {
      await userRef.set(
        {
          'rachaOracionDias': 0,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<void> _reconciliarRetiros({
    required DocumentReference<Map<String, dynamic>> userRef,
    required Map<String, dynamic> data,
    required User currentUser,
  }) async {
    final retirosCountActual = _safeInt(data['retirosCount']);

    if (retirosCountActual > 0) return;

    final retirosSnapshot =
        await FirebaseFirestore.instance.collection('retiros').get();

    int totalRetiros = 0;

    for (final retiroDoc in retirosSnapshot.docs) {
      final inscripciones = await retiroDoc.reference
          .collection('inscripciones')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      totalRetiros += inscripciones.docs.length;
    }

    if (totalRetiros > 0) {
      await userRef.set(
        {
          'retirosCount': totalRetiros,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }

  int _safeInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
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

  DateTime? _resolverUltimaOracionFecha(Map<String, dynamic> data) {
    final raw = data['ultimaOracionFecha'];

    if (raw is Timestamp) {
      return raw.toDate();
    }

    return null;
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

  int _resolveRachaVisible(Map<String, dynamic>? data) {
    final racha = _resolveCount(data, 'rachaOracionDias');
    final ultimaFecha = _resolverUltimaOracionFecha(data ?? {});

    if (racha <= 0 || ultimaFecha == null) return 0;

    final ultima = DateTime(
      ultimaFecha.year,
      ultimaFecha.month,
      ultimaFecha.day,
    );

    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    final diferencia = hoy.difference(ultima).inDays;

    if (diferencia > 1) {
      return 0;
    }

    return racha;
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
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('No hay sesión activa.'),
        ),
      );
    }

    final userStream = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(currentUser.uid)
        .snapshots();

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
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'No se pudo cargar el perfil.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final userData = snapshot.data?.data() ?? <String, dynamic>{};

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
                        racha: _resolveRachaVisible(userData),
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
