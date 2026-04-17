import 'package:app_bloc/app_bloc.dart';
import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../engine/theme/supra_colors.dart';

/// Full-screen admin flow: insert [profiles] + [profile_extensions] via [UsersBloc].
///
/// Push with [Navigator.push] and wrap with
/// `BlocProvider<UsersBloc>.value(value: context.read<UsersBloc>(), child: AddMemberProfilePage())`
/// so this shares the same [UsersBloc] instance as [UsersTestPage] (GetIt registers [UsersBloc] as a factory).
class AddMemberProfilePage extends StatefulWidget {
  const AddMemberProfilePage({super.key});

  @override
  State<AddMemberProfilePage> createState() => _AddMemberProfilePageState();
}

class _AddMemberProfilePageState extends State<AddMemberProfilePage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _contact = TextEditingController();
  final _emergency = TextEditingController();

  DateTime _dob = DateTime(1990, 1, 1);
  MembershipTypeEnum _membership = MembershipTypeEnum.social;
  bool _submitting = false;

  static Iterable<MembershipTypeEnum> get _membershipChoices =>
      MembershipTypeEnum.values.where((e) => e != MembershipTypeEnum.unknown);

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _contact.dispose();
    _emergency.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;

    final messenger = ScaffoldMessenger.of(context);

    setState(() => _submitting = true);
    try {
      await context.read<UsersBloc>().createMemberProfileAsAdmin(
        dto: CreateMemberProfileDto(
          firstName: _firstName.text,
          lastName: _lastName.text,
          email: _email.text,
          contactNumber: _contact.text,
          emergencyContactNumber: _emergency.text,
          dateOfBirth: _dob,
          membershipType: _membership,
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e, st) {
      if (!mounted) return;
      final msg = _userMessage(e);
      debugPrint('AddMemberProfilePage error: $e\n$st');
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
    return 'Could not create profile.';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add member profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Text(
              'Creates profile + extension rows (no login account). Requires admin or elevated access in session; server RLS must allow the insert.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SupraColors.textSecondary,
                    height: 1.35,
                  ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _firstName,
              enabled: !_submitting,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'First name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastName,
              enabled: !_submitting,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Last name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              enabled: !_submitting,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contact,
              enabled: !_submitting,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emergency,
              enabled: !_submitting,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Emergency contact number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date of birth'),
              subtitle: Text(_dob.formateDateForUi()),
              trailing: const Icon(Icons.calendar_month_outlined),
              onTap: _submitting ? null : _pickDob,
            ),
            const SizedBox(height: 8),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Membership type',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MembershipTypeEnum>(
                  isExpanded: true,
                  value: _membership,
                  items: [
                    for (final m in _membershipChoices)
                      DropdownMenuItem(value: m, child: Text(m.friendlyName)),
                  ],
                  onChanged: _submitting
                      ? null
                      : (v) {
                          if (v == null) return;
                          setState(() => _membership = v);
                        },
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: scheme.onPrimary,
                      ),
                    )
                  : const Text('Create profile'),
            ),
          ],
        ),
      ),
    );
  }
}
