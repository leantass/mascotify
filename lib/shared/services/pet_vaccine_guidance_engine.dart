import '../data/pet_vaccine_knowledge_catalog.dart';
import '../data/pet_vaccine_suggestion_catalog.dart';
import '../models/pet.dart';
import '../models/pet_vaccine.dart';
import '../models/pet_vaccine_guidance.dart';
import '../models/pet_vaccine_schedule_rule.dart';

class PetVaccineGuidanceEngine {
  const PetVaccineGuidanceEngine._();

  static PetVaccineGuidance buildVaccineGuidanceForPet(
    Pet pet,
    List<PetVaccine> vaccines, {
    DateTime? now,
  }) {
    final today = _dateOnly(now ?? DateTime.now());
    final speciesKey = PetVaccineSuggestionCatalog.speciesKeyFor(pet.species);
    final speciesSet = PetVaccineSuggestionCatalog.forSpecies(pet.species);
    final ageYears = _ageYearsFromLabel(pet.ageLabel);
    final stage = _stageFor(speciesKey, ageYears);
    final allRules = PetVaccineKnowledgeCatalog.rulesForSpecies(pet.species);
    final hasUniversalCalendar =
        PetVaccineKnowledgeCatalog.hasUniversalCalendar(pet.species);
    final baseRules = allRules
        .where(
          (rule) =>
              rule.category == PetVaccineRuleCategory.base ||
              rule.category == PetVaccineRuleCategory.legalRegional,
        )
        .toList();
    final riskRules = allRules
        .where(
          (rule) =>
              rule.category == PetVaccineRuleCategory.segunRiesgo ||
              rule.category == PetVaccineRuleCategory.consultarVeterinario,
        )
        .toList();

    final warnings = <String>[
      if (ageYears == null)
        'Para calcular recordatorios con más precisión, agregá fecha de nacimiento o edad aproximada.',
      if (pet.country.trim().isEmpty && pet.region.trim().isEmpty)
        'Algunas vacunas y normas dependen del país o provincia. Completá ubicación para mejorar la orientación.',
    ];
    final seniorWarnings = <String>[
      if (stage == PetHealthAgeStage.senior)
        'Si tu mascota es senior, tuvo reacciones previas, está preñada o tiene tratamientos en curso, consultá con un veterinario antes de vacunar.',
    ];

    final reviewNow = <PetVaccineGuidanceItem>[];
    final upcoming = <PetVaccineGuidanceItem>[];
    final overdue = <PetVaccineGuidanceItem>[];
    final incompleteHistory = <PetVaccineGuidanceItem>[];

    if (!hasUniversalCalendar) {
      return PetVaccineGuidance(
        knowledgeVersion: PetVaccineKnowledgeCatalog.version,
        speciesKey: speciesKey,
        speciesLabel: speciesSet.speciesLabel,
        ageStage: stage,
        ageStageLabel: _stageLabel(stage),
        approximateAgeYears: ageYears,
        regionLabel: _regionLabel(pet),
        baseRules: const <PetVaccineScheduleRule>[],
        riskRules: riskRules,
        reviewNow: const <PetVaccineGuidanceItem>[],
        upcoming: const <PetVaccineGuidanceItem>[],
        overdue: const <PetVaccineGuidanceItem>[],
        incompleteHistory: const <PetVaccineGuidanceItem>[],
        warnings: warnings,
        seniorWarnings: seniorWarnings,
        hasUniversalCalendar: false,
        noGeneralCalendarMessage:
            PetVaccineKnowledgeCatalog.noGeneralCalendarMessage(pet.species),
      );
    }

    final appliedVaccines = vaccines.where((item) => item.isApplied).toList();
    final pendingVaccines = vaccines.where((item) => item.isPending).toList();

    if (appliedVaccines.isEmpty) {
      final message = ageYears == null
          ? 'No hay historial sanitario cargado. Revisá con un veterinario qué vacunas registrar.'
          : 'Historial sanitario incompleto para ${pet.name}. No se marca como al día sin registros cargados.';
      for (final rule in baseRules) {
        final item = PetVaccineGuidanceItem(
          rule: rule,
          status: PetVaccineGuidanceStatus.historialIncompleto,
          message: message,
          actionLabel: 'Agregar como pendiente',
        );
        incompleteHistory.add(item);
        reviewNow.add(item);
      }
    }

    for (final pending in pendingVaccines) {
      final rule = _matchingRuleFor(pending.name, allRules);
      if (rule == null) continue;
      reviewNow.add(
        PetVaccineGuidanceItem(
          rule: rule,
          status: PetVaccineGuidanceStatus.pendiente,
          message: '${pending.name} figura como pendiente en la libreta.',
          actionLabel: 'Registrar como aplicada',
          dueDate: pending.nextDoseDate,
          daysUntilDue: pending.nextDoseDate?.difference(today).inDays,
        ),
      );
    }

    for (final vaccine in appliedVaccines) {
      final rule = _matchingRuleFor(vaccine.name, allRules);
      if (rule == null) continue;
      final dueDate = vaccine.nextDoseDate ?? _estimatedDueDate(vaccine, rule);
      if (dueDate == null) continue;
      final due = _dateOnly(dueDate);
      final days = due.difference(today).inDays;
      if (days < 0) {
        overdue.add(
          PetVaccineGuidanceItem(
            rule: rule,
            status: PetVaccineGuidanceStatus.vencida,
            message:
                '${rule.displayName} podría requerir refuerzo o revisión veterinaria.',
            actionLabel: 'Registrar refuerzo',
            dueDate: due,
            daysUntilDue: days,
          ),
        );
      } else if (days <= 30) {
        upcoming.add(
          PetVaccineGuidanceItem(
            rule: rule,
            status: PetVaccineGuidanceStatus.proxima,
            message:
                '${rule.displayName} tiene una próxima dosis o revisión cercana.',
            actionLabel: 'Ver detalle',
            dueDate: due,
            daysUntilDue: days,
          ),
        );
      }
    }

    reviewNow.addAll(overdue);

    return PetVaccineGuidance(
      knowledgeVersion: PetVaccineKnowledgeCatalog.version,
      speciesKey: speciesKey,
      speciesLabel: speciesSet.speciesLabel,
      ageStage: stage,
      ageStageLabel: _stageLabel(stage),
      approximateAgeYears: ageYears,
      regionLabel: _regionLabel(pet),
      baseRules: baseRules,
      riskRules: riskRules,
      reviewNow: _dedupeItems(reviewNow),
      upcoming: _dedupeItems(upcoming),
      overdue: _dedupeItems(overdue),
      incompleteHistory: _dedupeItems(incompleteHistory),
      warnings: warnings,
      seniorWarnings: seniorWarnings,
      hasUniversalCalendar: true,
      noGeneralCalendarMessage: null,
    );
  }

