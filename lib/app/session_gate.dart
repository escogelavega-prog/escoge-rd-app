import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/app/navigation/main_shell.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/presentation/complete_profile_screen.dart';
import 'package:escoge/features/entry/presentation/entry_choice_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  final AuthService _authService = AuthService();

  bool _bootChecking = true;
  bool _isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final seenEntry = prefs.getBool('seen_entry_choice') ?? false;

    if (!mounted) return;

    setState(() {
      _isFirstLaunch = !seenEntry;
      _bootChecking = false;
    });
  }

  Future<void> _markEntrySeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_entry_choice', true);
  }

  @override
  Widget build(BuildContext context) {
    if (_bootChecking) {
      return const _SessionLoadingScreen();
    }

    return StreamBuilder<User?>(
      stream: _authService.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const _SessionLoadingScreen();
        }

        final firebaseUser = authSnapshot.data;

        if (firebaseUser == null) {
          if (_isFirstLaunch) {
            _markEntrySeen();
          }
          return const EntryChoiceScreen();
        }

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('usuarios')
              .doc(firebaseUser.uid)
              .get(),
          builder: (context, userDocSnapshot) {
            if (userDocSnapshot.connectionState == ConnectionState.waiting) {
              return const _SessionLoadingScreen();
            }

            if (userDocSnapshot.hasError) {
              return const _SessionErrorScreen(
                message: 'No se pudo verificar tu sesión. Intenta nuevamente.',
              );
            }

            final userDoc = userDocSnapshot.data;
            final data = userDoc?.data();

            if (data == null) {
              return const CompleteProfileScreen();
            }

            final bool profileCompleted =
                (data['profileCompleted'] as bool?) ?? false;
            final bool isActive = (data['isActive'] as bool?) ?? true;

            if (!isActive) {
              return const _SessionErrorScreen(
                message:
                    'Tu cuenta está desactivada. Contacta al administrador.',
              );
            }

            if (!profileCompleted) {
              return const CompleteProfileScreen();
            }

            return const MainShell();
          },
        );
      },
    );
  }
}

class _SessionLoadingScreen extends StatelessWidget {
  const _SessionLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.darkBackground,
                    AppColors.darkBackgroundSoft,
                    AppColors.navShell,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.06),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lumenGold.withValues(alpha: 0.14),
                        blurRadius: 24,
                        spreadRadius: -10,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.lumenGold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Escoge RD',
                  style: GoogleFonts.lora(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Preparando tu experiencia espiritual',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withValues(alpha: 0.72),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
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

class _SessionErrorScreen extends StatelessWidget {
  final String message;

  const _SessionErrorScreen({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.lumenGold,
                  size: 36,
                ),
                const SizedBox(height: 14),
                Text(
                  'No pudimos iniciar la app',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withValues(alpha: 0.76),
                    fontSize: 14,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
