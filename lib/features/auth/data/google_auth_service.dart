import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthResult {
  const GoogleAuthResult.success(this.profile) : error = null;

  const GoogleAuthResult.cancelled() : profile = null, error = null;

  const GoogleAuthResult.failure(this.error) : profile = null;

  final GoogleAuthProfile? profile;
  final String? error;

  bool get isSuccess => profile != null;
  bool get isCancelled => profile == null && error == null;
}

class GoogleAuthProfile {
  const GoogleAuthProfile({
    required this.uid,
    required this.email,
    required this.displayName,
  });

  final String uid;
  final String email;
  final String displayName;
}

class GoogleAuthService {
  GoogleAuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  bool _isFirebaseReady = false;
  bool _isGoogleSignInReady = false;

  Future<GoogleAuthResult> signIn() async {
    try {
      final auth = await _resolveFirebaseAuth();
      final credential = kIsWeb
          ? await auth.signInWithPopup(GoogleAuthProvider())
          : await _signInNative(auth);
      final user = credential.user;

      if (user == null || user.email == null || user.email!.trim().isEmpty) {
        return const GoogleAuthResult.failure(
          'No pudimos obtener el email de tu cuenta de Google.',
        );
      }

      return GoogleAuthResult.success(
        GoogleAuthProfile(
          uid: user.uid,
          email: user.email!,
          displayName: _resolveDisplayName(user),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (_isCancelledFirebaseError(error.code)) {
        return const GoogleAuthResult.cancelled();
      }
      return GoogleAuthResult.failure(_friendlyFirebaseError(error));
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return const GoogleAuthResult.cancelled();
      }
      return const GoogleAuthResult.failure(
        'No pudimos completar el acceso con Google. Revisa la configuracion del proveedor e intenta nuevamente.',
      );
    } on FirebaseException catch (error) {
      return GoogleAuthResult.failure(_friendlyFirebaseSetupError(error));
    } catch (_) {
      return const GoogleAuthResult.failure(
        'No pudimos completar el acceso con Google. Intenta nuevamente.',
      );
    }
  }

  Future<void> signOut() async {
    try {
      final auth = await _resolveFirebaseAuth();
      await auth.signOut();
      if (!kIsWeb) {
        await _ensureGoogleSignInReady();
        await _googleSignIn.signOut();
      }
    } catch (_) {
      // Local logout remains the source of truth for Mascotify session state.
    }
  }

  Future<UserCredential> _signInNative(FirebaseAuth auth) async {
    await _ensureGoogleSignInReady();

    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return auth.signInWithCredential(credential);
  }

  Future<FirebaseAuth> _resolveFirebaseAuth() async {
    if (_firebaseAuth != null) return _firebaseAuth;
    await _ensureFirebaseReady();
    return FirebaseAuth.instance;
  }

  Future<void> _ensureFirebaseReady() async {
    if (_isFirebaseReady) return;

    if (Firebase.apps.isEmpty) {
      final options = MascotifyFirebaseOptions.currentPlatform;
      if (options == null) {
        await Firebase.initializeApp();
      } else {
        await Firebase.initializeApp(options: options);
      }
    }

    _isFirebaseReady = true;
  }

  Future<void> _ensureGoogleSignInReady() async {
    if (_isGoogleSignInReady) return;

    await _googleSignIn.initialize(
      clientId: MascotifyGoogleSignInConfig.clientId,
      serverClientId: MascotifyGoogleSignInConfig.serverClientId,
    );
    _isGoogleSignInReady = true;
  }

  bool _isCancelledFirebaseError(String code) {
    return code == 'popup-closed-by-user' ||
        code == 'web-context-cancelled' ||
        code == 'cancelled-popup-request';
  }

  String _friendlyFirebaseError(FirebaseAuthException error) {
    switch (error.code) {
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con ese email usando otro metodo de acceso.';
      case 'operation-not-allowed':
        return 'Google todavia no esta habilitado como proveedor de autenticacion.';
      case 'popup-blocked':
        return 'El navegador bloqueo la ventana de Google. Permiti popups para continuar.';
      case 'unauthorized-domain':
        return 'Este dominio no esta autorizado en Firebase Authentication.';
      default:
        return 'No pudimos autenticar con Google. Intenta nuevamente.';
    }
  }

  String _friendlyFirebaseSetupError(FirebaseException error) {
    if (error.plugin == 'core' || error.code == 'no-app') {
      return 'Firebase no esta configurado para este entorno. Completa la configuracion del proyecto Firebase antes de usar Google.';
    }
    return 'No pudimos conectar con Firebase. Revisa la configuracion e intenta nuevamente.';
  }

  String _resolveDisplayName(User user) {
    final displayName = user.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) return displayName;

    final email = user.email ?? '';
    final localPart = email.split('@').first.trim();
    return localPart.isEmpty ? 'Usuario Mascotify' : localPart;
  }
}

