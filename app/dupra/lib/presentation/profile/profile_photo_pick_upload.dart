import 'package:client_models/client_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middleware/middleware.dart';

/// Gallery pick plus [IUsersFacade.uploadOwnProfilePicture].
///
/// After closing a sheet or dialog, await [delayBeforeOpeningPicker] before
/// opening the picker to avoid iOS channel races.
class ProfilePhotoPickUpload {
  ProfilePhotoPickUpload._();

  static IUsersFacade get _users => middlewareSl<IUsersFacade>();

  static Future<void> delayBeforeOpeningPicker() async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
  }

  static String userFacingMessage(Object e) {
    if (e is PlatformException) {
      if (e.code == 'channel-error') {
        return 'Photo library could not open yet. Try again in a moment.';
      }
      final m = e.message?.trim();
      if (m != null && m.isNotEmpty) return m;
    }
    final s = e.toString().trim();
    if (s.isNotEmpty && s != 'Exception') return s;
    return 'Something went wrong.';
  }

  static Future<BasicProfileDTO?> pickAndUploadFromGallery(
    BuildContext context, {
    bool awaitPickerDelay = false,
  }) async {
    if (awaitPickerDelay) {
      await delayBeforeOpeningPicker();
    }
    if (!context.mounted) return null;

    final picker = ImagePicker();
    XFile? x;
    try {
      x = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1600, maxHeight: 1600, imageQuality: 88);
    } on PlatformException catch (e, st) {
      debugPrint('ProfilePhotoPickUpload.pickImage: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(userFacingMessage(e))));
      }
      return null;
    } catch (e, st) {
      debugPrint('ProfilePhotoPickUpload.pickImage: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(userFacingMessage(e))));
      }
      return null;
    }

    if (x == null || !context.mounted) return null;

    final bytes = await x.readAsBytes();
    final mime = x.mimeType ?? 'image/jpeg';

    try {
      return await _users.uploadOwnProfilePicture(bytes: bytes, contentType: mime);
    } catch (e, st) {
      debugPrint('ProfilePhotoPickUpload.upload: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(userFacingMessage(e))));
      }
      return null;
    }
  }
}
