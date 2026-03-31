import 'package:flutter/material.dart';

class DiocesanoDashboardScreen extends StatelessWidget {
  final String diocesisId;

  const DiocesanoDashboardScreen({
    super.key,
    required this.diocesisId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Dashboard Diocesano: $diocesisId'),
      ),
    );
  }
}
