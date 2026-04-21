import 'package:flutter/material.dart';

import '../../../shared/models/account_identity_models.dart';
import '../../../shared/models/app_user.dart';
import '../data/local_auth_models.dart';
import '../data/local_auth_repository.dart';

class AuthSessionController extends ChangeNotifier {
  AuthSessionController({required LocalAuthRepository repository})
    : _repository = repository;

  final LocalAuthRepository _repository;

  bool _isReady = false;
  bool _isBusy = false;
  StoredAuthAccount? _account;
  StoredAuthSession? _session;

  bool get isReady => _isReady;
  bool get isBusy => _isBusy;
  bool get isAuthenticated => _account != null && _session != null;
  bool get hasCompletedOnboarding => _account?.onboardingCompleted ?? false;
  AppUser? get currentUser => _account?.toAppUser();
  MascotifyAccount? get currentAccount => _account?.toMascotifyAccount();
  AccountExperience? get currentExperience => _session?.activeExperience;
  List<AccountExperience> get availableExperiences =>
      _account?.availableExperiences ?? const <AccountExperience>[];

  Future<void> initialize() async {
    await _setBusy(() async {
      // Demo accounts are seeded once, but every later interaction happens
      // against the same local auth store as real accounts. That keeps the
      // login flow honest while preserving a quick demo path.
      await _repository.ensureSeededAccounts();
      final restoredSession = await _repository.restoreSession();
      if (restoredSession != null) {
        _applyResult(restoredSession);
      }
      _isReady = true;
    });
    if (!_isReady) {
      _isReady = true;
      notifyListeners();
    }
  }

  MascotifyAccount accountFor(AccountExperience experience) {
    final account = currentAccount;
    if (account == null) {
      throw StateError('No hay una cuenta autenticada para resolver el perfil.');
    }
    // The active experience is already normalized when the session is restored
    // or switched, so the controller only exposes the current account snapshot.
    return account;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    return _runAuthMutation(() {
      return _repository.login(email: email, password: password);
    });
  }

  Future<String?> register({
    required String ownerName,
    required String email,
    required String city,
    required String password,
    required AccountExperience experience,
  }) async {
    return _runAuthMutation(() {
      return _repository.register(
        ownerName: ownerName,
        email: email,
        city: city,
        password: password,
        experience: experience,
      );
    });
  }

  Future<String?> completeOnboarding() async {
    final account = _account;
    if (account == null) return 'No hay una cuenta activa.';

    return _runAuthMutation(() {
      return _repository.completeOnboarding(userId: account.id);
    });
  }

  Future<String?> switchExperience(AccountExperience experience) async {
    final account = _account;
    if (account == null) return 'No hay una cuenta activa.';
    if (currentExperience == experience) return null;

    return _runAuthMutation(() {
      return _repository.switchExperience(
        userId: account.id,
        experience: experience,
      );
    });
  }

  Future<void> logout() async {
    await _setBusy(() async {
      await _repository.logout();
      _account = null;
      _session = null;
    });
  }

  Future<String?> _runAuthMutation(
    Future<AuthOperationResult> Function() action,
  ) async {
    String? error;
    await _setBusy(() async {
      final result = await action();
      if (result.isSuccess) {
        _applyResult(result);
      } else {
        error = result.error ?? 'No pudimos completar la acción.';
      }
    });
    return error;
  }

  void _applyResult(AuthOperationResult result) {
    _account = result.account;
    _session = result.session;
  }

  Future<void> _setBusy(Future<void> Function() action) async {
    _isBusy = true;
    notifyListeners();
    try {
      await action();
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }
}

class AuthScope extends InheritedNotifier<AuthSessionController> {
  const AuthScope({
    super.key,
    required super.child,
    required AuthSessionController controller,
  }) : super(notifier: controller);

  static AuthSessionController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    if (scope == null || scope.notifier == null) {
      throw StateError('AuthScope no está disponible en este contexto.');
    }
    return scope.notifier!;
  }
}
