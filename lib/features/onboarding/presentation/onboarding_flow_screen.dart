import 'package:flutter/material.dart';
import 'package:escoge/features/entry/presentation/entry_choice_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_features_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_intro_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_notifications_screen.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_preferences_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_action_button.dart';

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? const Color(0xFFD4AF37)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
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