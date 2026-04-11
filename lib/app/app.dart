import 'package:escoge/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:escoge/app/session_gate.dart';

class EscogeApp extends StatelessWidget {
  const EscogeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Escoge RD',

      // 🔥 ESTE ES EL CAMBIO CLAVE
      home: const SessionGate(),

      // Puedes mantener rutas para navegación interna
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
