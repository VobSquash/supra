part of '../member_profile_detail_page.dart';

List<Widget> buildMemberProfileContactRows({
  required BuildContext context,
  required ColorScheme scheme,
  required TextTheme textTheme,
  required bool showEmail,
  required String? email,
  required bool showPhone,
  required String? phone,
  required bool showDob,
  required String? dob,
  required Future<void> Function(Uri uri) onOpenUri,
  required String Function(String raw) telDialString,
}) {
  void openSheet(MemberProfileContactSheetKind kind, String fieldTitle, String value) {
    showMemberProfileContactActionSheet(
      context: context,
      fieldTitle: fieldTitle,
      actionValue: value,
      kind: kind,
      launchUri: onOpenUri,
      telDialString: telDialString,
    );
  }

  final contactRows = <Widget>[];
  void pushDivider() {
    if (contactRows.isNotEmpty) {
      contactRows.add(Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.1)));
    }
  }

  if (showEmail && email != null && email.isNotEmpty) {
    pushDivider();
    contactRows.add(
      _MemberProfileContactIconRow(
        scheme: scheme,
        textTheme: textTheme,
        icon: Icons.mail_outline_rounded,
        iconAccentColor: scheme.primary,
        label: 'Email',
        value: email,
        onPressed: () => openSheet(MemberProfileContactSheetKind.email, 'Email', email),
      ),
    );
  }
  if (showPhone && phone != null && phone.isNotEmpty) {
    pushDivider();
    contactRows.add(
      _MemberProfileContactIconRow(
        scheme: scheme,
        textTheme: textTheme,
        icon: Icons.phone_outlined,
        iconAccentColor: scheme.primary,
        label: 'Phone',
        value: phone,
        onPressed: () => openSheet(MemberProfileContactSheetKind.phone, 'Phone', phone),
      ),
    );
  }
  if (showDob && dob != null && dob.isNotEmpty) {
    pushDivider();
    contactRows.add(
      _MemberProfileContactIconRow(
        scheme: scheme,
        textTheme: textTheme,
        icon: Icons.calendar_today_outlined,
        iconAccentColor: scheme.primary,
        label: 'Date of birth',
        value: dob.toDMMMMY(),
        onPressed: () => openSheet(MemberProfileContactSheetKind.dateOfBirth, 'Date of birth', dob),
      ),
    );
  }

  return contactRows;
}

class _MemberProfileContactIconRow extends StatelessWidget {
  const _MemberProfileContactIconRow({
    required this.scheme,
    required this.textTheme,
    required this.icon,
    required this.iconAccentColor,
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final ColorScheme scheme;
  final TextTheme textTheme;
  final IconData icon;
  final Color iconAccentColor;
  final String label;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DupraIconRow(
      onTap: onPressed,
      contentPadding: const EdgeInsets.only(left: 15, right: 5, top: 12, bottom: 12),
      icon: icon,
      iconAccentColor: iconAccentColor,
      leadingEdgeAccent: true,
      trailing: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
      ),
      child: _MemberProfileLabelValue(
        label: label,
        value: value,
        textTheme: textTheme,
        scheme: scheme,
        emphasizeValue: true,
      ),
    );
  }
}

class _MemberProfileDetailRow extends StatelessWidget {
  const _MemberProfileDetailRow({
    required this.scheme,
    required this.textTheme,
    required this.icon,
    required this.label,
    required this.value,
  });

  final ColorScheme scheme;
  final TextTheme textTheme;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DupraIconRow(
      icon: icon,
      iconAccentColor: scheme.primary,
      leadingEdgeAccent: true,
      child: _MemberProfileLabelValue(label: label, value: value, textTheme: textTheme, scheme: scheme),
    );
  }
}

/// Matches profile `_ReadOnlyLine` typography.
class _MemberProfileLabelValue extends StatelessWidget {
  const _MemberProfileLabelValue({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.scheme,
    this.emphasizeValue = false,
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final ColorScheme scheme;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.25)),
        const SizedBox(height: 4),
        Text(
          value,
          style: emphasizeValue
              ? textTheme.titleSmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600)
              : textTheme.titleSmall?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
