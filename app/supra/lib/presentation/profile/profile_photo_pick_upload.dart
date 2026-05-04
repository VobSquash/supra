import 'package:client_models/client_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middleware/middleware.dart';

/// Gallery pick + [IUsersFacade.uploadOwnProfilePicture].
///
/// On iOS, opening [ImagePicker] while another modal route (dialog/sheet) is
/// still tearing down commonly triggers pigeon `channel-error`. Callers should
/// close sheets/dialogs first, then await [delayBeforeOpeningPicker].
class ProfilePhotoPickUpload {
  ProfilePhotoPickUpload._();

  static IUsersFacade get _users => middlewareSl<IUsersFacade>();

  /// Pause so platform channels are ready (use after closing a modal bottom sheet).
  static Future<void> delayBeforeOpeningPicker() async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
  }

  static String userFacingMessage(Object e) {
    if (e is PlatformException) {
      if (e.code == 'channel-error') {
        return 'Photo library could not open yet. Try again in a moment, or fully quit and restart the app.';
      }
      final m = e.message?.trim();
      if (m != null && m.isNotEmpty) return m;
    }
    if (e is DioException) {
      final fromErr = e.error?.toString().trim();
      if (fromErr != null && fromErr.isNotEmpty) return fromErr;
      final data = e.response?.data;
      if (data != null && data.toString().trim().isNotEmpty) {
        return data.toString();
      }
      final msg = e.message?.trim();
      if (msg != null && msg.isNotEmpty) return msg;
    }
    final s = e.toString().trim();
    if (s.isNotEmpty && s != 'Exception') return s;
    return 'Something went wrong.';
  }

  /// Returns updated profile after upload, or `null` if cancelled / failed.
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
      x = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 88,
      );
    } on PlatformException catch (e, st) {
      debugPrint('ProfilePhotoPickUpload.pickImage: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text(userFacingMessage(e))),
        );
      }
      return null;
    } catch (e, st) {
      debugPrint('ProfilePhotoPickUpload.pickImage: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text(userFacingMessage(e))),
        );
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
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text(userFacingMessage(e))),
        );
      }
      return null;
    }
  }
}
