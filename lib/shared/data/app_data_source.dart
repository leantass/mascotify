import '../models/account_identity_models.dart';
import '../models/app_user.dart';
import '../models/notification_models.dart';
import '../models/pet.dart';
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
  MessageThread? findMessageThreadForPet(Pet pet);
  List<SocialInboxEntry> getSocialInboxEntries();
  List<SavedProfileEntry> getSavedProfiles();

  List<ProfessionalProfile> getProfessionalProfiles();
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

  Future<void> syncCurrentUserState();
  Future<void> addPet(Pet pet);
  Future<void> setNotificationsEnabled(bool enabled);
}

class MockMascotifyDataSource implements MascotifyDataSource {
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
    return findMockThreadForPet(pet);
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
    return List.unmodifiable(buildMockNotifications());
  }

  @override
  List<MessageThread> getMessageThreads() {
    return List.unmodifiable(buildMockMessageThreads());
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
    return List.unmodifiable(buildMockSavedProfiles());
  }

  @override
  List<SocialInboxEntry> getSocialInboxEntries() {
    return List.unmodifiable(buildMockSocialInboxEntries());
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
  Future<void> addPet(Pet pet) async {}

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {}

  @override
  Future<void> syncCurrentUserState() async {}
}

class AppData {
  AppData._();

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

  static MessageThread? findMessageThreadForPet(Pet pet) {
    return source.findMessageThreadForPet(pet);
  }

  static List<SocialInboxEntry> get socialInboxEntries =>
      source.getSocialInboxEntries();

  static List<SavedProfileEntry> get savedProfiles => source.getSavedProfiles();

  static List<ProfessionalProfile> get professionalProfiles =>
      source.getProfessionalProfiles();

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
