class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.planName,
    required this.city,
    required this.memberSince,
    required this.notificationsEnabled,
    this.messagesNotificationsEnabled = true,
    this.petActivityNotificationsEnabled = true,
    this.ecosystemUpdatesNotificationsEnabled = true,
    required this.strategicNotificationsEnabled,
    required this.privacyLevel,
    required this.securityLevel,
    this.publicProfileEnabled = true,
    this.showBasicInfoOnPublicProfile = true,
    this.ecosystemSuggestionsEnabled = true,
  });

  final String id;
  final String name;
  final String email;
  final String planName;
  final String city;
  final String memberSince;
  final bool notificationsEnabled;
  final bool messagesNotificationsEnabled;
  final bool petActivityNotificationsEnabled;
  final bool ecosystemUpdatesNotificationsEnabled;
  final bool strategicNotificationsEnabled;
  final String privacyLevel;
  final String securityLevel;
  final bool publicProfileEnabled;
  final bool showBasicInfoOnPublicProfile;
  final bool ecosystemSuggestionsEnabled;
}
