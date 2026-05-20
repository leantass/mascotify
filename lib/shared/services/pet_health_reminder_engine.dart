import '../models/notification_models.dart';
import '../models/pet.dart';
import '../models/pet_vaccine.dart';
import '../models/pet_vaccine_guidance.dart';
import '../models/pet_vaccine_reminder.dart';

class PetHealthReminderEngine {
  const PetHealthReminderEngine._();

  static List<PetVaccineReminder> buildPetHealthReminders(
    Pet pet,
    List<PetVaccine> vaccines,
    PetVaccineGuidance guidance, {
    DateTime? now,
  }) {
    final today = DateTime(
      now?.year ?? DateTime.now().year,
      now?.month ?? DateTime.now().month,
      now?.day ?? DateTime.now().day,
    );
    final reminders = <PetVaccineReminder>[];

    if (guidance.incompleteHistory.isNotEmpty) {
      reminders.add(
        _reminder(
          id: 'health-${pet.id}-history',
          petId: pet.id,
          ruleId: 'history',
          vaccineName: 'Historial sanitario',
          status: PetVaccineReminderStatus.historialIncompleto,
          severity: PetVaccineReminderSeverity.warning,
          message: 'Falta cargar el historial sanitario de ${pet.name}.',
          actionLabel: 'Revisar historial',
          now: today,
        ),
      );
    }

    for (final item in guidance.overdue) {
      reminders.add(
        _reminder(
          id: 'health-${pet.id}-${item.rule.id}-overdue',
          petId: pet.id,
          ruleId: item.rule.id,
          vaccineName: item.rule.displayName,
          status: PetVaccineReminderStatus.vencida,
          severity: PetVaccineReminderSeverity.important,
          message:
              'La vacuna ${item.rule.displayName} de ${pet.name} podría requerir refuerzo.',
          actionLabel: 'Revisar vacuna',
          dueDate: item.dueDate,
          daysUntilDue: item.daysUntilDue,
          now: today,
        ),
      );
    }

    for (final item in guidance.upcoming) {
      reminders.add(
        _reminder(
          id: 'health-${pet.id}-${item.rule.id}-upcoming',
          petId: pet.id,
          ruleId: item.rule.id,
          vaccineName: item.rule.displayName,
          status: PetVaccineReminderStatus.proxima,
          severity: (item.daysUntilDue ?? 31) <= 7
              ? PetVaccineReminderSeverity.important
              : PetVaccineReminderSeverity.info,
          message: '${pet.name} tiene una vacuna próxima para revisar.',
          actionLabel: 'Ver salud',
          dueDate: item.dueDate,
          daysUntilDue: item.daysUntilDue,
          now: today,
        ),
      );
    }

    for (final vaccine in vaccines.where((item) => item.isPending)) {
      reminders.add(
        _reminder(
          id: 'health-${pet.id}-${_stable(vaccine.name)}-pending',
          petId: pet.id,
          ruleId: 'manual-pending',
          vaccineName: vaccine.name,
          status: PetVaccineReminderStatus.pendiente,
          severity: PetVaccineReminderSeverity.warning,
          message:
              '${vaccine.name} está pendiente en la libreta de ${pet.name}.',
          actionLabel: 'Registrar',
          dueDate: vaccine.nextDoseDate,
          daysUntilDue: vaccine.nextDoseDate?.difference(today).inDays,
          now: today,
        ),
      );
    }

    if (guidance.warnings.isNotEmpty) {
      reminders.add(
        _reminder(
          id: 'health-${pet.id}-missing-data',
          petId: pet.id,
          ruleId: 'missing-data',
          vaccineName: 'Datos sanitarios',
          status: PetVaccineReminderStatus.revisarConVeterinario,
          severity: PetVaccineReminderSeverity.info,
          message:
              'Completá edad, fecha de nacimiento o ubicación para mejorar los avisos de salud.',
          actionLabel: 'Completar datos',
          now: today,
        ),
      );
    }

    if (guidance.seniorWarnings.isNotEmpty &&
        (guidance.incompleteHistory.isNotEmpty || reminders.isNotEmpty)) {
      reminders.add(
        _reminder(
          id: 'health-${pet.id}-senior',
          petId: pet.id,
          ruleId: 'senior',
          vaccineName: 'Revisión senior',
          status: PetVaccineReminderStatus.revisarConVeterinario,
          severity: PetVaccineReminderSeverity.warning,
          message:
              '${pet.name} figura como senior. Revisá el plan sanitario con un veterinario.',
          actionLabel: 'Ver salud',
          now: today,
        ),
      );
    }

    final seen = <String>{};
    return [
      for (final reminder in reminders)
        if (seen.add(reminder.id)) reminder,
    ];
  }

  static List<EcosystemNotification> buildHealthNotifications(
    Pet pet,
    List<PetVaccineReminder> reminders,
  ) {
    return reminders
        .where(
          (reminder) =>
              reminder.status == PetVaccineReminderStatus.proxima ||
              reminder.status == PetVaccineReminderStatus.vencida ||
              reminder.status == PetVaccineReminderStatus.historialIncompleto,
        )
        .map(
          (reminder) => EcosystemNotification(
            id: 'notif-${reminder.id}',
            type: EcosystemNotificationType.reminder,
            title: _notificationTitle(pet, reminder),
            description: reminder.message,
            timeLabel: 'Hoy',
            accentColorHex: pet.colorHex,
            priority: _priority(reminder.severity),
            isUnread: true,
            actionLabel: 'Abrir salud',
            action: EcosystemNotificationAction.openPetHealth,
            petId: pet.id,
          ),
        )
        .toList();
  }

  static PetVaccineReminder _reminder({
    required String id,
    required String petId,
    required String ruleId,
    required String vaccineName,
    required PetVaccineReminderStatus status,
    required PetVaccineReminderSeverity severity,
    required String message,
    required String actionLabel,
    required DateTime now,
    DateTime? dueDate,
    int? daysUntilDue,
  }) {
    return PetVaccineReminder(
      id: id,
      petId: petId,
      vaccineRuleId: ruleId,
      vaccineName: vaccineName,
      status: status,
      dueDate: dueDate,
      daysUntilDue: daysUntilDue,
      severity: severity,
      message: message,
      actionLabel: actionLabel,
      createdAt: now,
      updatedAt: now,
    );
  }

  static EcosystemNotificationPriority _priority(
    PetVaccineReminderSeverity severity,
  ) {
    switch (severity) {
      case PetVaccineReminderSeverity.important:
        return EcosystemNotificationPriority.attention;
      case PetVaccineReminderSeverity.warning:
        return EcosystemNotificationPriority.useful;
      case PetVaccineReminderSeverity.info:
        return EcosystemNotificationPriority.info;
    }
  }

  static String _notificationTitle(Pet pet, PetVaccineReminder reminder) {
    switch (reminder.status) {
      case PetVaccineReminderStatus.proxima:
        return '${pet.name} tiene una vacuna próxima para revisar';
      case PetVaccineReminderStatus.vencida:
        return '${reminder.vaccineName} podría requerir refuerzo';
      case PetVaccineReminderStatus.historialIncompleto:
        return 'Falta cargar el historial sanitario de ${pet.name}';
      case PetVaccineReminderStatus.pendiente:
      case PetVaccineReminderStatus.segunRiesgo:
      case PetVaccineReminderStatus.revisarConVeterinario:
        return 'Revisá la salud de ${pet.name}';
    }
  }

  static String _stable(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}
