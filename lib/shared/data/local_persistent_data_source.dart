import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/auth_session_controller.dart';
import '../models/account_identity_models.dart';
import '../models/app_user.dart';
import '../models/notification_models.dart';
import '../models/pet.dart';
import '../models/profile_option_item.dart';
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
    required this.messagesNotificationsEnabled,
    required this.petActivityNotificationsEnabled,
    required this.ecosystemUpdatesNotificationsEnabled,
    required this.strategicNotificationsEnabled,
    required this.planName,
    required this.privacyLevel,
    required this.securityLevel,
    required this.publicProfileEnabled,
    required this.showBasicInfoOnPublicProfile,
    required this.ecosystemSuggestionsEnabled,
    required this.pets,
    required this.threads,
    required this.qrStates,
    required this.socialInboxEntries,
    required this.savedProfiles,
    required this.professionalProfile,
  });

  final bool notificationsEnabled;
  final bool messagesNotificationsEnabled;
  final bool petActivityNotificationsEnabled;
  final bool ecosystemUpdatesNotificationsEnabled;
  final bool strategicNotificationsEnabled;
  final String planName;
  final String privacyLevel;
  final String securityLevel;
  final bool publicProfileEnabled;
  final bool showBasicInfoOnPublicProfile;
  final bool ecosystemSuggestionsEnabled;
  final List<Pet> pets;
  final List<MessageThread> threads;
  final Map<String, PersistedPetQrState> qrStates;
  final List<SocialInboxEntry> socialInboxEntries;
  final List<SavedProfileEntry> savedProfiles;
  final ProfessionalProfile? professionalProfile;

  PersistedLocalUserState copyWith({
    bool? notificationsEnabled,
    bool? messagesNotificationsEnabled,
    bool? petActivityNotificationsEnabled,
    bool? ecosystemUpdatesNotificationsEnabled,
    bool? strategicNotificationsEnabled,
    String? planName,
    String? privacyLevel,
    String? securityLevel,
    bool? publicProfileEnabled,
    bool? showBasicInfoOnPublicProfile,
    bool? ecosystemSuggestionsEnabled,
    List<Pet>? pets,
    List<MessageThread>? threads,
    Map<String, PersistedPetQrState>? qrStates,
    List<SocialInboxEntry>? socialInboxEntries,
    List<SavedProfileEntry>? savedProfiles,
    ProfessionalProfile? professionalProfile,
    bool clearProfessionalProfile = false,
  }) {
    return PersistedLocalUserState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      messagesNotificationsEnabled:
          messagesNotificationsEnabled ?? this.messagesNotificationsEnabled,
      petActivityNotificationsEnabled:
          petActivityNotificationsEnabled ??
          this.petActivityNotificationsEnabled,
      ecosystemUpdatesNotificationsEnabled:
          ecosystemUpdatesNotificationsEnabled ??
          this.ecosystemUpdatesNotificationsEnabled,
      strategicNotificationsEnabled:
          strategicNotificationsEnabled ?? this.strategicNotificationsEnabled,
      planName: planName ?? this.planName,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      securityLevel: securityLevel ?? this.securityLevel,
      publicProfileEnabled: publicProfileEnabled ?? this.publicProfileEnabled,
      showBasicInfoOnPublicProfile:
          showBasicInfoOnPublicProfile ?? this.showBasicInfoOnPublicProfile,
      ecosystemSuggestionsEnabled:
          ecosystemSuggestionsEnabled ?? this.ecosystemSuggestionsEnabled,
      pets: pets ?? this.pets,
      threads: threads ?? this.threads,
      qrStates: qrStates ?? this.qrStates,
      socialInboxEntries: socialInboxEntries ?? this.socialInboxEntries,
      savedProfiles: savedProfiles ?? this.savedProfiles,
      professionalProfile: clearProfessionalProfile
          ? null
          : professionalProfile ?? this.professionalProfile,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'notificationsEnabled': notificationsEnabled,
      'messagesNotificationsEnabled': messagesNotificationsEnabled,
      'petActivityNotificationsEnabled': petActivityNotificationsEnabled,
      'ecosystemUpdatesNotificationsEnabled':
          ecosystemUpdatesNotificationsEnabled,
      'strategicNotificationsEnabled': strategicNotificationsEnabled,
      'planName': planName,
      'privacyLevel': privacyLevel,
      'securityLevel': securityLevel,
      'publicProfileEnabled': publicProfileEnabled,
      'showBasicInfoOnPublicProfile': showBasicInfoOnPublicProfile,
      'ecosystemSuggestionsEnabled': ecosystemSuggestionsEnabled,
      'pets': pets.map((item) => item.toJson()).toList(),
      'threads': threads.map((item) => item.toJson()).toList(),
      'qrStates': qrStates.map((key, value) => MapEntry(key, value.toJson())),
      'socialInboxEntries': socialInboxEntries
          .map((item) => item.toJson())
          .toList(),
      'savedProfiles': savedProfiles.map((item) => item.toJson()).toList(),
      'professionalProfile': professionalProfile?.toJson(),
    };
  }

  factory PersistedLocalUserState.fromJson(Map<String, dynamic> json) {
    final notificationsEnabled = json['notificationsEnabled'] as bool? ?? true;
    final strategicNotificationsEnabled =
        json['strategicNotificationsEnabled'] as bool? ?? true;

    return PersistedLocalUserState(
      notificationsEnabled: notificationsEnabled,
      messagesNotificationsEnabled:
          json['messagesNotificationsEnabled'] as bool? ?? notificationsEnabled,
      petActivityNotificationsEnabled:
          json['petActivityNotificationsEnabled'] as bool? ??
          notificationsEnabled,
      ecosystemUpdatesNotificationsEnabled:
          json['ecosystemUpdatesNotificationsEnabled'] as bool? ??
          strategicNotificationsEnabled,
      strategicNotificationsEnabled: strategicNotificationsEnabled,
      planName: json['planName'] as String? ?? 'Mascotify Plus',
      privacyLevel: json['privacyLevel'] as String? ?? 'Equilibrada',
      securityLevel: json['securityLevel'] as String? ?? 'Estándar',
      publicProfileEnabled: json['publicProfileEnabled'] as bool? ?? true,
      showBasicInfoOnPublicProfile:
          json['showBasicInfoOnPublicProfile'] as bool? ?? true,
      ecosystemSuggestionsEnabled:
          json['ecosystemSuggestionsEnabled'] as bool? ?? true,
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
      qrStates: (json['qrStates'] as Map<dynamic, dynamic>? ?? const {}).map(
        (key, value) => MapEntry(
          key as String,
          PersistedPetQrState.fromJson(
            Map<String, dynamic>.from(value as Map<dynamic, dynamic>),
          ),
        ),
      ),
      socialInboxEntries:
          (json['socialInboxEntries'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (item) => SocialInboxEntry.fromJson(
                  Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
                ),
              )
              .toList(),
      savedProfiles:
          (json['savedProfiles'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (item) => SavedProfileEntry.fromJson(
                  Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
                ),
              )
              .toList(),
      professionalProfile: json['professionalProfile'] == null
          ? null
          : ProfessionalProfile.fromJson(
              Map<String, dynamic>.from(
                json['professionalProfile'] as Map<dynamic, dynamic>,
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
    // Hydrate known account snapshots once so role/session changes can swap
    // state without recomputing every persisted slice from scratch.
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
    final publicProfessionalProfile = currentState.professionalProfile;
    final professionalProfile = currentAccount.professionalProfile;

    return MascotifyAccount(
      id: currentAccount.id,
      ownerName: currentAccount.ownerName,
      email: currentAccount.email,
      planName: currentState.planName,
      city: currentAccount.city,
      memberSince: currentAccount.memberSince,
      baseSummary: currentAccount.baseSummary,
      linkedProfilesSummary: currentAccount.linkedProfilesSummary,
      availableExperiences: currentAccount.availableExperiences,
      familyProfile: familyProfile == null
          ? null
          : FamilyAccountProfile(
              householdName: familyProfile.householdName,
              petsSummaryLabel: _buildPetsSummaryLabel(
                currentState.pets.length,
              ),
              primaryGoal: familyProfile.primaryGoal,
              nextSetupStep: currentState.pets.isEmpty
                  ? 'Agregar la primera mascota para completar la base local.'
                  : familyProfile.nextSetupStep,
              capabilities: familyProfile.capabilities,
            ),
      professionalProfile: professionalProfile == null
          ? null
          : ProfessionalAccountProfile(
              businessName: professionalProfile.businessName,
              category:
                  publicProfessionalProfile?.specialty ??
                  professionalProfile.category,
              operationLabel:
                  publicProfessionalProfile?.serviceAvailabilityLabel ??
                  professionalProfile.operationLabel,
              primaryGoal: professionalProfile.primaryGoal,
              nextSetupStep: publicProfessionalProfile == null
                  ? 'Activar la presencia profesional para volver visible tu base operativa y tus servicios.'
                  : professionalProfile.nextSetupStep,
              services:
                  publicProfessionalProfile?.services ??
                  professionalProfile.services,
              capabilities: professionalProfile.capabilities,
            ),
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
    for (final professional in getProfessionalProfiles()) {
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
      planName: currentState.planName,
      city: currentAccount.city,
      memberSince: currentAccount.memberSince,
      notificationsEnabled: currentState.notificationsEnabled,
      messagesNotificationsEnabled: currentState.messagesNotificationsEnabled,
      petActivityNotificationsEnabled:
          currentState.petActivityNotificationsEnabled,
      ecosystemUpdatesNotificationsEnabled:
          currentState.ecosystemUpdatesNotificationsEnabled,
      strategicNotificationsEnabled: currentState.strategicNotificationsEnabled,
      privacyLevel: currentState.privacyLevel,
      securityLevel: currentState.securityLevel,
      publicProfileEnabled: currentState.publicProfileEnabled,
      showBasicInfoOnPublicProfile: currentState.showBasicInfoOnPublicProfile,
      ecosystemSuggestionsEnabled: currentState.ecosystemSuggestionsEnabled,
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
        getSocialInboxEntries(),
        getSavedProfiles(),
        getQrActivityEntriesForPet,
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
    final currentProfessionalProfile = getCurrentProfessionalProfile();
    final currentProfileContents = currentProfessionalProfile == null
        ? const <ProfessionalLibraryContent>[]
        : currentProfessionalProfile.featuredContent
              .map(
                (content) => ProfessionalLibraryContent(
                  title: content.title,
                  professional: currentProfessionalProfile.name,
                  category: content.category,
                  duration: content.duration,
                  summary: content.summary,
                  accentColorHex: currentProfessionalProfile.accentColorHex,
                ),
              )
              .toList();

    return List.unmodifiable(
      _prependUniqueByTitle(
        currentProfileContents,
        professionalLibraryContents,
        (item) => item.title,
      ),
    );
  }

  @override
  List<ProfessionalProfile> getProfessionalProfiles() {
    final currentProfessionalProfile = getCurrentProfessionalProfile();
    if (currentProfessionalProfile == null) {
      return List.unmodifiable(professionalProfiles);
    }

    return List.unmodifiable(
      _prependUniqueByTitle(
        <ProfessionalProfile>[currentProfessionalProfile],
        professionalProfiles,
        (item) => item.name,
      ),
    );
  }

  @override
  ProfessionalProfile? getCurrentProfessionalProfile() {
    return _stateForCurrentUser().professionalProfile;
  }

  @override
  Future<void> activateCurrentProfessionalProfile() async {
    final userId = _currentUserId;
    if (userId == null) return;

    final nextProfile = _buildProfessionalProfileForCurrentAccount(
      requireExposure: false,
    );
    if (nextProfile == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(
      professionalProfile: nextProfile,
    );
    await _persistUserState(userId);
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
    final currentProfessionalProfile = getCurrentProfessionalProfile();
    final currentSpotlight = currentProfessionalProfile == null
        ? const <ProfessionalServiceSpotlight>[]
        : <ProfessionalServiceSpotlight>[
            ProfessionalServiceSpotlight(
              title: currentProfessionalProfile.specialty,
              subtitle: currentProfessionalProfile.serviceSummary,
              availabilityLabel:
                  currentProfessionalProfile.serviceAvailabilityLabel,
              accentColorHex: currentProfessionalProfile.accentColorHex,
            ),
          ];

    return List.unmodifiable(
      _prependUniqueByTitle(
        currentSpotlight,
        professionalServiceSpotlights,
        (item) => item.title,
      ),
    );
  }

  @override
  List<String> getProfessionalSpecialties() {
    final currentProfessionalProfile = getCurrentProfessionalProfile();
    if (currentProfessionalProfile == null) {
      return List.unmodifiable(professionalSpecialties);
    }

    return List.unmodifiable(
      _prependUniqueByTitle(
        <String>[currentProfessionalProfile.specialty],
        professionalSpecialties,
        (item) => item,
      ),
    );
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
    return List.unmodifiable(_savedProfilesWithCurrentPets());
  }

  @override
  List<SocialInboxEntry> getSocialInboxEntries() {
    return List.unmodifiable(_socialInboxEntriesWithCurrentPets());
  }

  @override
  Future<void> expressInterest({
    required String petId,
    required String interestType,
    required String message,
  }) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final pet = findPetById(petId);
    if (pet == null) return;

    final trimmedMessage = message.trim();
    final interestMessage = trimmedMessage.isEmpty
        ? 'Hay interés en ${pet.name} y el perfil quedó marcado para seguir la afinidad dentro de Mascotify.'
        : trimmedMessage;

    final currentState = _stateForUser(userId);
    final nextEntry = SocialInboxEntry(
      pet: pet,
      direction: 'Enviado',
      interestType: interestType,
      status: 'Pendiente',
      message: interestMessage,
      accentColorHex: _accentColorForInterestType(interestType),
    );
    final updatedEntries = <SocialInboxEntry>[
      nextEntry,
      ...currentState.socialInboxEntries.where(
        (entry) => entry.pet.id != petId || entry.direction != 'Enviado',
      ),
    ];

    _userStates[userId] = currentState.copyWith(
      socialInboxEntries: updatedEntries,
    );
    await _persistUserState(userId);
  }

  @override
  SightingLocationReference getSuggestedLocationForPet(Pet pet) {
    return _qrStateForPet(pet).suggestedLocation;
  }

  @override
  Future<void> saveProfile(String petId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final pet = findPetById(petId);
    if (pet == null) return;

    final currentState = _stateForUser(userId);
    final updatedEntries = <SavedProfileEntry>[
      SavedProfileEntry(
        pet: pet,
        savedAtLabel: 'Guardado hoy',
        reason: pet.matchingPreferences.matchSummary,
      ),
      ...currentState.savedProfiles.where((entry) => entry.pet.id != petId),
    ];

    _userStates[userId] = currentState.copyWith(savedProfiles: updatedEntries);
    await _persistUserState(userId);
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
    final initialQrState = _buildInitialQrStateForPet(pet);
    final normalizedPet = pet.copyWith(
      qrStatus: _buildQrStatusSnapshot(pet, initialQrState).lastSignalDetail,
      qrLastUpdate: _buildPetQrLastUpdateLabel(initialQrState),
    );
    final updatedQrStates = <String, PersistedPetQrState>{
      ...currentState.qrStates,
      pet.id: initialQrState,
    };
    final updatedState = currentState.copyWith(
      pets: <Pet>[...currentState.pets, normalizedPet],
      qrStates: updatedQrStates,
    );
    _userStates[userId] = updatedState;
    await _persistUserState(userId);
  }

  @override
  Future<void> updatePet(Pet pet) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    final existingIndex = currentState.pets.indexWhere(
      (item) => item.id == pet.id,
    );
    if (existingIndex == -1) return;

    final previousPet = currentState.pets[existingIndex];
    final qrState =
        currentState.qrStates[pet.id] ?? _buildInitialQrStateForPet(pet);
    final normalizedPet = pet.copyWith(
      qrStatus: _buildQrStatusSnapshot(pet, qrState).lastSignalDetail,
      qrLastUpdate: _buildPetQrLastUpdateLabel(qrState),
    );
    final updatedPets = <Pet>[...currentState.pets]
      ..[existingIndex] = normalizedPet;
    final updatedThreads = currentState.threads
        .map(
          (thread) => thread.pet.id == pet.id
              ? thread.copyWith(pet: normalizedPet)
              : thread,
        )
        .toList();
    final updatedSocialInboxEntries = currentState.socialInboxEntries
        .map(
          (entry) => entry.pet.id == pet.id
              ? entry.copyWith(pet: normalizedPet)
              : entry,
        )
        .toList();
    final updatedSavedProfiles = currentState.savedProfiles
        .map(
          (entry) => entry.pet.id == pet.id
              ? entry.copyWith(
                  pet: normalizedPet,
                  reason: normalizedPet.matchingPreferences.matchSummary,
                )
              : entry,
        )
        .toList();

    _userStates[userId] = currentState.copyWith(
      pets: updatedPets,
      threads: updatedThreads,
      socialInboxEntries: updatedSocialInboxEntries,
      savedProfiles: updatedSavedProfiles,
      qrStates: <String, PersistedPetQrState>{
        ...currentState.qrStates,
        previousPet.id: qrState,
      },
    );
    await _persistUserState(userId);
  }

  @override
  Future<void> deletePet(String petId) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    final updatedQrStates = <String, PersistedPetQrState>{
      ...currentState.qrStates,
    }..remove(petId);

    _userStates[userId] = currentState.copyWith(
      pets: currentState.pets.where((pet) => pet.id != petId).toList(),
      threads: currentState.threads
          .where((thread) => thread.pet.id != petId)
          .toList(),
      socialInboxEntries: currentState.socialInboxEntries
          .where((entry) => entry.pet.id != petId)
          .toList(),
      savedProfiles: currentState.savedProfiles
          .where((entry) => entry.pet.id != petId)
          .toList(),
      qrStates: updatedQrStates,
    );
    await _persistUserState(userId);
  }

  @override
  Future<void> addAutomatedReply(String threadId) async {
    final thread = findMessageThreadById(threadId);
    if (thread == null || thread.autoReplies.isEmpty) return;

    final userId = _currentUserId;
    if (userId == null) return;

    final reply =
        thread.autoReplies[thread.messages.length % thread.autoReplies.length];

    await _updateThread(userId, threadId, (currentThread) {
      return currentThread.copyWith(
        messages: <MessageEntry>[
          ...currentThread.messages,
          MessageEntry(text: reply, timestamp: 'Ahora', isMine: false),
        ],
        lastMessage: reply,
        lastActivity: 'Ahora',
        unreadCount: currentThread.unreadCount + 1,
        isAwaitingMyReply: true,
      );
    });
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
          MessageEntry(text: trimmedText, timestamp: 'Ahora', isMine: true),
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

    await _updateQrState(userId, pet, (currentState) {
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
    });
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(notificationsEnabled: enabled);
    await _persistUserState(userId);
  }

  @override
  Future<void> setMessagesNotificationsEnabled(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(
      messagesNotificationsEnabled: enabled,
    );
    await _persistUserState(userId);
  }

  @override
  Future<void> setPetActivityNotificationsEnabled(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(
      petActivityNotificationsEnabled: enabled,
    );
    await _persistUserState(userId);
  }

  @override
  Future<void> setEcosystemUpdatesNotificationsEnabled(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(
      ecosystemUpdatesNotificationsEnabled: enabled,
    );
    await _persistUserState(userId);
  }

  @override
  Future<void> setStrategicNotificationsEnabled(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(
      strategicNotificationsEnabled: enabled,
    );
    await _persistUserState(userId);
  }

  @override
  Future<void> setPlanName(String planName) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(planName: planName);
    await _persistUserState(userId);
  }

  @override
  Future<void> setPrivacyLevel(String privacyLevel) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(privacyLevel: privacyLevel);
    await _persistUserState(userId);
  }

  @override
  Future<void> setSecurityLevel(String securityLevel) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(securityLevel: securityLevel);
    await _persistUserState(userId);
  }

  @override
  Future<void> setPublicProfileEnabled(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(publicProfileEnabled: enabled);
    await _persistUserState(userId);
  }

  @override
  Future<void> setShowBasicInfoOnPublicProfile(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(
      showBasicInfoOnPublicProfile: enabled,
    );
    await _persistUserState(userId);
  }

  @override
  Future<void> setEcosystemSuggestionsEnabled(bool enabled) async {
    final userId = _currentUserId;
    if (userId == null) return;

    final currentState = _stateForUser(userId);
    _userStates[userId] = currentState.copyWith(
      ecosystemSuggestionsEnabled: enabled,
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

    await _updateQrState(userId, pet, (currentState) {
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
    });
  }

  @override
  Future<void> syncCurrentUserState() async {
    final userId = _currentUserId;
    if (userId == null) return;

    _ensureUserStateLoaded(userId);
    _synchronizeCurrentProfessionalProfile(userId);
    await _persistUserState(userId);
  }

  void _handleAuthStateChanged() {
    final nextUserId = _currentUserId;
    if (_activeUserId == nextUserId) return;

    _activeUserId = nextUserId;
    if (nextUserId == null) return;

    // Auth restore may happen before some derived slices exist on disk for the
    // current account, so every account switch re-validates the local snapshot.
    _ensureUserStateLoaded(nextUserId);
    _synchronizeCurrentProfessionalProfile(nextUserId);
    unawaited(_persistUserState(nextUserId));
  }

  String? get _currentUserId => _sessionController.currentAccount?.id;

  PersistedLocalUserState _stateForCurrentUser() {
    final userId = _currentUserId;
    if (userId == null) {
      final pets = _seedPetsForCurrentAccount();
      return _buildSeededUserState(pets, professionalProfile: null);
    }
    return _stateForUser(userId);
  }

  PersistedLocalUserState _stateForUser(String userId) {
    _ensureUserStateLoaded(userId);
    return _userStates[userId]!;
  }

  void _ensureUserStateLoaded(String userId) {
    if (_userStates.containsKey(userId)) return;

    final rawValue = _preferences.getString(_userStateStorageKey(userId));
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
    _userStates[userId] = _buildSeededUserState(
      pets,
      professionalProfile: _seedProfessionalProfileForCurrentAccount(),
    );
  }

  Future<void> _persistUserState(String userId) async {
    final state = _userStates[userId];
    if (state == null) return;

    await _preferences.setString(
      _userStateStorageKey(userId),
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

  String _userStateStorageKey(String userId) {
    return '$_userStatePrefix$userId';
  }

  PersistedLocalUserState _buildSeededUserState(
    List<Pet> pets, {
    required ProfessionalProfile? professionalProfile,
  }) {
    return PersistedLocalUserState(
      notificationsEnabled: true,
      messagesNotificationsEnabled: true,
      petActivityNotificationsEnabled: true,
      ecosystemUpdatesNotificationsEnabled: true,
      strategicNotificationsEnabled: true,
      planName: _sessionController.currentAccount?.planName ?? 'Mascotify Plus',
      privacyLevel: 'Equilibrada',
      securityLevel: 'Estándar',
      publicProfileEnabled: true,
      showBasicInfoOnPublicProfile: true,
      ecosystemSuggestionsEnabled: true,
      pets: pets,
      threads: _seedThreadsForCurrentAccount(pets),
      qrStates: _seedQrStatesForCurrentAccount(pets),
      socialInboxEntries: _seedSocialInboxEntriesForCurrentAccount(pets),
      savedProfiles: _seedSavedProfilesForCurrentAccount(pets),
      professionalProfile: professionalProfile,
    );
  }

  List<Pet> _seedPetsForCurrentAccount() {
    if (!_shouldSeedDemoContentForCurrentAccount()) {
      return const <Pet>[];
    }

    return _cloneJsonList(MockData.pets, (pet) => pet.toJson(), Pet.fromJson);
  }

  List<MessageThread> _seedThreadsForCurrentAccount(List<Pet> pets) {
    if (!_shouldSeedDemoContentForCurrentAccount()) {
      return const <MessageThread>[];
    }

    return _cloneJsonList(
      buildMockMessageThreads(pets),
      (thread) => thread.toJson(),
      MessageThread.fromJson,
    );
  }

  List<SocialInboxEntry> _seedSocialInboxEntriesForCurrentAccount(
    List<Pet> pets,
  ) {
    if (!_shouldSeedDemoContentForCurrentAccount()) {
      return const <SocialInboxEntry>[];
    }

    return _cloneJsonList(
      buildMockSocialInboxEntries(pets),
      (entry) => entry.toJson(),
      SocialInboxEntry.fromJson,
    );
  }

  List<SavedProfileEntry> _seedSavedProfilesForCurrentAccount(List<Pet> pets) {
    if (!_shouldSeedDemoContentForCurrentAccount()) {
      return const <SavedProfileEntry>[];
    }

    return _cloneJsonList(
      buildMockSavedProfiles(pets),
      (entry) => entry.toJson(),
      SavedProfileEntry.fromJson,
    );
  }

  Map<String, PersistedPetQrState> _seedQrStatesForCurrentAccount(
    List<Pet> pets,
  ) {
    final preferMockSeed = _shouldSeedDemoContentForCurrentAccount();
    return _buildQrStatesForPets(pets, preferMockSeed: preferMockSeed);
  }

  ProfessionalProfile? _seedProfessionalProfileForCurrentAccount() {
    return _buildProfessionalProfileForCurrentAccount(requireExposure: true);
  }

  ProfessionalProfile? _buildProfessionalProfileForCurrentAccount({
    required bool requireExposure,
  }) {
    final currentAccount = _sessionController.currentAccount;
    if (currentAccount == null) return null;

    final professionalProfile = currentAccount.professionalProfile;
    if (professionalProfile == null) return null;
    if (requireExposure &&
        !_shouldExposeProfessionalProfile(professionalProfile)) {
      return null;
    }

    if (!_isLocalUserId(currentAccount.id)) {
      for (final profile in professionalProfiles) {
        if (profile.name == currentAccount.ownerName) {
          return ProfessionalProfile.fromJson(
            Map<String, dynamic>.from(profile.toJson()),
          );
        }
      }
    }

    return _buildProfessionalProfileFromAccount(
      account: currentAccount,
      profile: professionalProfile,
      accentColorHex: _accentColorForProfessionalCategory(
        professionalProfile.category,
      ),
    );
  }

  void _synchronizeCurrentProfessionalProfile(String userId) {
    final currentState = _stateForUser(userId);
    final currentAccount = _sessionController.currentAccount;

    if (currentAccount?.professionalProfile == null) {
      if (currentState.professionalProfile == null) return;
      _userStates[userId] = currentState.copyWith(
        clearProfessionalProfile: true,
      );
      return;
    }

    final sourceProfile = currentState.professionalProfile == null
        ? _buildProfessionalProfileForCurrentAccount(requireExposure: true)
        : _buildProfessionalProfileForCurrentAccount(requireExposure: false);
    if (sourceProfile == null) return;

    final nextProfile = currentState.professionalProfile == null
        ? sourceProfile
        : currentState.professionalProfile!.copyWith(
            name: sourceProfile.name,
            specialty: sourceProfile.specialty,
            biography: sourceProfile.biography,
            description: sourceProfile.description,
            contentType: sourceProfile.contentType,
            valueProposition: sourceProfile.valueProposition,
            approachStyle: sourceProfile.approachStyle,
            helpSummary: sourceProfile.helpSummary,
            profileModeLabel: sourceProfile.profileModeLabel,
            presenceStatusLabel: sourceProfile.presenceStatusLabel,
            serviceAvailabilityLabel: sourceProfile.serviceAvailabilityLabel,
            serviceSummary: sourceProfile.serviceSummary,
            services: sourceProfile.services,
            trustSignals: sourceProfile.trustSignals,
            primaryActionLabel: sourceProfile.primaryActionLabel,
            secondaryActionLabel: sourceProfile.secondaryActionLabel,
            topics: sourceProfile.topics,
            featuredContent: sourceProfile.featuredContent,
            accentColorHex: sourceProfile.accentColorHex,
          );

    final previousJson = currentState.professionalProfile?.toJson();
    final nextJson = nextProfile.toJson();
    if (jsonEncode(previousJson) == jsonEncode(nextJson)) return;

    _userStates[userId] = currentState.copyWith(
      professionalProfile: nextProfile,
    );
  }

  PersistedLocalUserState _normalizeUserState(
    String userId,
    PersistedLocalUserState state,
  ) {
    // Local accounts must never inherit demo seeds. Demo accounts can keep
    // seeded scaffolding, but only until a real persisted slice replaces it.
    if (_isLocalUserId(userId)) {
      final nextPets = _looksLikeLegacyMockSeed(state.pets)
          ? const <Pet>[]
          : state.pets;
      final nextThreads =
          _looksLikeLegacyMockThreads(state.threads) || nextPets.isEmpty
          ? const <MessageThread>[]
          : state.threads;
      final nextSocialInboxEntries = _normalizeSocialInboxEntries(
        nextPets,
        state.socialInboxEntries,
        preferMockSeed: false,
      );
      final nextSavedProfiles = _normalizeSavedProfiles(
        nextPets,
        state.savedProfiles,
        preferMockSeed: false,
      );
      return state.copyWith(
        pets: nextPets,
        threads: nextThreads,
        qrStates: _normalizeQrStates(userId, nextPets, state.qrStates),
        socialInboxEntries: nextSocialInboxEntries,
        savedProfiles: nextSavedProfiles,
      );
    }

    final nextThreads = state.threads.isEmpty && state.pets.isNotEmpty
        ? _seedThreadsForCurrentAccount(state.pets)
        : state.threads;
    final nextQrStates = _normalizeQrStates(userId, state.pets, state.qrStates);
    final nextSocialInboxEntries = _normalizeSocialInboxEntries(
      state.pets,
      state.socialInboxEntries,
      preferMockSeed: true,
    );
    final nextSavedProfiles = _normalizeSavedProfiles(
      state.pets,
      state.savedProfiles,
      preferMockSeed: true,
    );
    if (nextThreads != state.threads ||
        nextQrStates != state.qrStates ||
        nextSocialInboxEntries != state.socialInboxEntries ||
        nextSavedProfiles != state.savedProfiles) {
      return state.copyWith(
        threads: nextThreads,
        qrStates: nextQrStates,
        socialInboxEntries: nextSocialInboxEntries,
        savedProfiles: nextSavedProfiles,
      );
    }

    return state;
  }

  bool _isLocalUserId(String userId) {
    return userId.startsWith('local-');
  }

  bool _shouldSeedDemoContentForCurrentAccount() {
    final currentAccount = _sessionController.currentAccount;
    return currentAccount == null || !_isLocalUserId(currentAccount.id);
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

  List<SocialInboxEntry> _normalizeSocialInboxEntries(
    List<Pet> pets,
    List<SocialInboxEntry> entries, {
    required bool preferMockSeed,
  }) {
    if (pets.isEmpty) {
      return const <SocialInboxEntry>[];
    }

    final petsById = <String, Pet>{for (final pet in pets) pet.id: pet};
    final normalized = entries
        .where((entry) => petsById.containsKey(entry.pet.id))
        .map((entry) => entry.copyWith(pet: petsById[entry.pet.id]!))
        .toList();

    if (preferMockSeed && normalized.isEmpty) {
      return _seedSocialInboxEntriesForCurrentAccount(pets);
    }

    return normalized;
  }

  List<SavedProfileEntry> _normalizeSavedProfiles(
    List<Pet> pets,
    List<SavedProfileEntry> entries, {
    required bool preferMockSeed,
  }) {
    if (pets.isEmpty) {
      return const <SavedProfileEntry>[];
    }

    final petsById = <String, Pet>{for (final pet in pets) pet.id: pet};
    final normalized = entries
        .where((entry) => petsById.containsKey(entry.pet.id))
        .map((entry) => entry.copyWith(pet: petsById[entry.pet.id]!))
        .toList();

    if (preferMockSeed && normalized.isEmpty) {
      return _seedSavedProfilesForCurrentAccount(pets);
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

  List<SocialInboxEntry> _socialInboxEntriesWithCurrentPets() {
    final petsById = <String, Pet>{for (final pet in getPets()) pet.id: pet};
    return _stateForCurrentUser().socialInboxEntries
        .where((entry) => petsById.containsKey(entry.pet.id))
        .map((entry) => entry.copyWith(pet: petsById[entry.pet.id]!))
        .toList();
  }

  List<SavedProfileEntry> _savedProfilesWithCurrentPets() {
    final petsById = <String, Pet>{for (final pet in getPets()) pet.id: pet};
    return _stateForCurrentUser().savedProfiles
        .where((entry) => petsById.containsKey(entry.pet.id))
        .map((entry) => entry.copyWith(pet: petsById[entry.pet.id]!))
        .toList();
  }

  PersistedPetQrState _qrStateForPet(Pet pet) {
    final currentState = _stateForCurrentUser();
    return currentState.qrStates[pet.id] ?? _buildInitialQrStateForPet(pet);
  }

  List<QrActivityEntry> _operationalQrActivity(PersistedPetQrState qrState) {
    return qrState.activity
        .where((entry) => _isOperationalQrSignal(entry))
        .toList();
  }

  QrActivityEntry? _latestOperationalQrActivity(PersistedPetQrState qrState) {
    for (final entry in qrState.activity) {
      if (_isOperationalQrSignal(entry)) {
        return entry;
      }
    }

    return null;
  }

  bool _isOperationalQrSignal(QrActivityEntry entry) {
    return entry.iconKey == 'qr' || entry.iconKey == 'location';
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
          title: pet.qrEnabled
              ? 'Perfil QR listo para usarse'
              : 'Perfil QR preparado',
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
    final latestActivity = _latestOperationalQrActivity(qrState);
    final signalCount = _operationalQrActivity(qrState).length;

    return QrStatusSnapshot(
      currentStatus: _buildCurrentQrStatus(pet, latestActivity),
      protectedContactState: pet.qrEnabled
          ? 'Contacto protegido activo'
          : 'Contacto protegido pendiente de vincular',
      lastSignalLabel: _buildLastSignalLabel(latestActivity),
      lastSignalDetail:
          latestActivity?.detail ??
          'La ficha está lista para sumar trazabilidad cuando llegue el primer escaneo o reporte real.',
      totalScansLabel: signalCount == 0
          ? 'Sin actividad QR todavía'
          : signalCount == 1
          ? '1 evento QR registrado'
          : '$signalCount eventos QR registrados',
      activeWindowLabel: _buildActiveWindowLabel(latestActivity),
    );
  }

  String _buildCurrentQrStatus(Pet pet, QrActivityEntry? latestActivity) {
    if (latestActivity == null) {
      return pet.qrEnabled
          ? 'QR activo sin actividad todavía'
          : 'QR preparado sin actividad todavía';
    }
    if (latestActivity.iconKey == 'location') {
      return 'QR con reporte reciente';
    }
    if (latestActivity.iconKey == 'qr') {
      return pet.qrEnabled
          ? 'QR activo con señales recientes'
          : 'QR consultado con trazabilidad activa';
    }
    return pet.qrEnabled
        ? 'QR activo con base persistida'
        : 'QR preparado para activación';
  }

  String _buildLastSignalLabel(QrActivityEntry? latestActivity) {
    if (latestActivity == null) {
      return 'Sin actividad QR todavía';
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
      return 'Esperando primer evento';
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
            qrStatus: _buildQrStatusSnapshot(
              currentPet,
              nextQrState,
            ).lastSignalDetail,
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
    final latestActivity = _latestOperationalQrActivity(qrState);
    if (latestActivity == null) return 'Sin actividad todavía';

    switch (latestActivity.timeLabel) {
      case 'Ahora':
        return 'Actualizado ahora';
      case 'Hoy':
        return 'Actualizado hoy';
      default:
        return latestActivity.timeLabel;
    }
  }

  bool _shouldExposeProfessionalProfile(ProfessionalAccountProfile? profile) {
    if (profile == null) return false;

    final businessName = profile.businessName.toLowerCase();
    final category = profile.category.toLowerCase();
    return !businessName.contains('futuro') &&
        !category.contains('disponible para activar');
  }

  ProfessionalProfile _buildProfessionalProfileFromAccount({
    required MascotifyAccount account,
    required ProfessionalAccountProfile profile,
    required int accentColorHex,
  }) {
    final trimmedServices = profile.services
        .where((item) => item.trim().isNotEmpty)
        .toList();
    final visibleServices = trimmedServices.isEmpty
        ? const <String>['Servicio principal', 'Orientación']
        : trimmedServices;
    final mainTopic = visibleServices.first;
    final topics = _prependUniqueByTitle(
      <String>[profile.category],
      visibleServices,
      (item) => item,
    ).take(4).toList();

    return ProfessionalProfile(
      name: profile.businessName,
      specialty: profile.category,
      biography:
          '${profile.businessName} ya tiene una presencia profesional persistida por cuenta dentro de Mascotify, pensada para ordenar servicios, confianza y visibilidad desde ${account.city}.',
      description:
          'Este perfil deja de ser solo vidriera: resume base operativa, servicios visibles y una presencia pública coherente con la cuenta profesional activa.',
      contentType: 'Base operativa + contenido',
      valueProposition: profile.operationLabel,
      approachStyle: 'Claro, profesional y orientado a operación real',
      helpSummary:
          'Puede centralizar servicios como ${visibleServices.take(3).join(', ')}, dejando una base lista para contacto, solicitudes y capas más operativas.',
      profileModeLabel: 'Perfil profesional persistido',
      presenceStatusLabel: _isLocalUserId(account.id)
          ? 'Perfil real guardado por cuenta'
          : 'Perfil validado y visible',
      serviceAvailabilityLabel: profile.operationLabel,
      serviceSummary:
          'Servicios visibles hoy: ${visibleServices.join(', ')}. La cuenta ya sostiene una base profesional coherente para crecer sin rehacer la vertical.',
      services: visibleServices,
      trustSignals: _prependUniqueByTitle(
        <String>[
          'Cuenta profesional persistida',
          'Servicios asociados a la cuenta correcta',
        ],
        profile.capabilities,
        (item) => item,
      ).take(4).toList(),
      primaryActionLabel: 'Recibir solicitud',
      secondaryActionLabel: 'Ver contenido',
      topics: topics,
      featuredContent: <ProfessionalContentPreview>[
        ProfessionalContentPreview(
          title: '$mainTopic dentro de una base profesional real',
          category: profile.category,
          duration: '2 min',
          summary:
              'Una pieza breve para explicar cómo ${profile.businessName} presenta su propuesta, servicios y forma de trabajo dentro de Mascotify.',
        ),
        ProfessionalContentPreview(
          title: 'Qué servicios ya están visibles en ${profile.businessName}',
          category: 'Operación',
          duration: '1 min 30 s',
          summary:
              'Resumen corto para ordenar la presencia pública, el alcance actual y los próximos pasos operativos del perfil.',
        ),
      ],
      accentColorHex: accentColorHex,
    );
  }

  int _accentColorForProfessionalCategory(String category) {
    final normalized = category.toLowerCase();
    if (normalized.contains('veter')) return 0xFFDDF6F6;
    if (normalized.contains('comport')) return 0xFFFFE1EA;
    if (normalized.contains('cría') || normalized.contains('cria')) {
      return 0xFFFFF2C6;
    }
    return 0xFFDDF6F6;
  }

  int _accentColorForInterestType(String interestType) {
    final normalized = interestType.toLowerCase();
    if (normalized.contains('cría') || normalized.contains('cria')) {
      return 0xFFDDF6F6;
    }
    if (normalized.contains('supervisado')) {
      return 0xFFFFE1EA;
    }
    return 0xFFFFF2C6;
  }

  List<T> _prependUniqueByTitle<T>(
    List<T> leading,
    List<T> trailing,
    String Function(T item) keyBuilder,
  ) {
    final seen = <String>{};
    final merged = <T>[];

    for (final item in [...leading, ...trailing]) {
      final key = keyBuilder(item);
      if (!seen.add(key)) continue;
      merged.add(item);
    }

    return merged;
  }

  List<T> _cloneJsonList<T>(
    Iterable<T> source,
    Map<String, dynamic> Function(T item) toJson,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    return source
        .map((item) => fromJson(Map<String, dynamic>.from(toJson(item))))
        .toList();
  }

  String _buildPetsSummaryLabel(int count) {
    if (count == 1) {
      return '1 mascota dentro de la cuenta';
    }
    return '$count mascotas dentro de la cuenta';
  }
}
