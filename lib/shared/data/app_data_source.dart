import '../models/account_identity_models.dart';
import '../models/app_user.dart';
import '../models/notification_models.dart';
import '../models/pet.dart';
import '../models/profile_option_item.dart';
import '../models/professional_models.dart';
import '../models/report_models.dart';
import '../models/social_models.dart';
import 'account_identity_mock_data.dart';
import 'mock_data.dart';
import 'notifications_mock_data.dart';
import 'professional_mock_data.dart';
import 'reporting_mock_data.dart';
import 'social_mock_data.dart';

abstract class MascotifyDataSource {
  AppUser getCurrentUser();
  List<Pet> getPets();
  Pet? findPetById(String id);
  List<ProfileOptionItem> getProfileOptions();

  MascotifyAccount accountFor(AccountExperience experience);
  List<ExperienceOption> getExperienceOptions();
  OnboardingTrack trackFor(AccountExperience experience);

  List<EcosystemNotification> getNotifications();

  List<MessageThread> getMessageThreads();
  MessageThread? findMessageThreadById(String id);
  MessageThread? findMessageThreadForPet(Pet pet);
  Future<void> sendMessage(String threadId, String text);
  Future<void> addAutomatedReply(String threadId);
  List<SocialInboxEntry> getSocialInboxEntries();
  List<SavedProfileEntry> getSavedProfiles();
  Future<void> saveProfile(String petId);
  Future<void> expressInterest({
    required String petId,
    required String interestType,
    required String message,
  });

  List<ProfessionalProfile> getProfessionalProfiles();
  ProfessionalProfile? getCurrentProfessionalProfile();
  Future<void> activateCurrentProfessionalProfile();
  ProfessionalProfile? findProfessionalByName(String name);
  ProfessionalContentPreview? findFeaturedContent(
    ProfessionalProfile professional,
    String title,
  );
  List<ProfessionalLibraryContent> getProfessionalLibraryContents();
  List<ProfessionalRecommendation> getProfessionalRecommendations();
  List<ProfessionalServiceSpotlight> getProfessionalServiceSpotlights();
  List<String> getProfessionalSpecialties();

  SightingLocationReference getSuggestedLocationForPet(Pet pet);
  QrStatusSnapshot getQrStatusSnapshotForPet(Pet pet);
  List<QrActivityEntry> getQrActivityEntriesForPet(Pet pet);
  Future<void> registerQrScan(String petId);
  Future<void> submitSightingReport(SightingReportDraft draft);

  Future<void> syncCurrentUserState();
  Future<void> addPet(Pet pet);
  Future<void> setNotificationsEnabled(bool enabled);
}

class MockMascotifyDataSource implements MascotifyDataSource {
  // Keeps the original demo-only behavior available for isolated previews and
  // as a safe fallback before the persistent source is wired in main().
  const MockMascotifyDataSource();

  @override
  MascotifyAccount accountFor(AccountExperience experience) {
    return AccountIdentityMockData.accountFor(experience);
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
    return findMockThreadForPet(pet, pets: MockData.pets);
  }

  @override
  MessageThread? findMessageThreadById(String id) {
    for (final thread in buildMockMessageThreads(MockData.pets)) {
      if (thread.id == id) return thread;
    }
    return null;
  }

