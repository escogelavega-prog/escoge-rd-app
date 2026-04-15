import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/features/peticiones/data/models/peticion_model.dart';
import 'package:escoge/features/peticiones/widgets/peticion_category_chip.dart';

class PeticionCard extends StatelessWidget {
  const PeticionCard({
    super.key,
    required this.peticion,
    required this.yaUnido,
    required this.onUnirse,
  });

  final PeticionModel peticion;
  final bool yaUnido;
  final VoidCallback onUnirse;

  static const Color _gold = Color(0xFFD4AF37);

  String _buildFechaLabel() {
    final createdAt = peticion.createdAt;
    if (createdAt == null) return 'Hace un momento';

    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Hace un momento';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';

    return '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final nombreVisible =
        peticion.esAnonima ? 'Petición anónima' : peticion.nombreVisible;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.36),
                    width: 1,
                  ),
                ),
                child: Icon(
                  peticion.esAnonima
                      ? Icons.visibility_off_rounded
                      : Icons.person_rounded,
                  color: Colors.white.withValues(alpha: 0.90),
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreVisible,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.8,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    PeticionCategoryChip(
                      categoria: peticion.categoria,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                color: Colors.white.withValues(alpha: 0.46),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            peticion.texto,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.94),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              height: 1.48,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${_buildFechaLabel()} • ${peticion.unidosCount} personas unidas',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.56),
              fontSize: 12.1,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: yaUnido ? null : onUnirse,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: yaUnido ? 0.10 : 0.08),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.white.withValues(alpha: yaUnido ? 0.15 : 0.11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    yaUnido
                        ? Icons.check_circle_rounded
                        : Icons.volunteer_activism_rounded,
                    color: yaUnido ? Colors.white : _gold,
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      yaUnido ? 'Unido en oración' : 'Me uno a tu oración',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13.2,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
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
