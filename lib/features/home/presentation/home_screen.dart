import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/constants/app_icons.dart';
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

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10255C),
        content: Text(
          '$title estará disponible pronto.',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
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
              'assets/backgrounds/bg_primary.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
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
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔥 HEADER
                            Center(
                              child: Column(
                                children: [
                                  Image.asset(AppIcons.biblia, width: 54),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Escoge RD',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumenGold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Camina cada día con la Palabra',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lora(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            LumenSegmentedControl(
                              selectedIndex: _showTomorrow ? 1 : 0,
                              items: const ['Hoy', 'Mañana'],
                              onChanged: (index) {
                                final date = index == 0
                                    ? DateTime.now()
                                    : DateTime.now().add(
                                        const Duration(days: 1),
                                      );

                                setState(() {
                                  _showTomorrow = index == 1;
                                });

                                _loadForDate(date);
                              },
                            ),

                            const SizedBox(height: 18),

                            // 🔥 EVANGELIO
                            GlassSpiritualCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _data?.celebracion ?? '',
                                    style: GoogleFonts.lora(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    evangelio?.cita ?? '',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumenGold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 🔥 ACCESOS RÁPIDOS
                            Text(
                              'Explorar',
                              style: GoogleFonts.poppins(
                                color: AppColors.lumenGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 12),

                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: [
                                _buildQuickAccessItem(
                                  title: 'Biblia',
                                  iconPath: AppIcons.biblia,
                                  onTap: () => _showComingSoon('Biblia'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Catecismo',
                                  iconPath: AppIcons.catecismo,
                                  onTap: () => _showComingSoon('Catecismo'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Santos del Día',
                                  iconPath: AppIcons.santoDelDia,
                                  onTap: () =>
                                      _showComingSoon('Santos del Día'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Rosario',
                                  iconPath: AppIcons.santoRosario,
                                  onTap: () => _showComingSoon('Rosario'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Reflexión',
                                  iconPath: AppIcons.reflexiones,
                                  onTap: () => _showComingSoon('Reflexión'),
                                ),
                              ],
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
