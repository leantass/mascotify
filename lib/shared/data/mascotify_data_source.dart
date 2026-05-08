import '../models/account_identity_models.dart';
import '../models/app_user.dart';
import '../models/ecosystem_activity_feed_item.dart';
import '../models/notification_models.dart';
import '../models/pet.dart';
import '../models/pet_activity_event.dart';
import '../models/profile_option_item.dart';
import '../models/professional_models.dart';
import '../models/report_models.dart';
import '../models/social_models.dart';

/// Contract consumed by [AppData].
///
/// Implementations can be local, mock, or remote-backed. The active app still
/// uses the local implementation; this boundary keeps screens from depending on
/// storage details when a backend is introduced later.
abstract interface class MascotifyDataSource {
  AppUser getCurrentUser();
  List<Pet> getPets();
  Pet? findPetById(String id);
  List<PetActivityEvent> getPetActivityEvents(String petId);
  List<EcosystemActivityFeedItem> getEcosystemActivityFeedItems();
  List<ProfileOptionItem> getProfileOptions();

  MascotifyAccount accountFor(AccountExperience experience);
  List<ExperienceOption> getExperienceOptions();
  OnboardingTrack trackFor(AccountExperience experience);

  List<EcosystemNotification> getNotifications();
  int getUnreadNotificationsCount();
  Future<void> markNotificationRead(String notificationId);
  Future<void> markAllNotificationsRead();

  List<MessageThread> getMessageThreads();
  MessageThread? findMessageThreadById(String id);
  MessageThread? findMessageThreadForPet(Pet pet);
  Future<void> sendMessage(String threadId, String text);
  Future<void> addAutomatedReply(String threadId);
  List<SocialInboxEntry> getSocialInboxEntries();
  List<SavedProfileEntry> getSavedProfiles();
  List<ExploreClip> getExploreClips();
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
  Future<void> registerQrTraceabilityReview(String petId);
  Future<void> registerQrScan(String petId);
  Future<void> submitSightingReport(SightingReportDraft draft);

  Future<void> syncCurrentUserState();
  Future<void> addPet(Pet pet);
  Future<void> updatePet(Pet pet);
  Future<void> deletePet(String petId);
  Future<void> addPetActivityEvent(PetActivityEvent event);
  Future<void> setNotificationsEnabled(bool enabled);
  Future<void> setMessagesNotificationsEnabled(bool enabled);
  Future<void> setPetActivityNotificationsEnabled(bool enabled);
  Future<void> setEcosystemUpdatesNotificationsEnabled(bool enabled);
  Future<void> setStrategicNotificationsEnabled(bool enabled);
  Future<void> setPlanName(String planName);
  Future<void> setPrivacyLevel(String privacyLevel);
  Future<void> setSecurityLevel(String securityLevel);
  Future<void> setPublicProfileEnabled(bool enabled);
  Future<void> setShowBasicInfoOnPublicProfile(bool enabled);
  Future<void> setEcosystemSuggestionsEnabled(bool enabled);
}
