import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:escoge/app/navigation/main_shell.dart';
import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/presentation/complete_profile_screen.dart';
import 'package:escoge/features/entry/presentation/entry_choice_screen.dart';

class SessionGate extends StatelessWidget {
  const SessionGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const _SessionLoadingScreen();
        }

        final firebaseUser = authSnapshot.data;

        if (firebaseUser == null) {
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
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
