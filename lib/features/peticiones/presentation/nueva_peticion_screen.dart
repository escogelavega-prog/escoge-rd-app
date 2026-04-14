import 'package:escoge/features/peticiones/services/peticiones_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NuevaPeticionScreen extends StatefulWidget {
  const NuevaPeticionScreen({super.key});

  @override
  State<NuevaPeticionScreen> createState() => _NuevaPeticionScreenState();
}

class _NuevaPeticionScreenState extends State<NuevaPeticionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textoController = TextEditingController();

  final PeticionesService _service = PeticionesService();

  bool _loading = false;

  String _categoriaSeleccionada = 'Familia';
  String _tipoVisibilidad = 'publica';

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _deepBlue = Color(0xFF0B1E66);

  final List<String> _categorias = const [
    'Salud',
    'Familia',
    'Estudios',
    'Trabajo',
    'Fortaleza espiritual',
    'Gratitud',
    'Otra',
  ];

  Future<void> _publicarPeticion() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    try {
      final isAnonymous = _tipoVisibilidad == 'anonima';

      await _service.crearPeticion(
        userId: user.uid,
        userName: isAnonymous
            ? 'Anónimo'
            : (user.displayName?.trim().isNotEmpty == true
                ? user.displayName!.trim()
                : 'Usuario'),
        texto: _textoController.text.trim(),
        categoria: _categoriaSeleccionada,
        tipoVisibilidad: _tipoVisibilidad,
        isAnonymous: isAnonymous,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Petición publicada correctamente.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al publicar petición: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _deepBlue.withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _gold.withValues(alpha: 0.26),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 15.5,
      ),
    );
  }

  Widget _buildVisibilidadOption({
    required String value,
    required String title,
    required String subtitle,
  }) {
    final selected = _tipoVisibilidad == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tipoVisibilidad = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? _gold.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _gold : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? _gold : Colors.white70,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 12.6,
                      height: 1.45,
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

  InputDecoration _inputDecoration({
    required String hint,
    String? label,
  }) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.48),
      ),
      labelStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.72),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.07),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.10),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: _deepBlue,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Nueva petición',
          style: GoogleFonts.lora(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/form.png',
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    _deepBlue.withValues(alpha: 0.28),
                    Colors.black.withValues(alpha: 0.50),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                children: [
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comparte tu intención',
                          style: GoogleFonts.lora(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tu comunidad podrá acompañarte espiritualmente en esta petición y unirse en oración contigo.',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.76),
                            fontSize: 13.5,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildSectionTitle('Tu petición'),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _textoController,
                          maxLines: 6,
                          maxLength: 400,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(
                            hint: 'Escribe aquí tu petición...',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Debes escribir una petición.';
                            }

                            if (value.trim().length < 10) {
                              return 'La petición es demasiado corta.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        _buildSectionTitle('Categoría'),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: _categoriaSeleccionada,
                          dropdownColor: _deepBlue,
                          style: const TextStyle(color: Colors.white),
                          items: _categorias
                              .map(
                                (categoria) => DropdownMenuItem<String>(
                                  value: categoria,
                                  child: Text(categoria),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              _categoriaSeleccionada = value;
                            });
                          },
                          decoration: _inputDecoration(
                            hint: '',
                            label: 'Selecciona una categoría',
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildSectionTitle('Visibilidad'),
                        const SizedBox(height: 14),
                        _buildVisibilidadOption(
                          value: 'publica',
                          title: 'Pública',
                          subtitle: 'Tu nombre aparecerá junto a la petición.',
                        ),
                        _buildVisibilidadOption(
                          value: 'anonima',
                          title: 'Anónima',
                          subtitle:
                              'La comunidad verá tu intención sin tu identidad.',
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _publicarPeticion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _gold,
                              foregroundColor: _deepBlue,
                              padding: const EdgeInsets.symmetric(
                                vertical: 17,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 8,
                            ),
                            child: _loading
                                ? SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: _deepBlue,
                                    ),
                                  )
                                : Text(
                                    'Publicar petición',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.2,
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
    );
  }
}
