import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../engine/route.dart';
import '../../engine/theme/supra_colors.dart';
import 'profile_photo_pick_upload.dart';

/// Shows after login when the member has no profile photo yet.
///
/// The sheet closes before opening the gallery so iOS image_picker pigeon channels stay connected.
Future<void> showProfilePhotoOnboardingSheet({
  required BuildContext context,
  required SharedPreferences prefs,
  required String skippedPrefsKey,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (sheetCtx) {
      final scheme = Theme.of(sheetCtx).colorScheme;
      final textTheme = Theme.of(sheetCtx).textTheme;
      final bottomInset = MediaQuery.paddingOf(sheetCtx).bottom;

      Future<void> onSkip() async {
        await prefs.setBool(skippedPrefsKey, true);
        if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
      }

      Future<void> onChoosePhoto() async {
        final nav = Navigator.of(context);
        Navigator.of(sheetCtx).pop();
        final updated = await ProfilePhotoPickUpload.pickAndUploadFromGallery(
          context,
          awaitPickerDelay: true,
        );
        if (!context.mounted) return;
        if (updated != null) {
          nav.pushNamed(RouteNames.profile);
        }
      }

      return Padding(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 24 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add a profile photo',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Others see your photo on bookings, member lists, and ladders. '
              'You can skip and add one anytime from Profile.',
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onChoosePhoto,
              icon: const Icon(Icons.photo_library_outlined, size: 20),
              label: const Text('Choose from library'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: SupraColors.secondary,
                foregroundColor: const Color(0xFF0a0a0a),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onSkip,
              child: const Text('Skip for now'),
            ),
          ],
        ),
      );
    },
  );
}
