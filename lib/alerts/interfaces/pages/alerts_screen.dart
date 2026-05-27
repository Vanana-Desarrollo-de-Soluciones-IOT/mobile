import 'package:flutter/material.dart';
import 'package:mobile/shared/interfaces/widgets/logout_button.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts'),
        actions: [LogoutButton()],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
