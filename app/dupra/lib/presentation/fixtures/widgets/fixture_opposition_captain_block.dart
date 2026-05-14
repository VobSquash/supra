import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:dupra/presentation/widgets/dupra_contact_action_sheet.dart';
import 'package:dupra/presentation/widgets/dupra_contact_icon_row.dart';
import 'package:flutter/material.dart';

/// Captain name + phone row (opens contact sheet), or fallback copy when phone/name missing.
class FixtureOppositionCaptainBlock extends StatelessWidget {
  const FixtureOppositionCaptainBlock({
    required this.captainName,
    required this.phone,
    required this.scheme,
    required this.textTheme,
    super.key,
  });

  final String? captainName;
  final String? phone;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final name = captainName?.trim();
    final tel = phone?.trim();

    if (name != null && name.isNotEmpty && tel != null && tel.isNotEmpty) {
      return DupraActionIconRow(
        wrapWithCard: true,
        scheme: scheme,
        textTheme: textTheme,
        icon: Icons.phone_outlined,
        iconAccentColor: scheme.primary,
        label: name,
        value: tel,
        onPressed: () => showContactInfoBottomSheet(
          context: context,
          fieldTitle: name,
          actionValue: tel,
          kind: DupraActiobSheetKind.phone,
          launchUri: dupraLaunchExternalUri,
          telDialString: dupraTelDialForDialer,
        ),
      );
    }

    if (name != null && name.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, height: 1.25)),
          const SizedBox(height: 6),
          Text(
            'No phone number on file',
            style: textTheme.bodySmall?.copyWith(color: DupraColors.textSecondary),
          ),
        ],
      );
    }

    return Text('Not listed', style: textTheme.bodyMedium?.copyWith(color: DupraColors.textSecondary));
  }
}
