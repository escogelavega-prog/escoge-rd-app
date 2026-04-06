import 'package:flutter/material.dart';

class AppBackgrounds {
  AppBackgrounds._();

  static const String home = 'assets/backgrounds/home.png';
  static const String liturgia = 'assets/backgrounds/lecturas.png';
  static const String formulario = 'assets/backgrounds/form.png';
  static const String perfil = 'assets/backgrounds/perfil.png';
  static const String login = 'assets/backgrounds/login.png';
}

class AppOverlay {
  AppOverlay._();

  static Color dark(double opacity) => Colors.black.withOpacity(opacity);

  static const double light = 0.08;
  static const double soft = 0.16;
  static const double medium = 0.24;
  static const double strong = 0.34;
}
