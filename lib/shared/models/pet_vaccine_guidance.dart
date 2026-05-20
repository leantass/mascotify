import 'pet_health_knowledge_version.dart';
import 'pet_vaccine_schedule_rule.dart';

enum PetVaccineGuidanceStatus {
  alDia,
  pendiente,
  proxima,
  vencida,
  historialIncompleto,
  segunRiesgo,
  consultarVeterinario,
  noHayCalendarioUniversal,
}

class PetVaccineGuidanceItem {
  const PetVaccineGuidanceItem({
    required this.rule,
    required this.status,
    required this.message,
    required this.actionLabel,
    this.dueDate,
    this.daysUntilDue,
  });

  final PetVaccineScheduleRule rule;
  final PetVaccineGuidanceStatus status;
  final String message;
  final String actionLabel;
  final DateTime? dueDate;
  final int? daysUntilDue;
}

class PetVaccineGuidance {
  const PetVaccineGuidance({
    required this.knowledgeVersion,
    required this.speciesKey,
    required this.speciesLabel,
    required this.ageStage,
    required this.ageStageLabel,
    required this.regionLabel,
    required this.baseRules,
    required this.riskRules,
    required this.reviewNow,
    required this.upcoming,
    required this.overdue,
    required this.incompleteHistory,
    required this.warnings,
    required this.seniorWarnings,
    required this.hasUniversalCalendar,
    required this.noGeneralCalendarMessage,
    this.approximateAgeYears,
  });

  final PetHealthKnowledgeVersion knowledgeVersion;
  final String speciesKey;
  final String speciesLabel;
  final PetHealthAgeStage ageStage;
  final String ageStageLabel;
  final int? approximateAgeYears;
  final String regionLabel;
  final List<PetVaccineScheduleRule> baseRules;
  final List<PetVaccineScheduleRule> riskRules;
  final List<PetVaccineGuidanceItem> reviewNow;
  final List<PetVaccineGuidanceItem> upcoming;
  final List<PetVaccineGuidanceItem> overdue;
  final List<PetVaccineGuidanceItem> incompleteHistory;
  final List<String> warnings;
  final List<String> seniorWarnings;
  final bool hasUniversalCalendar;
  final String? noGeneralCalendarMessage;
}
