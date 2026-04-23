import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BibliaSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final String asset;

  const BibliaSecondaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.asset = 'assets/images/biblia/btn_secundario_outline.png',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            asset,
            width: double.infinity,
            height: 50,
            fit: BoxFit.fill,
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: const Color(0xFFF4DFA3),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
