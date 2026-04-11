import 'package:flutter/material.dart';

import 'package:escoge/core/theme/app_spacing.dart';
import 'profile_stat_card.dart';

class ProfileStatsSection extends StatelessWidget {
  final int retiros;
  final int oraciones;
  final int dias;

  const ProfileStatsSection({
    super.key,
    required this.retiros,
    required this.oraciones,
    required this.dias,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            icon: Icons.calendar_today_rounded,
            label: 'Días',
            value: dias.toString(),
          ),
        ),
      ],
    );
  }
}