class MascotifyGoogleSignInConfig {
  const MascotifyGoogleSignInConfig._();

  static const String? clientId =
      String.fromEnvironment('MASCOTIFY_GOOGLE_CLIENT_ID') == ''
      ? null
      : String.fromEnvironment('MASCOTIFY_GOOGLE_CLIENT_ID');

  static const String? serverClientId =
      String.fromEnvironment('MASCOTIFY_GOOGLE_SERVER_CLIENT_ID') == ''
      ? null
      : String.fromEnvironment('MASCOTIFY_GOOGLE_SERVER_CLIENT_ID');
}

class MascotifyFirebaseOptions {
  const MascotifyFirebaseOptions._();

  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        return web;
    }
  }

  static FirebaseOptions? get web {
    const apiKey = String.fromEnvironment('MASCOTIFY_FIREBASE_WEB_API_KEY');
    const appId = String.fromEnvironment('MASCOTIFY_FIREBASE_WEB_APP_ID');
    const messagingSenderId = String.fromEnvironment(
      'MASCOTIFY_FIREBASE_MESSAGING_SENDER_ID',
    );
    const projectId = String.fromEnvironment('MASCOTIFY_FIREBASE_PROJECT_ID');

    if (!_hasRequiredValues(apiKey, appId, messagingSenderId, projectId)) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: const String.fromEnvironment(
        'MASCOTIFY_FIREBASE_AUTH_DOMAIN',
      ),
      storageBucket: const String.fromEnvironment(
        'MASCOTIFY_FIREBASE_STORAGE_BUCKET',
      ),
    );
  }

  static FirebaseOptions? get android {
    const apiKey = String.fromEnvironment('MASCOTIFY_FIREBASE_ANDROID_API_KEY');
    const appId = String.fromEnvironment('MASCOTIFY_FIREBASE_ANDROID_APP_ID');
    const messagingSenderId = String.fromEnvironment(
      'MASCOTIFY_FIREBASE_MESSAGING_SENDER_ID',
    );
    const projectId = String.fromEnvironment('MASCOTIFY_FIREBASE_PROJECT_ID');

    if (!_hasRequiredValues(apiKey, appId, messagingSenderId, projectId)) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: const String.fromEnvironment(
        'MASCOTIFY_FIREBASE_STORAGE_BUCKET',
      ),
    );
  }

  static FirebaseOptions? get ios {
    const apiKey = String.fromEnvironment('MASCOTIFY_FIREBASE_IOS_API_KEY');
    const appId = String.fromEnvironment('MASCOTIFY_FIREBASE_IOS_APP_ID');
    const messagingSenderId = String.fromEnvironment(
      'MASCOTIFY_FIREBASE_MESSAGING_SENDER_ID',
    );
    const projectId = String.fromEnvironment('MASCOTIFY_FIREBASE_PROJECT_ID');

    if (!_hasRequiredValues(apiKey, appId, messagingSenderId, projectId)) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      iosBundleId: const String.fromEnvironment(
        'MASCOTIFY_FIREBASE_IOS_BUNDLE_ID',
      ),
      storageBucket: const String.fromEnvironment(
        'MASCOTIFY_FIREBASE_STORAGE_BUCKET',
      ),
    );
  }

  static FirebaseOptions? get macos {
    const apiKey = String.fromEnvironment('MASCOTIFY_FIREBASE_MACOS_API_KEY');
    const appId = String.fromEnvironment('MASCOTIFY_FIREBASE_MACOS_APP_ID');
    const messagingSenderId = String.fromEnvironment(
      'MASCOTIFY_FIREBASE_MESSAGING_SENDER_ID',
    );
    const projectId = String.fromEnvironment('MASCOTIFY_FIREBASE_PROJECT_ID');

    if (!_hasRequiredValues(apiKey, appId, messagingSenderId, projectId)) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      iosBundleId: const String.fromEnvironment(
        'MASCOTIFY_FIREBASE_MACOS_BUNDLE_ID',
      ),
      storageBucket: const String.fromEnvironment(
        'MASCOTIFY_FIREBASE_STORAGE_BUCKET',
      ),
    );
  }

  static bool _hasRequiredValues(
    String apiKey,
    String appId,
    String messagingSenderId,
    String projectId,
  ) {
    return apiKey.isNotEmpty &&
        appId.isNotEmpty &&
        messagingSenderId.isNotEmpty &&
        projectId.isNotEmpty;
  }
}
