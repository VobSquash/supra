import 'package:client_models/client_models.dart';
import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

enum DupraActiobSheetKind { email, phone, dateOfBirth }

Future<void> dupraLaunchExternalUri(Uri uri) async {
  final ok = await canLaunchUrl(uri);
  if (!ok) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Strips to dialable digits (SA local `0…` when possible).
String dupraTelDialForDialer(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 9) {
    digits = '0$digits';
  } else if (digits.startsWith('27') && digits.length >= 11) {
    digits = '0${digits.substring(2)}';
  }
  return digits;
}

/// Display format for SA mobiles/lines: `(082) 123 4567`.
///
/// Falls back to trimmed [raw] when the number cannot be normalised to 10 digits.
String dupraFormatPhoneForDisplay(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return trimmed;

  final formatted = trimmed.toPhoneNumber();
  if (formatted != trimmed) {
    return formatted.replaceFirst('-', ' ');
  }
  return trimmed;
}

/// Bottom sheet for contact fields: launch [mailto:] / [tel:] when applicable and/or copy value.
Future<void> showContactInfoBottomSheet({
  required BuildContext context,
  required String fieldTitle,
  required String actionValue,
  required DupraActiobSheetKind kind,
  required Future<void> Function(Uri uri) launchUri,
  required String Function(String raw) telDialString,
}) {
  final outerContext = context;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final textTheme = Theme.of(sheetContext).textTheme;
      final displayValue = kind == DupraActiobSheetKind.phone
          ? dupraFormatPhoneForDisplay(actionValue)
          : actionValue;

      Future<void> dismissThenLaunch(Uri uri) async {
        if (!sheetContext.mounted) return;
        Navigator.of(sheetContext).pop();
        if (!outerContext.mounted) return;
        await launchUri(uri);
      }

      Future<void> copyValue() async {
        await Clipboard.setData(ClipboardData(text: displayValue));
        if (!sheetContext.mounted) return;
        Navigator.of(sheetContext).pop();
        if (!outerContext.mounted) return;
        ScaffoldMessenger.of(
          outerContext,
        ).showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, content: Text('Copied to clipboard')));
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fieldTitle, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                SelectableText(
                  displayValue,
                  style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: DupraColors.secondary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (kind == DupraActiobSheetKind.email) ...[
              FilledButton.icon(
                onPressed: () => dismissThenLaunch(Uri.parse('mailto:$actionValue')),
                icon: const Icon(Icons.mail_outline_rounded),
                label: const Text('Send email'),
              ),
              const SizedBox(height: 12),
            ],
            if (kind == DupraActiobSheetKind.phone) ...[
              FilledButton.icon(
                onPressed: () => dismissThenLaunch(Uri.parse('tel:${telDialString(actionValue)}')),
                icon: const Icon(Icons.call_rounded),
                label: const Text('Call'),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => dismissThenLaunch(Uri.parse('whatsapp://send?phone=${telDialString(actionValue)}')),
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Launch Whatsapp'),
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
              ),

              const SizedBox(height: 12),
            ],
            if (kind == DupraActiobSheetKind.dateOfBirth) ...[
              FilledButton.icon(
                onPressed: () => {},
                icon: const Icon(Icons.calendar_month_rounded),
                label: const Text('Birthday'),
              ),
              const SizedBox(height: 12),
            ],

            FilledButton.icon(
              onPressed: copyValue,
              icon: const Icon(Icons.copy_rounded),
              label: Text(kind == DupraActiobSheetKind.dateOfBirth ? 'Copy' : 'Copy to clipboard'),
              style: FilledButton.styleFrom(backgroundColor: DupraColors.textSecondary),
            ),
          ],
        ),
      );
    },
  );
}
