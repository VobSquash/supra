import 'package:flutter/material.dart';

class LaddersPage extends StatelessWidget {
  const LaddersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        Text('Ladders', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        SizedBox(height: 8),
        Text('Placeholder — port legacy ladders UI; consider leading-edge accent on blocks.'),
      ],
    );
  }
}
