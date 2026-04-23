import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BibliaSectionTitle extends StatelessWidget {
  final String title;
  final String separatorAsset;

  const BibliaSectionTitle({
    super.key,
    required this.title,
    this.separatorAsset = 'assets/images/biblia/separador_seccion.png',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          separatorAsset,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.cormorantGaramond(
            color: const Color(0xFFF4DFA3),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Image.asset(
          separatorAsset,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
