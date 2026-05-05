import 'package:flutter/material.dart';

class AdminHubPage extends StatelessWidget {
  const AdminHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        Text('Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        SizedBox(height: 8),
        Text('Placeholder — bookings, ladder management, users, create members (see preserve.md).'),
      ],
    );
  }
}
