import 'dart:convert';
import 'dart:io';

import 'stored_password_crypto.dart';

/// Reconstructs the **plaintext login password** from the legacy `profiles.password` column:
/// tries **new** (IV:cipher) decryption first, then **legacy** base64 blob — aligned with
/// `example-files/auth/auth/_credentials.dart`.
///
/// New-format decrypt often yields a base64 **string** that must be decoded again to UTF-8
/// (same behaviour we validated in middleware before Parse was removed).
String? plaintextPasswordFromProfileField(String? encryptedFromDb) {
  if (encryptedFromDb == null || encryptedFromDb.trim().isEmpty) return null;
  final stored = encryptedFromDb.trim();

  final newService = NewEncryptionService()..init();
  try {
    final d = newService.decryptData(stored);
    stdout.writeln('New encryption service: $d');
    return _normalizeDecrypted(d);
  } catch (_) {}

  final legacy = LegacyEncryptionService().decryptData(stored);
  if (legacy == null) return null;
  return _normalizeDecrypted(legacy);
}

String _normalizeDecrypted(String decrypted) {
  final t = decrypted.trim();
  try {
    return utf8.decode(base64.decode(t));
  } catch (_) {
    return t;
  }
}
