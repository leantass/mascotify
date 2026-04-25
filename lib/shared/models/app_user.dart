class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.planName,
    required this.city,
    required this.memberSince,
    required this.notificationsEnabled,
    required this.strategicNotificationsEnabled,
    required this.privacyLevel,
    required this.securityLevel,
  });

  final String id;
  final String name;
  final String email;
  final String planName;
  final String city;
  final String memberSince;
  final bool notificationsEnabled;
  final bool strategicNotificationsEnabled;
  final String privacyLevel;
  final String securityLevel;
}
