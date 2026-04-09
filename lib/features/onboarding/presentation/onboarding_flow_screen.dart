import 'package:flutter/material.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_features_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_intro_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_notifications_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_preferences_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_action_button.dart';
import 'package:escoge/features/entry/presentation/entry_choice_screen.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    OnboardingIntroScreen(),
    OnboardingFeaturesScreen(),
    OnboardingPreferencesScreen(),
    OnboardingNotificationsScreen(),
  ];

  bool get _isLastPage => _currentIndex == _pages.length - 1;

  void _nextPage() {
    if (_isLastPage) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const EntryChoiceScreen()),
      );
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _goToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _pages,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _goToLogin,
                      child: const Text(
                        'Ya tengo cuenta',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? const Color(0xFFD4AF37)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  OnboardingActionButton(
                    text: _isLastPage ? 'Continuar' : 'Siguiente',
                    onTap: _nextPage,
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
