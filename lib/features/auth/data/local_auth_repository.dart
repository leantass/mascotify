import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/data/account_identity_mock_data.dart';
import '../../../shared/models/account_identity_models.dart';
import 'local_auth_models.dart';

class AuthOperationResult {
  const AuthOperationResult.success({
    required this.account,
    required this.session,
  }) : error = null;

  const AuthOperationResult.failure(this.error)
    : account = null,
      session = null;

  final StoredAuthAccount? account;
  final StoredAuthSession? session;
  final String? error;

  bool get isSuccess => account != null && session != null;
}

class LocalAuthRepository {
  LocalAuthRepository(this._preferences);

  static const String _usersKey = 'mascotify.auth.users.v1';
  static const String _sessionKey = 'mascotify.auth.session.v1';

  final SharedPreferences _preferences;

  Future<void> ensureSeededAccounts() async {
    final users = _loadUsers();
    if (users.isNotEmpty) return;

    final seededUsers = <StoredAuthAccount>[
      _buildSeededAccount(
        account: AccountIdentityMockData.familyAccount,
        password: LocalAuthSeedData.demoPassword,
        lastActiveExperience: AccountExperience.family,
        onboardingCompleted: true,
      ),
      _buildSeededAccount(
        account: AccountIdentityMockData.professionalAccount,
        password: LocalAuthSeedData.demoPassword,
        lastActiveExperience: AccountExperience.professional,
        onboardingCompleted: true,
      ),
    ];

    await _saveUsers(seededUsers);
  }

  Future<AuthOperationResult?> restoreSession() async {
    final session = _loadSession();
    if (session == null) return null;

    final users = _loadUsers();
    final account = _findUserById(users, session.userId);
    if (account == null) {
      await _preferences.remove(_sessionKey);
      return null;
    }

    final resolvedExperience = account.supportsExperience(session.activeExperience)
        ? session.activeExperience
        : account.lastActiveExperience;

    final nextSession = StoredAuthSession(
      userId: account.id,
      activeExperience: resolvedExperience,
    );

    if (resolvedExperience != session.activeExperience) {
      await _saveSession(nextSession);
    }

    return AuthOperationResult.success(account: account, session: nextSession);
  }

  Future<AuthOperationResult> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = normalizeEmail(email);
    final hashedPassword = hashPassword(password);
    final users = _loadUsers();

    final account = users.where((item) => item.email == normalizedEmail).firstOrNull;
    if (account == null) {
      return const AuthOperationResult.failure(
        'No encontramos una cuenta con ese email.',
      );
    }

    if (account.passwordHash != hashedPassword) {
      return const AuthOperationResult.failure('La contraseña no coincide.');
    }

    final session = StoredAuthSession(
      userId: account.id,
      activeExperience: account.lastActiveExperience,
    );

