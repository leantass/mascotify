import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/auth_session_controller.dart';
import '../models/account_identity_models.dart';
import '../models/app_user.dart';
import '../models/notification_models.dart';
import '../models/pet.dart';
import '../models/professional_models.dart';
import '../models/report_models.dart';
import '../models/social_models.dart';
import 'account_identity_mock_data.dart';
import 'app_data_source.dart';
import 'mock_data.dart';
import 'notifications_mock_data.dart';
import 'professional_mock_data.dart';
import 'reporting_mock_data.dart';
import 'social_mock_data.dart';

class PersistedPetQrState {
  const PersistedPetQrState({
    required this.suggestedLocation,
    required this.activity,
  });

  final SightingLocationReference suggestedLocation;
  final List<QrActivityEntry> activity;

  PersistedPetQrState copyWith({
    SightingLocationReference? suggestedLocation,
    List<QrActivityEntry>? activity,
  }) {
    return PersistedPetQrState(
      suggestedLocation: suggestedLocation ?? this.suggestedLocation,
      activity: activity ?? this.activity,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'suggestedLocation': suggestedLocation.toJson(),
      'activity': activity.map((item) => item.toJson()).toList(),
    };
  }

  factory PersistedPetQrState.fromJson(Map<String, dynamic> json) {
    return PersistedPetQrState(
      suggestedLocation: SightingLocationReference.fromJson(
        Map<String, dynamic>.from(
          json['suggestedLocation'] as Map<dynamic, dynamic>,
        ),
      ),
      activity: (json['activity'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (item) => QrActivityEntry.fromJson(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
            ),
          )
          .toList(),
    );
  }
}

class PersistedLocalUserState {
  const PersistedLocalUserState({
    required this.notificationsEnabled,
    required this.pets,
    required this.threads,
    required this.qrStates,
  });

  final bool notificationsEnabled;
  final List<Pet> pets;
  final List<MessageThread> threads;
  final Map<String, PersistedPetQrState> qrStates;

