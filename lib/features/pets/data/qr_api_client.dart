import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/models/report_models.dart';

class QrApiClient {
  QrApiClient({
    required String baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(milliseconds: 1200),
  }) : _baseUri = Uri.parse(
         baseUrl.endsWith('/')
             ? baseUrl.substring(0, baseUrl.length - 1)
             : baseUrl,
       ),
       _httpClient = httpClient ?? http.Client();

  final Uri _baseUri;
  final http.Client _httpClient;
  final Duration timeout;

  Future<PublicQrPet> fetchPublicPet(String qrId) async {
    final response = await _httpClient
        .get(_uri('/qr/public/${Uri.encodeComponent(qrId)}'))
        .timeout(timeout);
    final body = _decodeOk(response);
    final pet = body['pet'];
    if (pet is! Map) {
      throw const FormatException('Invalid QR public pet response.');
    }
    return PublicQrPet.fromJson(Map<String, dynamic>.from(pet));
  }

  Future<QrScanEvent> submitPublicScan({
    required String qrId,
    required QrScanEvent draft,
  }) async {
    final response = await _httpClient
        .post(
          _uri('/qr/public/${Uri.encodeComponent(qrId)}/scans'),
          headers: const <String, String>{'content-type': 'application/json'},
          body: jsonEncode(<String, Object?>{
            'locationSource': _backendLocationSource(draft.locationSource),
            'latitude': draft.latitude,
            'longitude': draft.longitude,
            'accuracyMeters': draft.accuracyMeters,
            'country': draft.country,
            'region': draft.region,
            'city': draft.city,
            'area': draft.area,
            'message': draft.message,
            'scannerContact': draft.scannerContact,
          }),
        )
        .timeout(timeout);
    final body = _decodeOk(response);
    final scan = body['scan'];
    if (scan is! Map) {
      throw const FormatException('Invalid QR scan response.');
    }
    return _eventFromBackend(Map<String, dynamic>.from(scan));
  }

  Uri _uri(String path) => _baseUri.replace(path: '${_baseUri.path}$path');

  Map<String, dynamic> _decodeOk(http.Response response) {
    final decoded = jsonDecode(response.body);
    final body = decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw QrApiException(
        body?['error'] is Map
            ? (body!['error'] as Map)['message'].toString()
            : 'QR backend request failed with status ${response.statusCode}.',
      );
    }
    if (body == null) {
      throw const FormatException('Expected JSON object.');
    }
    return body;
  }
}

class PublicQrPet {
  const PublicQrPet({
    required this.qrId,
    required this.petId,
    required this.publicName,
    required this.species,
    this.breed,
    this.color,
    this.publicNotes,
    required this.status,
  });

  final String qrId;
  final String petId;
  final String publicName;
  final String species;
  final String? breed;
  final String? color;
  final String? publicNotes;
  final String status;

  bool get isLost => status == 'LOST';

  factory PublicQrPet.fromJson(Map<String, dynamic> json) {
    return PublicQrPet(
      qrId: json['qrId'] as String,
      petId: json['petId'] as String,
      publicName: json['publicName'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String?,
      color: json['color'] as String?,
      publicNotes: json['publicNotes'] as String?,
      status: json['status'] as String? ?? 'NORMAL',
    );
  }
}

class QrApiException implements Exception {
  const QrApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

QrScanEvent _eventFromBackend(Map<String, dynamic> json) {
  return QrScanEvent(
    id: json['id'] as String,
    petId: json['petId'] as String,
    qrId: json['qrId'] as String,
    ownerUserId: json['ownerUserId'] as String,
    scannedAt: DateTime.parse(json['scannedAt'] as String),
    locationSource: _locationSourceFromBackend(
      json['locationSource'] as String?,
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
    safetyFlag: json['safetyFlag'] as bool? ?? false,
    possibleLostPetSighting: json['possibleLostPetSighting'] as bool? ?? false,
  );
}

String _backendLocationSource(QrScanLocationSource source) {
  return switch (source) {
    QrScanLocationSource.deviceGeolocation => 'DEVICE_GEOLOCATION',
    QrScanLocationSource.manual => 'MANUAL',
    QrScanLocationSource.unknown => 'UNKNOWN',
  };
}

QrScanLocationSource _locationSourceFromBackend(String? source) {
  return switch (source) {
    'DEVICE_GEOLOCATION' => QrScanLocationSource.deviceGeolocation,
    'MANUAL' => QrScanLocationSource.manual,
    _ => QrScanLocationSource.unknown,
  };
}
