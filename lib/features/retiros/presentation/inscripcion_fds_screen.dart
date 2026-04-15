import 'package:escoge/core/theme/app_backgrounds.dart';
import 'package:escoge/core/widgets/app_background.dart';
import 'package:escoge/features/retiros/data/services/diocesis_service.dart';
import 'package:escoge/features/retiros/data/services/inscripcion_retiro_service.dart';
import 'package:escoge/features/retiros/domain/inscripcion_fds_model.dart';
import 'package:escoge/features/retiros/presentation/inscripcion_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InscripcionFDSScreen extends StatefulWidget {
  final String diocesis;
  final String retiroId;
  final String retiroNombre;

  const InscripcionFDSScreen({
    super.key,
    required this.diocesis,
    required this.retiroId,
    required this.retiroNombre,
  });

  @override
  State<InscripcionFDSScreen> createState() => _InscripcionFDSScreenState();
}

class _InscripcionFDSScreenState extends State<InscripcionFDSScreen> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _softGold = Color(0xFFE8C76A);
  static const Color _deepBlue = Color(0xFF0B1E66);

  final _service = InscripcionRetiroService();
  final _diocesisService = DiocesisService();

  bool _guardando = false;
  bool _cargandoDiocesis = true;

  List<Map<String, dynamic>> _diocesis = [];
  String? _diocesisId;
  String? _diocesisNombre;

  final _numeroFinDeSemanaCtrl = TextEditingController();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _invitadorNombreCtrl = TextEditingController();
  final _invitadorTelefonoCtrl = TextEditingController();
  final _porqueQuiereVivirCtrl = TextEditingController();
  final _queEsperaEncontrarCtrl = TextEditingController();

  DateTime _fechaEvento = DateTime.now();

  @override
  void initState() {
    super.initState();
    _cargarDiocesis();
  }

  @override
  void dispose() {
    _numeroFinDeSemanaCtrl.dispose();
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _telefonoCtrl.dispose();
    _invitadorNombreCtrl.dispose();
    _invitadorTelefonoCtrl.dispose();
    _porqueQuiereVivirCtrl.dispose();
    _queEsperaEncontrarCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDiocesis() async {
    try {
      final data = await _diocesisService.obtenerDiocesis();

      if (!mounted) return;

      setState(() {
        _diocesis = data;
        _cargandoDiocesis = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _cargandoDiocesis = false;
      });

      _showError('No se pudieron cargar las diócesis.');
    }
  }

  Future<void> _seleccionarDiocesis() async {
    if (_diocesis.isEmpty) {
      _showError('No hay diócesis disponibles en este momento.');
      return;
    }

    final seleccion = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: BoxDecoration(
            color: const Color(0xFF0C1C60),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 52,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Selecciona una diócesis',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: _diocesis.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = _diocesis[index];
                    final id = item['id']?.toString() ?? '';
                    final nombre = item['nombre']?.toString() ?? 'Sin nombre';
                    final isSelected = _diocesisId == id;

                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _gold.withValues(alpha: 0.14)
                              : Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? _gold
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                nombre,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: _gold,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (seleccion == null || !mounted) return;

    setState(() {
      _diocesisId = seleccion['id']?.toString();
      _diocesisNombre = seleccion['nombre']?.toString();
    });
  }

  Future<void> _seleccionarFechaEvento() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaEvento,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _deepBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaEvento = picked;
      });
    }
  }

  bool _validarFormulario() {
    if (_diocesisId == null || _diocesisNombre == null) {
      _showError('Debes seleccionar una diócesis.');
      return false;
    }

    if (_numeroFinDeSemanaCtrl.text.trim().isEmpty) {
      _showError('Debes indicar el número de fin de semana.');
      return false;
    }

    if (int.tryParse(_numeroFinDeSemanaCtrl.text.trim()) == null) {
      _showError('El número de fin de semana debe ser numérico.');
      return false;
    }

    if (_nombresCtrl.text.trim().isEmpty) {
      _showError('Debes indicar los nombres.');
      return false;
    }

    if (_apellidosCtrl.text.trim().isEmpty) {
      _showError('Debes indicar los apellidos.');
      return false;
    }

    if (_telefonoCtrl.text.trim().isEmpty) {
      _showError('Debes indicar el teléfono.');
      return false;
    }

    if (_telefonoCtrl.text.trim().length < 7) {
      _showError('El teléfono parece inválido.');
      return false;
    }

    if (_invitadorNombreCtrl.text.trim().isEmpty) {
      _showError('Debes indicar el nombre del invitador.');
      return false;
    }

    if (_invitadorTelefonoCtrl.text.trim().isEmpty) {
      _showError('Debes indicar el teléfono del invitador.');
      return false;
    }

    if (_invitadorTelefonoCtrl.text.trim().length < 7) {
      _showError('El teléfono del invitador parece inválido.');
      return false;
    }

    if (_porqueQuiereVivirCtrl.text.trim().isEmpty) {
      _showError('Debes indicar por qué quieres vivir esta experiencia.');
      return false;
    }

    if (_queEsperaEncontrarCtrl.text.trim().isEmpty) {
      _showError('Debes indicar qué esperas encontrar.');
      return false;
    }

    return true;
  }

  Future<void> _guardar() async {
    if (_guardando) return;

    FocusScope.of(context).unfocus();

    if (!_validarFormulario()) return;

    setState(() {
      _guardando = true;
    });

    try {
      final inscripcion = InscripcionFdsModel(
        retiroId: widget.retiroId,
        retiroTitulo: widget.retiroNombre,
        diocesisId: _diocesisId!,
        diocesisNombre: _diocesisNombre!,
        tipoFormulario: 'invitado_fds',
        tipoEvento: 'fin_de_semana',
        numeroFinDeSemana:
            int.tryParse(_numeroFinDeSemanaCtrl.text.trim()) ?? 0,
        fechaEvento: _fechaEvento,
        datosGenerales: {
          'nombres': _nombresCtrl.text.trim(),
          'apellidos': _apellidosCtrl.text.trim(),
          'telefono': _telefonoCtrl.text.trim(),
        },
        invitador: {
          'nombreCompleto': _invitadorNombreCtrl.text.trim(),
          'telefono': _invitadorTelefonoCtrl.text.trim(),
        },
        familiares: const {},
        experienciaEspiritual: {
          'porqueQuiereVivirExperiencia': _porqueQuiereVivirCtrl.text.trim(),
          'queEsperaEncontrar': _queEsperaEncontrarCtrl.text.trim(),
        },
      );

      await _service.inscribir(
        retiroId: widget.retiroId,
        data: inscripcion.toMap(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => InscripcionSuccessScreen(
            retiroNombre: widget.retiroNombre,
            diocesis: _diocesisNombre ?? widget.diocesis,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    String hint = 'Escribe aquí',
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.78),
      ),
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.42),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.07),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: _gold,
          width: 1.2,
        ),
      ),
    );
  }

  Widget _campo({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label: label),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
          color: _softGold,
        ),
      ),
    );
  }

  Widget _diocesisSelector() {
    final hasValue = _diocesisId != null &&
        _diocesisId!.trim().isNotEmpty &&
        _diocesisNombre != null &&
        _diocesisNombre!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _seleccionarDiocesis,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hasValue
                      ? _diocesisNombre!
                      : 'Toca para seleccionar diócesis',
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    color: hasValue
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _gold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.66),
          ),
        ),
        trailing: const Icon(
          Icons.calendar_today_rounded,
          color: _gold,
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoDiocesis) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          background: AppBackgrounds.home,
          overlayOpacity: 0.24,
          child: const Center(
            child: CircularProgressIndicator(
              color: _gold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        background: AppBackgrounds.home,
        overlayOpacity: 0.24,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.14),
                      _deepBlue.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.40),
                      Colors.black.withValues(alpha: 0.58),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(18),
                            child: Ink(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Inscripción FDS',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _TopChip(
                                      icon: Icons.event_available_rounded,
                                      label: 'Formulario FDS',
                                    ),
                                    _TopChip(
                                      icon: Icons.church_rounded,
                                      label: widget.diocesis,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  widget.retiroNombre,
                                  style: GoogleFonts.lora(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Completa este formulario para solicitar tu participación en la experiencia.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    color: Colors.white.withValues(alpha: 0.76),
                                    height: 1.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle('Información general'),
                                _diocesisSelector(),
                                _campo(
                                  label: 'Número de fin de semana',
                                  controller: _numeroFinDeSemanaCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                                _dateTile(
                                  title: 'Fecha del evento',
                                  subtitle: _formatDate(_fechaEvento),
                                  onTap: _seleccionarFechaEvento,
                                ),
                                _campo(
                                  label: 'Nombres',
                                  controller: _nombresCtrl,
                                ),
                                _campo(
                                  label: 'Apellidos',
                                  controller: _apellidosCtrl,
                                ),
                                _campo(
                                  label: 'Teléfono',
                                  controller: _telefonoCtrl,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 8),
                                _sectionTitle('Invitador'),
                                _campo(
                                  label: 'Nombre completo del invitador',
                                  controller: _invitadorNombreCtrl,
                                ),
                                _campo(
                                  label: 'Teléfono del invitador',
                                  controller: _invitadorTelefonoCtrl,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 8),
                                _sectionTitle('Experiencia espiritual'),
                                _campo(
                                  label:
                                      '¿Por qué quiere vivir esta experiencia?',
                                  controller: _porqueQuiereVivirCtrl,
                                  maxLines: 4,
                                ),
                                _campo(
                                  label:
                                      '¿Qué espera encontrar en este fin de semana?',
                                  controller: _queEsperaEncontrarCtrl,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: _guardando ? null : _guardar,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _gold,
                                      foregroundColor: _deepBlue,
                                      elevation: 0,
                                      disabledBackgroundColor:
                                          _gold.withValues(alpha: 0.45),
                                      disabledForegroundColor: _deepBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: _guardando
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              color: _deepBlue,
                                            ),
                                          )
                                        : Text(
                                            'Enviar inscripción',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TopChip({
    required this.icon,
    required this.label,
  });

  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: _gold,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: _gold,
            ),
          ),
        ],
      ),
    );
  }
}
