import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _adminResetFunctionName = 'admin-reset-password';

/// Admin: edit another member's profile (`UpdateAdminProfileDto`) + password actions.
class AdminMemberProfileEditPage extends StatefulWidget {
  const AdminMemberProfileEditPage({required this.profile, super.key});

  final BasicProfileDTO profile;

  @override
  State<AdminMemberProfileEditPage> createState() => _AdminMemberProfileEditPageState();
}

class _AdminMemberProfileEditPageState extends State<AdminMemberProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _email;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _contactNumber;
  late final TextEditingController _emergencyContactNumber;
  late final TextEditingController _ssaNumber;
  late DateTime? _dob;

  late bool _isActive;
  late bool _canShowEmail;
  late bool _canShowContactNumber;
  late bool _canShowDateOfBirth;

  bool _submitting = false;
  bool _sendingReset = false;
  String? _errorText;

  bool get _hasRowId {
    final id = widget.profile.objectId?.trim() ?? '';
    return id.isNotEmpty;
  }

  bool get _hasExtension {
    final id = widget.profile.extendedProfile?.objectId?.trim() ?? '';
    return id.isNotEmpty;
  }

  String? get _extensionId {
    final id = widget.profile.extendedProfile?.objectId?.trim();
    if (id == null || id.isEmpty) {
      return null;
    }
    return id;
  }

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _email = TextEditingController(text: p.email?.trim() ?? '');
    _firstName = TextEditingController(text: p.firstName?.trim() ?? '');
    _lastName = TextEditingController(text: p.lastName?.trim() ?? '');
    _contactNumber = TextEditingController(text: p.contactNumber?.trim() ?? '');
    _emergencyContactNumber = TextEditingController(text: p.emergencyContactNumber?.trim() ?? '');
    _ssaNumber = TextEditingController(text: p.extendedProfile?.SSANumber?.trim() ?? '');
    _dob = _parseDob(p.dateOfBirth);
    _isActive = p.isActive ?? false;
    _canShowEmail = p.extendedProfile?.canShowEmail ?? true;
    _canShowContactNumber = p.extendedProfile?.canShowContactNumber ?? true;
    _canShowDateOfBirth = p.extendedProfile?.canShowDateOfBirth ?? false;
  }

  @override
  void dispose() {
    _email.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _contactNumber.dispose();
    _emergencyContactNumber.dispose();
    _ssaNumber.dispose();
    super.dispose();
  }

  DateTime? _parseDob(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(raw.trim());
    } catch (_) {
      return null;
    }
  }

  String _humanDob(BuildContext context, DateTime? dob) {
    if (dob == null) {
      return '';
    }
    final loc = MaterialLocalizations.of(context);
    final d = DateTime(dob.year, dob.month, dob.day);
    return loc.formatMediumDate(d);
  }

  Future<void> _pickDob() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final initial = _dob ?? DateTime(today.year - 18, today.month, today.day);
    final firstDate = DateTime(1900);
    final lastDate = DateTime(today.year - 6, today.month, today.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(lastDate) ? lastDate : initial,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Date of birth',
    );

    if (picked != null) {
      setState(() {
        _dob = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  String _userMessage(Object e) {
    if (e is DioException) {
      final fromErr = e.error?.toString().trim();
      if (fromErr != null && fromErr.isNotEmpty) {
        return fromErr;
      }
      final data = e.response?.data;
      if (data != null && data.toString().trim().isNotEmpty) {
        return data.toString();
      }
      final m = e.message?.trim();
      if (m != null && m.isNotEmpty) {
        return m;
      }
    }
    final s = e.toString().trim();
    if (s.isNotEmpty && s != 'Exception') {
      return s;
    }
    return 'Something went wrong.';
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (_submitting || !_hasRowId) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dob = _dob;
    if (dob == null) {
      const msg = 'Please set date of birth.';
      setState(() => _errorText = msg);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text(msg), backgroundColor: Theme.of(context).colorScheme.errorContainer),
      );
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
    });

    final messenger = ScaffoldMessenger.of(context);
    final trimmedGuid = widget.profile.vobGuid?.trim();
    final vobGuid = (trimmedGuid == null || trimmedGuid.isEmpty) ? null : trimmedGuid;

    try {
      await context.read<UsersBloc>().updateMemberProfileAsAdmin(
            profileRowId: widget.profile.objectId!.trim(),
            vobGuid: vobGuid,
            extensionId: _extensionId,
            dto: UpdateAdminProfileDto(
              email: _email.text.trim(),
              isActive: _isActive,
              firstName: _firstName.text.trim(),
              lastName: _lastName.text.trim(),
              contactNumber: _contactNumber.text.trim(),
              dateOfBirth: DateTime(dob.year, dob.month, dob.day),
              emergencyContactNumber: _emergencyContactNumber.text.trim(),
              canShowEmail: _canShowEmail,
              canShowContactNumber: _canShowContactNumber,
              canShowDateOfBirth: _canShowDateOfBirth,
              ssaNumber: _ssaNumber.text.trim(),
            ),
          );
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Profile updated.'),
          backgroundColor: DupraColors.success.withValues(alpha: 0.92),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e, st) {
      if (!mounted) {
        return;
      }
      debugPrint('AdminMemberProfileEditPage save error: $e\n$st');
      final msg = _userMessage(e);
      setState(() => _errorText = msg);
      messenger.showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  /// Member self-service recovery email (does not expose whether the inbox exists).
  Future<void> _sendPasswordResetEmail() async {
    if (_sendingReset) {
      return;
    }
    final email = _email.text.trim().toLowerCase();
    final messenger = ScaffoldMessenger.of(context);
    if (email.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Enter an email address first.')));
      return;
    }

    setState(() => _sendingReset = true);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        const SnackBar(content: Text('If that account exists, a reset email was sent.')),
      );
    } catch (e, st) {
      if (!mounted) {
        return;
      }
      debugPrint('AdminMemberProfileEditPage reset email error: $e\n$st');
      messenger.showSnackBar(
        SnackBar(
          content: Text(_userMessage(e)),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sendingReset = false);
      }
    }
  }

  /// Elevated-support path via Supabase Edge Function (same contract as legacy Supra app).
  Future<void> _setTemporaryPassword() async {
    if (_sendingReset || !_hasRowId) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const _DupraAdminSetTemporaryPasswordPage(),
      ),
    );
    if (result == null || result.isEmpty) {
      return;
    }

    setState(() => _sendingReset = true);
    try {
      final profileId = widget.profile.objectId!.trim();
      final response = await Supabase.instance.client.functions.invoke(
        _adminResetFunctionName,
        body: <String, dynamic>{
          'target_profile_id': profileId,
          'target_email': _email.text.trim().toLowerCase(),
          'new_password': result,
          'reason': 'admin_support',
        },
      );
      final data = response.data;
      if (response.status >= 400) {
        throw Exception(data is Map && data['error'] != null ? data['error'].toString() : 'Password reset failed.');
      }
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        const SnackBar(content: Text('Temporary password set. Ask the member to change it after login.')),
      );
    } catch (e, st) {
      if (!mounted) {
        return;
      }
      debugPrint('AdminMemberProfileEditPage temporary password error: $e\n$st');
      messenger.showSnackBar(
        SnackBar(
          content: Text(_userMessage(e)),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sendingReset = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final p = widget.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit member (admin)'),
        actions: [
          TextButton(
            onPressed: _submitting || !_hasRowId ? null : _save,
            child: _submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_errorText != null)
              Material(
                color: scheme.errorContainer.withValues(alpha: 0.9),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 20, color: scheme.onErrorContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorText!,
                          style: textTheme.bodySmall?.copyWith(color: scheme.onErrorContainer),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                        onPressed: () => setState(() => _errorText = null),
                        icon: Icon(Icons.close, size: 18, color: scheme.onErrorContainer),
                      ),
                    ],
                  ),
                ),
              ),
            if (!_hasRowId)
              Material(
                color: scheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'This profile has no row id; it cannot be updated from the app.',
                    style: TextStyle(color: scheme.onErrorContainer),
                  ),
                ),
              ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              DupraAvatar(displayName: p.displayName, imageUrl: p.profilePictureUrl, radius: 36),
                              const SizedBox(height: 8),
                              Text(
                                'Photos are chosen by the member in the Dupra profile tab.',
                                style: textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Text('Account', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text(
                          'Email and active status affect sign-in visibility. Updating email may still require aligning Supabase Auth.',
                          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            filled: true,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email is required.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Active'),
                          subtitle: const Text('Inactive users are routed to the inactive admin tab.'),
                          value: _isActive,
                          onChanged: _hasRowId ? (v) => setState(() => _isActive = v) : null,
                        ),
                        const SizedBox(height: 24),
                        Text('Personal info', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text(
                          'Stored for identity and ladders / age thresholds.',
                          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _firstName,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(labelText: 'First name', filled: true),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'First name is required.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _lastName,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(labelText: 'Last name', filled: true),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Last name is required.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _hasRowId ? _pickDob : null,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Date of birth',
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _dob == null ? 'Tap to select' : _humanDob(context, _dob),
                                    style: _dob == null
                                        ? textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)
                                        : textTheme.bodyMedium,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 18,
                                  color: scheme.onSurfaceVariant.withValues(alpha: 0.9),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Contact & emergency',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _contactNumber,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Mobile number',
                            filled: true,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Contact number is required.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_hasExtension)
                          TextFormField(
                            controller: _emergencyContactNumber,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Emergency contact',
                              filled: true,
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'No profile extension row — emergency contact is not stored separately.',
                              style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        const SizedBox(height: 24),
                        if (_hasExtension) ...[
                          Text(
                            'Directory visibility',
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'What logged-in peers can surface in the Dupra roster.',
                            style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
                          ),
                          const SizedBox(height: 12),
                          Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: scheme.outline.withValues(alpha: 0.25)),
                            ),
                            color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
                            child: Column(
                              children: [
                                SwitchListTile(
                                  value: _canShowEmail,
                                  onChanged: _hasRowId ? (v) => setState(() => _canShowEmail = v) : null,
                                  title: const Text('Show email'),
                                  subtitle: const Text('Visible to authenticated members.'),
                                ),
                                const Divider(height: 1),
                                SwitchListTile(
                                  value: _canShowContactNumber,
                                  onChanged: _hasRowId ? (v) => setState(() => _canShowContactNumber = v) : null,
                                  title: const Text('Show phone number'),
                                  subtitle: const Text('Visible to authenticated members only.'),
                                ),
                                const Divider(height: 1),
                                SwitchListTile(
                                  value: _canShowDateOfBirth,
                                  onChanged: _hasRowId ? (v) => setState(() => _canShowDateOfBirth = v) : null,
                                  title: const Text('Show birthday'),
                                  subtitle: const Text('Date of birth is still stored regardless.'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Membership details',
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _ssaNumber,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'SSA number',
                              helperText: 'Optional.',
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        Text(
                          'Password assistance',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Send a generic reset email via Supabase Auth, or invoke the admin-reset edge function '
                          '(requires deployment + permissions parallel to legacy Supra).',
                          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _sendingReset ? null : _setTemporaryPassword,
                          icon: _sendingReset
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                                )
                              : const Icon(Icons.admin_panel_settings_outlined),
                          label: Text(_sendingReset ? 'Updating…' : 'Set temporary password'),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.tonalIcon(
                          onPressed: _sendingReset ? null : _sendPasswordResetEmail,
                          icon: _sendingReset
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                                )
                              : const Icon(Icons.mail_outline),
                          label: Text(_sendingReset ? 'Sending…' : 'Send password reset email'),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
