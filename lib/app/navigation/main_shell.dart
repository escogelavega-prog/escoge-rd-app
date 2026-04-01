import 'package:flutter/material.dart';

import 'package:escoge/core/widgets/custom_bottom_nav.dart';
import 'package:escoge/features/contenido/presentation/contenido_screen.dart';
import 'package:escoge/features/home/presentation/home_screen.dart';
import 'package:escoge/features/oracion/presentation/oracion_screen.dart';
import 'package:escoge/features/perfil/presentation/perfil_screen.dart';
import 'package:escoge/features/retiros/presentation/retiros_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _goToTab(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      _goToTab(0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        onOpenOracion: () => _goToTab(1),
        onOpenRetiros: () => _goToTab(2),
        onOpenContenido: () => _goToTab(3),
        onOpenPerfil: () => _goToTab(4),
      ),
      const OracionScreen(),
      const RetirosScreen(),
      const ContenidoScreen(),
      const PerfilScreen(),
    ];

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: _goToTab,
        ),
      ),
    );
  }
}
