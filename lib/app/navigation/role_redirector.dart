import 'package:escoge/app/navigation/main_shell.dart';
import 'package:escoge/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:escoge/features/admin/presentation/diocesano_dashboard_screen.dart';
import 'package:escoge/features/admin/presentation/nacional_dashboard_screen.dart';
import 'package:flutter/material.dart';

class RoleRedirector {
  static Widget resolve(String? role) {
    switch (role) {
      case 'superadmin':
        return const AdminDashboardScreen();

      case 'nacional':
        return const NacionalDashboardScreen();

      case 'diocesano':
        return DiocesanoDashboardScreen(
          diocesisId: 'default', // 👈 temporal
        );

      default:
        return const MainShell();
    }
  }
}
