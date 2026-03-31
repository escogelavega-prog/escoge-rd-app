import 'package:escoge/core/theme/app_theme.dart';
//import 'package:escoge/features/auth/presentation/login_screen.dart';
import 'package:escoge/features/home/presentation/home_screen.dart';
import 'package:escoge/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('Firebase projectId: ${Firebase.app().options.projectId}');

  runApp(const EscogeApp());
}

class EscogeApp extends StatelessWidget {
  const EscogeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escoge RD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