  PersistedLocalUserState copyWith({
    bool? notificationsEnabled,
    List<Pet>? pets,
    List<MessageThread>? threads,
    Map<String, PersistedPetQrState>? qrStates,
  }) {
    return PersistedLocalUserState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      pets: pets ?? this.pets,
      threads: threads ?? this.threads,
      qrStates: qrStates ?? this.qrStates,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'notificationsEnabled': notificationsEnabled,
      'pets': pets.map((item) => item.toJson()).toList(),
      'threads': threads.map((item) => item.toJson()).toList(),
      'qrStates': qrStates.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  factory PersistedLocalUserState.fromJson(Map<String, dynamic> json) {
    return PersistedLocalUserState(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      pets: (json['pets'] as List<dynamic>)
          .map(
            (item) => Pet.fromJson(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
            ),
          )
          .toList(),
      threads: (json['threads'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (item) => MessageThread.fromJson(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
            ),
          )
          .toList(),
      qrStates: (json['qrStates'] as Map<dynamic, dynamic>? ?? const {})
          .map(
            (key, value) => MapEntry(
              key as String,
              PersistedPetQrState.fromJson(
                Map<String, dynamic>.from(value as Map<dynamic, dynamic>),
              ),
            ),
          ),
    );
  }
}

class PersistentLocalMascotifyDataSource implements MascotifyDataSource {
  PersistentLocalMascotifyDataSource({
    required SharedPreferences preferences,
    required AuthSessionController sessionController,
  }) : _preferences = preferences,
       _sessionController = sessionController {
    _hydrateStoredUserStates();
    _sessionController.addListener(_handleAuthStateChanged);
    _handleAuthStateChanged();
  }

  static const String _userStatePrefix = 'mascotify.user-state.v1.';

  final SharedPreferences _preferences;
  final AuthSessionController _sessionController;
  final Map<String, PersistedLocalUserState> _userStates =
      <String, PersistedLocalUserState>{};

  String? _activeUserId;

  @override
  MascotifyAccount accountFor(AccountExperience experience) {
    final currentAccount = _sessionController.currentAccount;
    if (currentAccount == null) {
      return AccountIdentityMockData.accountFor(experience);
    }

    final currentState = _stateForCurrentUser();
    final familyProfile = currentAccount.familyProfile;

    return MascotifyAccount(
      id: currentAccount.id,
      ownerName: currentAccount.ownerName,
      email: currentAccount.email,
      planName: currentAccount.planName,
      city: currentAccount.city,
      memberSince: currentAccount.memberSince,
      baseSummary: currentAccount.baseSummary,
      linkedProfilesSummary: currentAccount.linkedProfilesSummary,
      availableExperiences: currentAccount.availableExperiences,
      familyProfile: familyProfile == null
          ? null
          : FamilyAccountProfile(
              householdName: familyProfile.householdName,
              petsSummaryLabel: _buildPetsSummaryLabel(currentState.pets.length),
              primaryGoal: familyProfile.primaryGoal,
              nextSetupStep: currentState.pets.isEmpty
                  ? 'Agregar la primera mascota para completar la base local.'
                  : familyProfile.nextSetupStep,
              capabilities: familyProfile.capabilities,
            ),
      professionalProfile: currentAccount.professionalProfile,
    );
  }

  @override
  ProfessionalContentPreview? findFeaturedContent(
    ProfessionalProfile professional,
    String title,
  ) {
    for (final content in professional.featuredContent) {
      if (content.title == title) return content;
    }
    return null;
  }

  @override
  MessageThread? findMessageThreadForPet(Pet pet) {
    for (final thread in getMessageThreads()) {
      if (thread.pet.id == pet.id) return thread;
    }
    return null;
  }

  @override
  MessageThread? findMessageThreadById(String id) {
    for (final thread in getMessageThreads()) {
      if (thread.id == id) return thread;
    }
    return null;
  }

  @override
  Pet? findPetById(String id) {
    for (final pet in getPets()) {
      if (pet.id == id) return pet;
    }
    return null;
  }

  @override
  ProfessionalProfile? findProfessionalByName(String name) {
    for (final professional in professionalProfiles) {
      if (professional.name == name) return professional;
    }
    return null;
  }

  @override
  AppUser getCurrentUser() {
    final currentAccount = _sessionController.currentAccount;
    if (currentAccount == null) {
      return MockData.currentUser;
    }

    final currentState = _stateForCurrentUser();
    return AppUser(
      id: currentAccount.id,
      name: currentAccount.ownerName,
      email: currentAccount.email,
      planName: currentAccount.planName,
      city: currentAccount.city,
      memberSince: currentAccount.memberSince,
      notificationsEnabled: currentState.notificationsEnabled,
    );
  }

  @override
  List<ExperienceOption> getExperienceOptions() {
    return List.unmodifiable(AccountIdentityMockData.experienceOptions);
  }

  @override
  List<EcosystemNotification> getNotifications() {
    return List.unmodifiable(
      buildMockNotifications(
        getPets(),
        getMessageThreads(),
        getSuggestedLocationForPet,
      ),
    );
  }

  @override
  List<MessageThread> getMessageThreads() {
    return List.unmodifiable(_stateForCurrentUser().threads);
  }

  @override
  List<Pet> getPets() {
    return List.unmodifiable(_stateForCurrentUser().pets);
  }

  @override
  List<ProfessionalLibraryContent> getProfessionalLibraryContents() {
    return List.unmodifiable(professionalLibraryContents);
  }

  @override
  List<ProfessionalProfile> getProfessionalProfiles() {
    return List.unmodifiable(professionalProfiles);
  }

  @override
  List<ProfessionalRecommendation> getProfessionalRecommendations() {
    return List.unmodifiable(professionalRecommendations);
  }

  @override
  List<ProfileOptionItem> getProfileOptions() {
    return List.unmodifiable(MockData.profileOptions);
  }

  @override
  List<ProfessionalServiceSpotlight> getProfessionalServiceSpotlights() {
    return List.unmodifiable(professionalServiceSpotlights);
  }

  @override
  List<String> getProfessionalSpecialties() {
    return List.unmodifiable(professionalSpecialties);
  }

  @override
  List<QrActivityEntry> getQrActivityEntriesForPet(Pet pet) {
    return List.unmodifiable(_qrStateForPet(pet).activity);
  }

  @override
  QrStatusSnapshot getQrStatusSnapshotForPet(Pet pet) {
    return _buildQrStatusSnapshot(pet, _qrStateForPet(pet));
  }

  @override
  List<SavedProfileEntry> getSavedProfiles() {
    return List.unmodifiable(buildMockSavedProfiles(getPets()));
  }

  @override
  List<SocialInboxEntry> getSocialInboxEntries() {
    return List.unmodifiable(buildMockSocialInboxEntries(getPets()));
  }

  @override
  SightingLocationReference getSuggestedLocationForPet(Pet pet) {
    return _qrStateForPet(pet).suggestedLocation;
  }

  @override
  OnboardingTrack trackFor(AccountExperience experience) {
    return AccountIdentityMockData.trackFor(experience);
  }

  @override
  Future<void> addPet(Pet pet) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    final updatedQrStates = <String, PersistedPetQrState>{
      ...currentState.qrStates,
      pet.id: _buildInitialQrStateForPet(pet),
    };
    final updatedState = currentState.copyWith(
      pets: <Pet>[...currentState.pets, pet],
      qrStates: updatedQrStates,
    );
    _userStates[userId] = updatedState;
    await _persistUserState(userId);
  }

  @override
  Future<void> addAutomatedReply(String threadId) async {
    final thread = findMessageThreadById(threadId);
    if (thread == null || thread.autoReplies.isEmpty) return;

    final userId = _currentUserId;
    if (userId == null) return;

    final reply = thread.autoReplies[
      thread.messages.length % thread.autoReplies.length
    ];

    await _updateThread(
      userId,
      threadId,
      (currentThread) {
        return currentThread.copyWith(
          messages: <MessageEntry>[
            ...currentThread.messages,
            MessageEntry(
              text: reply,
              timestamp: 'Ahora',
              isMine: false,
            ),
          ],
          lastMessage: reply,
          lastActivity: 'Ahora',
          unreadCount: currentThread.unreadCount + 1,
          isAwaitingMyReply: true,
        );
      },
    );
  }

  @override
  Future<void> sendMessage(String threadId, String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    final userId = _currentUserId;
    if (userId == null) return;

    await _updateThread(
      userId,
      threadId,
      (currentThread) => currentThread.copyWith(
        messages: <MessageEntry>[
          ...currentThread.messages,
          MessageEntry(
            text: trimmedText,
            timestamp: 'Ahora',
            isMine: true,
          ),
        ],
        lastMessage: trimmedText,
        lastActivity: 'Ahora',
        unreadCount: 0,
        isAwaitingMyReply: false,
      ),
    );
  }

  @override
  Future<void> registerQrScan(String petId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final pet = findPetById(petId);
    if (pet == null) return;

    await _updateQrState(
      userId,
      pet,
      (currentState) {
        return currentState.copyWith(
          suggestedLocation: currentState.suggestedLocation.copyWith(
            timeReference: 'Escaneo registrado hace instantes',
          ),
          activity: <QrActivityEntry>[
            QrActivityEntry(
              title: 'Escaneo público registrado',
              detail:
                  'Se abrió la vista pública de ${pet.name} y quedó asentada una nueva señal dentro del historial QR.',
              timeLabel: 'Ahora',
              statusLabel: pet.qrEnabled ? 'Escaneo válido' : 'Consulta recibida',
              iconKey: 'qr',
              accentColorHex: 0xFFDDF6F6,
            ),
            ...currentState.activity,
          ],
        );
      },
    );
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(
      notificationsEnabled: enabled,
    );
    await _persistUserState(userId);
  }

  @override
  Future<void> submitSightingReport(SightingReportDraft draft) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final pet = findPetById(draft.petId);
    if (pet == null) return;

    final locationLabel = draft.locationLabel.trim();
    final normalizedLocationLabel = locationLabel.isEmpty
        ? _qrStateForPet(pet).suggestedLocation.zoneReference
        : locationLabel;
    final notes = draft.notes.trim();

    await _updateQrState(
      userId,
      pet,
      (currentState) {
        final nextLocation = currentState.suggestedLocation.copyWith(
          zone: normalizedLocationLabel,
          zoneReference: normalizedLocationLabel,
          timeReference: 'Reporte recibido hace instantes',
          mapLabelTop: pet.name,
          mapLabelBottom: 'Reporte activo',
        );

        final detailParts = <String>[
          'Se recibió un aviso sobre ${pet.name} en $normalizedLocationLabel.',
          'Estado observado: ${draft.condition}.',
          if (notes.isNotEmpty) notes,
          draft.allowContact
              ? 'El flujo permite contacto posterior dentro del canal protegido.'
              : 'El reporte quedó sin contacto posterior habilitado.',
        ];

        return currentState.copyWith(
          suggestedLocation: nextLocation,
          activity: <QrActivityEntry>[
            QrActivityEntry(
              title: draft.condition == 'Parece lastimada'
                  ? 'Reporte con posible alerta física'
                  : 'Avistamiento reportado',
              detail: detailParts.join(' '),
              timeLabel: 'Ahora',
              statusLabel: draft.condition == 'Parece lastimada'
                  ? 'Requiere revisión'
                  : 'Reporte nuevo',
              iconKey: 'location',
              accentColorHex: draft.condition == 'Parece lastimada'
                  ? 0xFFFFF2C6
                  : 0xFFFFE1EA,
            ),
            ...currentState.activity,
          ],
        );
      },
    );
  }

