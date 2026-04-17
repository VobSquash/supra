import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// Default AES key (base64) matching historical portal encryption (`NewEncryptionService`).
const String kDefaultParseNewEncryptionKeyBase64 =
    'RCG191I2rpWOt8HR0l42/IQTP2K4AAryBro0p3e03TA=';

/// IV:cipher text, same as legacy portal `NewEncryptionService`.
class NewEncryptionService {
  NewEncryptionService([String? keyBase64])
      : _keyBase64 = keyBase64 ?? kDefaultParseNewEncryptionKeyBase64;

  final String _keyBase64;
  Key? _key;

  void init() {
    _key = Key.fromBase64(_keyBase64);
  }

  String decryptData(String encryptedData) {
    final key = _key;
    if (key == null) {
      throw StateError('Call init() before decryptData');
    }
    final parts = encryptedData.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid encrypted data format');
    }
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}

/// Legacy AES (C#-compatible) for older `profiles.password` blobs.
class LegacyEncryptionService {
  LegacyEncryptionService() {
    _initializeEncryption();
  }

  late final Key _key;
  late final IV _iv;
  late final Encrypter _encrypter;

  static final Uint8List rawSecretKey = Uint8List.fromList([
    0x06,
    0x01,
    0x03,
    0x13,
    0x18,
    0x21,
    0x02,
    0x13,
    0x05,
    0x16,
    0x14,
    0x10,
    0x23,
    0x19,
    0x24,
    0x14,
  ]);

  void _initializeEncryption() {
    final keyBytes = _generateMd5Key('This!!!_cryptokey-23');
    _key = Key(keyBytes);
    _iv = IV(rawSecretKey);
    _encrypter = Encrypter(AES(_key, mode: AESMode.cbc, padding: 'PKCS7'));
  }

  String? decryptData(String encryptedData) {
    try {
      final fixedBase64 = encryptedData.replaceAll(' ', '+');
      final encrypted = Encrypted.fromBase64(fixedBase64);
      final decryptedBytes = _encrypter.decryptBytes(encrypted, iv: _iv);
      return utf8.decode(decryptedBytes);
    } catch (_) {
      return null;
    }
  }

  Uint8List _generateMd5Key(String passPhrase) {
    final bytes = utf8.encode(passPhrase);
    final digest = md5.convert(bytes);
    return Uint8List.fromList(digest.bytes);
  }
}