  @override
  Pet? findPetById(String id) {
    for (final pet in MockData.pets) {
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
    return MockData.currentUser;
  }

  @override
  List<ExperienceOption> getExperienceOptions() {
    return List.unmodifiable(AccountIdentityMockData.experienceOptions);
  }

  @override
  List<EcosystemNotification> getNotifications() {
    return List.unmodifiable(
      buildMockNotifications(
        MockData.pets,
        buildMockMessageThreads(MockData.pets),
        buildSuggestedLocationForPet,
        null,
        null,
        buildQrActivityEntriesForPet,
      ),
    );
  }

  @override
  List<MessageThread> getMessageThreads() {
    return List.unmodifiable(buildMockMessageThreads(MockData.pets));
  }

  @override
  List<Pet> getPets() {
    return List.unmodifiable(MockData.pets);
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
  ProfessionalProfile? getCurrentProfessionalProfile() {
    return professionalProfiles.isEmpty ? null : professionalProfiles.first;
  }

  @override
  Future<void> activateCurrentProfessionalProfile() async {}

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
  Future<void> registerQrScan(String petId) async {}

  @override
  List<SavedProfileEntry> getSavedProfiles() {
    return List.unmodifiable(buildMockSavedProfiles(MockData.pets));
  }

  @override
  List<SocialInboxEntry> getSocialInboxEntries() {
    return List.unmodifiable(buildMockSocialInboxEntries(MockData.pets));
  }

  @override
  Future<void> expressInterest({
    required String petId,
    required String interestType,
    required String message,
  }) async {}

  @override
  SightingLocationReference getSuggestedLocationForPet(Pet pet) {
    return buildSuggestedLocationForPet(pet);
  }

  @override
  OnboardingTrack trackFor(AccountExperience experience) {
    return AccountIdentityMockData.trackFor(experience);
  }

  @override
  Future<void> addPet(Pet pet) async {}

  @override
  Future<void> addAutomatedReply(String threadId) async {}

  @override
  Future<void> saveProfile(String petId) async {}

  @override
  Future<void> sendMessage(String threadId, String text) async {}

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {}

  @override
  Future<void> submitSightingReport(SightingReportDraft draft) async {}

  @override
  Future<void> syncCurrentUserState() async {}
}

class AppData {
  AppData._();

  // The app reads data through this static façade so screens stay agnostic
  // about whether they are backed by pure mock data or account-scoped local
  // persistence.
  static MascotifyDataSource source = const MockMascotifyDataSource();

  static AppUser get currentUser => source.getCurrentUser();

  static List<Pet> get pets => source.getPets();

  static Pet? findPetById(String id) => source.findPetById(id);

  static List<ProfileOptionItem> get profileOptions =>
      source.getProfileOptions();

  static MascotifyAccount accountFor(AccountExperience experience) {
    return source.accountFor(experience);
  }

  static List<ExperienceOption> get experienceOptions =>
      source.getExperienceOptions();

  static OnboardingTrack trackFor(AccountExperience experience) {
    return source.trackFor(experience);
  }

  static List<EcosystemNotification> get notifications =>
      source.getNotifications();

  static List<MessageThread> get messageThreads => source.getMessageThreads();

  static MessageThread? findMessageThreadById(String id) {
    return source.findMessageThreadById(id);
  }

  static MessageThread? findMessageThreadForPet(Pet pet) {
    return source.findMessageThreadForPet(pet);
  }

  static Future<void> sendMessage(String threadId, String text) {
    return source.sendMessage(threadId, text);
  }

  static Future<void> addAutomatedReply(String threadId) {
    return source.addAutomatedReply(threadId);
  }

  static List<SocialInboxEntry> get socialInboxEntries =>
      source.getSocialInboxEntries();

  static List<SavedProfileEntry> get savedProfiles => source.getSavedProfiles();

  static Future<void> saveProfile(String petId) {
    return source.saveProfile(petId);
  }

  static Future<void> expressInterest({
    required String petId,
    required String interestType,
    required String message,
  }) {
    return source.expressInterest(
      petId: petId,
      interestType: interestType,
      message: message,
    );
  }

  static List<ProfessionalProfile> get professionalProfiles =>
      source.getProfessionalProfiles();

  static ProfessionalProfile? get currentProfessionalProfile =>
      source.getCurrentProfessionalProfile();

  static Future<void> activateCurrentProfessionalProfile() {
    return source.activateCurrentProfessionalProfile();
  }

  static ProfessionalProfile? findProfessionalByName(String name) {
    return source.findProfessionalByName(name);
  }

  static ProfessionalContentPreview? findFeaturedContent(
    ProfessionalProfile professional,
    String title,
  ) {
    return source.findFeaturedContent(professional, title);
  }

  static List<ProfessionalLibraryContent> get professionalLibraryContents =>
      source.getProfessionalLibraryContents();

  static List<ProfessionalRecommendation> get professionalRecommendations =>
      source.getProfessionalRecommendations();

  static List<ProfessionalServiceSpotlight> get professionalServiceSpotlights =>
      source.getProfessionalServiceSpotlights();

  static List<String> get professionalSpecialties =>
      source.getProfessionalSpecialties();

  static SightingLocationReference suggestedLocationForPet(Pet pet) {
    return source.getSuggestedLocationForPet(pet);
  }

  static QrStatusSnapshot qrStatusSnapshotForPet(Pet pet) {
    return source.getQrStatusSnapshotForPet(pet);
  }

  static List<QrActivityEntry> qrActivityEntriesForPet(Pet pet) {
    return source.getQrActivityEntriesForPet(pet);
  }

  static Future<void> registerQrScan(String petId) {
    return source.registerQrScan(petId);
  }

  static Future<void> submitSightingReport(SightingReportDraft draft) {
    return source.submitSightingReport(draft);
  }

  static Future<void> syncCurrentUserState() {
    return source.syncCurrentUserState();
  }

  static Future<void> addPet(Pet pet) {
    return source.addPet(pet);
  }

  static Future<void> setNotificationsEnabled(bool enabled) {
    return source.setNotificationsEnabled(enabled);
  }
}