  @override
  Future<void> syncCurrentUserState() async {
    final userId = _currentUserId;
    if (userId == null) return;

    _ensureUserStateLoaded(userId);
    await _persistUserState(userId);
  }

  void _handleAuthStateChanged() {
    final nextUserId = _currentUserId;
    if (_activeUserId == nextUserId) return;

    _activeUserId = nextUserId;
    if (nextUserId == null) return;

    _ensureUserStateLoaded(nextUserId);
    unawaited(_persistUserState(nextUserId));
  }

  String? get _currentUserId => _sessionController.currentAccount?.id;

  PersistedLocalUserState _stateForCurrentUser() {
    final userId = _currentUserId;
    if (userId == null) {
      final pets = _seedPetsForCurrentAccount();
      return PersistedLocalUserState(
        notificationsEnabled: true,
        pets: pets,
        threads: _seedThreadsForCurrentAccount(pets),
        qrStates: _seedQrStatesForCurrentAccount(pets),
      );
    }
    return _stateForUser(userId);
  }

  PersistedLocalUserState _stateForUser(String userId) {
    _ensureUserStateLoaded(userId);
    return _userStates[userId]!;
  }

  void _ensureUserStateLoaded(String userId) {
    if (_userStates.containsKey(userId)) return;

    final rawValue = _preferences.getString('$_userStatePrefix$userId');
    if (rawValue != null && rawValue.isNotEmpty) {
      final decoded = jsonDecode(rawValue) as Map<String, dynamic>;
      final restoredState = PersistedLocalUserState.fromJson(decoded);
      final normalizedState = _normalizeUserState(userId, restoredState);
      _userStates[userId] = normalizedState;
      if (_stateWasNormalized(restoredState, normalizedState)) {
        unawaited(_persistUserState(userId));
      }
      return;
    }

    final pets = _seedPetsForCurrentAccount();
    _userStates[userId] = PersistedLocalUserState(
      notificationsEnabled: true,
      pets: pets,
      threads: _seedThreadsForCurrentAccount(pets),
      qrStates: _seedQrStatesForCurrentAccount(pets),
    );
  }

