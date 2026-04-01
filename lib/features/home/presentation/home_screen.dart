import 'package:escoge/features/oracion/data/models/evangelio_model.dart';
import 'package:escoge/features/oracion/services/evangelio_service.dart';
import 'package:flutter/material.dart';
import 'package:escoge/core/theme/app_theme.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/core/widgets/app_button.dart';
import 'package:escoge/core/widgets/app_card.dart';
import 'package:escoge/core/widgets/app_header.dart';
import 'package:escoge/core/widgets/premium_menu_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenOracion;
  final VoidCallback onOpenRetiros;
  final VoidCallback onOpenContenido;
  final VoidCallback onOpenPerfil;

  const HomeScreen({
    super.key,
    required this.onOpenOracion,
    required this.onOpenRetiros,
    required this.onOpenContenido,
    required this.onOpenPerfil,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              AppHeader(
                title: 'Movimiento Escoge',
                subtitle: 'República Dominicana',
                rightWidget: GestureDetector(
                  onTap: onOpenPerfil,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),
                    child: const Text(
                      'Perfil',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 310,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/home_hero.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.20),
                            Colors.black.withOpacity(0.30),
                            Colors.black.withOpacity(0.58),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.16),
                              ),
                            ),
                            child: Text(
                              'Experiencia espiritual',
                              style: textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Hoy puedes comenzar un nuevo encuentro',
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Explora contenido espiritual, fortalece tu oración y prepárate para vivir la experiencia Escoge.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.92),
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: 'Contenido',
                                  onPressed: onOpenContenido,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: AppButton(
                                  text: 'Retiros',
                                  isPrimary: false,
                                  onPressed: onOpenRetiros,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<EvangelioModel?>(
                  future: EvangelioService().obtenerHoy(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Cargando evangelio del día...',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return AppCard(
                        color: AppColors.lightBlue.withOpacity(0.72),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hoy en la Iglesia',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Muy pronto verás aquí el evangelio del día y su contenido espiritual principal.',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final evangelio = snapshot.data!;

                    return _EvangelioPreviewCard(
                      evangelio: evangelio,
                      onTap: onOpenContenido,
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    PremiumMenuCard(
                      icon: Icons.auto_awesome_rounded,
                      title: 'Oración',
                      subtitle: 'Rosario, evangelio y encuentro espiritual',
                      onTap: onOpenOracion,
                    ),
                    const SizedBox(height: 14),
                    PremiumMenuCard(
                      icon: Icons.grid_view_rounded,
                      title: 'Contenido',
                      subtitle: 'Recursos y publicaciones del movimiento',
                      onTap: onOpenContenido,
                    ),
                    const SizedBox(height: 14),
                    PremiumMenuCard(
                      icon: Icons.terrain_rounded,
                      title: 'Retiros',
                      subtitle: 'Consulta e inscríbete en los retiros',
                      onTap: onOpenRetiros,
                    ),
                    const SizedBox(height: 14),
                    PremiumMenuCard(
                      icon: Icons.person_rounded,
                      title: 'Perfil',
                      subtitle: 'Administra tu información personal',
                      onTap: onOpenPerfil,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppCard(
                  color: Colors.white.withOpacity(0.94),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Un espacio para encontrarte con Dios',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Escoge RD reúne oración, evangelio y retiros en una experiencia espiritual clara, cercana y útil para tu día a día.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'Ir a oración',
                        onPressed: onOpenOracion,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EvangelioPreviewCard extends StatelessWidget {
  final EvangelioModel evangelio;
  final VoidCallback onTap;

  const _EvangelioPreviewCard({
    required this.evangelio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evangelio del día',
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          if (evangelio.titulo.trim().isNotEmpty)
            Text(
              evangelio.titulo,
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (evangelio.titulo.trim().isNotEmpty) const SizedBox(height: 6),
          Text(
            evangelio.cita,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            evangelio.contenido,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: onTap,
            child: const Text('Leer completo'),
          ),
        ],
      ),
    );
  }
}
