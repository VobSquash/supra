import 'package:flutter/material.dart';

import 'bootstrap.dart';
import 'engine/route.dart';
import 'engine/theme/supra_theme.dart';
import 'shared/widgets/glassic_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(const SupraTestApp());
}

class SupraTestApp extends StatelessWidget {
  const SupraTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supra',
      theme: SupraTheme.dark,
      initialRoute: RouteNames.initial,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
        return GlassicBackground(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
