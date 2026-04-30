import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoge/app/navigation/main_shell.dart';
import 'package:escoge/app/routes/app_page_route.dart';
import 'package:escoge/core/constants/app_assets.dart';
import 'package:escoge/core/theme/app_colors.dart';
import 'package:escoge/features/auth/data/services/auth_service.dart';
import 'package:escoge/features/auth/presentation/register_screen.dart';
import 'package:escoge/features/oracion/widgets/glass_spiritual_card.dart';
import 'package:escoge/features/profile_setup/presentation/complete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  static const String _logoPath = 'assets/images/logo_movimiento.png';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('No se encontró el usuario autenticado.');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      final data = userDoc.data() ?? {};
      final bool profileCompleted = data['profileCompleted'] == true;

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        AppPageRoute(
          page: profileCompleted
              ? const MainShell()
              : const CompleteProfileScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      _showMessage(_mapLoginError(e));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    HapticFeedback.mediumImpact();

    FocusScope.of(context).unfocus();

    setState(() => _isGoogleLoading = true);

    try {
      final credential = await _authService.signInWithGoogle();

      final user = credential.user;

      if (user == null) {
        throw Exception('No se pudo autenticar el usuario con Google.');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      final data = userDoc.data() ?? {};
      final bool profileCompleted = data['profileCompleted'] == true;

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        AppPageRoute(
          page: profileCompleted
              ? const MainShell()
              : const CompleteProfileScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      _showMessage(_mapGoogleError(e));
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  String _mapLoginError(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('invalid-email')) {
      return 'Correo no válido.';
    }

    if (message.contains('invalid-credential')) {
      return 'Credenciales incorrectas.';
    }

    if (message.contains('user-not-found')) {
      return 'Usuario no existe.';
    }

    if (message.contains('wrong-password')) {
      return 'Contraseña incorrecta.';
    }

    if (message.contains('too-many-requests')) {
      return 'Demasiados intentos. Intenta más tarde.';
    }

    return 'No se pudo iniciar sesión.';
  }

  String _mapGoogleError(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('cancel')) {
      return 'Inicio de sesión cancelado.';
    }

    if (message.contains('network')) {
      return 'Problema de conexión con Google.';
    }

    if (message.contains('missing-google-id-token')) {
      return 'Google Sign-In no está configurado correctamente en iOS.';
    }

    if (message.contains('google-sign-in-failed')) {
      return 'No se pudo iniciar con Google. Verifica Firebase y GoogleService-Info.plist.';
    }

    return 'Error al iniciar sesión con Google.';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black87,
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: Colors.white54,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      suffixIcon: suffixIcon,
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

  void _openRegister() {
    Navigator.of(context).push(
      AppPageRoute(
        page: const RegisterScreen(),
      ),
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
              errorBuilder: (_, __, ___) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.screenGradient,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.64),
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

                    /// LOGO MOVIMIENTO
                    Container(
                      width: 118,
                      height: 118,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lumenCard.withValues(alpha: 0.82),
                        border: Border.all(
                          color: AppColors.lumenGold.withValues(alpha: 0.34),
                          width: 1.3,
                        ),
                      ),
                      child: ClipOval(
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Image.asset(
                              AppAssets.logoMovimiento,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Bienvenido',
                      style: GoogleFonts.lora(
                        color: AppColors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Ingresa para continuar tu camino espiritual',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// FORMULARIO
                    GlassSpiritualCard(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                hint: 'Correo electrónico',
                                icon: Icons.mail_outline,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Correo inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                hint: 'Contraseña',
                                icon: Icons.lock_outline,
                                suffixIcon: IconButton(
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
                            const SizedBox(height: 20),
                            _primaryButton(),
                            const SizedBox(height: 12),
                            _googleButton(),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _openRegister,
                              child: Text(
                                'Crear cuenta',
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
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

  Widget _primaryButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _signInWithEmail,
      child: Container(
        width: double.infinity,
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
                  'Iniciar sesión',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return GestureDetector(
      onTap: _isGoogleLoading ? null : _signInWithGoogle,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white24,
          ),
          color: Colors.white.withValues(alpha: 0.03),
        ),
        child: Center(
          child: _isGoogleLoading
              ? const CircularProgressIndicator(
                  color: AppColors.lumenGold,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.g_mobiledata_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Continuar con Google',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
