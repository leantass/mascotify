enum PetVaccineRuleCategory {
  base,
  segunRiesgo,
  legalRegional,
  consultarVeterinario,
  noRutinaGeneral,
}

enum PetHealthAgeStage {
  cachorro,
  gatito,
  cria,
  joven,
  adulto,
  senior,
  cualquierEdad,
  desconocida,
}

class PetVaccineScheduleRule {
  const PetVaccineScheduleRule({
    required this.id,
    required this.speciesKey,
    required this.vaccineName,
    required this.displayName,
    required this.category,
    required this.ageStage,
    required this.sourceLabel,
    required this.disclaimer,
    this.minAgeWeeks,
    this.recommendedFromLabel = '',
    this.initialSeriesLabel = '',
    this.boosterLabel = '',
    this.frequencyLabel = '',
    this.dueIntervalMonths,
    this.countryCode,
    this.regionCode,
    this.riskFactors = const <String>[],
    this.appliesIfUnknownHistory = true,
    this.requiresVetConfirmation = true,
  });

  final String id;
  final String speciesKey;
  final String vaccineName;
  final String displayName;
  final PetVaccineRuleCategory category;
  final PetHealthAgeStage ageStage;
  final int? minAgeWeeks;
  final String recommendedFromLabel;
  final String initialSeriesLabel;
  final String boosterLabel;
  final String frequencyLabel;
  final int? dueIntervalMonths;
  final String? countryCode;
  final String? regionCode;
  final List<String> riskFactors;
  final bool appliesIfUnknownHistory;
  final String sourceLabel;
  final String disclaimer;
  final bool requiresVetConfirmation;

  String get categoryLabel {
    switch (category) {
      case PetVaccineRuleCategory.base:
        return 'Base orientativa';
      case PetVaccineRuleCategory.segunRiesgo:
        return 'Según riesgo';
      case PetVaccineRuleCategory.legalRegional:
        return 'Legal/regional';
      case PetVaccineRuleCategory.consultarVeterinario:
        return 'Consultar veterinario';
      case PetVaccineRuleCategory.noRutinaGeneral:
        return 'Sin rutina general';
    }
  }
}