  Future<void> _persistUserState(String userId) async {
    final state = _userStates[userId];
    if (state == null) return;

    await _preferences.setString(
      '$_userStatePrefix$userId',
      jsonEncode(state.toJson()),
    );
  }

  void _hydrateStoredUserStates() {
    for (final key in _preferences.getKeys()) {
      if (!key.startsWith(_userStatePrefix)) continue;
      final rawValue = _preferences.getString(key);
      if (rawValue == null || rawValue.isEmpty) continue;
      final userId = key.substring(_userStatePrefix.length);
      final decoded = jsonDecode(rawValue) as Map<String, dynamic>;
      final restoredState = PersistedLocalUserState.fromJson(decoded);
      final normalizedState = _normalizeUserState(userId, restoredState);
      _userStates[userId] = normalizedState;
      if (_stateWasNormalized(restoredState, normalizedState)) {
        unawaited(_persistUserState(userId));
      }
    }
  }

  List<Pet> _seedPetsForCurrentAccount() {
    final currentAccount = _sessionController.currentAccount;
    if (currentAccount != null && _isLocalUserId(currentAccount.id)) {
      return const <Pet>[];
    }

    return MockData.pets
        .map(
          (pet) => Pet.fromJson(
            Map<String, dynamic>.from(pet.toJson()),
          ),
        )
        .toList();
  }

