import 'package:escoge/features/retiros/domain/inscripcion_fds_model.dart';
import 'package:escoge/features/retiros/data/services/diocesis_service.dart';
import 'package:escoge/features/retiros/data/services/inscripcion_fds_service.dart';
import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _service = InscripcionFDSService();
  final _diocesisService = DiocesisService();

  bool _guardando = false;
  List<Map<String, dynamic>> _diocesis = [];

  String? _diocesisId;
  String? _diocesisNombre;

  final _numeroFinDeSemanaCtrl = TextEditingController();
  DateTime _fechaEvento = DateTime.now();

  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _cedulaCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _sexoCtrl = TextEditingController();
  final _estadoCivilCtrl = TextEditingController();
  final _gradoEstudioCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _ciudadCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _lugarTrabajoCtrl = TextEditingController();
  final _telefonoTrabajoCtrl = TextEditingController();
  final _religionCtrl = TextEditingController();
  final _sizeSueterCtrl = TextEditingController();

  final _invitadorNombreCtrl = TextEditingController();
  final _invitadorNumeroEscogeCtrl = TextEditingController();
  final _invitadorTelefonoCtrl = TextEditingController();

  final _conQuienViveCtrl = TextEditingController();
  final _nombresConQuienViveCtrl = TextEditingController();
  final _nombrePadresCtrl = TextEditingController();
  final _telefonoPadresCtrl = TextEditingController();

  final _cualRetiroCtrl = TextEditingController();
  final _porqueQuiereVivirCtrl = TextEditingController();
  final _queEsperaEncontrarCtrl = TextEditingController();

  bool _bautizado = false;
  bool _primeraComunion = false;
  bool _confirmado = false;
  bool _familiares = false;
  bool _haParticipadoRetiro = false;

  DateTime? _fechaNacimiento;

  @override
  void initState() {
    super.initState();
    _cargarDiocesis();
  }

  Future<void> _cargarDiocesis() async {
    try {
      final data = await _diocesisService.obtenerDiocesis();
      if (!mounted) return;
      setState(() {
        _diocesis = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No se pudieron cargar las diócesis. Intenta de nuevo en unos minutos.'),
        ),
      );
    }
  }

  Future<void> _seleccionarFechaEvento() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaEvento,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() => _fechaEvento = picked);
    }
  }

  Future<void> _seleccionarFechaNacimiento() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _fechaNacimiento = picked);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_diocesisId == null || _diocesisNombre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar una diócesis')),
      );
      return;
    }

    if (_fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Debes seleccionar la fecha de nacimiento')),
      );
      return;
    }

    setState(() => _guardando = true);

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
          'cedulaPasaporte': _cedulaCtrl.text.trim(),
          'edad': int.tryParse(_edadCtrl.text.trim()) ?? 0,
          'sexo': _sexoCtrl.text.trim(),
          'estadoCivil': _estadoCivilCtrl.text.trim(),
          'fechaNacimiento': _fechaNacimiento,
          'gradoMaximoEstudio': _gradoEstudioCtrl.text.trim(),
          'direccion': _direccionCtrl.text.trim(),
          'ciudad': _ciudadCtrl.text.trim(),
          'telefono': _telefonoCtrl.text.trim(),
          'lugarTrabajo': _lugarTrabajoCtrl.text.trim(),
          'telefonoTrabajo': _telefonoTrabajoCtrl.text.trim(),
          'religion': _religionCtrl.text.trim(),
          'bautizado': _bautizado,
          'primeraComunion': _primeraComunion,
          'confirmado': _confirmado,
          'sizeSueter': _sizeSueterCtrl.text.trim(),
        },
        invitador: {
          'nombreCompleto': _invitadorNombreCtrl.text.trim(),
          'numeroEscoge':
              int.tryParse(_invitadorNumeroEscogeCtrl.text.trim()) ?? 0,
          'telefono': _invitadorTelefonoCtrl.text.trim(),
        },
        familiares: {
          'conQuienVive': _conQuienViveCtrl.text.trim(),
          'familiares': _familiares,
          'nombresConQuienVive': _nombresConQuienViveCtrl.text.trim(),
          'nombrePadres': _nombrePadresCtrl.text.trim(),
          'telefonoPadres': _telefonoPadresCtrl.text.trim(),
        },
        experienciaEspiritual: {
          'haParticipadoRetiro': _haParticipadoRetiro,
          'cualRetiro': _cualRetiroCtrl.text.trim(),
          'porqueQuiereVivirExperiencia': _porqueQuiereVivirCtrl.text.trim(),
          'queEsperaEncontrar': _queEsperaEncontrarCtrl.text.trim(),
        },
      );

      await _service.guardarInscripcion(inscripcion);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscripción enviada correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar inscripción: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  Widget _campo({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: requiredField
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Campo requerido';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _seccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 16),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numeroFinDeSemanaCtrl.dispose();
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _cedulaCtrl.dispose();
    _edadCtrl.dispose();
    _sexoCtrl.dispose();
    _estadoCivilCtrl.dispose();
    _gradoEstudioCtrl.dispose();
    _direccionCtrl.dispose();
    _ciudadCtrl.dispose();
    _telefonoCtrl.dispose();
    _lugarTrabajoCtrl.dispose();
    _telefonoTrabajoCtrl.dispose();
    _religionCtrl.dispose();
    _sizeSueterCtrl.dispose();
    _invitadorNombreCtrl.dispose();
    _invitadorNumeroEscogeCtrl.dispose();
    _invitadorTelefonoCtrl.dispose();
    _conQuienViveCtrl.dispose();
    _nombresConQuienViveCtrl.dispose();
    _nombrePadresCtrl.dispose();
    _telefonoPadresCtrl.dispose();
    _cualRetiroCtrl.dispose();
    _porqueQuiereVivirCtrl.dispose();
    _queEsperaEncontrarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscripción FDS'),
      ),
      body: _diocesis.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _seccion('Diócesis y evento'),
                  DropdownButtonFormField<String>(
                    initialValue: _diocesisId,
                    decoration: const InputDecoration(
                      labelText: 'Diócesis',
                      border: OutlineInputBorder(),
                    ),
                    items: _diocesis.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'] as String,
                        child: Text(item['nombre'] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selected =
                          _diocesis.firstWhere((e) => e['id'] == value);
                      setState(() {
                        _diocesisId = selected['id'] as String;
                        _diocesisNombre = selected['nombre'] as String;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _campo(
                    label: 'Número de fin de semana',
                    controller: _numeroFinDeSemanaCtrl,
                    keyboardType: TextInputType.number,
                    requiredField: true,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Fecha del evento'),
                    subtitle: Text(
                      '${_fechaEvento.day}/${_fechaEvento.month}/${_fechaEvento.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _seleccionarFechaEvento,
                  ),
                  _seccion('Datos generales'),
                  _campo(
                      label: 'Nombres',
                      controller: _nombresCtrl,
                      requiredField: true),
                  _campo(
                      label: 'Apellidos',
                      controller: _apellidosCtrl,
                      requiredField: true),
                  _campo(
                      label: 'Cédula o pasaporte',
                      controller: _cedulaCtrl,
                      requiredField: true),
                  _campo(
                    label: 'Edad',
                    controller: _edadCtrl,
                    keyboardType: TextInputType.number,
                    requiredField: true,
                  ),
                  _campo(
                      label: 'Sexo',
                      controller: _sexoCtrl,
                      requiredField: true),
                  _campo(label: 'Estado civil', controller: _estadoCivilCtrl),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Fecha de nacimiento'),
                    subtitle: Text(
                      _fechaNacimiento == null
                          ? 'Seleccionar fecha'
                          : '${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _seleccionarFechaNacimiento,
                  ),
                  _campo(
                      label: 'Grado máximo de estudio',
                      controller: _gradoEstudioCtrl),
                  _campo(
                      label: 'Dirección',
                      controller: _direccionCtrl,
                      requiredField: true),
                  _campo(
                      label: 'Ciudad',
                      controller: _ciudadCtrl,
                      requiredField: true),
                  _campo(
                      label: 'Teléfono',
                      controller: _telefonoCtrl,
                      requiredField: true),
                  _campo(
                      label: 'Lugar de trabajo', controller: _lugarTrabajoCtrl),
                  _campo(
                      label: 'Teléfono de trabajo',
                      controller: _telefonoTrabajoCtrl),
                  _campo(label: 'Religión', controller: _religionCtrl),
                  SwitchListTile(
                    title: const Text('Bautizado'),
                    value: _bautizado,
                    onChanged: (value) => setState(() => _bautizado = value),
                  ),
                  SwitchListTile(
                    title: const Text('Primera comunión'),
                    value: _primeraComunion,
                    onChanged: (value) =>
                        setState(() => _primeraComunion = value),
                  ),
                  SwitchListTile(
                    title: const Text('Confirmado'),
                    value: _confirmado,
                    onChanged: (value) => setState(() => _confirmado = value),
                  ),
                  _campo(label: 'Size en suéter', controller: _sizeSueterCtrl),
                  _seccion('Invitador'),
                  _campo(
                    label: 'Nombre completo del invitador',
                    controller: _invitadorNombreCtrl,
                    requiredField: true,
                  ),
                  _campo(
                    label: 'Número de Escoge del invitador',
                    controller: _invitadorNumeroEscogeCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  _campo(
                    label: 'Teléfono del invitador',
                    controller: _invitadorTelefonoCtrl,
                    requiredField: true,
                  ),
                  _seccion('Familiares'),
                  _campo(
                      label: '¿Con quién vive?', controller: _conQuienViveCtrl),
                  SwitchListTile(
                    title: const Text('Tiene familiares'),
                    value: _familiares,
                    onChanged: (value) => setState(() => _familiares = value),
                  ),
                  _campo(
                    label: 'Nombres de las personas con quien vive',
                    controller: _nombresConQuienViveCtrl,
                  ),
                  _campo(
                      label: 'Nombre de los padres',
                      controller: _nombrePadresCtrl),
                  _campo(
                      label: 'Teléfono de los padres',
                      controller: _telefonoPadresCtrl),
                  _seccion('Experiencia espiritual'),
                  SwitchListTile(
                    title: const Text('¿Ha participado en algún retiro?'),
                    value: _haParticipadoRetiro,
                    onChanged: (value) =>
                        setState(() => _haParticipadoRetiro = value),
                  ),
                  _campo(label: '¿Cuál retiro?', controller: _cualRetiroCtrl),
                  _campo(
                    label: '¿Por qué quiere vivir esta experiencia?',
                    controller: _porqueQuiereVivirCtrl,
                    maxLines: 4,
                    requiredField: true,
                  ),
                  _campo(
                    label: '¿Qué espera encontrar en este fin de semana?',
                    controller: _queEsperaEncontrarCtrl,
                    maxLines: 4,
                    requiredField: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _guardando ? null : _guardar,
                      child: _guardando
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : const Text('Enviar inscripción'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
