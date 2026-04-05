import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/features/oracion/services/lecturas_service.dart';

class LecturasScreen extends StatefulWidget {
  const LecturasScreen({super.key});

  @override
  State<LecturasScreen> createState() => _LecturasScreenState();
}

class _LecturasScreenState extends State<LecturasScreen>
    with SingleTickerProviderStateMixin {
  static const Color gold = Color(0xFFD4AF37);
  static const Color softGold = Color(0xFFE8C76A);

  LecturasDayData? data;
  bool loading = true;
  int currentTab = 0;

  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  final List<String> tabs = const [
    'Santo',
    '1.ª',
    'Salmo',
    '2.ª',
    'Evangelio',
    'Reflexión',
    'Oración',
  ];

  @override
  void initState() {
    super.initState();
    _load();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _bgController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _load() async {
    final result = await LecturasService.getLecturasDelDiaConFallback();
    if (!mounted) return;

    setState(() {
      data = result;
      loading = false;
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgAnimation,
              builder: (_, child) {
                return Transform.scale(
                  scale: _bgAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/lecturas.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.28),
            ),
          ),
          SafeArea(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: softGold,
                    ),
                  )
                : data == null
                    ? _buildEmptyState(context)
                    : Column(
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 10),
                          _buildTabs(),
                          const SizedBox(height: 10),
                          Expanded(
                            child: _buildAnimatedContent(),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: softGold,
                    size: 34,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'No hay lecturas disponibles',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No se encontró contenido litúrgico para este día.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      color: Colors.white.withOpacity(0.88),
                      fontSize: 17,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
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
              data?.titulo ?? 'Lecturas del día',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
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

  Widget _buildTabs() {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final selected = currentTab == index;

          return GestureDetector(
            onTap: () {
              if (currentTab == index) return;
              setState(() => currentTab = index);
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: selected ? 1.05 : 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: selected
                      ? Colors.white.withOpacity(0.18)
                      : Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: selected
                        ? Colors.white.withOpacity(0.22)
                        : Colors.white.withOpacity(0.08),
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: gold.withOpacity(0.12),
                            blurRadius: 20,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: GoogleFonts.poppins(
                    color: selected ? softGold : Colors.white70,
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(tabs[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedContent() {
    final section = _getSection();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        final slide = Tween<Offset>(
          begin: const Offset(0.03, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
      child: _buildContent(section),
    );
  }

  Widget _buildContent(Map<String, dynamic> section) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('content_$currentTab'),
      tween: Tween(begin: 0.98, end: 1.0),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          alignment: Alignment.topCenter,
          child: child,
        );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['label'] as String,
              style: GoogleFonts.poppins(
                color: gold,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if ((section['cita'] as String).isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                section['cita'] as String,
                style: GoogleFonts.poppins(
                  color: softGold.withOpacity(0.9),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white.withOpacity(0.10),
            ),
            const SizedBox(height: 18),
            if ((section['titulo'] as String).isNotEmpty) ...[
              Text(
                section['titulo'] as String,
                style: GoogleFonts.lora(
                  color: Colors.white,
                  fontSize: 26,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
            ],
            Text(
              section['texto'] as String,
              style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 20,
                height: 1.75,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 36),
            if (currentTab == 5 &&
                data?.preguntaDelDia != null &&
                data!.preguntaDelDia!.trim().isNotEmpty)
              _buildPregunta(),
          ],
        ),
      ),
    );
  }

  Widget _buildPregunta() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Para reflexionar',
                style: GoogleFonts.poppins(
                  color: gold,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                data!.preguntaDelDia!,
                style: GoogleFonts.lora(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getSection() {
    switch (currentTab) {
      case 0:
        return {
          'label': 'Santo del día',
          'cita': '',
          'titulo': _getSantoTitulo(),
          'texto': _getSantoTexto(),
        };

      case 1:
        return {
          'label': 'Primera Lectura',
          'cita': data?.primeraLectura?['cita']?.toString() ?? '',
          'titulo': data?.primeraLectura?['titulo']?.toString() ?? '',
          'texto': data?.primeraLectura?['texto']?.toString() ?? '',
        };

      case 2:
        return {
          'label': 'Salmo',
          'cita': data?.salmo?['cita']?.toString() ?? '',
          'titulo': data?.salmo?['respuesta']?.toString() ?? '',
          'texto': data?.salmo?['texto']?.toString() ?? '',
        };

      case 3:
        return {
          'label': 'Segunda Lectura',
          'cita': data?.segundaLectura?['cita']?.toString() ?? '',
          'titulo': data?.segundaLectura?['titulo']?.toString() ?? '',
          'texto': data?.segundaLectura?['texto']?.toString() ?? '',
        };

      case 4:
        return {
          'label': 'Evangelio',
          'cita': data?.evangelio?['cita']?.toString() ?? '',
          'titulo': data?.evangelio?['titulo']?.toString() ?? '',
          'texto': data?.evangelio?['texto']?.toString() ??
              data?.evangelio?['evangelio']?.toString() ??
              '',
        };

      case 5:
        return {
          'label': 'Reflexión',
          'cita': '',
          'titulo': data?.reflexion?['titulo']?.toString() ?? '',
          'texto': data?.reflexion?['texto']?.toString() ?? '',
        };

      case 6:
        return {
          'label': 'Oración Final',
          'cita': '',
          'titulo': _getOracionTitulo(),
          'texto': _getOracionTexto(),
        };

      default:
        return {
          'label': '',
          'cita': '',
          'titulo': '',
          'texto': '',
        };
    }
  }

  String _getSantoTitulo() {
    final santo = data?.santoDelDia;
    if (santo == null || santo.isEmpty) return 'Santo del día';
    return santo['titulo']?.toString() ??
        santo['nombre']?.toString() ??
        'Santo del día';
  }

  String _getSantoTexto() {
    final santo = data?.santoDelDia;
    if (santo == null || santo.isEmpty) {
      return 'No hay información del santo del día disponible.';
    }
    return santo['texto']?.toString() ??
        santo['descripcion']?.toString() ??
        santo['contenido']?.toString() ??
        'No hay información del santo del día disponible.';
  }

  String _getOracionTitulo() {
    final oracion = data?.oracionFinal;
    if (oracion == null || oracion.isEmpty) return '';

    final titulo = oracion['titulo']?.toString() ?? '';
    if (titulo.trim().isNotEmpty) return titulo;

    final firstKey =
        oracion.keys.isNotEmpty ? oracion.keys.first.toString() : '';
    return firstKey;
  }

  String _getOracionTexto() {
    final oracion = data?.oracionFinal;
    if (oracion == null || oracion.isEmpty) return '';

    final texto = oracion['texto']?.toString() ?? '';
    if (texto.trim().isNotEmpty) return texto;

    if (oracion.keys.isNotEmpty) {
      final firstKey = oracion.keys.first;
      final firstValue = oracion[firstKey];
      if (firstValue != null) return firstValue.toString();
    }

    return '';
  }
}
