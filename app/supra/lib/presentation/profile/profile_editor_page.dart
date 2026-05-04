import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:middleware/middleware.dart';

import '../../engine/theme/supra_colors.dart';
import '../widgets/profile_avatar.dart';
import 'profile_photo_pick_upload.dart';

/// Full-screen edit form (pushed from [ProfilePage]).
class ProfileEditorPage extends StatefulWidget {
  const ProfileEditorPage({super.key, required this.profile});

  final BasicProfileDTO profile;

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _contactNumber;
  late final TextEditingController _emergencyContactNumber;
  late final TextEditingController _ssaNumber;
  late DateTime? _dob;

  late bool _canShowEmail;
  late bool _canShowContactNumber;
  late bool _canShowDateOfBirth;

  bool _saving = false;
  bool _uploadingPhoto = false;
  String? _errorText;

  late BasicProfileDTO _workingProfile;

  IUsersFacade get _users => appBlocSl<IUsersFacade>();

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _workingProfile = p;

    _firstName = TextEditingController(text: p.firstName?.trim() ?? '');
    _lastName = TextEditingController(text: p.lastName?.trim() ?? '');
    _contactNumber = TextEditingController(text: p.contactNumber?.trim() ?? '');
    _emergencyContactNumber = TextEditingController(text: p.emergencyContactNumber?.trim() ?? '');
    _ssaNumber = TextEditingController(text: p.extendedProfile?.SSANumber?.trim() ?? '');

    _dob = _parseDob(p.dateOfBirth);

    _canShowEmail = p.extendedProfile?.canShowEmail ?? true;
    _canShowContactNumber = p.extendedProfile?.canShowContactNumber ?? true;
    _canShowDateOfBirth = p.extendedProfile?.canShowDateOfBirth ?? false;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _contactNumber.dispose();
    _emergencyContactNumber.dispose();
    _ssaNumber.dispose();
    super.dispose();
  }

  DateTime? _parseDob(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      return DateTime.parse(raw.trim());
    } catch (_) {
      return null;
    }
  }

  String _humanDob(DateTime? dob) {
    if (dob == null) return '';
    const monthNames = <int, String>{
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };
    final month = monthNames[dob.month] ?? dob.month.toString();
    return '${dob.day} $month ${dob.year}';
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 18, now.month, now.day);
    final firstDate = DateTime(1900, 1, 1);
    final lastDate = DateTime(now.year - 6, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(lastDate) ? lastDate : initial,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select your date of birth',
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
      if (fromErr != null && fromErr.isNotEmpty) return fromErr;
      final data = e.response?.data;
      if (data != null && data.toString().trim().isNotEmpty) {
        return data.toString();
      }
      final m = e.message?.trim();
      if (m != null && m.isNotEmpty) return m;
    }
    final s = e.toString().trim();
    if (s.isNotEmpty && s != 'Exception') return s;
    return 'Something went wrong.';
  }

  Future<void> _pickProfilePhoto() async {
    setState(() {
      _uploadingPhoto = true;
      _errorText = null;
    });

    final updated = await ProfilePhotoPickUpload.pickAndUploadFromGallery(
      context,
      awaitPickerDelay: true,
    );

    if (!mounted) return;
    setState(() => _uploadingPhoto = false);

    if (updated != null) {
      setState(() => _workingProfile = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated')),
      );
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    try {
      final dob = _dob;
      if (dob == null) {
        const msg = 'Please set your date of birth.';
        setState(() => _errorText = msg);
        messenger.showSnackBar(
          SnackBar(content: const Text(msg), backgroundColor: Theme.of(context).colorScheme.errorContainer),
        );
        return;
      }

      final dto = UpdateOwnProfileDto(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        contactNumber: _contactNumber.text.trim(),
        emergencyContactNumber: _emergencyContactNumber.text.trim(),
        dateOfBirth: DateTime(dob.year, dob.month, dob.day),
        canShowEmail: _canShowEmail,
        canShowContactNumber: _canShowContactNumber,
        canShowDateOfBirth: _canShowDateOfBirth,
        ssaNumber: _ssaNumber.text.trim(),
      );

      await _users.updateOwnProfile(dto: dto);

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: const Text('Profile updated.'),
          backgroundColor: SupraColors.success.withValues(alpha: 0.9),
        ),
      );
      nav.pop<bool>(true);
    } catch (e, st) {
      debugPrint('ProfileEditorPage _save error: $e\n$st');
      if (!mounted) return;
      final msg = _userMessage(e);
      setState(() {
        _errorText = msg;
      });
      messenger.showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Theme.of(context).colorScheme.errorContainer),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final profile = _workingProfile;
    final email = (profile.email?.trim().isEmpty ?? true) ? null : profile.email!.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
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
                        child: Text(_errorText!, style: textTheme.bodySmall?.copyWith(color: scheme.onErrorContainer)),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                        onPressed: () {
                          setState(() => _errorText = null);
                        },
                        icon: Icon(Icons.close, size: 18, color: scheme.onErrorContainer),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: (_saving || _uploadingPhoto) ? null : _pickProfilePhoto,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ProfileAvatar(
                                      displayName: profile.displayName,
                                      imageUrl: profile.profilePictureUrl,
                                      radius: 36,
                                    ),
                                    if (_uploadingPhoto)
                                      SizedBox(
                                        width: 72,
                                        height: 72,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: scheme.secondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _uploadingPhoto
                                    ? 'Uploading photo…'
                                    : 'Tap to change photo',
                                style: textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Text('Personal info', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text(
                          'Your name and date of birth help the club identify you and confirm age categories.',
                          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _firstName,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(labelText: 'First name', filled: true),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your first name.';
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
                              return 'Please enter your last name.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _pickDob,
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
                                    _dob == null ? 'Tap to select' : _humanDob(_dob),
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
                        Text(
                          'Tell us how to reach you and who to contact in an emergency.',
                          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _contactNumber,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Mobile number',
                            helperText: 'Used by club staff and for account-related messages.',
                            filled: true,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter a contact number.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emergencyContactNumber,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Emergency contact',
                            helperText: 'A number we can call in case of an emergency during activities.',
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Visibility in the directory',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Control what other members can see in the club directory.',
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
                                onChanged: (v) {
                                  setState(() => _canShowEmail = v);
                                },
                                title: const Text('Show my email'),
                                subtitle: const Text('Other members can use this to contact you.'),
                              ),
                              const Divider(height: 1),
                              SwitchListTile(
                                value: _canShowContactNumber,
                                onChanged: (v) {
                                  setState(() => _canShowContactNumber = v);
                                },
                                title: const Text('Show my phone number'),
                                subtitle: const Text('Visible to logged-in club members only.'),
                              ),
                              const Divider(height: 1),
                              SwitchListTile(
                                value: _canShowDateOfBirth,
                                onChanged: (v) {
                                  setState(() => _canShowDateOfBirth = v);
                                },
                                title: const Text('Show my birthday'),
                                subtitle: const Text(
                                  'We’ll still store your date of birth for eligibility checks.',
                                ),
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
                        Text(
                          'If you have an SSA number, you can add it here.',
                          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ssaNumber,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'SSA number',
                            helperText: 'Optional. Leave empty if you don’t have one.',
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (email != null) ...[
                          Text('Account email', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: email,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Email on your account',
                              helperText: 'The club manages your email. Contact the club if this needs to change.',
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (_saving || _uploadingPhoto) ? null : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: (_saving || _uploadingPhoto) ? null : _save,
                        style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: _saving
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : const Text('Save changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
