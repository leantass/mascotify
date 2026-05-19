enum AppRuntimeMode { demoLocal, production }

class AppEnvironment {
  const AppEnvironment._();

  static const AppRuntimeMode runtimeMode = AppRuntimeMode.demoLocal;
  static const String socialClipsApiBaseUrl = String.fromEnvironment(
    'MASCOTIFY_CLIPS_API_BASE_URL',
    defaultValue: 'http://localhost:4000/api/v1',
  );
  static const String qrApiBaseUrl = String.fromEnvironment(
    'MASCOTIFY_QR_API_BASE_URL',
    defaultValue: 'http://localhost:4000/api/v1',
  );
  static const String publicQrBaseUrl = String.fromEnvironment(
    'MASCOTIFY_PUBLIC_QR_BASE_URL',
    defaultValue: '',
  );
  static const String publicQrBaseUrlAlias = String.fromEnvironment(
    'QR_PUBLIC_BASE_URL',
    defaultValue: '',
  );

  static bool get isDemoLocal => runtimeMode == AppRuntimeMode.demoLocal;
  static bool get isProduction => runtimeMode == AppRuntimeMode.production;

  static String get runtimeLabel {
    switch (runtimeMode) {
      case AppRuntimeMode.demoLocal:
        return 'Demo local';
      case AppRuntimeMode.production:
        return 'Produccion';
    }
  }

  static String get runtimeShortDescription {
    switch (runtimeMode) {
      case AppRuntimeMode.demoLocal:
        return 'Los datos se guardan localmente en este entorno.';
      case AppRuntimeMode.production:
        return 'Datos conectados a servicios productivos.';
    }
  }

  static String get runtimeLongDescription {
    switch (runtimeMode) {
      case AppRuntimeMode.demoLocal:
        return 'Mascotify corre como demo local: no usa backend real, pagos reales ni push remoto.';
      case AppRuntimeMode.production:
        return 'Mascotify corre en modo produccion.';
    }
  }

  static String get productionReadinessLabel {
    switch (runtimeMode) {
      case AppRuntimeMode.demoLocal:
        return 'Integracion real disponible en una proxima etapa.';
      case AppRuntimeMode.production:
        return 'Integracion real activa.';
    }
  }

  static String get effectivePublicQrBaseUrl {
    final primary = publicQrBaseUrl.trim();
    if (primary.isNotEmpty) return primary;
    return publicQrBaseUrlAlias.trim();
  }

  static bool get hasPublicQrBaseUrl => effectivePublicQrBaseUrl.isNotEmpty;

  static QrPublicLinkMode qrPublicLinkMode({String? overrideBaseUrl}) {
    final base = (overrideBaseUrl ?? effectivePublicQrBaseUrl).trim();
    if (base.isEmpty) return QrPublicLinkMode.localDemo;
    final uri = Uri.tryParse(base);
    if (uri == null || !uri.hasScheme || uri.host.trim().isEmpty) {
      return QrPublicLinkMode.localDemo;
    }
    final host = uri.host.toLowerCase();
    if (host == 'localhost' || host == '127.0.0.1' || host == '::1') {
      return QrPublicLinkMode.localDemo;
    }
    if (_isPrivateLanHost(host)) return QrPublicLinkMode.lanTesting;
    return QrPublicLinkMode.publicReady;
  }

  static String publicQrUrlFor(String qrId, {String? overrideBaseUrl}) {
    final normalizedQrId = Uri.encodeComponent(qrId.trim());
    final baseUrl = (overrideBaseUrl ?? effectivePublicQrBaseUrl).trim();
    if (baseUrl.isNotEmpty) {
      final base = baseUrl.replaceFirst(RegExp(r'/+$'), '');
      return '$base/q/$normalizedQrId';
    }
    return '/pet/qr/$normalizedQrId';
  }

  static bool _isPrivateLanHost(String host) {
    final parts = host.split('.');
    if (parts.length != 4) return false;
    final numbers = parts.map(int.tryParse).toList();
    if (numbers.any((part) => part == null)) return false;
    final first = numbers[0]!;
    final second = numbers[1]!;
    return first == 10 ||
        (first == 172 && second >= 16 && second <= 31) ||
        (first == 192 && second == 168);
  }
}

enum QrPublicLinkMode { publicReady, lanTesting, localDemo }

extension QrPublicLinkModeLabels on QrPublicLinkMode {
  String get statusLabel {
    switch (this) {
      case QrPublicLinkMode.publicReady:
        return 'QR público listo';
      case QrPublicLinkMode.lanTesting:
        return 'QR testing LAN';
      case QrPublicLinkMode.localDemo:
        return 'QR local/demo';
    }
  }

  String get helpText {
    switch (this) {
      case QrPublicLinkMode.publicReady:
        return 'Este QR codifica una URL pública completa y puede abrirse desde otro teléfono.';
      case QrPublicLinkMode.lanTesting:
        return 'Este QR codifica una URL de red local. Solo sirve si el teléfono está en la misma Wi-Fi y el servidor escucha en LAN.';
      case QrPublicLinkMode.localDemo:
        return 'Este QR está en modo local/demo. Para que funcione desde otro teléfono necesita una URL pública configurada.';
    }
  }
}
