import 'package:escoge/app/navigation/main_shell.dart';
import 'package:escoge/app/routes/route_names.dart';
import 'package:escoge/features/auth/presentation/forgot_password_screen.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/auth/presentation/register_screen.dart';
import 'package:escoge/features/entry/presentation/entry_choice_screen.dart';
import 'package:escoge/features/entry/presentation/public_home_screen.dart';
import 'package:escoge/features/lauch/presentation/splash_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_flow_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingFlowScreen());

      case RouteNames.entryChoice:
        return MaterialPageRoute(builder: (_) => const EntryChoiceScreen());

      case RouteNames.publicHome:
        return MaterialPageRoute(builder: (_) => const PublicHomeScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RouteNames.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );

      case RouteNames.mainShell:
        return MaterialPageRoute(builder: (_) => const MainShell());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
