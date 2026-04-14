import 'package:flutter/material.dart';
import 'package:escoge/core/theme/app_spacing.dart';
import 'profile_stat_card.dart';

class ProfileStatsSection extends StatelessWidget {
  final int retiros;
  final int oraciones;
  final int racha;

  const ProfileStatsSection({
    super.key,
    required this.retiros,
    required this.oraciones,
    required this.racha,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ProfileStatCard(
            icon: Icons.event_available_rounded,
            label: 'Retiros',
            value: retiros.toString(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ProfileStatCard(
            icon: Icons.favorite_rounded,
            label: 'Oraciones',
            value: oraciones.toString(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ProfileStatCard(
            icon: Icons.local_fire_department_rounded,
            label: 'Racha',
            value: racha.toString(),
          ),
        ),
      ],
    );
  }
}
