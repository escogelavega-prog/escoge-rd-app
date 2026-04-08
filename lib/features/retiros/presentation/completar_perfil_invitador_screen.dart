import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/retiros/data/repositories/inscripciones_repository.dart';
import 'package:escoge/features/retiros/data/services/inscripcion_fds_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletarPerfilInvitadorScreen extends StatefulWidget {
  const CompletarPerfilInvitadorScreen({super.key});

  @override
  State<CompletarPerfilInvitadorScreen> createState() =>
      _CompletarPerfilInvitadorScreenState();
}

class _CompletarPerfilInvitadorScreenState
    extends State<CompletarPerfilInvitadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _numeroEscogeController = TextEditingController();
  final _comunidadController = TextEditingController();
  final _parroquiaController = TextEditingController();
  final _diocesisController = TextEditingController();
  final _cualidadesController = TextEditingController();
  final _razonesController = TextEditingController();
  final _compromisosController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _firmaInvitadorController = TextEditingController();

  final _repo = InscripcionesRepository(InscripcionFDSService());

  bool _isLoading = false;
  bool _isSaving = false;
  bool _inscripcionCargada = false;

  String? _retiroId;
  String? _inscripcionId;
  Map<String, dynamic>? _inscripcionData;

  @override
  void dispose() {
    _tokenController.dispose();
    _nombreController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _numeroEscogeController.dispose();
    _comunidadController.dispose();
    _parroquiaController.dispose();
    _diocesisController.dispose();
    _cualidadesController.dispose();
    _razonesController.dispose();
    _compromisosController.dispose();
    _observacionesController.dispose();
    _firmaInvitadorController.dispose();
    super.dispose();
  }

  Future<void> _buscarPorToken() async {
    final token = _tokenController.text.trim();

    if (token.isEmpty) {
      _showError('Debes escribir el código de acceso.');
      return;
    }

    setState(() {
      _isLoading = true;
      _inscripcionCargada = false;
      _retiroId = null;
      _inscripcionId = null;
      _inscripcionData = null;
    });

    try {
      final result = await _repo.buscarInscripcionPorToken(token);

      if (result == null) {
        _showError('No se encontró ninguna inscripción con ese código.');
        return;
      }

      final data = Map<String, dynamic>.from(result['data'] as Map);

      final invitadorFlow =
          Map<String, dynamic>.from(data['invitadorFlow'] ?? {});
      final yaCompletado = invitadorFlow['completado'] == true;

      if (yaCompletado) {
        _showError('Esta ficha del invitador ya fue completada.');
        return;
      }

      setState(() {
        _retiroId = result['retiroId'] as String;
        _inscripcionId = result['inscripcionId'] as String;
        _inscripcionData = data;
        _inscripcionCargada = true;
      });
    } catch (e) {
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _guardarPerfilInvitado() async {
    if (_isSaving) return;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_retiroId == null ||
        _inscripcionId == null ||
        _inscripcionData == null) {
      _showError('Primero debes validar un código de acceso.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final referenciaInvitador = Map<String, dynamic>.from(
        _inscripcionData!['referenciaInvitador'] ?? {},
      );

      final perfilInvitado = {
        'tipo': 'perfil_invitado',
        'version': 1,
        'invitador': {
          'nombre': _nombreController.text.trim(),
          'apellidos': _apellidosController.text.trim(),
          'telefono': _telefonoController.text.trim(),
          'email': _emailController.text.trim(),
          'numeroEscoge': _numeroEscogeController.text.trim(),
          'comunidad': _comunidadController.text.trim(),
          'parroquia': _parroquiaController.text.trim(),
          'diocesisId': referenciaInvitador['diocesisId'] ?? '',
          'diocesisNombre': _diocesisController.text.trim(),
        },
        'discernimiento': {
          'cualidadesInvitado': _cualidadesController.text.trim(),
          'razonesParaFDS': _razonesController.text.trim(),
          'compromisosInvitador': _compromisosController.text.trim(),
          'observacionesAdicionales': _observacionesController.text.trim(),
        },
        'firmas': {
          'firmaInvitadorNombre': _firmaInvitadorController.text.trim(),
          'fechaFirma': DateTime.now(),
        },
        'estado': 'completo',
        'revisionEstado': 'pendiente',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      await _repo.completarPerfilInvitado(
        retiroId: _retiroId!,
        inscripcionId: _inscripcionId!,
        perfilInvitado: perfilInvitado,
        completadoPor: {
          'nombre':
              '${_nombreController.text.trim()} ${_apellidosController.text.trim()}'
                  .trim(),
          'telefono': _telefonoController.text.trim(),
          'email': _emailController.text.trim(),
          'ip': '',
          'dispositivo': 'app_flutter',
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ficha del invitador completada correctamente.'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Requerido';
          }
          return null;
        },
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
            borderSide: BorderSide(color: AppColors.borderSoft),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.borderSoft),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumenInscripcion() {
    final data = _inscripcionData ?? {};
    final participante = Map<String, dynamic>.from(data['participante'] ?? {});

    final nombre =
        '${participante['nombre'] ?? ''} ${participante['apellidos'] ?? ''}'
            .trim();
    final retiroTitulo = data['retiroTitulo'] ?? 'Retiro';
    final diocesis = data['retiroDiocesisNombre'] ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de la inscripción',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Retiro: $retiroTitulo',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Diócesis: $diocesis',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Participante: ${nombre.isEmpty ? 'No disponible' : nombre}',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Perfil del Invitador',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
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
                'Completa la ficha del invitador',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa el código recibido para cargar la inscripción pendiente y completar tu parte.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tokenController,
                      decoration: InputDecoration(
                        labelText: 'Código de acceso',
                        hintText: 'Ej: INV-FDS60-X8K2P9',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.borderSoft),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.borderSoft),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _buscarPorToken,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Validar',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_inscripcionCargada) ...[
                _buildResumenInscripcion(),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _input(_nombreController, 'Nombre del invitador'),
                      _input(_apellidosController, 'Apellidos del invitador'),
                      _input(
                        _telefonoController,
                        'Teléfono',
                        keyboardType: TextInputType.phone,
                      ),
                      _input(
                        _emailController,
                        'Correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _input(
                          _numeroEscogeController, 'Número de Escoge vivido'),
                      _input(_comunidadController, 'Comunidad'),
                      _input(_parroquiaController, 'Parroquia'),
                      _input(_diocesisController, 'Diócesis del invitador'),
                      _input(
                        _cualidadesController,
                        'Cualidades del invitado',
                        maxLines: 3,
                      ),
                      _input(
                        _razonesController,
                        'Razones para recomendarlo al FDS',
                        maxLines: 3,
                      ),
                      _input(
                        _compromisosController,
                        'Compromisos del invitador',
                        maxLines: 3,
                      ),
                      _input(
                        _observacionesController,
                        'Observaciones adicionales',
                        maxLines: 3,
                      ),
                      _input(
                        _firmaInvitadorController,
                        'Nombre para firma del invitador',
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _guardarPerfilInvitado,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Guardar ficha del invitador',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
