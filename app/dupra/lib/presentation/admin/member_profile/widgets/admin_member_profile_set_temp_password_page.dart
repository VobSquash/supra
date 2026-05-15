part of '../../admin_member_profile_edit_page.dart';

class _DupraAdminSetTemporaryPasswordPage extends StatefulWidget {
  const _DupraAdminSetTemporaryPasswordPage();

  @override
  State<_DupraAdminSetTemporaryPasswordPage> createState() => _DupraAdminSetTemporaryPasswordPageState();
}

class _DupraAdminSetTemporaryPasswordPageState extends State<_DupraAdminSetTemporaryPasswordPage> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final messenger = ScaffoldMessenger.of(context);
    final p1 = _passController.text.trim();
    final p2 = _confirmController.text.trim();
    if (p1.length < 8) {
      messenger.showSnackBar(const SnackBar(content: Text('Password must be at least 8 characters.')));
      return;
    }
    if (p1 != p2) {
      messenger.showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }
    Navigator.of(context).pop(p1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set temporary password')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: _passController,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Temporary password',
                helperText: 'Minimum 8 characters.',
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: const Text('Set password')),
          ],
        ),
      ),
    );
  }
}
