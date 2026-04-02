import 'package:flutter/material.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Tu usuario no tiene acceso o no está activo.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
