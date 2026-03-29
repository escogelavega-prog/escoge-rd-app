import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/theme/app_spacing.dart';
import 'package:escoge/features/perfil/widgets/profile_account_card.dart';
import 'package:escoge/features/perfil/widgets/profile_header.dart';
import 'package:escoge/features/perfil/widgets/profile_hero_card.dart';
import 'package:escoge/features/perfil/widgets/profile_reflection_card.dart';
import 'package:escoge/features/perfil/widgets/profile_stats_section.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }
}
