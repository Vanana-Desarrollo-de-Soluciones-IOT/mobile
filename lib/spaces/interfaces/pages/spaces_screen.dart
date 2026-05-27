import 'package:flutter/material.dart';
import 'package:mobile/shared/interfaces/widgets/logout_button.dart';

class SpacesScreen extends StatelessWidget {
  const SpacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spaces'),
        actions: [LogoutButton()],
      ),
      body: const SizedBox.shrink(),
    );
  }
}
