import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/data/models/santo_model.dart';
import 'package:escoge/features/oracion/services/santos_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SantoDelDiaScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const SantoDelDiaScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<SantoDelDiaScreen> createState() => _SantoDelDiaScreenState();
}

class _SantoDelDiaScreenState extends State<SantoDelDiaScreen> {
  final SantosService _santosService = SantosService();

  SantoModel? _santo;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final targetDate = widget.selectedDate ?? DateTime.now();
      final santo = await _santosService.getSantoByDate(targetDate);

      if (!mounted) return;

      setState(() {
        _santo = santo;
        _loading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudo cargar el santo del día.';
      });
    }
  }

  String _getNombre() {
    final nombre = _santo?.nombre.trim() ?? '';
    return nombre.isNotEmpty ? nombre : 'Santo del día';
  }

  String _getSubtitulo() {
    return _santo?.subtitulo.trim() ?? '';
  }

  String _getResumen() {
    final resumen = _santo?.resumen.trim() ?? '';
    return resumen.isNotEmpty
        ? resumen
        : 'No hay información disponible para este día.';
  }

  String _getHistoria() {
    final historia = _santo?.historia?.trim() ?? '';
    return historia.isNotEmpty ? historia : _getResumen();
  }

  String _getFrase() {
    return _santo?.frase?.trim() ?? '';
  }

  String? _getImagenUrl() {
    final url = _santo?.imagenUrl?.trim() ?? '';
    return url.isNotEmpty ? url : null;
  }

  bool get _hasSanto => _santo != null && _errorMessage == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/lecturas.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.28),
                    Colors.black.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.42),
                    Colors.black.withValues(alpha: 0.70),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
            ),
          ),
          SafeArea(
            child: _loading
                ? _buildLoadingState(context)
                : _errorMessage != null
                    ? _buildErrorState()
                    : !_hasSanto
                        ? _buildEmptyState()
                        : Column(
                            children: [
                              _buildHeader(context),
                              Expanded(
                                child: _buildContent(),
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      child: Column(
        children: [
          _buildHeader(context, loading: true),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: AppColors.white.withValues(alpha: 0.07),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return _buildMessageState(
      icon: Icons.error_outline_rounded,
      title: 'No se pudo cargar el santo del día',
      message: _errorMessage ?? 'Ocurrió un error inesperado.',
      buttonLabel: 'Reintentar',
      onTap: _load,
    );
  }

  Widget _buildEmptyState() {
    return _buildMessageState(
      icon: Icons.auto_stories_rounded,
      title: 'No hay santo disponible',
      message: 'No se encontró contenido del santo del día.',
      buttonLabel: 'Volver',
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildMessageState({
    required IconData icon,
    required String title,
    required String message,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _MessageCard(
          icon: icon,
          title: title,
          message: message,
          buttonLabel: buttonLabel,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {bool loading = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.08),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Santo del día',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lora(
                color: AppColors.white,
                fontSize: 24,
                height: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final frase = _getFrase();
    final imageUrl = _getImagenUrl();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 34),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeroCard(imageUrl),
          const SizedBox(height: 18),
          _ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel('Resumen'),
                const SizedBox(height: 16),
                _BodyText(_getResumen()),
                if (frase.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  _QuoteCard(frase: frase),
                ],
                const SizedBox(height: 22),
                Divider(
                  color: AppColors.white.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 22),
                _SectionLabel('Historia'),
                const SizedBox(height: 16),
                _BodyText(_getHistoria()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImageFallback(),
                    )
                  : _buildImageFallback(),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.30, 0.64, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.18),
                      AppColors.primaryBlue.withValues(alpha: 0.50),
                      Colors.black.withValues(alpha: 0.82),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.10),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getNombre(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                      color: AppColors.white,
                      fontSize: 27,
                      height: 1.14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_getSubtitulo().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _getSubtitulo(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: AppColors.goldSoft,
                        fontSize: 13.8,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: AppColors.white.withValues(alpha: 0.05),
      child: Center(
        child: Icon(
          Icons.auto_stories_rounded,
          color: AppColors.goldSoft,
          size: 52,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.gold,
        fontSize: 15.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;

  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lora(
        color: AppColors.white.withValues(alpha: 0.98),
        fontSize: 19.2,
        height: 1.82,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final String frase;

  const _QuoteCard({
    required this.frase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        '“$frase”',
        style: GoogleFonts.lora(
          color: AppColors.white.withValues(alpha: 0.95),
          fontSize: 17.5,
          height: 1.6,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final Widget child;

  const _ContentCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onTap;

  const _MessageCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.goldSoft,
            size: 34,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              color: AppColors.white.withValues(alpha: 0.88),
              fontSize: 17,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onTap,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
