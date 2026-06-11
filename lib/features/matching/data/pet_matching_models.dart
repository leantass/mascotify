import '../../../shared/models/pet.dart';

enum PetMatchingGoal {
  walk('Paseo'),
  play('Juego'),
  company('Compania');

  const PetMatchingGoal(this.label);

  final String label;
}

class PetMatchingCriteria {
  const PetMatchingCriteria({
    required this.zone,
    required this.goal,
    this.sameSpeciesOnly = true,
    this.preferSameBreed = true,
  });

  final String zone;
  final PetMatchingGoal goal;
  final bool sameSpeciesOnly;
  final bool preferSameBreed;
}

class PetMatchCandidate {
  const PetMatchCandidate({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageLabel,
    required this.sizeLabel,
    required this.zone,
    required this.energyLabel,
    required this.sociabilityLabel,
    required this.goal,
    required this.distanceLabel,
    required this.colorHex,
    required this.summary,
  });

  final String id;
  final String name;
  final String species;
  final String breed;
  final String ageLabel;
  final String sizeLabel;
  final String zone;
  final String energyLabel;
  final String sociabilityLabel;
  final PetMatchingGoal goal;
  final String distanceLabel;
  final int colorHex;
  final String summary;
}

class PetMatchScore {
  const PetMatchScore({
    required this.candidate,
    required this.percent,
    required this.reasons,
  });

  final PetMatchCandidate candidate;
  final int percent;
  final List<String> reasons;

  String get label {
    if (percent >= 88) return 'Muy compatible';
    if (percent >= 74) return 'Compatible';
    return 'Cerca tuyo';
  }
}

class PetMatchingService {
  const PetMatchingService();

  List<PetMatchScore> findMatches({
    required Pet pet,
    required PetMatchingCriteria criteria,
  }) {
    final scored =
        _demoCandidates
            .where(
              (candidate) =>
                  !criteria.sameSpeciesOnly ||
                  _sameText(candidate.species, pet.species),
            )
            .map((candidate) => _scoreCandidate(pet, candidate, criteria))
            .where((score) => score.percent >= 58)
            .toList()
          ..sort((a, b) => b.percent.compareTo(a.percent));

    return scored.take(6).toList(growable: false);
  }

  PetMatchScore _scoreCandidate(
    Pet pet,
    PetMatchCandidate candidate,
    PetMatchingCriteria criteria,
  ) {
    var score = 22;
    final reasons = <String>[];

    if (_sameText(candidate.species, pet.species)) {
      score += 24;
      reasons.add('Misma especie');
    }
    if (criteria.preferSameBreed && _similarBreed(candidate.breed, pet.breed)) {
      score += 12;
      reasons.add('Raza compatible');
    }
    if (_sameText(candidate.zone, criteria.zone) ||
        _sameText(candidate.zone, _zoneFromPet(pet))) {
      score += 20;
      reasons.add('Zona cercana');
    }
    if (_ageBand(candidate.ageLabel) == _ageBand(pet.ageLabel)) {
      score += 9;
      reasons.add('Edad compatible');
    }
    if (_energyFromPet(pet) == candidate.energyLabel) {
      score += 8;
      reasons.add('Energia similar');
    }
    if (candidate.sociabilityLabel == 'Sociable') {
      score += 6;
      reasons.add('Buena sociabilidad');
    }
    if (candidate.goal == criteria.goal) {
      score += 9;
      reasons.add(criteria.goal.label);
    }

    return PetMatchScore(
      candidate: candidate,
      percent: score.clamp(0, 98),
      reasons: reasons.take(3).toList(growable: false),
    );
  }
}

String zoneForPet(Pet pet) => _zoneFromPet(pet);

String _zoneFromPet(Pet pet) {
  if (pet.city.trim().isNotEmpty) return pet.city;
  final parts = pet.location.split(',');
  return parts.first.trim().isEmpty ? 'CABA' : parts.first.trim();
}

