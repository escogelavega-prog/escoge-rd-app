import 'package:flutter/material.dart';
import 'package:escoge/features/onboarding/presentation/onboarding_flow_screen.dart';

class AppEntryGate extends StatefulWidget {
  const AppEntryGate({super.key});

  @override
  State<AppEntryGate> createState() => _AppEntryGateState();
}

class _AppEntryGateState extends State<AppEntryGate> {
  @override
  void initState() {
    super.initState();
    _resolveEntry();
  }

  Future<void> _resolveEntry() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingFlowScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0B1023),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
