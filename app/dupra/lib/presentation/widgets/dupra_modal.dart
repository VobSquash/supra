import 'package:flutter/material.dart';

/// Shared alert dialogs. Cancel only pops the route; the primary button pops then runs
/// `onConfirm` when the originating `BuildContext` is still mounted.
class DupraModal {
  DupraModal._({
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.primaryLabel,
    required this.cancelLabel,
    required this.barrierDismissible,
    required this.destructive,
  });

  /// Defaults: primary label `Confirm`, `destructive` false.
  factory DupraModal.confirm({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool barrierDismissible = false,
    bool destructive = false,
  }) {
    return DupraModal._(
      title: title,
      message: message,
      onConfirm: onConfirm,
      primaryLabel: confirmLabel,
      cancelLabel: cancelLabel,
      barrierDismissible: barrierDismissible,
      destructive: destructive,
    );
  }

  /// Defaults: primary label `Save`, theme-styled primary (non-destructive).
  factory DupraModal.save({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String saveLabel = 'Save',
    String cancelLabel = 'Cancel',
    bool barrierDismissible = false,
  }) {
    return DupraModal._(
      title: title,
      message: message,
      onConfirm: onConfirm,
      primaryLabel: saveLabel,
      cancelLabel: cancelLabel,
      barrierDismissible: barrierDismissible,
      destructive: false,
    );
  }

  final String title;
  final String message;
  final VoidCallback onConfirm;
  final String primaryLabel;
  final String cancelLabel;
  final bool barrierDismissible;

  /// When true, primary `FilledButton` uses error / on-error colors from the dialog theme.
  final bool destructive;

  Future<void> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelLabel),
            ),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: scheme.error,
                      foregroundColor: scheme.onError,
                    )
                  : null,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(primaryLabel),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;
    onConfirm();
  }
}
