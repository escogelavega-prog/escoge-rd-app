import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_background.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPreferencesScreen extends StatefulWidget {
  const OnboardingPreferencesScreen({super.key});

  @override
  State<OnboardingPreferencesScreen> createState() =>
      _OnboardingPreferencesScreenState();
}

class _OnboardingPreferencesScreenState
    extends State<OnboardingPreferencesScreen> {
  String _selectedLanguage = 'Español';
  String _selectedDiocesis = 'La Vega';

  static const List<String> _languages = [
    'Español',
    'English',
  ];

  static const List<String> _diocesis = [
    'La Vega',
    'Santo Domingo',
    'Santiago de los Caballeros',
    'Baní',
    'Barahona',
    'San Francisco de Macorís',
    'Mao-Monte Cristi',
    'San Juan de la Maguana',
    'Nuestra Señora de la Altagracia',
    'Puerto Plata',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: OnboardingBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 150),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: OnboardingCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lumenGold.withValues(alpha: 0.14),
                          border: Border.all(
                            color: AppColors.lumenGold.withValues(alpha: 0.24),
                          ),
                        ),
                        child: const Icon(
                          Icons.church_rounded,
                          color: AppColors.lumenGold,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Personaliza tu\nexperiencia',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Selecciona tu idioma y diócesis para mostrar contenido pastoral más cercano a tu realidad.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.lumenTextSecondary,
                          fontSize: 14,
                          height: 1.55,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _selectorCard(
                        title: 'Idioma',
                        value: _selectedLanguage,
                        icon: Icons.translate_rounded,
                        items: _languages,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _selectedLanguage = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      _selectorCard(
                        title: 'Diócesis',
                        value: _selectedDiocesis,
                        icon: Icons.location_city_rounded,
                        items: _diocesis,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _selectedDiocesis = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectorCard({
    required String title,
    required String value,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final safeValue = items.contains(value) ? value : items.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lumenCard.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: safeValue,
          isExpanded: true,
          dropdownColor: const Color(0xFF11101B),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
            labelStyle: GoogleFonts.poppins(
              color: AppColors.lumenTextSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.lumenGold,
              size: 22,
            ),
          ),
          iconEnabledColor: AppColors.lumenGold,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 14.2,
            fontWeight: FontWeight.w600,
          ),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 14.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList();
          },
          items: items.toSet().map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
