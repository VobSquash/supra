import 'package:dupra/engine/app_router.dart';
import 'package:dupra/engine/theme/dupra_theme.dart';
import 'package:dupra/presentation/widgets/glassic_background.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DupraApp());
}

class DupraApp extends StatelessWidget {
  const DupraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dupra',
      theme: DupraTheme.dark,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return GlassicBackground(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
