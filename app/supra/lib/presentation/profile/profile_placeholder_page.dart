import 'package:flutter/material.dart';

import '../../engine/theme/supra_colors.dart';

/// Placeholder until auth-backed profile; opened from the home app bar.
class ProfilePlaceholderPage extends StatelessWidget {
  const ProfilePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 48,
                color: SupraColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Your profile',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Authentication will unlock your member details, preferences, and history.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: SupraColors.textSecondary,
                      height: 1.35,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
