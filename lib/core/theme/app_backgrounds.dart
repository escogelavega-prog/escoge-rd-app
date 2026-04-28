import 'package:flutter/material.dart';

class AppBackgrounds {
  AppBackgrounds._();

  // =========================
  // FONDO ESPIRITUAL OFICIAL
  // =========================
  static const String uniform = 'assets/backgrounds/fondo_uniforme.png';

  // =========================
  // FONDOS POR MÓDULO
  // =========================
  static const String home = 'assets/backgrounds/home.png';
  static const String liturgia = 'assets/backgrounds/lecturas.png';
  static const String formulario = 'assets/backgrounds/form.png';
  static const String perfil = 'assets/backgrounds/perfil.png';
  static const String login = 'assets/backgrounds/login.png';

  // =========================
  // ALIAS PRODUCTIVOS
  // Mantienen compatibilidad y permiten estandarizar visualmente.
  // =========================
  static const String oracion = uniform;
  static const String evangelio = liturgia;
  static const String lecturas = liturgia;
  static const String santo = liturgia;
  static const String rosario = uniform;
  static const String contenido = uniform;
  static const String biblia = uniform;
  static const String retiros = formulario;
  static const String peticiones = uniform;
  static const String onboarding = uniform;
  static const String admin = uniform;
}

class AppOverlay {
  AppOverlay._();

  // =========================
  // HELPERS
  // =========================
  static Color dark(double opacity) => Colors.black.withValues(alpha: opacity);
  static Color lightOverlay(double opacity) =>
      Colors.white.withValues(alpha: opacity);
  static Color gold(double opacity) =>
      const Color(0xFFD4AF37).withValues(alpha: opacity);

  // =========================
  // NIVELES BASE
  // =========================
  static const double light = 0.08;
  static const double soft = 0.16;
  static const double medium = 0.24;
  static const double strong = 0.34;
  static const double extraStrong = 0.52;

  // =========================
  // NIVELES LUMEN / SACRO
  // =========================
  static const double lumenImage = 0.38;
  static const double lumenTop = 0.58;
  static const double lumenBottom = 0.76;
  static const double lumenCard = 0.10;
  static const double lumenGlow = 0.18;
}
