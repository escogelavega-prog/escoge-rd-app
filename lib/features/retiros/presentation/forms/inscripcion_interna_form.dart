import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/retiros/data/repositories/inscripciones_repository.dart';
import 'package:escoge/features/retiros/data/services/inscripcion_fds_service.dart';
import 'package:escoge/features/retiros/domain/inscripcion_model.dart';
import 'package:escoge/features/retiros/presentation/inscripcion_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InscripcionInternaForm extends StatefulWidget {
  final String diocesis;
  final String retiroId;
  final String retiroNombre;
  final String tipoEvento;

  const InscripcionInternaForm({
    super.key,
    required this.diocesis,
    required this.retiroId,
    required this.retiroNombre,
    required this.tipoEvento,
  });

  @override
  State<InscripcionInternaForm> createState() => _InscripcionInternaFormState();
}

class _InscripcionInternaFormState extends State<InscripcionInternaForm> {
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  final _repo = InscripcionesRepository(InscripcionFDSService());

  int _currentStep = 0;
  bool _isSaving = false;

  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final cedulaController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final direccionController = TextEditingController();
  final comunidadController = TextEditingController();
  final parroquiaController = TextEditingController();
  final observacionesController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    nombreController.dispose();
    apellidosController.dispose();
    cedulaController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    direccionController.dispose();
    comunidadController.dispose();
    parroquiaController.dispose();
    observacionesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSaving = true);

    try {
      final model = InscripcionModel(
        retiroId: widget.retiroId,
        retiroTitulo: widget.retiroNombre,
        retiroTipoEvento: widget.tipoEvento,
        retiroNumeroFinDeSemana: 0,
        retiroDiocesisId: widget.diocesis,
        retiroDiocesisNombre: widget.diocesis,
        tipoFormulario: 'inscripcion_interna',
        modalidadIngreso: 'interna',
        requiereFormularioInvitador: false,
        participante: {
          'uid': null,
          'nombre': nombreController.text.trim(),
          'apellidos': apellidosController.text.trim(),
          'cedula': cedulaController.text.trim(),
          'telefono': telefonoController.text.trim(),
          'email': emailController.text.trim(),
          'fechaNacimiento': null,
          'edad': null,
          'sexo': '',
          'estadoCivil': '',
          'direccion': direccionController.text.trim(),
          'ciudad': '',
          'provincia': '',
          'ocupacion': '',
          'lugarTrabajo': '',
          'diocesisIdOrigen': widget.diocesis,
          'diocesisNombreOrigen': widget.diocesis,
        },
        familiares: {
          'conQuienVive': '',
          'padre': {
            'nombre': '',
            'telefono': '',
          },
          'madre': {
            'nombre': '',
            'telefono': '',
          },
          'contactoEmergencia': {
            'nombre': '',
            'parentesco': '',
            'telefono': '',
          },
        },
        experienciaEspiritual: {
          'religion': '',
          'bautizado': false,
          'primeraComunion': false,
          'confirmado': false,
          'haVividoRetiroAntes': true,
          'cualRetiro': 'Escoge',
          'haVividoEscogeAntes': true,
          'perteneceComunidad': true,
          'nombreComunidad': comunidadController.text.trim(),
          'parroquia': parroquiaController.text.trim(),
        },
        motivacion: {
          'porqueDeseaVivirlo':
              'Participación en retiro interno del movimiento.',
          'queEsperaEncontrar': observacionesController.text.trim(),
        },
        referenciaInvitador: {},
        perfilInvitado: null,
        invitadorFlow: {
          'requiereFormulario': false,
          'tokenAcceso': '',
          'tokenCreadoEn': null,
          'tokenExpiraEn': null,
          'estado': 'no_aplica',
          'enviado': false,
          'completado': false,
          'intentosRestantes': 0,
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
        },
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
          'revisadoPorUid': null,
          'revisadoPorNombre': null,
          'fechaRevision': null,
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
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _nextStep() {
    FocusScope.of(context).unfocus();

    if (_currentStep == 0) {
      if (!_validateStep1()) return;
    } else if (_currentStep == 1) {
      if (!_validateStep2()) return;
    } else if (_currentStep == 2) {
      if (!_validateStep3()) return;
      _submit();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  void _previousStep() {
    FocusScope.of(context).unfocus();

    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool _validateStep1() {
    final nombre = nombreController.text.trim();
    final apellidos = apellidosController.text.trim();
    final cedula = cedulaController.text.trim();

    if (nombre.isEmpty || apellidos.isEmpty || cedula.isEmpty) {
      _showError('Completa todos los campos del paso 1.');
      return false;
    }

    if (cedula.length < 6) {
      _showError('La cédula o pasaporte parece inválido.');
      return false;
    }

    return true;
  }

  bool _validateStep2() {
    final telefono = telefonoController.text.trim();
    final email = emailController.text.trim();

    if (telefono.isEmpty || email.isEmpty) {
      _showError('Completa todos los campos del paso 2.');
      return false;
    }

    if (telefono.length < 7) {
      _showError('El teléfono parece inválido.');
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showError('Ingresa un correo electrónico válido.');
      return false;
    }

    return true;
  }

  bool _validateStep3() {
    final direccion = direccionController.text.trim();
    final comunidad = comunidadController.text.trim();
    final parroquia = parroquiaController.text.trim();

    if (direccion.isEmpty) {
      _showError('Completa la dirección antes de enviar.');
      return false;
    }

    if (comunidad.isEmpty || parroquia.isEmpty) {
      _showError('Completa comunidad y parroquia para continuar.');
      return false;
    }

    return true;
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

  String _stepLabel() => 'Paso ${_currentStep + 1} de 3';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopHeader(),
        Expanded(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
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
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentStep = index);
                  },
                  children: [
                    SingleChildScrollView(child: _buildStep1()),
                    SingleChildScrollView(child: _buildStep2()),
                    SingleChildScrollView(child: _buildStep3()),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.retiroNombre,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Diócesis: ${widget.diocesis}',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tipo: ${widget.tipoEvento}',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildProgressBar()),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _stepLabel(),
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: (_currentStep + 1) / 3,
        minHeight: 8,
        backgroundColor: AppColors.borderSoft,
        valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
      ),
    );
  }

  Widget _buildBottomActions() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : _previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    side: BorderSide(
                      color: AppColors.primaryBlue.withValues(alpha: 0.18),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Atrás',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSaving ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                        _currentStep == 2 ? 'Enviar inscripción' : 'Siguiente',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return _buildStepContainer(
      title: 'Datos personales',
      subtitle: 'Completa tu información básica para continuar.',
      children: [
        _input(nombreController, 'Nombre(s)'),
        _input(apellidosController, 'Apellido(s)'),
        _input(cedulaController, 'Cédula o pasaporte'),
      ],
    );
  }

  Widget _buildStep2() {
    return _buildStepContainer(
      title: 'Datos de contacto',
      subtitle: 'Estos datos nos permitirán comunicarnos contigo.',
      children: [
        _input(
          telefonoController,
          'Teléfono',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Requerido';
            }
            if (value.trim().length < 7) {
              return 'Teléfono inválido';
            }
            return null;
          },
        ),
        _input(
          emailController,
          'Correo electrónico',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Requerido';
            }
            final email = value.trim();
            if (!email.contains('@') || !email.contains('.')) {
              return 'Correo inválido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return _buildStepContainer(
      title: 'Comunidad y confirmación',
      subtitle: 'Completa tus datos comunitarios y confirma tu participación.',
      children: [
        _input(direccionController, 'Dirección'),
        _input(comunidadController, 'Comunidad'),
        _input(parroquiaController, 'Parroquia'),
        _input(
          observacionesController,
          'Observaciones (opcional)',
          validator: (_) => null,
        ),
        const SizedBox(height: 8),
        Container(
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
                'Resumen',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 10),
              _summaryRow('Retiro', widget.retiroNombre),
              const SizedBox(height: 8),
              _summaryRow('Diócesis', widget.diocesis),
              const SizedBox(height: 8),
              _summaryRow(
                'Nombre',
                nombreController.text.trim().isEmpty
                    ? 'Pendiente'
                    : '${nombreController.text.trim()} ${apellidosController.text.trim()}',
              ),
              const SizedBox(height: 8),
              _summaryRow(
                'Correo',
                emailController.text.trim().isEmpty
                    ? 'Pendiente'
                    : emailController.text.trim(),
              ),
              const SizedBox(height: 8),
              _summaryRow('Modalidad', 'Interna'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 74,
          child: Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepContainer({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ??
            (value) {
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red.shade400),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red.shade600, width: 1.4),
          ),
        ),
      ),
    );
  }
}
