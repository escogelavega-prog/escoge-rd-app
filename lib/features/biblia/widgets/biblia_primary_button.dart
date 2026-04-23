import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BibliaPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final String asset;

  const BibliaPrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.asset = 'assets/images/biblia/btn_primario_dorado.png',
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
            height: 54,
            fit: BoxFit.fill,
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: const Color(0xFF082447),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
