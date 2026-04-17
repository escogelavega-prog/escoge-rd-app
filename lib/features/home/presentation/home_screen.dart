import 'dart:ui';

import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/core/widgets/lumen_segmented_control.dart';
import 'package:escoge/features/oracion/data/models/liturgia_day_model.dart';
import 'package:escoge/features/oracion/data/models/lectura_model.dart';
import 'package:escoge/features/oracion/presentation/evangelio_screen.dart';
import 'package:escoge/features/oracion/presentation/lecturas_screen.dart';
import 'package:escoge/features/oracion/services/liturgia_service.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LiturgiaService _liturgiaService = LiturgiaService();

  LiturgiaDayModel? _data;
  bool _loading = true;
  String? _errorMessage;
  bool _showTomorrow = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadForDate(DateTime.now());
  }

  Future<void> _loadForDate(DateTime date) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _liturgiaService.getLiturgiaByDate(date);

      if (!mounted) return;

      setState(() {
        _selectedDate = date;
        _data = result;
        _loading = false;
        _errorMessage = result == null ? 'No hay liturgia disponible' : null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'Error al cargar la liturgia';
      });
    }
  }

  LecturaModel? _findLectura(String tipo) {
    try {
      return _data?.lecturas.firstWhere((item) => item.tipo == tipo);
    } catch (_) {
      return null;
    }
  }

  String _preview(String text) {
    final clean = text.replaceAll('\n', ' ').trim();
    return clean.length > 120 ? '${clean.substring(0, 120)}...' : clean;
  }

  @override
  Widget build(BuildContext context) {
    final evangelio = _data?.evangelio;
    final primera = _findLectura('primera_lectura');

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/home.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.8),
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
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Escoge RD',
                              style: GoogleFonts.poppins(
                                color: AppColors.lumenGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Camina cada día con la Palabra',
                              style: GoogleFonts.lora(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            LumenSegmentedControl(
                              selectedIndex: _showTomorrow ? 1 : 0,
                              items: const ['Hoy', 'Mañana'],
                              onChanged: (index) {
                                final date = index == 0
                                    ? DateTime.now()
                                    : DateTime.now()
                                        .add(const Duration(days: 1));

                                setState(() {
                                  _showTomorrow = index == 1;
                                });

                                _loadForDate(date);
                              },
                            ),
                            const SizedBox(height: 16),
                            GlassSpiritualCard(
                              radius: 30,
                              blur: 18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _data?.celebracion ?? 'Hoy en la Iglesia',
                                    style: GoogleFonts.lora(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    evangelio?.cita ?? '',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumenGold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        AppPageRoute(
                                          page: EvangelioScreen(
                                            selectedDate: _selectedDate,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Leer evangelio',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.lumenGoldBright,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (primera != null)
                              GlassSpiritualCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Primera Lectura',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.lumenGold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      primera.titulo,
                                      style: GoogleFonts.lora(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _preview(primera.texto),
                                      style: GoogleFonts.lora(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          AppPageRoute(
                                            page: LecturasScreen(
                                              selectedDate: _selectedDate,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Ver lecturas',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.lumenGoldBright,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
