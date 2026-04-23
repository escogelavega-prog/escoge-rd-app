import 'package:escoge/app/routes/app_routes.dart';
import 'package:escoge/app/session_gate.dart';
import 'package:escoge/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EscogeApp extends StatelessWidget {
  const EscogeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escoge RD',
      theme: AppTheme.light,
      darkTheme: AppTheme.spiritualDark,
      themeMode: ThemeMode.dark,
      home: const SessionGate(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