  List<MessageThread> _seedThreadsForCurrentAccount(List<Pet> pets) {
    final currentAccount = _sessionController.currentAccount;
    if (currentAccount != null && _isLocalUserId(currentAccount.id)) {
      return const <MessageThread>[];
    }

    return buildMockMessageThreads(pets)
        .map(
          (thread) => MessageThread.fromJson(
            Map<String, dynamic>.from(thread.toJson()),
          ),
        )
        .toList();
  }

  Map<String, PersistedPetQrState> _seedQrStatesForCurrentAccount(
    List<Pet> pets,
  ) {
    final currentAccount = _sessionController.currentAccount;
    final preferMockSeed =
        currentAccount == null || !_isLocalUserId(currentAccount.id);
    return _buildQrStatesForPets(pets, preferMockSeed: preferMockSeed);
  }

  PersistedLocalUserState _normalizeUserState(
    String userId,
    PersistedLocalUserState state,
  ) {
    if (_isLocalUserId(userId)) {
      final nextPets = _looksLikeLegacyMockSeed(state.pets)
          ? const <Pet>[]
          : state.pets;
      final nextThreads =
          _looksLikeLegacyMockThreads(state.threads) || nextPets.isEmpty
          ? const <MessageThread>[]
          : state.threads;
      return state.copyWith(
        pets: nextPets,
        threads: nextThreads,
        qrStates: _normalizeQrStates(
          userId,
          nextPets,
          state.qrStates,
        ),
      );
    }

    final nextThreads = state.threads.isEmpty && state.pets.isNotEmpty
        ? _seedThreadsForCurrentAccount(state.pets)
        : state.threads;
    final nextQrStates = _normalizeQrStates(
      userId,
      state.pets,
      state.qrStates,
    );
    if (nextThreads != state.threads || nextQrStates != state.qrStates) {
      return state.copyWith(
        threads: nextThreads,
        qrStates: nextQrStates,
      );
    }

    return state;
  }

  bool _isLocalUserId(String userId) {
    return userId.startsWith('local-');
  }

  bool _looksLikeLegacyMockSeed(List<Pet> pets) {
    if (pets.length != MockData.pets.length) return false;

    for (var index = 0; index < pets.length; index++) {
      if (pets[index].id != MockData.pets[index].id) {
        return false;
      }
    }

    return true;
  }

  bool _looksLikeLegacyMockThreads(List<MessageThread> threads) {
    final mockThreads = buildMockMessageThreads(MockData.pets);
    if (threads.length != mockThreads.length) return false;

    for (var index = 0; index < threads.length; index++) {
      if (threads[index].id != mockThreads[index].id) {
        return false;
      }
    }

    return true;
  }

