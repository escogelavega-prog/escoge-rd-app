import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/onboarding/widgets/onboarding_page_scaffold.dart';

class OnboardingNotificationsScreen extends StatelessWidget {
  const OnboardingNotificationsScreen({super.key});

  Widget _item(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFD4AF37),
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageScaffold(
      onLoginTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFFD4AF37),
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mantente al día',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Recibe recordatorios suaves para tus rutinas de oración y eventos importantes.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          _item(Icons.schedule_rounded, 'Recordatorios de oración'),
          _item(Icons.wb_sunny_rounded, 'Oración de mañana y noche'),
          _item(Icons.calendar_month_rounded, 'Fechas litúrgicas importantes'),
          _item(Icons.tune_rounded, 'Tú decides qué recibir'),
        ],
      ),
    );
  }
}
