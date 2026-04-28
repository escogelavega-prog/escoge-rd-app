import 'package:escoge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingView extends StatelessWidget {
  final String message;
  final String? subtitle;
  final double size;
  final bool showCard;

  const LoadingView({
    super.key,
    this.message = 'Cargando...',
    this.subtitle,
    this.size = 34,
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AppColors.lumenGold,
            backgroundColor: AppColors.white.withValues(alpha: 0.08),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.lora(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.lumenTextPrimary,
            height: 1.2,
          ),
        ),
        if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.lumenTextSecondary,
              height: 1.45,
            ),
          ),
        ],
      ],
    );

    if (!showCard) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: content,
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 26,
          ),
          decoration: BoxDecoration(
            gradient: AppColors.cardGlassGradient,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.glassStroke,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 28,
                spreadRadius: -8,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppColors.lumenGold.withValues(alpha: 0.08),
                blurRadius: 24,
                spreadRadius: -12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.cardGlassGradient,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.glassStroke,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lumenGold.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.glassStrokeGold,
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.lumenGoldSoft,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lumenTextPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lumenTextSecondary,
                  height: 1.55,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorStateView extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onRetry;
  final IconData icon;

  const ErrorStateView({
    super.key,
    this.title = 'No se pudo cargar',
    required this.message,
    this.actionLabel = 'Reintentar',
    required this.onRetry,
    this.icon = Icons.warning_amber_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onRetry,
    );
  }
}