  Map<String, PersistedPetQrState> _normalizeQrStates(
    String userId,
    List<Pet> pets,
    Map<String, PersistedPetQrState> qrStates,
  ) {
    if (pets.isEmpty) {
      return const <String, PersistedPetQrState>{};
    }

    final normalized = <String, PersistedPetQrState>{};
    final preferMockSeed = !_isLocalUserId(userId);

    for (final pet in pets) {
      normalized[pet.id] =
          qrStates[pet.id] ??
          _buildQrStateForPet(pet, preferMockSeed: preferMockSeed);
    }

    return normalized;
  }

  bool _stateWasNormalized(
    PersistedLocalUserState previous,
    PersistedLocalUserState next,
  ) {
    return jsonEncode(previous.toJson()) != jsonEncode(next.toJson());
  }

  Future<void> _updateThread(
    String userId,
    String threadId,
    MessageThread Function(MessageThread thread) transform,
  ) async {
    final currentState = _stateForUser(userId);
    final threadIndex = currentState.threads.indexWhere(
      (thread) => thread.id == threadId,
    );
    if (threadIndex == -1) return;

    final updatedThreads = <MessageThread>[...currentState.threads];
    updatedThreads[threadIndex] = transform(updatedThreads[threadIndex]);
    _userStates[userId] = currentState.copyWith(threads: updatedThreads);
    await _persistUserState(userId);
  }

  PersistedPetQrState _qrStateForPet(Pet pet) {
    final currentState = _stateForCurrentUser();
    return currentState.qrStates[pet.id] ?? _buildInitialQrStateForPet(pet);
  }

  Map<String, PersistedPetQrState> _buildQrStatesForPets(
    List<Pet> pets, {
    required bool preferMockSeed,
  }) {
    return <String, PersistedPetQrState>{
      for (final pet in pets)
        pet.id: _buildQrStateForPet(pet, preferMockSeed: preferMockSeed),
    };
  }

  PersistedPetQrState _buildQrStateForPet(
    Pet pet, {
    required bool preferMockSeed,
  }) {
    if (preferMockSeed && _isMockSeedPet(pet.id)) {
      return PersistedPetQrState(
        suggestedLocation: buildSuggestedLocationForPet(pet),
        activity: buildQrActivityEntriesForPet(pet)
            .map(
              (entry) => QrActivityEntry.fromJson(
                Map<String, dynamic>.from(entry.toJson()),
              ),
            )
            .toList(),
      );
    }

    return _buildInitialQrStateForPet(pet);
  }

  PersistedPetQrState _buildInitialQrStateForPet(Pet pet) {
    final referenceLabel = pet.location.trim().isEmpty
        ? 'Zona todavía por definir'
        : pet.location.trim();
    final location = SightingLocationReference(
      zone: referenceLabel,
      zoneReference: referenceLabel,
      shortReference: 'Punto base',
      timeReference: 'Sin señales todavía',
      mapLabelTop: pet.name,
      mapLabelBottom: 'Base local',
      horizontalFactor: 0.50,
      verticalFactor: 0.54,
    );

    return PersistedPetQrState(
      suggestedLocation: location,
      activity: <QrActivityEntry>[
        QrActivityEntry(
          title: pet.qrEnabled ? 'Perfil QR listo para usarse' : 'Perfil QR preparado',
          detail:
              'La base local de ${pet.name} ya puede empezar a registrar escaneos y reportes dentro de Mascotify.',
          timeLabel: 'Hoy',
          statusLabel: pet.qrEnabled ? 'Base activa' : 'Base creada',
          iconKey: pet.qrEnabled ? 'badge' : 'pending',
          accentColorHex: pet.colorHex,
        ),
      ],
    );
  }

  bool _isMockSeedPet(String petId) {
    return MockData.pets.any((pet) => pet.id == petId);
  }

