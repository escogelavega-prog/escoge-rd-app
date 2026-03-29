import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/retiros/services/inscripcion_fds_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InscripcionScreen extends StatefulWidget {
  final String diocesis;
  final String retiroId;
  final String retiroNombre;

  const InscripcionScreen({
    super.key,
    required this.diocesis,
    required this.retiroId,
    required this.retiroNombre,
  });

  @override
  State<InscripcionScreen> createState() => _InscripcionScreenState();
}

class _InscripcionScreenState extends State<InscripcionScreen> {
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  final InscripcionFDSService _service = InscripcionFDSService();

  int _currentStep = 0;
  bool _isSaving = false;

  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final cedulaController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final direccionController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    nombreController.dispose();
    apellidosController.dispose();
    cedulaController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    direccionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await _service.guardarInscripcion(
        tipoFormulario: 'general',
        retiroId: widget.retiroId,
        retiroNombre: widget.retiroNombre,
        diocesis: widget.diocesis,
        datos: {
          'nombre': nombreController.text.trim(),
          'apellidos': apellidosController.text.trim(),
          'cedula': cedulaController.text.trim(),
          'telefono': telefonoController.text.trim(),
          'email': emailController.text.trim(),
          'direccion': direccionController.text.trim(),
        },
      );

      if (!mounted) return;
      await _showSuccessAndReturn();
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _showSuccessAndReturn() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Inscripción enviada correctamente'),
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(milliseconds: 1000),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1050));

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _nextStep() {
    FocusScope.of(context).unfocus();

    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
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

  String _stepLabel() => 'Paso ${_currentStep + 1} de 3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Inscripción',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
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
        ),
      ),
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
                  child: const Text('Atrás'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSaving ? null : _nextStep,
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
      title: 'Dirección y confirmación',
      subtitle: 'Revisa tus datos antes de enviar la inscripción.',
      children: [
        _input(direccionController, 'Dirección'),
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
        ),
      ),
    );
  }
}
