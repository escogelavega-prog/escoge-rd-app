import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryBlue,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: _lightTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      inputDecorationTheme: _lightInputTheme(),
      elevatedButtonTheme: _lightElevatedButtons(),
      outlinedButtonTheme: _lightOutlinedButtons(),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: GoogleFonts.poppins(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  static ThemeData get spiritualDark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.lumenGold,
      splashFactory: InkRipple.splashFactory,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lumenGold,
        secondary: AppColors.lumenGoldBright,
        surface: AppColors.darkSurface,
        error: AppColors.error,
      ),
      textTheme: _darkTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.lumenTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.lora(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: AppColors.lumenTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lumenTextPrimary,
          size: 22,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lumenCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: const BorderSide(
            color: AppColors.lumenCardStroke,
            width: 1,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.lumenGold,
      ),
      inputDecorationTheme: _darkInputTheme(),
      elevatedButtonTheme: _darkElevatedButtons(),
      outlinedButtonTheme: _darkOutlinedButtons(),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lumenGoldBright,
          textStyle: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCardStrong,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: GoogleFonts.poppins(
          color: AppColors.lumenTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: AppColors.lumenCardStroke,
          ),
        ),
      ),
    );
  }

  static TextTheme _lightTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.lora(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.lora(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.7,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
        height: 1.65,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
      ),
    );
  }

  static TextTheme _darkTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.lora(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: AppColors.lumenTextPrimary,
      ),
      displayMedium: GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.lumenTextPrimary,
      ),
      displaySmall: GoogleFonts.lora(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.lumenTextPrimary,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.lumenTextPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: AppColors.lumenTextPrimary,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: AppColors.lumenTextPrimary,
      ),
      titleLarge: GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.lumenTextPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.lumenTextPrimary,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.lumenTextSecondary,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.8,
        color: AppColors.lumenTextSecondary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        height: 1.7,
        color: AppColors.lumenTextSecondary,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.55,
        color: AppColors.lumenTextMuted,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: AppColors.lumenGoldBright,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.lumenTextMuted,
      ),
    );
  }

  static InputDecorationTheme _lightInputTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(
          color: AppColors.primaryBlue,
          width: 1.4,
        ),
      ),
    );
  }

  static InputDecorationTheme _darkInputTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
        color: AppColors.lumenTextMuted,
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: AppColors.lumenTextSecondary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.darkBorderSoft),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.darkBorderSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.lumenGold,
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.3,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _lightElevatedButtons() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _darkElevatedButtons() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.lumenGold,
        foregroundColor: AppColors.black,
        minimumSize: const Size(double.infinity, 54),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _lightOutlinedButtons() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _darkOutlinedButtons() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lumenTextPrimary,
        minimumSize: const Size(double.infinity, 54),
        side: const BorderSide(
          color: AppColors.lumenCardStroke,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
