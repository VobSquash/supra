/// The entrypoint for the **client** app.
///
/// This file is compiled to javascript and executed on the client when loading the page.
library;

import 'package:jaspr/client.dart';

import 'bootstrap.dart';
import 'root_app.dart';

Future<void> main() async {
  await bootstrapKali();
  runApp(const RootApp());
}
