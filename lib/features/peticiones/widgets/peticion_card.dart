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

  static const Color _primaryBlue = Color(0xFF0B1E66);
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _primaryBlue.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _gold.withValues(alpha: 0.42),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: peticion.esAnonima
                      ? Colors.white.withValues(alpha: 0.18)
                      : Colors.white.withValues(alpha: 0.14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(
                  peticion.esAnonima
                      ? Icons.visibility_off_rounded
                      : Icons.person_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreVisible,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PeticionCategoryChip(
                      categoria: peticion.categoria,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            peticion.texto,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.94),
              fontSize: 14.3,
              fontWeight: FontWeight.w500,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _buildFechaLabel(),
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 12.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: yaUnido
                  ? _gold.withValues(alpha: 0.92)
                  : Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _gold.withValues(alpha: 0.38),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  yaUnido
                      ? Icons.favorite_rounded
                      : Icons.volunteer_activism_rounded,
                  color: _primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: yaUnido ? null : onUnirse,
                    child: Text(
                      yaUnido ? 'Unido en oración' : 'Me uno a tu oración',
                      style: GoogleFonts.poppins(
                        color: _primaryBlue,
                        fontSize: 14.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${peticion.unidosCount} personas unidas',
                  style: GoogleFonts.poppins(
                    color: _primaryBlue,
                    fontSize: 12.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
