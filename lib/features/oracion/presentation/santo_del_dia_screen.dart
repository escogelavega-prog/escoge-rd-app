import 'dart:ui';

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
  static const Color gold = Color(0xFFD4AF37);
  static const Color softGold = Color(0xFFE8C76A);
  static const Color deepBlue = Color(0xFF0B1E66);

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
    } catch (e) {
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
    if (resumen.isNotEmpty) return resumen;
    return 'No hay información disponible para este día.';
  }

  String _getHistoria() {
    final historia = _santo?.historia?.trim() ?? '';
    if (historia.isNotEmpty) return historia;
    return _getResumen();
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
      backgroundColor: Colors.transparent,
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
              color: deepBlue.withValues(alpha: 0.08),
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
            height: 205,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Colors.white.withValues(alpha: 0.07),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _MessageCard(
          icon: Icons.error_outline_rounded,
          title: 'No se pudo cargar el santo del día',
          message: _errorMessage ?? 'Ocurrió un error inesperado.',
          buttonLabel: 'Reintentar',
          onTap: _load,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _MessageCard(
          icon: Icons.auto_stories_rounded,
          title: 'No hay santo disponible',
          message: 'No se encontró contenido del santo del día.',
          buttonLabel: 'Volver',
          onTap: () => Navigator.pop(context),
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
                color: Colors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              loading ? 'Santo del día' : 'Santo del día',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lora(
                color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCard(imageUrl),
          const SizedBox(height: 18),
          _ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen',
                  style: GoogleFonts.poppins(
                    color: gold,
                    fontSize: 15.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _getResumen(),
                  style: GoogleFonts.lora(
                    color: Colors.white.withValues(alpha: 0.98),
                    fontSize: 19.2,
                    height: 1.82,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (frase.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Text(
                      '“$frase”',
                      style: GoogleFonts.lora(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 17.5,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 22),
                Text(
                  'Historia',
                  style: GoogleFonts.poppins(
                    color: gold,
                    fontSize: 15.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _getHistoria(),
                  style: GoogleFonts.lora(
                    color: Colors.white.withValues(alpha: 0.98),
                    fontSize: 19.2,
                    height: 1.82,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
        height: 205,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImageFallback(),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return _buildImageFallback();
                      },
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
                      deepBlue.withValues(alpha: 0.50),
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
                    color: Colors.white.withValues(alpha: 0.10),
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
                      color: Colors.white,
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
                        color: softGold.withValues(alpha: 0.94),
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
      color: Colors.white.withValues(alpha: 0.05),
      child: Center(
        child: Icon(
          Icons.auto_stories_rounded,
          color: softGold.withValues(alpha: 0.90),
          size: 52,
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
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _SantoDelDiaScreenState.softGold,
                size: 34,
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 17,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _SantoDelDiaScreenState.gold,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
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
