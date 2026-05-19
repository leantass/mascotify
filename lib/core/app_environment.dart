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

  static bool get hasPublicQrBaseUrl => publicQrBaseUrl.trim().isNotEmpty;

  static String publicQrUrlFor(String qrId) {
    final normalizedQrId = Uri.encodeComponent(qrId.trim());
    if (hasPublicQrBaseUrl) {
      final base = publicQrBaseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
      return '$base/q/$normalizedQrId';
    }
    return '/pet/qr/$normalizedQrId';
  }
}
