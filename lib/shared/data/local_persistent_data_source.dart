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

class PersistedLocalUserState {
  const PersistedLocalUserState({
    required this.notificationsEnabled,
    required this.pets,
    required this.threads,
  });

  final bool notificationsEnabled;
  final List<Pet> pets;
  final List<MessageThread> threads;

  PersistedLocalUserState copyWith({
    bool? notificationsEnabled,
    List<Pet>? pets,
    List<MessageThread>? threads,
  }) {
    return PersistedLocalUserState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      pets: pets ?? this.pets,
      threads: threads ?? this.threads,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'notificationsEnabled': notificationsEnabled,
      'pets': pets.map((item) => item.toJson()).toList(),
      'threads': threads.map((item) => item.toJson()).toList(),
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
      buildMockNotifications(getPets(), getMessageThreads()),
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
    return List.unmodifiable(buildQrActivityEntriesForPet(pet));
  }

  @override
  QrStatusSnapshot getQrStatusSnapshotForPet(Pet pet) {
    return buildQrStatusSnapshotForPet(pet);
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
    return buildSuggestedLocationForPet(pet);
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
    final updatedState = currentState.copyWith(
      pets: <Pet>[...currentState.pets, pet],
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
      return PersistedLocalUserState(
        notificationsEnabled: true,
        pets: _seedPetsForCurrentAccount(),
        threads: _seedThreadsForCurrentAccount(_seedPetsForCurrentAccount()),
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

    _userStates[userId] = PersistedLocalUserState(
      notificationsEnabled: true,
      pets: _seedPetsForCurrentAccount(),
      threads: _seedThreadsForCurrentAccount(_seedPetsForCurrentAccount()),
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
      return state.copyWith(pets: nextPets, threads: nextThreads);
    }

    if (state.threads.isEmpty && state.pets.isNotEmpty) {
      return state.copyWith(
        threads: _seedThreadsForCurrentAccount(state.pets),
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

  bool _stateWasNormalized(
    PersistedLocalUserState previous,
    PersistedLocalUserState next,
  ) {
    return previous.pets.length != next.pets.length ||
        previous.threads.length != next.threads.length;
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

  String _buildPetsSummaryLabel(int count) {
    if (count == 1) {
      return '1 mascota dentro de la cuenta';
    }
    return '$count mascotas dentro de la cuenta';
  }
}
