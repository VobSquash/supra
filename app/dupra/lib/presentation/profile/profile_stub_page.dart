import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/profile/profile_photo_pick_upload.dart';
import 'package:dupra/presentation/widgets/dupra_avatar.dart';
import 'package:dupra/presentation/widgets/dupra_icon_row.dart';
import 'package:dupra/presentation/widgets/dupra_link_button.dart';
import 'package:dupra/presentation/widgets/dupra_modal.dart';
import 'package:dupra/presentation/widgets/dupra_profile_hero_sliver.dart';
import 'package:dupra/presentation/widgets/dupra_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:middleware/middleware.dart';

part 'widgets/profile_change_password_panel.dart';
part 'widgets/profile_layout_widgets.dart';
part 'widgets/profile_scroll_content.dart';
part 'widgets/profile_sliver_header.dart';

class ProfileStubPage extends StatefulWidget {
  const ProfileStubPage({super.key});

  @override
  State<ProfileStubPage> createState() => _ProfileStubPageState();
}

class _ProfileStubPageState extends State<ProfileStubPage> {
  static const double _headerExtent = 210;
  static const double _avatarRadius = 62;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  IUsersFacade get _users => appBlocSl<IUsersFacade>();
  AuthService get _auth => middlewareSl<AuthService>();

  bool _editing = false;
  bool _saving = false;
  bool _uploadingPhoto = false;

  bool _canShowEmail = true;
  bool _canShowPhone = true;
  bool _canShowDob = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final users = context.read<UsersBloc>();
      if (users.state.currentUserProfile == null) {
        users.add(const UsersEvent.loadCurrentUserProfile());
      }
      final p = users.state.currentUserProfile;
      if (p != null) _applyProfile(p);
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  DateTime? _parseDob(BasicProfileDTO? p) {
    final raw = p?.dateOfBirth?.trim();
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }

  void _applyProfile(BasicProfileDTO? p) {
    _firstName.text = p?.firstName?.trim() ?? '';
    _lastName.text = p?.lastName?.trim() ?? '';
    _canShowEmail = p?.extendedProfile?.canShowEmail ?? true;
    _canShowPhone = p?.extendedProfile?.canShowContactNumber ?? true;
    _canShowDob = p?.extendedProfile?.canShowDateOfBirth ?? false;
  }

