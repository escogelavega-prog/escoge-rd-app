import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/features/oracion/services/lecturas_service.dart';

class EvangelioScreen extends StatefulWidget {
  const EvangelioScreen({super.key});

  @override
  State<EvangelioScreen> createState() => _EvangelioScreenState();
}

class _EvangelioScreenState extends State<EvangelioScreen> {
  static const Color gold = Color(0xFFD4AF37);
  static const Color softGold = Color(0xFFE8C76A);

  LecturasDayData? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await LecturasService.getLecturasDelDiaConFallback();
    if (!mounted) return;

    setState(() {
      data = result;
      loading = false;
    });
  }

  String _getEvangelioTitulo() {
    final evangelio = data?.evangelio;
    if (evangelio == null || evangelio.isEmpty) return 'Evangelio del día';
    return evangelio['titulo']?.toString() ?? 'Evangelio del día';
  }

  String _getEvangelioCita() {
    final evangelio = data?.evangelio;
    if (evangelio == null || evangelio.isEmpty) return '';
    return evangelio['cita']?.toString() ?? '';
  }

  String _getEvangelioTexto() {
    final evangelio = data?.evangelio;
    if (evangelio == null || evangelio.isEmpty) {
      return 'No hay evangelio disponible para este día.';
    }

    final texto = evangelio['texto']?.toString() ?? '';
    if (texto.trim().isNotEmpty) return texto;

    final contenido = evangelio['evangelio']?.toString() ?? '';
    if (contenido.trim().isNotEmpty) return contenido;

    return 'No hay evangelio disponible para este día.';
  }

  String _getTituloLiturgico() {
    return data?.titulo ?? 'Evangelio del día';
  }

  String _getFraseClave() {
    final frase = data?.fraseClave ?? '';
    return frase.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/lecturas.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.34),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.30),
                    Colors.black.withOpacity(0.22),
                    Colors.black.withOpacity(0.36),
                  ],
                ),
              ),
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
                  color: Colors.white.withOpacity(0.08),
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
                    'No hay evangelio disponible',
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
              _getTituloLiturgico(),
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

  Widget _buildContent() {
    final frase = _getFraseClave();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.white.withOpacity(0.08),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: Text(
                'Evangelio',
                style: GoogleFonts.poppins(
                  color: gold,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              _getEvangelioCita(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: softGold.withOpacity(0.92),
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 26),
          Center(
            child: _buildListenButton(),
          ),
          const SizedBox(height: 26),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.white.withOpacity(0.10),
          ),
          const SizedBox(height: 24),
          Text(
            _getEvangelioTitulo(),
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 30,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (frase.isNotEmpty) ...[
            const SizedBox(height: 22),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Text(
                    '“$frase”',
                    style: GoogleFonts.lora(
                      color: Colors.white.withOpacity(0.96),
                      fontSize: 18,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 28),
          Text(
            _getEvangelioTexto(),
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 20,
              height: 1.82,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListenButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.graphic_eq_rounded,
            color: gold,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Escuchar el Evangelio',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
