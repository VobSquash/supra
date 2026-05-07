import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key, this.embedInShell = false});

  /// When true, content only — the root shell provides the app bar and dock.
  final bool embedInShell;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final padding = embedInShell
        ? EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset + 72)
        : const EdgeInsets.all(24);

    final body = ListView(
      padding: padding,
      children: const [
        Text('Users', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        SizedBox(height: 8),
        Text('Placeholder — list of users.'),
      ],
    );

    if (embedInShell) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: body,
    );
  }
}
