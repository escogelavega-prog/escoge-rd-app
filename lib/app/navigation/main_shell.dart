import 'package:flutter/material.dart';

import 'package:escoge/core/widgets/custom_bottom_nav.dart';

import 'package:escoge/features/home/presentation/home_screen.dart';
import 'package:escoge/features/oracion/presentation/oracion_screen.dart';
import 'package:escoge/features/retiros/presentation/retiros_screen.dart';
import 'package:escoge/features/contenido/presentation/contenido_screen.dart';
import 'package:escoge/features/perfil/presentation/perfil_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(
        onOpenOracion: () => _goToTab(1),
        onOpenRetiros: () => _goToTab(2),
        onOpenContenido: () => _goToTab(3),
      ),
      const OracionScreen(),
      const RetirosScreen(),
      const ContenidoScreen(),
      const PerfilScreen(),
    ];
  }

  void _goToTab(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 IMPORTANTE: evita que el teclado rompa el layout
      resizeToAvoidBottomInset: false,

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}