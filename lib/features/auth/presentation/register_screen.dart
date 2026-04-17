import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/presentation/complete_profile_screen.dart';
import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user!;

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'nombre': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'joven',
        'isActive': true,
        'profileCompleted': false,
        'onboardingCompleted': true,
        'provider': 'password',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        AppPageRoute(page: const CompleteProfileScreen()),
        (route) => false,
      );
    } catch (e) {
      _showMessage(_mapError(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapError(Object error) {
    final msg = error.toString();

    if (msg.contains('email-already-in-use')) return 'Correo ya registrado.';
    if (msg.contains('invalid-email')) return 'Correo inválido.';
    if (msg.contains('weak-password')) return 'Contraseña débil.';

    return 'No se pudo crear la cuenta.';
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  InputDecoration _input({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
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
          color: AppColors.lumenGold,
          width: 1.2,
        ),
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      AppPageRoute(page: const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/home.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    /// 🔥 HEADER
                    Text(
                      'Crear Cuenta',
                      style: GoogleFonts.lora(
                        color: AppColors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// 🔥 FORM
                    GlassSpiritualCard(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _input(
                                hint: 'Nombre completo',
                                icon: Icons.person_outline,
                              ),
                              validator: (v) =>
                                  v!.length < 3 ? 'Nombre inválido' : null,
                            ),

                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _input(
                                hint: 'Correo electrónico',
                                icon: Icons.mail_outline,
                              ),
                              validator: (v) =>
                                  v!.contains('@') ? null : 'Correo inválido',
                            ),

                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: _input(
                                hint: 'Contraseña',
                                icon: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: _input(
                                hint: 'Confirmar contraseña',
                                icon: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (v) => v != _passwordController.text
                                  ? 'No coinciden'
                                  : null,
                            ),

                            const SizedBox(height: 20),

                            /// 🔥 BOTÓN
                            GestureDetector(
                              onTap: _isLoading ? null : _register,
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.lumenGold,
                                      AppColors.lumenGoldBright,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.black,
                                        )
                                      : Text(
                                          'Crear cuenta',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            TextButton(
                              onPressed: _goToLogin,
                              child: Text(
                                '¿Ya tienes cuenta? Inicia sesión',
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
