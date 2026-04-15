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
