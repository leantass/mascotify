enum PetVaccineSuggestionCategory {
  base,
  riskBased,
  consultVet,
  noGeneralRoutine,
}

class PetVaccineSuggestion {
  const PetVaccineSuggestion({
    required this.id,
    required this.speciesKey,
    required this.vaccineName,
    required this.category,
    required this.description,
    required this.note,
    required this.sourceLabel,
    this.isRiskBased = false,
    this.isManualOnly = false,
  });

  final String id;
  final String speciesKey;
  final String vaccineName;
  final PetVaccineSuggestionCategory category;
  final String description;
  final String note;
  final String sourceLabel;
  final bool isRiskBased;
  final bool isManualOnly;

  String get categoryLabel {
    switch (category) {
      case PetVaccineSuggestionCategory.base:
        return 'Base';
      case PetVaccineSuggestionCategory.riskBased:
        return 'Según riesgo';
      case PetVaccineSuggestionCategory.consultVet:
        return 'Consultar veterinario';
      case PetVaccineSuggestionCategory.noGeneralRoutine:
        return 'Sin esquema general';
    }
  }
}
