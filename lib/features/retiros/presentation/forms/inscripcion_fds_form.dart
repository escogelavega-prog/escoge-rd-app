import 'package:escoge/features/retiros/data/repositories/inscripciones_repository.dart';
import 'package:escoge/features/retiros/data/services/inscripcion_fds_service.dart';
import 'package:escoge/features/retiros/domain/inscripcion_model.dart';
import 'package:escoge/features/retiros/presentation/inscripcion_success_screen.dart';
import 'package:flutter/material.dart';

class InscripcionFdsForm extends StatefulWidget {
  final String diocesis;
  final String retiroId;
  final String retiroNombre;
  final String tipoEvento;

  const InscripcionFdsForm({
    super.key,
    required this.diocesis,
    required this.retiroId,
    required this.retiroNombre,
    required this.tipoEvento,
  });

  @override
  State<InscripcionFdsForm> createState() => _InscripcionFdsFormState();
}

class _InscripcionFdsFormState extends State<InscripcionFdsForm> {
  final _repo = InscripcionesRepository(InscripcionFDSService());

  bool _guardando = false;

  final nombresCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  final invitadorNombreCtrl = TextEditingController();
  final invitadorTelefonoCtrl = TextEditingController();

  final porqueCtrl = TextEditingController();
  final esperaCtrl = TextEditingController();

  bool _tieneInvitador = true;

  @override
  void dispose() {
    nombresCtrl.dispose();
    apellidosCtrl.dispose();
    telefonoCtrl.dispose();
    invitadorNombreCtrl.dispose();
    invitadorTelefonoCtrl.dispose();
    porqueCtrl.dispose();
    esperaCtrl.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildInvitadorFlow() {
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: 72));

    return {
      'requiereFormulario': true,
      'tokenAcceso': 'INV-${now.millisecondsSinceEpoch}',
      'tokenCreadoEn': now,
      'tokenExpiraEn': expiresAt,
      'estado': 'pendiente',
      'enviado': false,
      'completado': false,
      'intentosRestantes': 5,
      'ultimoIntentoAt': null,
      'bloqueado': false,
      'fechaEnvio': null,
      'fechaCompletado': null,
      'completadoPor': {
        'nombre': '',
        'telefono': '',
        'email': '',
        'ip': '',
        'dispositivo': '',
      },
    };
  }

  Future<void> _guardar() async {
    if (_guardando) return;

    if (!_validar()) return;

    setState(() => _guardando = true);

    try {
      final model = InscripcionModel(
        retiroId: widget.retiroId,
        retiroTitulo: widget.retiroNombre,
        retiroTipoEvento: widget.tipoEvento,
        retiroNumeroFinDeSemana: 0,
        retiroDiocesisId: widget.diocesis,
        retiroDiocesisNombre: widget.diocesis,
        tipoFormulario: 'inscripcion_fds',
        modalidadIngreso: _tieneInvitador ? 'recomendado' : 'directo',
        requiereFormularioInvitador: _tieneInvitador,
        participante: {
          'uid': null,
          'nombre': nombresCtrl.text.trim(),
          'apellidos': apellidosCtrl.text.trim(),
          'telefono': telefonoCtrl.text.trim(),
        },
        familiares: {},
        experienciaEspiritual: {
          'porqueDeseaVivirlo': porqueCtrl.text.trim(),
          'queEsperaEncontrar': esperaCtrl.text.trim(),
        },
        motivacion: {
          'porqueDeseaVivirlo': porqueCtrl.text.trim(),
          'queEsperaEncontrar': esperaCtrl.text.trim(),
        },
        referenciaInvitador: _tieneInvitador
            ? {
                'nombre': invitadorNombreCtrl.text.trim(),
                'telefono': invitadorTelefonoCtrl.text.trim(),
              }
            : {},
        perfilInvitado: null,
        invitadorFlow: _tieneInvitador
            ? _buildInvitadorFlow()
            : {'requiereFormulario': false},
        formulariosCompletados: {
          'inscripcionPrincipal': true,
          'perfilInvitado': false,
        },
        aceptacion: {
          'declaraInformacionCorrecta': true,
          'aceptaUsoInternoDatos': true,
          'firmadoPorParticipante': true,
          'fechaFirma': DateTime.now().toIso8601String(),
        },
        admin: {
          'observacionesAdministrativas': '',
        },
        fechaEvento: DateTime.now(),
      );

      await _repo.guardar(model);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => InscripcionSuccessScreen(
            retiroNombre: widget.retiroNombre,
            diocesis: widget.diocesis,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _error(e.toString());
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  bool _validar() {
    if (nombresCtrl.text.isEmpty) return _error('Nombre requerido');
    if (telefonoCtrl.text.length < 7) return _error('Teléfono inválido');

    if (_tieneInvitador && invitadorNombreCtrl.text.isEmpty) {
      return _error('Invitador requerido');
    }

    return true;
  }

  bool _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _campo('Nombres', nombresCtrl),
          _campo('Apellidos', apellidosCtrl),
          _campo('Teléfono', telefonoCtrl),
          SwitchListTile(
            value: _tieneInvitador,
            title: const Text('Tiene invitador'),
            onChanged: (v) => setState(() => _tieneInvitador = v),
          ),
          if (_tieneInvitador) ...[
            _campo('Nombre invitador', invitadorNombreCtrl),
            _campo('Teléfono invitador', invitadorTelefonoCtrl),
          ],
          _campo('¿Por qué quieres vivirlo?', porqueCtrl),
          _campo('¿Qué esperas?', esperaCtrl),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _guardando ? null : _guardar,
            child: const Text('Enviar'),
          )
        ],
      ),
    );
  }

  Widget _campo(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