  QrStatusSnapshot _buildQrStatusSnapshot(
    Pet pet,
    PersistedPetQrState qrState,
  ) {
    final latestActivity = qrState.activity.isEmpty ? null : qrState.activity.first;
    final signalCount = qrState.activity
        .where((entry) => entry.iconKey == 'qr' || entry.iconKey == 'location')
        .length;

    return QrStatusSnapshot(
      currentStatus: _buildCurrentQrStatus(pet, latestActivity),
      protectedContactState: pet.qrEnabled
          ? 'Contacto protegido activo'
          : 'Contacto protegido pendiente de vincular',
      lastSignalLabel: _buildLastSignalLabel(latestActivity),
      lastSignalDetail: latestActivity?.detail ??
          'La ficha está lista para sumar trazabilidad cuando llegue el primer escaneo o reporte.',
      totalScansLabel: signalCount == 0
          ? 'Sin escaneos todavía'
          : signalCount == 1
          ? '1 señal registrada'
          : '$signalCount señales registradas',
      activeWindowLabel: _buildActiveWindowLabel(latestActivity),
    );
  }

  String _buildCurrentQrStatus(Pet pet, QrActivityEntry? latestActivity) {
    if (latestActivity == null) {
      return pet.qrEnabled ? 'QR activo y listo' : 'QR preparado para activación';
    }
    if (latestActivity.iconKey == 'location') {
      return 'QR con reporte reciente';
    }
    if (latestActivity.iconKey == 'qr') {
      return pet.qrEnabled
          ? 'QR activo con señales recientes'
          : 'QR consultado con trazabilidad activa';
    }
    return pet.qrEnabled ? 'QR activo con base persistida' : 'QR preparado para activación';
  }

  String _buildLastSignalLabel(QrActivityEntry? latestActivity) {
    if (latestActivity == null) {
      return 'Sin señales todavía';
    }

    final prefix = latestActivity.iconKey == 'location'
        ? 'Último reporte'
        : latestActivity.iconKey == 'qr'
        ? 'Último escaneo'
        : latestActivity.title;

    switch (latestActivity.timeLabel) {
      case 'Ahora':
        return '$prefix hace instantes';
      case 'Hoy':
        return '$prefix de hoy';
      default:
        return '$prefix ${latestActivity.timeLabel.toLowerCase()}';
    }
  }

  String _buildActiveWindowLabel(QrActivityEntry? latestActivity) {
    if (latestActivity == null) {
      return 'Esperando primera señal';
    }
    if (latestActivity.timeLabel == 'Ahora') {
      return 'Actividad en tiempo real';
    }
    if (latestActivity.timeLabel == 'Hoy') {
      return 'Actividad reciente';
    }
    return 'Actividad registrada';
  }

  Future<void> _updateQrState(
    String userId,
    Pet pet,
    PersistedPetQrState Function(PersistedPetQrState currentState) transform,
  ) async {
    final currentState = _stateForUser(userId);
    final existingQrState =
        currentState.qrStates[pet.id] ?? _buildInitialQrStateForPet(pet);
    final nextQrState = transform(existingQrState);
    final updatedQrStates = <String, PersistedPetQrState>{
      ...currentState.qrStates,
      pet.id: nextQrState,
    };
    final updatedPets = <Pet>[
      for (final currentPet in currentState.pets)
        if (currentPet.id == pet.id)
          currentPet.copyWith(
            qrStatus: _buildQrStatusSnapshot(currentPet, nextQrState).lastSignalDetail,
            qrLastUpdate: _buildPetQrLastUpdateLabel(nextQrState),
          )
        else
          currentPet,
    ];
    _userStates[userId] = currentState.copyWith(
      pets: updatedPets,
      qrStates: updatedQrStates,
    );
    await _persistUserState(userId);
  }

  String _buildPetQrLastUpdateLabel(PersistedPetQrState qrState) {
    if (qrState.activity.isEmpty) return 'Sin actividad todavía';

    switch (qrState.activity.first.timeLabel) {
      case 'Ahora':
        return 'Actualizado ahora';
      case 'Hoy':
        return 'Actualizado hoy';
      default:
        return qrState.activity.first.timeLabel;
    }
  }

  String _buildPetsSummaryLabel(int count) {
    if (count == 1) {
      return '1 mascota dentro de la cuenta';
    }
    return '$count mascotas dentro de la cuenta';
  }
}
