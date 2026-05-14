import 'package:app_bloc/app_bloc.dart';
import 'package:dupra/engine/accessibility/dupra_build_context_accessibility.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Initial route: dispatches session check once; redirect follows from auth state.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthBloc>().add(const AuthEvent.checkRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_tennis_rounded,
              size: context.dupraScaledIconSize(56),
              color: DupraColors.secondary,
            ),
            SizedBox(height: context.dupraScaled(16)),
            Text(
              'Dupra',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: DupraColors.textPrimary,
              ),
            ),
            SizedBox(height: context.dupraScaled(32)),
            SizedBox(
              width: context.dupraScaled(28),
              height: context.dupraScaled(28),
              child: const CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
