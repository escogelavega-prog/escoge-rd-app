import 'package:escoge/app/navigation/main_shell.dart';
import 'package:escoge/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:escoge/features/admin/presentation/diocesano_dashboard_screen.dart';
import 'package:escoge/features/admin/presentation/nacional_dashboard_screen.dart';
import 'package:escoge/features/auth/data/repositories/auth_repository.dart';
import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/auth/presentation/unauthorized_screen.dart';
import 'package:flutter/material.dart';

class SplashAuthGate extends StatefulWidget {
  const SplashAuthGate({super.key});

  @override
  State<SplashAuthGate> createState() => _SplashAuthGateState();
}

class _SplashAuthGateState extends State<SplashAuthGate> {
  final AuthRepository _repository = AuthRepository(AuthService());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolve();
    });
  }

  Future<void> _resolve() async {
    try {
      final firebaseUser = AuthService().currentFirebaseUser;

      debugPrint('firebaseUser: ${firebaseUser?.uid}');

      if (firebaseUser == null) {
        _go(const LoginScreen());
        return;
      }

      final appUser = await _repository.getCurrentAppUser();

      debugPrint(
        'appUser: ${appUser?.email} | role: ${appUser?.role} | active: ${appUser?.isActive}',
      );

      if (!mounted) return;

      if (appUser == null || !appUser.isActive) {
        _go(const UnauthorizedScreen());
        return;
      }

      switch (appUser.role) {
        case 'superadmin':
          _go(const AdminDashboardScreen());
          break;

        case 'nacional':
          _go(const NacionalDashboardScreen());
          break;

        case 'diocesano':
          _go(
            DiocesanoDashboardScreen(
              diocesisId: appUser.diocesisId,
            ),
          );
          break;

        case 'joven':
        default:
          _go(const MainShell());
          break;
      }
    } catch (e, stack) {
      debugPrint('Error en SplashAuthGate: $e');
      debugPrintStack(stackTrace: stack);

      if (!mounted) return;

      _go(const LoginScreen());
    }
  }

  void _go(Widget screen) {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
