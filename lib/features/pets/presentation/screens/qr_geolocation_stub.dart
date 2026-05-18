class QrDeviceLocation {
  const QrDeviceLocation({
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double? accuracyMeters;
}

Future<QrDeviceLocation?> requestQrDeviceLocation() async {
  return null;
}
