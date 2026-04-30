import 'package:escoge/app/session_gate.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_features_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_intro_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_notifications_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_preferences_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_action_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  static const String onboardingKey = 'has_seen_onboarding_2026';

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;
  bool _isFinishing = false;

  final List<Widget> _pages = const [
    OnboardingIntroScreen(),
    OnboardingFeaturesScreen(),
    OnboardingPreferencesScreen(),
    OnboardingNotificationsScreen(),
  ];

  bool get _isLastPage => _currentIndex == _pages.length - 1;

  Future<void> _nextPage() async {
    if (_isFinishing) return;

    if (_isLastPage) {
      await _finishOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _skipOnboarding() async {
    if (_isFinishing) return;
    await _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isFinishing = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(OnboardingFlowScreen.onboardingKey, true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SessionGate()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lumenBackground,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _pages,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 90),
                      if (!_isLastPage)
                        TextButton(
                          onPressed: _isFinishing ? null : _skipOnboarding,
                          child: Text(
                            'Saltar',
                            style: GoogleFonts.poppins(
                              color: AppColors.white.withValues(alpha: 0.72),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 70),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) {
                        final selected = _currentIndex == index;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: selected ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.lumenGold
                                : AppColors.white.withValues(alpha: 0.24),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  OnboardingActionButton(
                    text: _isFinishing
                        ? 'Preparando...'
                        : _isLastPage
                            ? 'Continuar'
                            : 'Siguiente',
                    onTap: _isFinishing ? null : _nextPage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
