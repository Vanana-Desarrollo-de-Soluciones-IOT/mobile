import 'package:flutter/material.dart';
import 'package:mobile/shared/interfaces/widgets/logout_button.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        actions: [LogoutButton()],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
