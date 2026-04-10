import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/app/navigation/main_shell.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  String? _sexoSeleccionado;
  String? _diocesisIdSeleccionada;
  String? _diocesisNombreSeleccionada;

  bool _isLoading = false;
  bool _isFetchingDiocesis = true;

  List<Map<String, dynamic>> _diocesis = [];

  final Color primaryBlue = const Color(0xFF0B1E66);
  final Color secondaryBlue = const Color(0xFF1A3DAB);
  final Color gold = const Color(0xFFD4AF37);
  final Color background = const Color(0xFFF3F5FB);
  final Color textPrimary = const Color(0xFF1B1F2A);
  final Color textSecondary = const Color(0xFF6B7280);
  final Color surface = Colors.white;

  @override
  void initState() {
    super.initState();
    _precargarDatosUsuario();
    _cargarDiocesis();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  Future<void> _precargarDatosUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      _nombreController.text = (data['nombre'] ?? '').toString();
      _telefonoController.text = (data['telefono'] ?? '').toString();
      _edadController.text =
          data['edad'] != null ? data['edad'].toString() : '';

      final sexo = (data['sexo'] ?? '').toString().trim();
      final diocesisId = (data['diocesisId'] ?? '').toString().trim();
      final diocesisNombre = (data['diocesisNombre'] ?? '').toString().trim();

      _sexoSeleccionado = sexo.isNotEmpty ? sexo : null;
      _diocesisIdSeleccionada = diocesisId.isNotEmpty ? diocesisId : null;
      _diocesisNombreSeleccionada =
          diocesisNombre.isNotEmpty ? diocesisNombre : null;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error al precargar usuario: $e');
    }
  }

  Future<void> _cargarDiocesis() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('diocesis').get();

      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'nombre': (data['nombre'] ?? '').toString().trim(),
          'activo': data['activo'] == true,
          'orden': (data['orden'] is num) ? (data['orden'] as num).toInt() : 0,
        };
      }).where((item) {
        final nombre = (item['nombre'] as String).trim();
        final activo = item['activo'] == true;
        return nombre.isNotEmpty && activo;
      }).toList();

      items.sort((a, b) {
        final ordenA = (a['orden'] as int?) ?? 0;
        final ordenB = (b['orden'] as int?) ?? 0;
        return ordenA.compareTo(ordenB);
      });

      debugPrint('DIOCESIS CARGADAS: ${items.length}');
      debugPrint('LISTA DIOCESIS: $items');

      if (!mounted) return;

      final existeSeleccionActual = items.any(
        (item) => item['id'] == _diocesisIdSeleccionada,
      );

      setState(() {
        _diocesis = items;
        _isFetchingDiocesis = false;

        if (!existeSeleccionActual) {
          _diocesisIdSeleccionada = null;
          _diocesisNombreSeleccionada = null;
        }
      });
    } catch (e) {
      debugPrint('Error al cargar diócesis: $e');

      if (mounted) {
        setState(() {
          _isFetchingDiocesis = false;
        });
      }

      _mostrarSnack('No se pudieron cargar las diócesis: $e');
    }
  }

  String? _validarNombre(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu nombre';
    }
    if (value.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }

  String? _validarTelefono(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu teléfono';
    }

    final limpio = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (limpio.length < 10) {
      return 'Ingresa un teléfono válido';
    }
    return null;
  }

  String? _validarEdad(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu edad';
    }

    final edad = int.tryParse(value.trim());
    if (edad == null) {
      return 'La edad debe ser numérica';
    }

    if (edad < 12 || edad > 99) {
      return 'Ingresa una edad válida';
    }

    return null;
  }

  Future<void> _guardarPerfil() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_sexoSeleccionado == null || _sexoSeleccionado!.isEmpty) {
      _mostrarSnack('Selecciona tu sexo');
      return;
    }

    if (_diocesisIdSeleccionada == null || _diocesisIdSeleccionada!.isEmpty) {
      _mostrarSnack('Selecciona tu diócesis');
      return;
    }

    final diocesisSeleccionada =
        _diocesis.cast<Map<String, dynamic>?>().firstWhere(
              (item) => item != null && item['id'] == _diocesisIdSeleccionada,
              orElse: () => null,
            );

    final diocesisNombre =
        (diocesisSeleccionada?['nombre'] ?? '').toString().trim();

    if (diocesisNombre.isEmpty) {
      _mostrarSnack('No se pudo identificar la diócesis seleccionada');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _mostrarSnack('No se encontró una sesión activa');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final now = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'email': user.email ?? '',
        'nombre': _nombreController.text.trim(),
        'telefono': _telefonoController.text.trim(),
        'edad': int.parse(_edadController.text.trim()),
        'sexo': _sexoSeleccionado,
        'diocesisId': _diocesisIdSeleccionada,
        'diocesisNombre': diocesisNombre,
        'profileCompleted': true,
        'role': 'joven',
        'isActive': true,
        'provider': user.providerData.isNotEmpty
            ? user.providerData.first.providerId
            : 'unknown',
        'updatedAt': now,
        'createdAt': now,
      }, SetOptions(merge: true));

      if (!mounted) return;

      _mostrarSnack('Perfil completado correctamente', isError: false);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error al guardar perfil: $e');
      _mostrarSnack('Ocurrió un error al guardar tu perfil');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _mostrarSnack(String mensaje, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryBlue),
      filled: true,
      fillColor: surface.withOpacity(0.95),
      labelStyle: GoogleFonts.poppins(
        color: textSecondary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.poppins(
        color: textSecondary.withOpacity(0.75),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: primaryBlue.withOpacity(0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: primaryBlue.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: gold, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.red.shade600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryBlue,
              secondaryBlue,
              background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.28, 0.75],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(user?.email ?? ''),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F5FB),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildIntroCard(),
                          const SizedBox(height: 22),
                          _buildFormCard(),
                          const SizedBox(height: 24),
                          _buildSaveButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String email) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completa tu perfil',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Antes de continuar, necesitamos algunos datos para personalizar tu experiencia dentro de Escoge RD.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.92),
              height: 1.5,
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      email,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: gold.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: gold.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: primaryBlue,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu perfil es importante',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Estos datos nos ayudarán a identificar tu diócesis, asignar tu experiencia dentro de la app y habilitar las funciones correspondientes.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    final dropdownValueValido = _diocesis.any(
      (item) => item['id'] == _diocesisIdSeleccionada,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface.withOpacity(0.98),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: primaryBlue.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.07),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _nombreController,
            textCapitalization: TextCapitalization.words,
            validator: _validarNombre,
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Nombre completo',
              icon: Icons.badge_outlined,
              hint: 'Ej. Anderson Medina',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _telefonoController,
            keyboardType: TextInputType.phone,
            validator: _validarTelefono,
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Teléfono',
              icon: Icons.phone_outlined,
              hint: 'Ej. 8095551234',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _sexoSeleccionado,
            isExpanded: true,
            decoration: _inputDecoration(
              label: 'Sexo',
              icon: Icons.wc_rounded,
            ),
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              DropdownMenuItem(value: 'masculino', child: Text('Masculino')),
              DropdownMenuItem(value: 'femenino', child: Text('Femenino')),
            ],
            onChanged: (value) {
              setState(() {
                _sexoSeleccionado = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecciona tu sexo';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _edadController,
            keyboardType: TextInputType.number,
            validator: _validarEdad,
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              label: 'Edad',
              icon: Icons.cake_outlined,
              hint: 'Ej. 24',
            ),
          ),
          const SizedBox(height: 16),
          if (_isFetchingDiocesis)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: surface.withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: primaryBlue.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cargando diócesis...',
                      style: GoogleFonts.poppins(
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (_diocesis.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: surface.withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.orange.withOpacity(0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No hay diócesis disponibles',
                    style: GoogleFonts.poppins(
                      color: textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Verifica que existan documentos activos en la colección diocesis.',
                    style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            DropdownButtonFormField<String>(
              value: dropdownValueValido ? _diocesisIdSeleccionada : null,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryBlue),
              decoration: _inputDecoration(
                label: 'Diócesis',
                icon: Icons.location_city_outlined,
              ),
              style: GoogleFonts.poppins(
                color: textPrimary,
                fontWeight: FontWeight.w500,
              ),
              items: _diocesis.map((item) {
                return DropdownMenuItem<String>(
                  value: item['id'] as String,
                  child: Text(
                    item['nombre'] as String,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                final seleccion =
                    _diocesis.cast<Map<String, dynamic>?>().firstWhere(
                          (item) => item != null && item['id'] == value,
                          orElse: () => null,
                        );

                setState(() {
                  _diocesisIdSeleccionada = value;
                  _diocesisNombreSeleccionada =
                      (seleccion?['nombre'] ?? '').toString().trim();
                });

                debugPrint(
                    'DIOCESIS ID SELECCIONADA: $_diocesisIdSeleccionada');
                debugPrint(
                  'DIOCESIS NOMBRE SELECCIONADA: $_diocesisNombreSeleccionada',
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecciona tu diócesis';
                }
                return null;
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _guardarPerfil,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: primaryBlue.withOpacity(0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: Colors.white,
                ),
              )
            : Text(
                'Guardar y continuar',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
