import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_background.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_card.dart';

class OnboardingPreferencesScreen extends StatefulWidget {
  const OnboardingPreferencesScreen({super.key});

  @override
  State<OnboardingPreferencesScreen> createState() =>
      _OnboardingPreferencesScreenState();
}

class _OnboardingPreferencesScreenState
    extends State<OnboardingPreferencesScreen> {
  String _selectedLanguage = 'Español';
  String _selectedRegion = 'República Dominicana';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OnboardingCard(
                child: Column(
                  children: [
                    const Icon(
                      Icons.language_rounded,
                      color: Color(0xFFD4AF37),
                      size: 42,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Personaliza tu experiencia',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Configura tu idioma y tu región para mostrar el contenido adecuado.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _selectorCard(
                      title: 'Idioma',
                      value: _selectedLanguage,
                      items: const ['Español', 'English'],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedLanguage = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _selectorCard(
                      title: 'Región',
                      value: _selectedRegion,
                      items: const [
                        'República Dominicana',
                        'España',
                        'México',
                        'Estados Unidos',
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedRegion = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectorCard({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        dropdownColor: const Color(0xFF11182F),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: title,
          labelStyle: GoogleFonts.poppins(color: Colors.white70),
        ),
        iconEnabledColor: const Color(0xFFD4AF37),
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
