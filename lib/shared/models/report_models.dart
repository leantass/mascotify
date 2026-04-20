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
