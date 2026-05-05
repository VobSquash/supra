import 'package:flutter/material.dart';

class FixturesPage extends StatelessWidget {
  const FixturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        Text('Fixtures', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        SizedBox(height: 8),
        Text('Placeholder — keep home/away and “no catering” blocks equal height.'),
      ],
    );
  }
}
