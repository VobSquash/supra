import 'package:dupra/bootstrap.dart';
import 'package:dupra/dupra_root.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(const DupraRoot());
}
