class SightingLocationReference {
  const SightingLocationReference({
    required this.zone,
    required this.zoneReference,
    required this.shortReference,
    required this.timeReference,
    required this.mapLabelTop,
    required this.mapLabelBottom,
    required this.horizontalFactor,
    required this.verticalFactor,
  });

  final String zone;
  final String zoneReference;
  final String shortReference;
  final String timeReference;
  final String mapLabelTop;
  final String mapLabelBottom;
  final double horizontalFactor;
  final double verticalFactor;

  SightingLocationReference copyWith({
    String? zone,
    String? zoneReference,
    String? shortReference,
    String? timeReference,
    String? mapLabelTop,
    String? mapLabelBottom,
    double? horizontalFactor,
    double? verticalFactor,
  }) {
    return SightingLocationReference(
      zone: zone ?? this.zone,
      zoneReference: zoneReference ?? this.zoneReference,
      shortReference: shortReference ?? this.shortReference,
      timeReference: timeReference ?? this.timeReference,
      mapLabelTop: mapLabelTop ?? this.mapLabelTop,
      mapLabelBottom: mapLabelBottom ?? this.mapLabelBottom,
      horizontalFactor: horizontalFactor ?? this.horizontalFactor,
      verticalFactor: verticalFactor ?? this.verticalFactor,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'zone': zone,
      'zoneReference': zoneReference,
      'shortReference': shortReference,
      'timeReference': timeReference,
      'mapLabelTop': mapLabelTop,
      'mapLabelBottom': mapLabelBottom,
      'horizontalFactor': horizontalFactor,
      'verticalFactor': verticalFactor,
    };
  }

  factory SightingLocationReference.fromJson(Map<String, dynamic> json) {
    return SightingLocationReference(
      zone: json['zone'] as String,
      zoneReference: json['zoneReference'] as String,
      shortReference: json['shortReference'] as String,
      timeReference: json['timeReference'] as String,
      mapLabelTop: json['mapLabelTop'] as String,
      mapLabelBottom: json['mapLabelBottom'] as String,
      horizontalFactor: (json['horizontalFactor'] as num).toDouble(),
      verticalFactor: (json['verticalFactor'] as num).toDouble(),
    );
  }
}

class SightingReportDraft {
  const SightingReportDraft({
    required this.petId,
    required this.locationLabel,
    required this.notes,
    required this.condition,
    required this.allowContact,
  });

  final String petId;
  final String locationLabel;
  final String notes;
  final String condition;
  final bool allowContact;
}

enum QrScanLocationSource { deviceGeolocation, manual, unknown }

enum QrScanEventStatus { pending, reviewed, resolved }

class QrScanEvent {
  const QrScanEvent({
    required this.id,
    required this.petId,
    required this.qrId,
    required this.ownerUserId,
    required this.scannedAt,
    required this.locationSource,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    this.country = '',
    this.region = '',
    this.city = '',
    this.area = '',
    this.message = '',
    this.scannerContact = '',
    this.status = QrScanEventStatus.pending,
    this.safetyFlag = false,
    this.possibleLostPetSighting = false,
  });

  final String id;
  final String petId;
  final String qrId;
  final String ownerUserId;
  final DateTime scannedAt;
  final QrScanLocationSource locationSource;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final String country;
  final String region;
  final String city;
  final String area;
  final String message;
  final String scannerContact;
  final QrScanEventStatus status;
  final bool safetyFlag;
  final bool possibleLostPetSighting;

  bool get hasCoordinates => latitude != null && longitude != null;

  String get locationSummary {
    final parts = <String>[
      if (area.trim().isNotEmpty) area.trim(),
      if (city.trim().isNotEmpty) city.trim(),
      if (region.trim().isNotEmpty) region.trim(),
      if (country.trim().isNotEmpty) country.trim(),
    ];
    if (parts.isNotEmpty) return parts.join(', ');
    if (hasCoordinates) {
      return '${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}';
    }
    return 'Ubicación no informada';
  }

  String get sourceLabel {
    switch (locationSource) {
      case QrScanLocationSource.deviceGeolocation:
        return 'Ubicación compartida por el dispositivo';
      case QrScanLocationSource.manual:
        return 'Ubicación cargada manualmente';
      case QrScanLocationSource.unknown:
        return 'Ubicación no compartida';
    }
  }

  String get mapUrl {
    if (!hasCoordinates) return '';
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'qrId': qrId,
      'ownerUserId': ownerUserId,
      'scannedAt': scannedAt.toIso8601String(),
      'locationSource': locationSource.name,
      'latitude': latitude,
      'longitude': longitude,
      'accuracyMeters': accuracyMeters,
      'country': country,
      'region': region,
      'city': city,
      'area': area,
      'message': message,
      'scannerContact': scannerContact,
      'status': status.name,
      'safetyFlag': safetyFlag,
      'possibleLostPetSighting': possibleLostPetSighting,
    };
  }

  factory QrScanEvent.fromJson(Map<String, dynamic> json) {
    return QrScanEvent(
      id: json['id'] as String,
      petId: json['petId'] as String,
      qrId: json['qrId'] as String,
      ownerUserId: json['ownerUserId'] as String,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      locationSource: _enumValue(
        QrScanLocationSource.values,
        json['locationSource'] as String?,
        QrScanLocationSource.unknown,
      ),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      accuracyMeters: (json['accuracyMeters'] as num?)?.toDouble(),
      country: json['country'] as String? ?? '',
      region: json['region'] as String? ?? '',
      city: json['city'] as String? ?? '',
      area: json['area'] as String? ?? '',
      message: json['message'] as String? ?? '',
      scannerContact: json['scannerContact'] as String? ?? '',
      status: _enumValue(
        QrScanEventStatus.values,
        json['status'] as String?,
        QrScanEventStatus.pending,
      ),
      safetyFlag: json['safetyFlag'] as bool? ?? false,
      possibleLostPetSighting:
          json['possibleLostPetSighting'] as bool? ?? false,
    );
  }
}

class QrStatusSnapshot {
  const QrStatusSnapshot({
    required this.currentStatus,
    required this.protectedContactState,
    required this.lastSignalLabel,
    required this.lastSignalDetail,
    required this.totalScansLabel,
    required this.activeWindowLabel,
  });

  final String currentStatus;
  final String protectedContactState;
  final String lastSignalLabel;
  final String lastSignalDetail;
  final String totalScansLabel;
  final String activeWindowLabel;
}

T _enumValue<T extends Enum>(List<T> values, String? name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

class QrActivityEntry {
  const QrActivityEntry({
    required this.title,
    required this.detail,
    required this.timeLabel,
    required this.statusLabel,
    required this.iconKey,
    required this.accentColorHex,
  });

  final String title;
  final String detail;
  final String timeLabel;
  final String statusLabel;
  final String iconKey;
  final int accentColorHex;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'detail': detail,
      'timeLabel': timeLabel,
      'statusLabel': statusLabel,
      'iconKey': iconKey,
      'accentColorHex': accentColorHex,
    };
  }

  factory QrActivityEntry.fromJson(Map<String, dynamic> json) {
    return QrActivityEntry(
      title: json['title'] as String,
      detail: json['detail'] as String,
      timeLabel: json['timeLabel'] as String,
      statusLabel: json['statusLabel'] as String,
      iconKey: json['iconKey'] as String,
      accentColorHex: json['accentColorHex'] as int,
    );
  }
}
