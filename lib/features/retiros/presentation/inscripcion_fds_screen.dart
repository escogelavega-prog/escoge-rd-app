import 'package:escoge/features/retiros/data/services/diocesis_service.dart';
import 'package:escoge/features/retiros/data/services/inscripcion_fds_service.dart';
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
  final _service = InscripcionFDSService();
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
    } catch (e) {
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
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 52,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DFEC),
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
                          color: const Color(0xFF1736B6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
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
                              ? const Color(0xFF1736B6).withValues(alpha: 0.08)
                              : const Color(0xFFF8FAFF),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1736B6)
                                : const Color(0xFFE3E8F2),
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
                                  color: const Color(0xFF1F2A44),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF1736B6),
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
        familiares: {},
        experienciaEspiritual: {
          'porqueQuiereVivirExperiencia': _porqueQuiereVivirCtrl.text.trim(),
          'queEsperaEncontrar': _queEsperaEncontrarCtrl.text.trim(),
        },
      );

      await _service.guardarInscripcion(inscripcion);

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
      _showError('Error al guardar inscripción: $e');
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
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Escribe aquí',
          filled: true,
          fillColor: const Color(0xFFF8FAFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE3E8F2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE3E8F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF1736B6),
              width: 1.4,
            ),
          ),
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
        borderRadius: BorderRadius.circular(16),
        onTap: _seleccionarDiocesis,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3E8F2)),
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
                        ? const Color(0xFF1F2A44)
                        : const Color(0xFF6E7A96),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF1736B6),
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
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E8F2)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2A44),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: const Color(0xFF6E7A96),
          ),
        ),
        trailing: const Icon(
          Icons.calendar_today_rounded,
          color: Color(0xFF1736B6),
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1736B6),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1736B6),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Inscripción FDS',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.retiroNombre,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1F2A44),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Completa este formulario para solicitar tu participación.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF6E7A96),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
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
                    _campo(
                      label: 'Nombre completo del invitador',
                      controller: _invitadorNombreCtrl,
                    ),
                    _campo(
                      label: 'Teléfono del invitador',
                      controller: _invitadorTelefonoCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    _campo(
                      label: '¿Por qué quiere vivir esta experiencia?',
                      controller: _porqueQuiereVivirCtrl,
                      maxLines: 4,
                    ),
                    _campo(
                      label: '¿Qué espera encontrar en este fin de semana?',
                      controller: _queEsperaEncontrarCtrl,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _guardando ? null : _guardar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1736B6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _guardando
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: Colors.white,
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
    );
  }
}
