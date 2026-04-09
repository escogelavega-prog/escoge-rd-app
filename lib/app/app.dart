import 'package:escoge/app/routes/app_routes.dart';
import 'package:escoge/app/routes/route_names.dart';
import 'package:flutter/material.dart';

class EscogeApp extends StatelessWidget {
  const EscogeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escoge RD',
      theme: AppTheme.theme,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData();
  static ThemeData get darkTheme => ThemeData();

  static ThemeData? get theme => null;
}
