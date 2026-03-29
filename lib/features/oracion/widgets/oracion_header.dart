import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OracionHeader extends StatelessWidget {
  const OracionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton = true,
    this.horizontalPadding = 20,
    this.onBackTap,
  });

  final String title;
  final String subtitle;
  final bool showBackButton;
  final double horizontalPadding;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (showBackButton)
                _BackButtonCard(
                  onTap: () {
                    if (onBackTap != null) {
                      onBackTap!();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                )
              else
                const SizedBox(width: 58),
              const Spacer(),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'ESCOGE',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 160,
            height: 3,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 26),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButtonCard extends StatelessWidget {
  const _BackButtonCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
