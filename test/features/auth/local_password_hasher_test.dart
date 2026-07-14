import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/auth/data/local_password_hasher.dart';

void main() {
  group('LocalPasswordHasher', () {
    test('hashes and verifies local passwords with a versioned record', () {
      final hash = LocalPasswordHasher.hashPassword(
        'Mascotify123',
        salt: 'camila@mascotify.app',
      );

      expect(hash, startsWith(r'pbkdf2-sha256$'));
      expect(
        LocalPasswordHasher.verifyPassword(
          rawPassword: 'Mascotify123',
          salt: 'camila@mascotify.app',
          storedHash: hash,
        ),
        isTrue,
      );
      expect(
        LocalPasswordHasher.verifyPassword(
          rawPassword: 'wrong-password',
          salt: 'camila@mascotify.app',
          storedHash: hash,
        ),
        isFalse,
      );
    });

    test('keeps legacy local hashes verifiable for migration', () {
      expect(
        LocalPasswordHasher.verifyPassword(
          rawPassword: 'Mascotify123',
          salt: 'camila@mascotify.app',
          storedHash: '152eabe91439c076',
        ),
        isTrue,
      );
      expect(LocalPasswordHasher.needsRehash('152eabe91439c076'), isTrue);
    });
  });
}
