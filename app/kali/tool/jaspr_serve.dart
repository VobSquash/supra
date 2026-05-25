import 'dart:io';

/// IDE launch entry: runs the Jaspr dev server without requiring a globally
/// activated `jaspr` on PATH.
///
/// If you see **Address already in use**, another `jaspr serve` (or the same app
/// started twice from the IDE) is still holding **8080** / **5467** / **5567**
/// (or the `--web-port` / `--proxy-port` you chose). Stop that terminal (**Ctrl+C**)
/// or `lsof`/ `kill`; see **`README.md`** in this package.
///
/// Extra args from the launch config are appended (see `.vscode/launch.json`).
Future<void> main(List<String> args) async {
  final process = await Process.start(
    'dart',
    ['run', 'jaspr_cli:jaspr', 'serve', ...args],
    mode: ProcessStartMode.inheritStdio,
  );
  exit(await process.exitCode);
}
