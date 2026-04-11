import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:escoge/features/auth/domain/app_roles.dart';

class RoleGuard extends StatelessWidget {
  final List<String>? allowedRoles;
  final String? minRole;
  final Widget child;
  final Widget? fallback;
  final bool showLoader;

  const RoleGuard({
    super.key,
    this.allowedRoles,
    this.minRole,
    required this.child,
    this.fallback,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    /// 🔒 Si no hay sesión
    if (user == null) {
      return fallback ?? const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        /// ⏳ Loading
        if (!snapshot.hasData) {
          return showLoader
              ? const Center(child: CircularProgressIndicator())
              : (fallback ?? const SizedBox.shrink());
        }

        final data = snapshot.data?.data();
        final userRole = (data?['role'] ?? '').toString();

        /// 🚫 Rol inválido
        if (!AppRoles.isValid(userRole)) {
          return fallback ?? const SizedBox.shrink();
        }

        /// ✅ CASO 1: Lista específica de roles permitidos
        if (allowedRoles != null && allowedRoles!.isNotEmpty) {
          if (allowedRoles!.contains(userRole)) {
            return child;
          }
          return fallback ?? const SizedBox.shrink();
        }

        /// ✅ CASO 2: Jerarquía mínima requerida
        if (minRole != null) {
          final hasAccess = AppRoles.hasAccess(
            userRole: userRole,
            requiredRole: minRole!,
          );

          if (hasAccess) {
            return child;
          }

          return fallback ?? const SizedBox.shrink();
        }

        /// ⚠️ Si no se define regla → no mostrar
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}
