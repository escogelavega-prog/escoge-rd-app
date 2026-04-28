import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================
  // IDENTIDAD ESCOGE RD
  // =========================
  static const Color primaryBlue = Color(0xFF0B1E66);
  static const Color secondaryBlue = Color(0xFF1736A2);
  static const Color accentBlue = Color(0xFF1A3DAB);

  static const Color gold = Color(0xFFD4AF37);
  static const Color goldSoft = Color(0xFFF1C76B);

  // =========================
  // LIGHT SYSTEM
  // =========================
  static const Color background = Color(0xFFF3F6FD);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  static const Color surfaceSoft = Color(0xFFF8FAFF);

  static const Color textPrimary = Color(0xFF1B2559);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textMuted = Color(0xFF98A2B3);

  static const Color border = Color(0xFFE2E8F5);
  static const Color borderSoft = Color(0xFFE9EEF8);
  static const Color divider = Color(0xFFE9EEF8);

  // =========================
  // LUMEN / SACRO DARK BASE
  // =========================
  static const Color darkBackground = Color(0xFF09080F);
  static const Color darkBackgroundSoft = Color(0xFF100F18);
  static const Color darkSurface = Color(0xFF151420);
  static const Color darkSurfaceSoft = Color(0xFF1B1928);
  static const Color darkCard = Color(0xFF191824);
  static const Color darkCardStrong = Color(0xFF211F31);

  static const Color darkTextPrimary = Color(0xFFF8F5FA);
  static const Color darkTextSecondary = Color(0xFFD4CEDD);
  static const Color darkTextMuted = Color(0xFF9D96AB);

  static const Color darkBorder = Color(0xFF312E42);
  static const Color darkBorderSoft = Color(0xFF262333);
  static const Color darkDivider = Color(0xFF262333);

  // =========================
  // NAVIGATION LUMEN
  // =========================
  static const Color navShell = Color(0xFF07060C);
  static const Color navBackground = Color(0xE6171621);
  static const Color navBackgroundActive = Color(0x33211F31);
  static const Color navBorder = Color(0x3DF1DE9E);

  // =========================
  // OVERLAYS
  // =========================
  static const Color overlayStrong = Color(0xCC000000);
  static const Color overlayMedium = Color(0x80000000);
  static const Color overlaySoft = Color(0x33000000);

  // =========================
  // PALETA LUMEN PREMIUM
  // =========================
  static const Color lumenBackground = Color(0xFF100F18);
  static const Color lumenBackgroundTop = Color(0xFF171423);
  static const Color lumenBackgroundBottom = Color(0xFF07060C);

  static const Color lumenCard = Color(0xFF191824);
  static const Color lumenCardElevated = Color(0xFF211F31);
  static const Color lumenCardDeep = Color(0xFF12111B);
  static const Color lumenCardStroke = Color(0x26FFFFFF);

  static const Color lumenGold = Color(0xFFC8A732);
  static const Color lumenGoldBright = Color(0xFFE3C75F);
  static const Color lumenGoldSoft = Color(0xFFF1DE9E);
  static const Color lumenGoldDeep = Color(0xFF9E8122);

  static const Color lumenTextPrimary = Color(0xFFF8F5FA);
  static const Color lumenTextSecondary = Color(0xFFD5CEDF);
  static const Color lumenTextMuted = Color(0xFF9B95A6);

  static const Color lumenPurpleGlow = Color(0xFF2B2543);
  static const Color lumenBlueGlow = Color(0xFF182743);
  static const Color lumenWineGlow = Color(0xFF3A1E2A);

  // =========================
  // GLASS / HIGHLIGHT
  // =========================
  static const Color glassFill = Color(0x14FFFFFF);
  static const Color glassFillStrong = Color(0x1FFFFFFF);
  static const Color glassStroke = Color(0x2AFFFFFF);
  static const Color glassStrokeGold = Color(0x3DF1DE9E);
  static const Color glassHighlight = Color(0x22F1DE9E);

  // =========================
  // STATUS
  // =========================
  static const Color success = Color(0xFF12B76A);
  static const Color warning = Color(0xFFF79009);
  static const Color error = Color(0xFFD92D20);
  static const Color info = Color(0xFF2E90FA);

  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // =========================
  // GRADIENTES REUTILIZABLES
  // =========================
  static const LinearGradient screenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      lumenBackgroundTop,
      lumenBackground,
      lumenBackgroundBottom,
    ],
  );

  static const LinearGradient sacredGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x33C8A732),
      Color(0x14182743),
      Color(0x12FFFFFF),
    ],
  );

  static const LinearGradient cardGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1FFFFFFF),
      Color(0x0AFFFFFF),
      Color(0x14C8A732),
    ],
  );

  static const LinearGradient bottomFadeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00000000),
      Color(0x9907060C),
      Color(0xE607060C),
    ],
  );
}