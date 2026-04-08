import 'package:flutter/material.dart';

import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/theme/app_spacing.dart';
import 'package:escoge/core/widgets/app_background.dart';

import 'package:escoge/features/perfil/widgets/profile_account_card.dart';
import 'package:escoge/features/perfil/widgets/profile_header.dart';
import 'package:escoge/features/perfil/widgets/profile_hero_card.dart';
import 'package:escoge/features/perfil/widgets/profile_reflection_card.dart';
import 'package:escoge/features/perfil/widgets/profile_stats_section.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        background: AppBackgrounds.perfil,
        overlayOpacity: 0.10,
        useSafeArea: false,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ProfileHeader(),
                SizedBox(height: AppSpacing.lg),
                ProfileHeroCard(
                  userName: 'Anderson Medina',
                  userEmail: 'anderson@email.com',
                  estadoEspiritual: 'Caminando con propósito ✨',
                ),
                SizedBox(height: AppSpacing.lg),
                ProfileStatsSection(),
                SizedBox(height: AppSpacing.lg),
                ProfileAccountCard(
                  userName: 'Anderson Medina',
                  userEmail: 'anderson@email.com',
                  estadoEspiritual: 'Caminando con propósito ✨',
                ),
                SizedBox(height: AppSpacing.lg),
                ProfileReflectionCard(),
                SizedBox(height: AppSpacing.xl + 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
