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
        mapLabelBottom: 'Area tranquila',
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
        lastSignalLabel: 'Ultimo escaneo publico hace 2 dias',
        lastSignalDetail:
            'Se abrio la vista publica del perfil y el responsable habria podido seguir el evento sin exponer datos directos.',
        totalScansLabel: '4 escaneos locales',
        activeWindowLabel: 'Actividad estable esta semana',
      );
    case 'pet-02':
      return const QrStatusSnapshot(
        currentStatus: 'QR preparado para activacion',
        protectedContactState: 'Contacto protegido pendiente de vincular',
        lastSignalLabel: 'Sin escaneos todavia',
        lastSignalDetail:
            'La ficha esta lista para sumar trazabilidad cuando la placa quede asociada.',
        totalScansLabel: '0 escaneos locales',
        activeWindowLabel: 'Esperando activacion',
      );
    default:
      return const QrStatusSnapshot(
        currentStatus: 'QR configurado con señales recientes',
        protectedContactState: 'Contacto protegido activo',
        lastSignalLabel: 'Ultimo avistamiento hace 18 min',
        lastSignalDetail:
            'El sistema ya puede mostrar referencias de zona, reportes y un historial basico de actividad QR.',
        totalScansLabel: '7 escaneos locales',
        activeWindowLabel: 'Actividad alta hoy',
      );
  }
}

List<QrActivityEntry> buildQrActivityEntriesForPet(Pet pet) {
  switch (pet.id) {
    case 'pet-01':
      return const [
        QrActivityEntry(
          title: 'Escaneo publico registrado',
          detail:
              'Se abrio el perfil QR y quedo asentada una consulta publica del codigo.',
          timeLabel: 'Hace 2 dias',
          statusLabel: 'Consulta segura',
          iconKey: 'qr',
          accentColorHex: 0xFFDDF6F6,
        ),
        QrActivityEntry(
          title: 'Contacto protegido disponible',
          detail:
              'La capa de contacto quedo lista para derivar informacion sin mostrar datos privados.',
          timeLabel: 'Hace 5 dias',
          statusLabel: 'Proteccion activa',
          iconKey: 'shield',
          accentColorHex: 0xFFFFF2C6,
        ),
        QrActivityEntry(
          title: 'Perfil QR actualizado',
          detail:
              'Se confirmo el estado del codigo y el acceso al perfil interno de la mascota.',
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
              'El perfil ya admite trazabilidad, pero el codigo todavia no fue activado para uso publico.',
          timeLabel: 'Hoy',
          statusLabel: 'Pendiente',
          iconKey: 'pending',
          accentColorHex: 0xFFFFF2C6,
        ),
        QrActivityEntry(
          title: 'Ficha QR preparada',
          detail:
              'Quedo lista la identidad basica que va a acompañar al codigo una vez activo.',
          timeLabel: 'Hace 3 dias',
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
              'Se cargo una referencia aproximada para seguimiento del responsable.',
          timeLabel: 'Hace 18 min',
          statusLabel: 'Reporte nuevo',
          iconKey: 'location',
          accentColorHex: 0xFFFFF2C6,
        ),
        const QrActivityEntry(
          title: 'Escaneo publico confirmado',
          detail:
              'El perfil QR se abrio y dejo una señal de actividad dentro del historial.',
          timeLabel: 'Hoy',
          statusLabel: 'Escaneo valido',
          iconKey: 'qr',
          accentColorHex: 0xFFDDF6F6,
        ),
        QrActivityEntry(
          title: 'Zona sugerida disponible',
          detail:
              'La referencia ${buildSuggestedLocationForPet(pet).shortReference} quedo lista para compartir dentro del flujo seguro.',
          timeLabel: 'Hoy',
          statusLabel: 'Trazabilidad activa',
          iconKey: 'history',
          accentColorHex: 0xFFFFE1EA,
        ),
      ];
  }
}
