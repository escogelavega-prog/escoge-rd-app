import 'package:escoge/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'profile_stat_card.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: ProfileStatCard(
            icon: Icons.event_available_rounded,
            label: 'Retiros',
            value: '5',
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ProfileStatCard(
            icon: Icons.favorite_rounded,
            label: 'Oraciones',
            value: '120',
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ProfileStatCard(
            icon: Icons.calendar_today_rounded,
            label: 'Días',
            value: '30',
          ),
        ),
      ],
    );
  }
}