String _energyFromPet(Pet pet) {
  final text = [
    pet.matchingPreferences.rhythmLabel,
    ...pet.personalityTags,
  ].join(' ').toLowerCase();
  if (text.contains('activo') || text.contains('jugu')) return 'Alta';
  if (text.contains('suave') || text.contains('calmo')) return 'Baja';
  return 'Media';
}

String _ageBand(String label) {
  final lower = label.toLowerCase();
  final match = RegExp(r'\d+').firstMatch(lower);
  final value = match == null ? 3 : int.parse(match.group(0)!);
  if (lower.contains('mes')) return 'joven';
  if (value <= 2) return 'joven';
  if (value >= 8) return 'senior';
  return 'adulto';
}

bool _sameText(String a, String b) =>
    a.trim().toLowerCase() == b.trim().toLowerCase();

bool _similarBreed(String a, String b) {
  final left = a.toLowerCase();
  final right = b.toLowerCase();
  return left == right ||
      left.contains(right.split(' ').first) ||
      right.contains(left.split(' ').first);
}

const List<PetMatchCandidate> _demoCandidates = [
  PetMatchCandidate(
    id: 'match-luna',
    name: 'Luna',
    species: 'Perro',
    breed: 'Border Collie mix',
    ageLabel: '3 anos',
    sizeLabel: 'Mediana',
    zone: 'Palermo',
    energyLabel: 'Alta',
    sociabilityLabel: 'Sociable',
    goal: PetMatchingGoal.play,
    distanceLabel: '1.4 km aprox.',
    colorHex: 0xFFDDF6F6,
    summary: 'Le gustan los juegos de olfato y encuentros breves en plaza.',
  ),
  PetMatchCandidate(
    id: 'match-simon',
    name: 'Simon',
    species: 'Perro',
    breed: 'Golden Retriever',
    ageLabel: '6 anos',
    sizeLabel: 'Grande',
    zone: 'Belgrano',
    energyLabel: 'Media',
    sociabilityLabel: 'Sociable',
    goal: PetMatchingGoal.walk,
    distanceLabel: '3.2 km aprox.',
    colorHex: 0xFFFFF2C6,
    summary: 'Paseos tranquilos, buena lectura social y familia cuidadosa.',
  ),
  PetMatchCandidate(
    id: 'match-mora',
    name: 'Mora',
    species: 'Gata',
    breed: 'European Shorthair',
    ageLabel: '1 ano',
    sizeLabel: 'Chica',
    zone: 'Caballito',
    energyLabel: 'Baja',
    sociabilityLabel: 'Gradual',
    goal: PetMatchingGoal.company,
    distanceLabel: '900 m aprox.',
    colorHex: 0xFFFFE1EA,
    summary: 'Perfil calmo para presentaciones digitales y tiempos suaves.',
  ),
  PetMatchCandidate(
    id: 'match-toto',
    name: 'Toto',
    species: 'Perro',
    breed: 'Mestizo mediano',
    ageLabel: '4 anos',
    sizeLabel: 'Mediana',
    zone: 'Villa Crespo',
    energyLabel: 'Media',
    sociabilityLabel: 'Sociable',
    goal: PetMatchingGoal.walk,
    distanceLabel: '2.1 km aprox.',
    colorHex: 0xFFE4F5F5,
    summary: 'Sale a caminar por la tarde y prefiere encuentros supervisados.',
  ),
  PetMatchCandidate(
    id: 'match-olivia',
    name: 'Olivia',
    species: 'Gata',
    breed: 'Comun europea',
    ageLabel: '2 anos',
    sizeLabel: 'Chica',
    zone: 'Almagro',
    energyLabel: 'Baja',
    sociabilityLabel: 'Gradual',
    goal: PetMatchingGoal.company,
    distanceLabel: '2.8 km aprox.',
    colorHex: 0xFFFFE1EA,
    summary: 'Rutina indoor, curiosa y compatible con vinculos sin apuro.',
  ),
];
