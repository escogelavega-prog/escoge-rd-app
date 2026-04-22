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
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.2,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.18),
                    Colors.black.withOpacity(0.38),
                    Colors.black.withOpacity(0.72),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/icons/icon_book.png',
                                    width: 54,
                                    height: 54,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Escoge RD',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumenGold,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      letterSpacing: 0.5,
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
                                      height: 1.15,
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
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    evangelio?.cita ?? '',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumenGold,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    evangelio?.titulo ?? 'Evangelio del día',
                                    style: GoogleFonts.lora(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
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
                                  ),
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
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      primera.titulo,
                                      style: GoogleFonts.lora(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _preview(primera.texto),
                                      style: GoogleFonts.lora(
                                        color: Colors.white70,
                                        height: 1.45,
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
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 24),
                            Text(
                              'Explorar',
                              style: GoogleFonts.poppins(
                                color: AppColors.lumenGold,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.15,
                              children: [
                                _buildQuickAccessItem(
                                  title: 'Catecismo',
                                  iconPath: 'assets/icons/icon_book.png',
                                  onTap: () => _showComingSoon('Catecismo'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Nuevo Testamento',
                                  iconPath: 'assets/icons/icon_evangelio.png',
                                  onTap: () =>
                                      _showComingSoon('Nuevo Testamento'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Santos del Día',
                                  iconPath: 'assets/icons/icon_santos_dia.png',
                                  onTap: () =>
                                      _showComingSoon('Santos del Día'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Oración',
                                  iconPath: 'assets/icons/icon_prayer.png',
                                  onTap: () => _showComingSoon('Oración'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Rosario',
                                  iconPath: 'assets/icons/icon_rosario.png',
                                  onTap: () => _showComingSoon('Rosario'),
                                ),
                                _buildQuickAccessItem(
                                  title: 'Reflexión',
                                  iconPath: 'assets/icons/icon_reflexion.png',
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
