import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvangelioActionRow extends StatelessWidget {
  const EvangelioActionRow({super.key, this.onReminderTap, this.onLecturasTap});

  final VoidCallback? onReminderTap;
  final VoidCallback? onLecturasTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _EvangelioActionButton(
            icon: Icons.notifications_active_outlined,
            label: 'Activar recordatorio',
            onTap: onReminderTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _EvangelioActionButton(
            icon: Icons.menu_book_rounded,
            label: 'Lecturas del día',
            onTap: onLecturasTap,
          ),
        ),
      ],
    );
  }
}

class _EvangelioActionButton extends StatelessWidget {
  const _EvangelioActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  static const Color gold = Color(0xFFD4AF37);
  static const Color primaryBlue = Color(0xFF0B1E66);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Material(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8D7A7)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: gold, size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
