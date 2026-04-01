import 'package:escoge/app/navigation/main_shell.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:escoge/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EscogeApp());
}

class EscogeApp extends StatelessWidget {
  const EscogeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escoge RD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F5FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1736B6),
          primary: const Color(0xFF1736B6),
          secondary: const Color(0xFFE3BE2B),
          // ignore: deprecated_member_use
          background: const Color(0xFFF3F5FB),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xFF1736B6),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF1736B6),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}
