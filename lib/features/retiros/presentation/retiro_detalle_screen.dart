import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/features/retiros/data/models/retiro_item_model.dart';
import 'package:escoge/features/retiros/presentation/inscripcion_fds_screen.dart'
    as retiro_fds;
import 'package:escoge/features/retiros/presentation/inscripcion_screen.dart'
    as retiro_local;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetiroDetalleScreen extends StatefulWidget {
  final RetiroItemModel retiro;

  const RetiroDetalleScreen({
    super.key,
    required this.retiro,
  });

  @override
  State<RetiroDetalleScreen> createState() => _RetiroDetalleScreenState();
}

class _RetiroDetalleScreenState extends State<RetiroDetalleScreen> {
  static const Color _softGold = Color(0xFFE8C76A);
  static const Color _deepBlue = Color(0xFF0B1E66);

  bool _inscripcionEnviada = false;
  bool _abriendoInscripcion = false;

  RetiroItemModel get retiro => widget.retiro;

  String get _retiroId => retiro.id;

  bool get _esFds {
    final tipo = retiro.tipoFormulario.trim().toLowerCase();
    return tipo == 'fds' || tipo.contains('fds');
  }

  Future<void> _openInscripcion() async {
    if (_abriendoInscripcion) return;

    setState(() => _abriendoInscripcion = true);

    try {
      final destination = _esFds
          ? retiro_fds.InscripcionFDSScreen(
              diocesis: retiro.diocesis,
              retiroId: _retiroId,
              retiroNombre: retiro.titulo,
            )
          : retiro_local.InscripcionScreen(
              diocesis: retiro.diocesis,
              retiroId: _retiroId,
              retiroNombre: retiro.titulo,
            );

      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => destination),
      );

      if (!mounted) return;

      if (result == true || result == 'success') {
        setState(() => _inscripcionEnviada = true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Inscripción enviada correctamente'),
            backgroundColor: _deepBlue,
          ),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al abrir inscripción'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _abriendoInscripcion = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: _BottomInscripcionBar(
        yaInscrito: _inscripcionEnviada,
        cargando: _abriendoInscripcion,
        onTap: _openInscripcion,
      ),
      body: AppBackground(
        background: AppBackgrounds.home,
        overlayOpacity: 0.26,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 120 + bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  retiro.titulo,
                  style: GoogleFonts.lora(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  retiro.descripcion,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfo("Fecha", retiro.fecha),
                _buildInfo("Ciudad", retiro.ciudad),
                _buildInfo("Diócesis", retiro.diocesis),
                _buildInfo("Lugar", retiro.lugar),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String title, String value) {
    if (value.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: GoogleFonts.poppins(
              color: _softGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomInscripcionBar extends StatelessWidget {
  final bool yaInscrito;
  final bool cargando;
  final VoidCallback onTap;

  const _BottomInscripcionBar({
    required this.yaInscrito,
    required this.cargando,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: cargando ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: RetiroDetalleScreenStateColors.gold,
        ),
        child: cargando
            ? const CircularProgressIndicator()
            : Text(
                yaInscrito ? 'YA INSCRITO' : 'INSCRIBIRME',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

class RetiroDetalleScreenStateColors {
  static const Color gold = Color(0xFFD4AF37);
}
