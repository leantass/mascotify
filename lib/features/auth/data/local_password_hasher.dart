import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class LocalPasswordHasher {
  const LocalPasswordHasher._();

  static const String _algorithm = 'pbkdf2-sha256';
  static const int _iterations = 12000;
  static const int _keyLength = 32;

  static String hashPassword(String rawPassword, {required String salt}) {
    final saltDigest = _saltDigest(salt);
    final derivedKey = _pbkdf2(
      password: utf8.encode(rawPassword),
      salt: utf8.encode(saltDigest),
      iterations: _iterations,
      keyLength: _keyLength,
    );

    return [
      _algorithm,
      _iterations.toString(),
      saltDigest,
      base64Url.encode(derivedKey),
    ].join(r'$');
  }

  static bool verifyPassword({
    required String rawPassword,
    required String salt,
    required String storedHash,
  }) {
    if (storedHash.startsWith('$_algorithm\$')) {
      return _constantTimeEquals(
        hashPassword(rawPassword, salt: salt),
        storedHash,
      );
    }

    return _constantTimeEquals(_legacyFnvHash(rawPassword), storedHash);
  }

  static bool needsRehash(String storedHash) {
    return !storedHash.startsWith('$_algorithm\$');
  }

  static String _saltDigest(String salt) {
    return sha256
        .convert(utf8.encode('mascotify-local-auth-salt::$salt'))
        .toString();
  }

  static Uint8List _pbkdf2({
    required List<int> password,
    required List<int> salt,
    required int iterations,
    required int keyLength,
  }) {
    final hmac = Hmac(sha256, password);
    final digestLength = hmac.convert(<int>[]).bytes.length;
    final blockCount = (keyLength / digestLength).ceil();
    final result = BytesBuilder(copy: false);

    for (var blockIndex = 1; blockIndex <= blockCount; blockIndex++) {
      final blockSalt = <int>[
        ...salt,
        (blockIndex >> 24) & 0xff,
        (blockIndex >> 16) & 0xff,
        (blockIndex >> 8) & 0xff,
        blockIndex & 0xff,
      ];
      var digest = hmac.convert(blockSalt).bytes;
      final block = Uint8List.fromList(digest);

      for (var i = 1; i < iterations; i++) {
        digest = hmac.convert(digest).bytes;
        for (var j = 0; j < block.length; j++) {
          block[j] ^= digest[j];
        }
      }

      result.add(block);
    }

    return Uint8List.sublistView(result.toBytes(), 0, keyLength);
  }

  static bool _constantTimeEquals(String left, String right) {
    final leftBytes = utf8.encode(left);
    final rightBytes = utf8.encode(right);
    var diff = leftBytes.length ^ rightBytes.length;
    final maxLength = leftBytes.length > rightBytes.length
        ? leftBytes.length
        : rightBytes.length;

    for (var i = 0; i < maxLength; i++) {
      final leftByte = i < leftBytes.length ? leftBytes[i] : 0;
      final rightByte = i < rightBytes.length ? rightBytes[i] : 0;
      diff |= leftByte ^ rightByte;
    }

    return diff == 0;
  }

  static String _legacyFnvHash(String rawPassword) {
    final offsetBasis = BigInt.parse('cbf29ce484222325', radix: 16);
    final prime = BigInt.parse('100000001b3', radix: 16);
    final mask = BigInt.parse('ffffffffffffffff', radix: 16);
    final bytes = utf8.encode('mascotify-local-auth::$rawPassword');

    var hash = offsetBasis;
    for (final byte in bytes) {
      hash ^= BigInt.from(byte);
      hash = (hash * prime) & mask;
    }

    return hash.toRadixString(16).padLeft(16, '0');
  }
}
