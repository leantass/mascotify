import '../models/pet.dart';
import '../models/report_models.dart';

SightingLocationReference buildSuggestedLocationForPet(Pet pet) {
  switch (pet.id) {
    case 'pet-01':
      return const SightingLocationReference(
        zone: 'Palermo Soho',
        zoneReference: 'A 1 cuadra de Plaza Armenia, sobre calle tranquila',
        shortReference: 'Punto aproximado A3',
        timeReference: 'Detectado hace instantes',
        mapLabelTop: 'Plaza Armenia',
        mapLabelBottom: 'Corredor Costa Rica',
        horizontalFactor: 0.68,
        verticalFactor: 0.36,
      );
    case 'pet-02':
      return const SightingLocationReference(
        zone: 'Caballito norte',
        zoneReference: 'Cerca de Plaza Irlanda y vereda arbolada',
        shortReference: 'Punto aproximado C2',
        timeReference: 'Referencia sugerida al escanear',
        mapLabelTop: 'Plaza Irlanda',
        mapLabelBottom: 'Zona residencial',
        horizontalFactor: 0.42,
        verticalFactor: 0.48,
      );
    default:
      return const SightingLocationReference(
        zone: 'Belgrano R',
        zoneReference: 'Entre avenida principal y tramo residencial cercano',
        shortReference: 'Punto aproximado B4',
        timeReference: 'Referencia lista para compartir',
        mapLabelTop: 'Eje principal',
        mapLabelBottom: 'Área tranquila',
        horizontalFactor: 0.58,
        verticalFactor: 0.30,
      );
  }
}

QrStatusSnapshot buildQrStatusSnapshotForPet(Pet pet) {
  switch (pet.id) {
    case 'pet-01':
      return const QrStatusSnapshot(
        currentStatus: 'QR activo y visible',
        protectedContactState: 'Contacto protegido listo para derivar',
        lastSignalLabel: 'Último escaneo público hace 2 días',
        lastSignalDetail:
            'Se abrió la vista pública del perfil y el responsable habría podido seguir el evento sin exponer datos directos.',
        totalScansLabel: '4 escaneos mock',
        activeWindowLabel: 'Actividad estable esta semana',
      );
    case 'pet-02':
      return const QrStatusSnapshot(
        currentStatus: 'QR preparado para activación',
        protectedContactState: 'Contacto protegido pendiente de vincular',
        lastSignalLabel: 'Sin escaneos todavía',
        lastSignalDetail:
            'La ficha está lista para sumar trazabilidad cuando la placa quede asociada.',
        totalScansLabel: '0 escaneos mock',
        activeWindowLabel: 'Esperando activación',
      );
    default:
      return const QrStatusSnapshot(
        currentStatus: 'QR configurado con señales recientes',
        protectedContactState: 'Contacto protegido activo',
        lastSignalLabel: 'Último avistamiento hace 18 min',
        lastSignalDetail:
            'El sistema ya puede mostrar referencias de zona, reportes y un historial básico de actividad QR.',
        totalScansLabel: '7 escaneos mock',
        activeWindowLabel: 'Actividad alta hoy',
      );
  }
}

List<QrActivityEntry> buildQrActivityEntriesForPet(Pet pet) {
  switch (pet.id) {
    case 'pet-01':
      return const [
        QrActivityEntry(
          title: 'Escaneo público registrado',
          detail:
              'Se abrió el perfil QR y quedó asentada una consulta pública del código.',
          timeLabel: 'Hace 2 días',
          statusLabel: 'Consulta segura',
          iconKey: 'qr',
          accentColorHex: 0xFFDDF6F6,
        ),
        QrActivityEntry(
          title: 'Contacto protegido disponible',
          detail:
              'La capa de contacto quedó lista para derivar información sin mostrar datos privados.',
          timeLabel: 'Hace 5 días',
          statusLabel: 'Protección activa',
          iconKey: 'shield',
          accentColorHex: 0xFFFFF2C6,
        ),
        QrActivityEntry(
          title: 'Perfil QR actualizado',
          detail:
              'Se confirmó el estado del código y el acceso al perfil interno de la mascota.',
          timeLabel: 'Hace 1 semana',
          statusLabel: 'Perfil sincronizado',
          iconKey: 'history',
          accentColorHex: 0xFFFFE1EA,
        ),
      ];
    case 'pet-02':
      return const [
        QrActivityEntry(
          title: 'Placa pendiente de asociar',
          detail:
              'El perfil ya admite trazabilidad, pero el código todavía no fue activado para uso público.',
          timeLabel: 'Hoy',
          statusLabel: 'Pendiente',
          iconKey: 'pending',
          accentColorHex: 0xFFFFF2C6,
        ),
        QrActivityEntry(
          title: 'Ficha QR preparada',
          detail:
              'Quedó lista la identidad básica que va a acompañar al código una vez activo.',
          timeLabel: 'Hace 3 días',
          statusLabel: 'Base lista',
          iconKey: 'badge',
          accentColorHex: 0xFFDDF6F6,
        ),
      ];
    default:
      return [
        const QrActivityEntry(
          title: 'Avistamiento QR recibido',
          detail:
              'Se cargó una referencia aproximada para seguimiento del responsable.',
          timeLabel: 'Hace 18 min',
          statusLabel: 'Reporte nuevo',
          iconKey: 'location',
          accentColorHex: 0xFFFFF2C6,
        ),
        const QrActivityEntry(
          title: 'Escaneo público confirmado',
          detail:
              'El perfil QR se abrió y dejó una señal de actividad dentro del historial.',
          timeLabel: 'Hoy',
          statusLabel: 'Escaneo válido',
          iconKey: 'qr',
          accentColorHex: 0xFFDDF6F6,
        ),
        QrActivityEntry(
          title: 'Zona sugerida disponible',
          detail:
              'La referencia ${buildSuggestedLocationForPet(pet).shortReference} quedó lista para compartir dentro del flujo seguro.',
          timeLabel: 'Hoy',
          statusLabel: 'Trazabilidad activa',
          iconKey: 'history',
          accentColorHex: 0xFFFFE1EA,
        ),
      ];
  }
}
