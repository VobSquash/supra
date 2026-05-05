import 'package:flutter/material.dart';

class ProfileStubPage extends StatelessWidget {
  const ProfileStubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile shell — scrolling header in production.'),
      ),
    );
  }
}