    await _saveSession(session);
    return AuthOperationResult.success(account: account, session: session);
  }

  Future<AuthOperationResult> register({
    required String ownerName,
    required String email,
    required String city,
    required String password,
    required AccountExperience experience,
  }) async {
    final normalizedEmail = normalizeEmail(email);
    final trimmedName = ownerName.trim();
    final trimmedCity = city.trim();
    final trimmedPassword = password.trim();

    if (trimmedName.isEmpty) {
      return const AuthOperationResult.failure('Necesitamos tu nombre.');
    }
    if (trimmedCity.isEmpty) {
      return const AuthOperationResult.failure('Necesitamos una ciudad base.');
    }
    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      return const AuthOperationResult.failure('Ingresa un email valido.');
    }
    if (trimmedPassword.length < 8) {
      return const AuthOperationResult.failure(
        'La contraseña debe tener al menos 8 caracteres.',
      );
    }

    final users = _loadUsers();
    final emailExists = users.any((item) => item.email == normalizedEmail);
    if (emailExists) {
      return const AuthOperationResult.failure(
        'Ese email ya esta registrado. Inicia sesion o usa otro.',
      );
    }

    final account = StoredAuthAccount(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      ownerName: trimmedName,
      email: normalizedEmail,
      passwordHash: hashPassword(trimmedPassword),
      planName: experience == AccountExperience.family
          ? 'Mascotify Plus'
          : 'Mascotify Pro',
      city: trimmedCity,
      memberSince: _buildMemberSinceLabel(DateTime.now()),
      availableExperiences: <AccountExperience>[experience],
      lastActiveExperience: experience,
      onboardingCompleted: false,
      familyProfile: experience == AccountExperience.family
          ? StoredFamilyProfile(
              householdName: 'Hogar de ${_firstName(trimmedName)}',
              petsSummaryLabel: 'Todavía no cargaste mascotas',
              primaryGoal:
                  'Ordenar identidad, seguridad y seguimiento de tus mascotas desde una sola base.',
              nextSetupStep:
                  'Completar onboarding y sumar la primera mascota cuando quieras.',
              capabilities: const <String>[
                'Cuenta base persistida',
                'Perfil familia activo',
                'Sesion local guardada',
              ],
            )
          : null,
      professionalProfile: experience == AccountExperience.professional
          ? StoredProfessionalProfile(
              businessName: trimmedName,
              category: 'Perfil profesional inicial',
              operationLabel: 'Base local lista para crecer',
              primaryGoal:
                  'Ordenar presencia, servicios y una cuenta profesional que pueda escalar sin rehacer la base.',
              nextSetupStep:
                  'Completar onboarding y definir mejor como se presenta tu perfil.',
              services: const <String>[
                'Servicio principal',
                'Orientacion',
                'Seguimiento futuro',
              ],
              capabilities: const <String>[
                'Cuenta base persistida',
                'Perfil profesional activo',
                'Sesion local guardada',
              ],
            )
          : null,
    );

    final updatedUsers = <StoredAuthAccount>[...users, account];
    final session = StoredAuthSession(
      userId: account.id,
      activeExperience: experience,
    );

    await _saveUsers(updatedUsers);
    await _saveSession(session);

    return AuthOperationResult.success(account: account, session: session);
  }

  Future<AuthOperationResult> completeOnboarding({
    required String userId,
  }) async {
    final users = _loadUsers();
    final index = users.indexWhere((item) => item.id == userId);
    if (index == -1) {
      return const AuthOperationResult.failure('No pudimos actualizar la cuenta.');
    }

    final updatedAccount = users[index].copyWith(onboardingCompleted: true);
    final updatedUsers = [...users]..[index] = updatedAccount;
    final session = _loadSession() ??
        StoredAuthSession(
          userId: updatedAccount.id,
          activeExperience: updatedAccount.lastActiveExperience,
        );

    await _saveUsers(updatedUsers);
    await _saveSession(session);
    return AuthOperationResult.success(account: updatedAccount, session: session);
  }

  Future<AuthOperationResult> switchExperience({
    required String userId,
    required AccountExperience experience,
  }) async {
    final users = _loadUsers();
    final index = users.indexWhere((item) => item.id == userId);
    if (index == -1) {
      return const AuthOperationResult.failure('No encontramos la cuenta activa.');
    }

    final account = users[index];
    if (!account.supportsExperience(experience)) {
      return const AuthOperationResult.failure(
        'Ese perfil todavia no esta disponible en esta cuenta.',
      );
    }

    final updatedAccount = account.copyWith(lastActiveExperience: experience);
    final updatedUsers = [...users]..[index] = updatedAccount;
    final session = StoredAuthSession(
      userId: updatedAccount.id,
      activeExperience: experience,
    );

    await _saveUsers(updatedUsers);
    await _saveSession(session);
    return AuthOperationResult.success(account: updatedAccount, session: session);
  }

  Future<void> logout() async {
    await _preferences.remove(_sessionKey);
  }

  StoredAuthAccount _buildSeededAccount({
    required MascotifyAccount account,
    required String password,
    required AccountExperience lastActiveExperience,
    required bool onboardingCompleted,
  }) {
    return StoredAuthAccount(
      id: account.id,
      ownerName: account.ownerName,
      email: normalizeEmail(account.email),
      passwordHash: hashPassword(password),
      planName: account.planName,
      city: account.city,
      memberSince: account.memberSince,
      availableExperiences: List<AccountExperience>.unmodifiable(
        account.availableExperiences,
      ),
      lastActiveExperience: lastActiveExperience,
      onboardingCompleted: onboardingCompleted,
      familyProfile: account.familyProfile == null
          ? null
          : StoredFamilyProfile.fromDomain(account.familyProfile!),
      professionalProfile: account.professionalProfile == null
          ? null
          : StoredProfessionalProfile.fromDomain(account.professionalProfile!),
    );
  }

  StoredAuthAccount? _findUserById(List<StoredAuthAccount> users, String userId) {
    for (final user in users) {
      if (user.id == userId) return user;
    }
    return null;
  }

  List<StoredAuthAccount> _loadUsers() {
    final rawUsers = _preferences.getString(_usersKey);
    if (rawUsers == null || rawUsers.isEmpty) return const <StoredAuthAccount>[];

    final decoded = jsonDecode(rawUsers) as List<dynamic>;
    return decoded
        .map(
          (item) => StoredAuthAccount.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  StoredAuthSession? _loadSession() {
    final rawSession = _preferences.getString(_sessionKey);
    if (rawSession == null || rawSession.isEmpty) return null;

    final decoded = jsonDecode(rawSession) as Map<String, dynamic>;
    return StoredAuthSession.fromJson(decoded);
  }

  Future<void> _saveUsers(List<StoredAuthAccount> users) async {
    await _preferences.setString(
      _usersKey,
      jsonEncode(users.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> _saveSession(StoredAuthSession session) async {
    await _preferences.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  String _buildMemberSinceLabel(DateTime dateTime) {
    const months = <String>[
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String _firstName(String value) {
    final parts = value.split(' ').where((item) => item.isNotEmpty);
    return parts.isEmpty ? value : parts.first;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}
