import 'dart:ui';

import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/oracion/data/models/evangelio_model.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvangelioScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const EvangelioScreen({
    super.key,
    this.selectedDate,
  });

  @override
  State<EvangelioScreen> createState() => _EvangelioScreenState();
}

class _EvangelioScreenState extends State<EvangelioScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _liturgiaDay;
  EvangelioModel? _evangelio;
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
      final liturgia = await _liturgiaService.getLiturgiaByDate(targetDate);

      if (!mounted) return;

      setState(() {
        _liturgiaDay = liturgia;
        _evangelio = liturgia?.evangelio;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'No se pudo cargar el evangelio.';
      });
    }
  }

  String _texto() {
    final t = _evangelio?.texto.trim() ?? '';
    return t.isNotEmpty ? t : 'No hay evangelio disponible para este día.';
  }

  String _cita() {
    final c = _evangelio?.cita.trim() ?? '';
    return c.isNotEmpty ? c : '';
  }

  String _titulo() {
    final t = _liturgiaDay?.celebracion.trim() ?? '';
    return t.isNotEmpty ? t : 'Evangelio del día';
  }

  String _tiempo() {
    final t = _liturgiaDay?.tiempoLiturgico.trim() ?? '';
    return t.isNotEmpty ? t : 'Liturgia diaria';
  }

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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.lumenGold,
                    ),
                  )
                : _errorMessage != null
                    ? _error()
                    : _content(context),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _topBar(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _hero(),
                const SizedBox(height: 18),
                GlassSpiritualCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _texto(),
                        style: GoogleFonts.lora(
                          color: AppColors.white,
                          fontSize: 19,
                          height: 1.85,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Palabra del Señor',
                        style: GoogleFonts.poppins(
                          color: AppColors.lumenGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
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
              _titulo(),
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _hero() {
    return GlassSpiritualCard(
      radius: 30,
      blur: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tiempo(),
            style: GoogleFonts.poppins(
              color: AppColors.lumenGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (_cita().isNotEmpty)
            Text(
              _cita(),
              style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  Widget _error() {
    return Center(
      child: GlassSpiritualCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.lumenGold,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _load,
              child: const Text('Reintentar'),
            )
          ],
        ),
      ),
    );
  }
}