  Future<void> _pickPhoto() async {
    setState(() => _uploadingPhoto = true);
    final updated = await ProfilePhotoPickUpload.pickAndUploadFromGallery(context, awaitPickerDelay: true);
    if (!mounted) return;
    setState(() => _uploadingPhoto = false);

    if (updated != null) {
      context.read<UsersBloc>().add(const UsersEvent.loadCurrentUserProfile());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile photo updated'),
          backgroundColor: DupraColors.success.withValues(alpha: 0.92),
        ),
      );
    }
  }

  String? _membershipLabel(BasicProfileDTO? p) {
    final mt = p?.extendedProfile?.membershipType;
    if (mt == null || mt == MembershipTypeEnum.unknown) return null;
    return mt.friendlyName;
  }

  String _nonEmpty(String? s) {
    final t = s?.trim();
    return (t != null && t.isNotEmpty) ? t : '—';
  }

  String _userFacingError(Object e) {
    final s = e.toString().trim();
    if (s.isNotEmpty && s != 'Exception') return s;
    return 'Something went wrong.';
  }

  Future<void> _save(BasicProfileDTO baseline) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final dob = _parseDob(baseline);
    if (dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Your profile is missing a date of birth. Please contact support to complete your record before editing.',
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final dto = UpdateOwnProfileDto(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        contactNumber: baseline.contactNumber?.trim() ?? '',
        emergencyContactNumber: baseline.emergencyContactNumber?.trim() ?? '',
        dateOfBirth: DateTime(dob.year, dob.month, dob.day),
        canShowEmail: _canShowEmail,
        canShowContactNumber: _canShowPhone,
        canShowDateOfBirth: _canShowDob,
        ssaNumber: baseline.extendedProfile?.SSANumber?.trim() ?? '',
      );

      await _users.updateOwnProfile(dto: dto);
      if (!mounted) return;
      context.read<UsersBloc>().add(const UsersEvent.loadCurrentUserProfile());
      setState(() => _editing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Profile updated'), backgroundColor: DupraColors.success.withValues(alpha: 0.92)),
      );
    } catch (e, st) {
      debugPrint('ProfileStubPage _save: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_userFacingError(e)), backgroundColor: Theme.of(context).colorScheme.errorContainer),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _cancelEdit(BasicProfileDTO? p) {
    _applyProfile(p);
    setState(() => _editing = false);
  }

  Future<void> _offerLogout(BuildContext context) {
    return DupraModal.confirm(
      title: 'Log out?',
      message: 'You will need to sign in again to continue.',
      confirmLabel: 'Log out',
      onConfirm: () {
        context.read<AuthBloc>().add(const AuthEvent.signOutRequested());
      },
    ).show(context);
  }

  Future<void> _showPasswordSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
          child: _ChangePasswordPanel(
            onSubmit: (pw) async {
              final result = await _auth.updatePassword(newPassword: pw);
              if (!sheetContext.mounted) return;
              if (result.success) {
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Password updated'),
                    backgroundColor: DupraColors.success.withValues(alpha: 0.92),
                  ),
                );
              } else {
                ScaffoldMessenger.of(
                  sheetContext,
                ).showSnackBar(SnackBar(content: Text(result.errorMessage ?? 'Could not update password')));
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocConsumer<UsersBloc, UsersState>(
      listenWhen: (a, b) => a.currentUserProfile != b.currentUserProfile,
      listener: (context, state) {
        if (!_editing) {
          _applyProfile(state.currentUserProfile);
        }
      },
      builder: (context, usersState) {
        final profile = usersState.currentUserProfile;

        return BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (prev, curr) {
            SessionSnapshot? snap(AuthState s) => s.maybeWhen(authenticated: (v) => v, orElse: () => null);
            final a = snap(prev);
            final b = snap(curr);
            return a?.avatarUrl != b?.avatarUrl || a?.email != b?.email || a?.displayName != b?.displayName;
          },
          builder: (context, authState) {
            final snapshot = authState.maybeWhen(authenticated: (s) => s, orElse: () => null);
            return Scaffold(
              body: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      _ProfileSliverAppBar(
                        expandedHeight: _headerExtent,
                        avatarRadius: _avatarRadius,
                        profile: profile,
                        snapshot: snapshot,
                        uploadingPhoto: _uploadingPhoto,
                        onAvatarTap: _uploadingPhoto ? null : _pickPhoto,
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 24),
                        sliver: SliverToBoxAdapter(
                          child: profile == null
                              ? _ProfileLoadingBody(
                                  onRetry: () {
                                    context.read<UsersBloc>().add(const UsersEvent.loadCurrentUserProfile());
                                  },
                                )
                              : _ProfileScrollContent(
                                  profile: profile,
                                  formKey: _formKey,
                                  firstNameController: _firstName,
                                  lastNameController: _lastName,
                                  editing: _editing,
                                  saving: _saving,
                                  uploadingPhoto: _uploadingPhoto,
                                  canShowEmail: _canShowEmail,
                                  canShowPhone: _canShowPhone,
                                  canShowDob: _canShowDob,
                                  membershipLabel: _membershipLabel(profile) ?? '—',
                                  firstNameRead: _nonEmpty(profile.firstName),
                                  lastNameRead: _nonEmpty(profile.lastName),
                                  emailRead: _nonEmpty(profile.email),
                                  onEdit: () => setState(() => _editing = true),
                                  onCancel: () => _cancelEdit(profile),
                                  onSave: () => _save(profile),
                                  onCanShowEmail: (v) => setState(() => _canShowEmail = v),
                                  onCanShowPhone: (v) => setState(() => _canShowPhone = v),
                                  onCanShowDob: (v) => setState(() => _canShowDob = v),
                                  onPasswordSheet: () => _showPasswordSheet(context),
                                  onLogout: () => _offerLogout(context),
                                  bottomInset: bottomInset,
                                ),
                        ),
                      ),
                    ],
                  ),
                  if (_uploadingPhoto) const _ProfilePhotoUploadOverlay(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
