part of '../member_profile_detail_page.dart';

enum MemberProfileContactSheetKind { email, phone, dateOfBirth }

/// Bottom sheet for contact fields: launch [mailto:] / [tel:] when applicable and/or copy value.
Future<void> showMemberProfileContactActionSheet({
  required BuildContext context,
  required String fieldTitle,
  required String actionValue,
  required MemberProfileContactSheetKind kind,
  required Future<void> Function(Uri uri) launchUri,
  required String Function(String raw) telDialString,
}) {
  final outerContext = context;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final scheme = Theme.of(sheetContext).colorScheme;
      final textTheme = Theme.of(sheetContext).textTheme;

      Future<void> dismissThenLaunch(Uri uri) async {
        if (!sheetContext.mounted) return;
        Navigator.of(sheetContext).pop();
        if (!outerContext.mounted) return;
        await launchUri(uri);
      }

      Future<void> copyValue() async {
        await Clipboard.setData(ClipboardData(text: actionValue));
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
            Text(fieldTitle, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: SelectableText(actionValue, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),
            if (kind == MemberProfileContactSheetKind.email) ...[
              FilledButton.icon(
                onPressed: () => dismissThenLaunch(Uri.parse('mailto:$actionValue')),
                icon: const Icon(Icons.mail_outline_rounded),
                label: const Text('Send email'),
              ),
              const SizedBox(height: 12),
            ],
            if (kind == MemberProfileContactSheetKind.phone) ...[
              FilledButton.icon(
                onPressed: () => dismissThenLaunch(Uri.parse('tel:${telDialString(actionValue)}')),
                icon: const Icon(Icons.call_rounded),
                label: const Text('Call'),
              ),
              const SizedBox(height: 12),
            ],
            if (kind == MemberProfileContactSheetKind.dateOfBirth) ...[
              FilledButton.icon(
                onPressed: () => {},
                icon: const Icon(Icons.calendar_month_rounded),
                label: const Text('Birthday'),
              ),
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: copyValue,
              icon: const Icon(Icons.copy_rounded),
              label: Text(kind == MemberProfileContactSheetKind.dateOfBirth ? 'Copy' : 'Copy to clipboard'),
            ),
          ],
        ),
      );
    },
  );
}
