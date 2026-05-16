class LostPet {
  const LostPet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageLabel,
    required this.sex,
    required this.colorHex,
    required this.country,
    required this.region,
    required this.city,
    required this.locationFreeText,
    required this.location,
    required this.lostZone,
    required this.lostDateLabel,
    required this.description,
    required this.contact,
    required this.distinctiveSigns,
    required this.isFound,
    required this.createdAt,
    this.photoLabel = '',
  });

  final String id;
  final String name;
  final String species;
  final String breed;
  final String ageLabel;
  final String sex;
  final int colorHex;
  final String country;
  final String region;
  final String city;
  final String locationFreeText;
  final String location;
  final String lostZone;
  final String lostDateLabel;
  final String description;
  final String contact;
  final String distinctiveSigns;
  final bool isFound;
  final DateTime createdAt;
  final String photoLabel;

  String get statusLabel => isFound ? 'Encontrada' : 'Perdida';

  String get breedSummary =>
      breed.trim().isEmpty ? species : '$species • $breed';

  String get readableLocation {
    final zone = lostZone.trim();
    if (zone.isEmpty) return location;
    if (location.trim().isEmpty) return zone;
    return '$zone, $location';
  }

  LostPet copyWith({
    String? id,
    String? name,
    String? species,
    String? breed,
    String? ageLabel,
    String? sex,
    int? colorHex,
    String? country,
    String? region,
    String? city,
    String? locationFreeText,
    String? location,
    String? lostZone,
    String? lostDateLabel,
    String? description,
    String? contact,
    String? distinctiveSigns,
    bool? isFound,
    DateTime? createdAt,
    String? photoLabel,
  }) {
    return LostPet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      ageLabel: ageLabel ?? this.ageLabel,
      sex: sex ?? this.sex,
      colorHex: colorHex ?? this.colorHex,
      country: country ?? this.country,
      region: region ?? this.region,
      city: city ?? this.city,
      locationFreeText: locationFreeText ?? this.locationFreeText,
      location: location ?? this.location,
      lostZone: lostZone ?? this.lostZone,
      lostDateLabel: lostDateLabel ?? this.lostDateLabel,
      description: description ?? this.description,
      contact: contact ?? this.contact,
      distinctiveSigns: distinctiveSigns ?? this.distinctiveSigns,
      isFound: isFound ?? this.isFound,
      createdAt: createdAt ?? this.createdAt,
      photoLabel: photoLabel ?? this.photoLabel,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'ageLabel': ageLabel,
      'sex': sex,
      'colorHex': colorHex,
      'country': country,
      'region': region,
      'city': city,
      'locationFreeText': locationFreeText,
      'location': location,
      'lostZone': lostZone,
      'lostDateLabel': lostDateLabel,
      'description': description,
      'contact': contact,
      'distinctiveSigns': distinctiveSigns,
      'isFound': isFound,
      'createdAt': createdAt.toIso8601String(),
      'photoLabel': photoLabel,
    };
  }

  factory LostPet.fromJson(Map<String, dynamic> json) {
    return LostPet(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String? ?? '',
      ageLabel: json['ageLabel'] as String? ?? '',
      sex: json['sex'] as String? ?? 'No informado',
      colorHex: json['colorHex'] as int? ?? 0xFFFFE1EA,
      country: json['country'] as String? ?? '',
      region: json['region'] as String? ?? '',
      city: json['city'] as String? ?? '',
      locationFreeText: json['locationFreeText'] as String? ?? '',
      location: json['location'] as String? ?? '',
      lostZone: json['lostZone'] as String? ?? '',
      lostDateLabel: json['lostDateLabel'] as String? ?? '',
      description: json['description'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      distinctiveSigns: json['distinctiveSigns'] as String? ?? '',
      isFound: json['isFound'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      photoLabel: json['photoLabel'] as String? ?? '',
    );
  }
}
