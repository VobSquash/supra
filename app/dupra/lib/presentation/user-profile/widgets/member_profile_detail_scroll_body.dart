part of '../member_profile_detail_page.dart';

class _MemberProfileDetailScrollBody extends StatelessWidget {
  const _MemberProfileDetailScrollBody({
    required this.resolvedMembershipType,
    required this.textTheme,
    required this.scheme,
    required this.emergencyLine,
    required this.contactRows,
    required this.onOpenEmergencyPressed,
  });

  final String resolvedMembershipType;
  final TextTheme textTheme;
  final ColorScheme scheme;
  final String? emergencyLine;
  final List<Widget> contactRows;
  final VoidCallback? onOpenEmergencyPressed;

  @override
  Widget build(BuildContext context) {
    final emergency = emergencyLine;
    final openEmergency = onOpenEmergencyPressed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            resolvedMembershipType,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        DupraSection(
          title: 'Emergency',
          cardChild: Column(
            children: [
              if (emergency != null && openEmergency != null)
                DupraActionIconRow(
                  scheme: scheme,
                  textTheme: textTheme,
                  icon: Icons.emergency_rounded,
                  iconAccentColor: DupraColors.warning,
                  label: 'Contact number',
                  value: emergency,
                  onPressed: openEmergency,
                )
              else if (emergency != null)
                _MemberProfileDetailRow(
                  scheme: scheme,
                  textTheme: textTheme,
                  icon: Icons.emergency_rounded,
                  label: 'Contact number',
                  value: emergency,
                )
              else
                _MemberProfileDetailRow(
                  scheme: scheme,
                  textTheme: textTheme,
                  icon: Icons.emergency_rounded,
                  label: 'Contact number',
                  value: 'Not provided',
                ),
            ],
          ),
        ),
        if (contactRows.isNotEmpty)
          DupraSection(
            title: 'Contact',
            cardChild: Column(children: contactRows),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Contact details are hidden based on this member's privacy settings.",
              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.72)),
            ),
          ),
      ],
    );
  }
}