  static int? _ageYearsFromLabel(String label) {
    final normalized = label.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    final match = RegExp(r'(\d+)').firstMatch(normalized);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  static PetHealthAgeStage _stageFor(String speciesKey, int? ageYears) {
    if (ageYears == null) return PetHealthAgeStage.desconocida;
    if (speciesKey == 'dog') {
      if (ageYears < 1) return PetHealthAgeStage.cachorro;
      if (ageYears >= 8) return PetHealthAgeStage.senior;
      return PetHealthAgeStage.adulto;
    }
    if (speciesKey == 'cat') {
      if (ageYears < 1) return PetHealthAgeStage.gatito;
      if (ageYears >= 10) return PetHealthAgeStage.senior;
      return PetHealthAgeStage.adulto;
    }
    if (speciesKey == 'horse') {
      if (ageYears < 2) return PetHealthAgeStage.cria;
      if (ageYears >= 18) return PetHealthAgeStage.senior;
      return PetHealthAgeStage.adulto;
    }
    if (ageYears >= 7) return PetHealthAgeStage.senior;
    if (ageYears < 1) return PetHealthAgeStage.cria;
    return PetHealthAgeStage.adulto;
  }

  static String _stageLabel(PetHealthAgeStage stage) {
    switch (stage) {
      case PetHealthAgeStage.cachorro:
        return 'Cachorro';
      case PetHealthAgeStage.gatito:
        return 'Gatito';
      case PetHealthAgeStage.cria:
        return 'Cría';
      case PetHealthAgeStage.joven:
        return 'Joven';
      case PetHealthAgeStage.adulto:
        return 'Adulto';
      case PetHealthAgeStage.senior:
        return 'Senior';
      case PetHealthAgeStage.cualquierEdad:
        return 'Cualquier edad';
      case PetHealthAgeStage.desconocida:
        return 'Edad no informada';
    }
  }

  static String _regionLabel(Pet pet) {
    final parts = [
      if (pet.country.trim().isNotEmpty) pet.country.trim(),
      if (pet.region.trim().isNotEmpty) pet.region.trim(),
      if (pet.city.trim().isNotEmpty) pet.city.trim(),
    ];
    return parts.isEmpty ? 'Región no informada' : parts.join(' / ');
  }

  static PetVaccineScheduleRule? _matchingRuleFor(
    String vaccineName,
    List<PetVaccineScheduleRule> rules,
  ) {
    final normalized = _normalize(vaccineName);
    for (final rule in rules) {
      final ruleName = _normalize(rule.vaccineName);
      final displayName = _normalize(rule.displayName);
      if (normalized.contains(ruleName) ||
          ruleName.contains(normalized) ||
          normalized.contains(displayName) ||
          displayName.contains(normalized)) {
        return rule;
      }
    }
    return null;
  }

  static DateTime? _estimatedDueDate(
    PetVaccine vaccine,
    PetVaccineScheduleRule rule,
  ) {
    final interval = rule.dueIntervalMonths;
    final applicationDate = vaccine.applicationDate;
    if (interval == null || applicationDate == null) return null;
    return DateTime(
      applicationDate.year,
      applicationDate.month + interval,
      applicationDate.day,
    );
  }

  static List<PetVaccineGuidanceItem> _dedupeItems(
    List<PetVaccineGuidanceItem> items,
  ) {
    final seen = <String>{};
    return [
      for (final item in items)
        if (seen.add('${item.rule.id}-${item.status.name}')) item,
    ];
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }
}
