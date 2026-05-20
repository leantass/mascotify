enum PetVaccineStatus { applied, pending }

class PetVaccine {
  const PetVaccine({
    required this.id,
    required this.petId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.applicationDate,
    this.nextDoseDate,
    this.clinic,
    this.batch,
    this.notes,
  });

  final String id;
  final String petId;
  final String name;
  final PetVaccineStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? applicationDate;
  final DateTime? nextDoseDate;
  final String? clinic;
  final String? batch;
  final String? notes;

  bool get isApplied => status == PetVaccineStatus.applied;
  bool get isPending => status == PetVaccineStatus.pending;

  PetVaccine copyWith({
    String? id,
    String? petId,
    String? name,
    PetVaccineStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? applicationDate,
    DateTime? nextDoseDate,
    String? clinic,
    String? batch,
    String? notes,
    bool clearApplicationDate = false,
    bool clearNextDoseDate = false,
    bool clearClinic = false,
    bool clearBatch = false,
    bool clearNotes = false,
  }) {
    return PetVaccine(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      name: name ?? this.name,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      applicationDate: clearApplicationDate
          ? null
          : applicationDate ?? this.applicationDate,
      nextDoseDate: clearNextDoseDate
          ? null
          : nextDoseDate ?? this.nextDoseDate,
      clinic: clearClinic ? null : clinic ?? this.clinic,
      batch: clearBatch ? null : batch ?? this.batch,
      notes: clearNotes ? null : notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'name': name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'applicationDate': applicationDate?.toIso8601String(),
      'nextDoseDate': nextDoseDate?.toIso8601String(),
      'clinic': clinic,
      'batch': batch,
      'notes': notes,
    };
  }

  factory PetVaccine.fromJson(Map<String, dynamic> json) {
    return PetVaccine(
      id: json['id'] as String,
      petId: json['petId'] as String,
      name: json['name'] as String,
      status: PetVaccineStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => PetVaccineStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      applicationDate: _optionalDate(json['applicationDate'] as String?),
      nextDoseDate: _optionalDate(json['nextDoseDate'] as String?),
      clinic: json['clinic'] as String?,
      batch: json['batch'] as String?,
      notes: json['notes'] as String?,
    );
  }

  static DateTime? _optionalDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
