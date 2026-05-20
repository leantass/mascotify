enum PetVaccineReminderStatus {
  pendiente,
  proxima,
  vencida,
  historialIncompleto,
  segunRiesgo,
  revisarConVeterinario,
}

enum PetVaccineReminderSeverity { info, warning, important }

class PetVaccineReminder {
  const PetVaccineReminder({
    required this.id,
    required this.petId,
    required this.vaccineRuleId,
    required this.vaccineName,
    required this.status,
    required this.severity,
    required this.message,
    required this.actionLabel,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.daysUntilDue,
    this.dismissedAt,
  });

  final String id;
  final String petId;
  final String vaccineRuleId;
  final String vaccineName;
  final PetVaccineReminderStatus status;
  final DateTime? dueDate;
  final int? daysUntilDue;
  final PetVaccineReminderSeverity severity;
  final String message;
  final String actionLabel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dismissedAt;
}
