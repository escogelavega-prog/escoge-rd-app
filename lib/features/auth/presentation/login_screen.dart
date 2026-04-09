import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/home.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Overlay oscuro
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),

          /// Contenido
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        /// Logo
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.black54,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Título
                        Text(
                          'Iniciar Sesión',
                          style: GoogleFonts.lora(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// Card del formulario
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.78),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Correo Electrónico',
                                  prefixIcon: const Icon(Icons.mail_outline),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon:
                                      const Icon(Icons.visibility_outlined),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD4AF37),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Iniciar Sesión',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.g_mobiledata, size: 28),
                                  label: Text(
                                    'Continuar con Google',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '¿No tienes una cuenta?',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black54,
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
          ),
        ],
      ),
    );
  }
}
