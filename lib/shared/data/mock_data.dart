import '../models/app_user.dart';
import '../models/pet.dart';

class MockData {
  static const AppUser currentUser = AppUser(
    id: 'user-01',
    name: 'Camila Rojas',
    email: 'camila@mascotify.app',
    planName: 'Mascotify Plus',
    city: 'Buenos Aires',
    memberSince: 'Enero 2026',
    notificationsEnabled: true,
  );

  static const List<Pet> pets = [
    Pet(
      id: 'pet-01',
      name: 'Milo',
      species: 'Perro',
      breed: 'Border Collie',
      ageLabel: '3 anos',
      status: 'Perfil verificado',
      colorHex: 0xFFDDF6F6,
      profileId: 'MSC-BC-1042',
      identitySummary:
          'Perfil completo con datos de contacto, verificacion activa y presencia lista para crecer dentro del ecosistema.',
      documentStatus: 'Vacunas y datos base cargados, revision al dia.',
      qrStatus: 'QR activo y listo para compartir contacto seguro.',
      healthSummary: 'Controles recientes registrados y seguimiento estable.',
      quickActions: ['Compartir perfil', 'Actualizar datos', 'Activar QR'],
      qrCodeLabel: 'MSC-MILO-1042',
      qrEnabled: true,
      qrLastUpdate: 'Actualizado hace 2 dias',
      qrPrimaryAction: 'Ver QR',
      qrSecondaryAction: 'Compartir',
      sex: 'Macho',
      location: 'Palermo, Buenos Aires',
      biography:
          'Milo es curioso, activo y muy companero. Disfruta espacios abiertos, juegos de inteligencia y vinculos con mascotas equilibradas.',
      personalityTags: ['Activo', 'Sociable', 'Inteligente', 'Companero'],
      seekingBreeding: false,
      socialInterest:
          'Abierto a vinculos sociales y futuras recomendaciones compatibles.',
      socialProfileStatus:
          'Perfil social completo y visible para futuras conexiones.',
      featuredMoments: [
        'Paseos largos',
        'Juegos de pelota',
        'Encuentros controlados',
      ],
      matchingPreferences: PetMatchingPreferences(
        preferredBondType: 'Vinculo social activo y companero',
        locationRadiusLabel: 'Hasta 8 km',
        acceptsGradualMeet: true,
        desiredCompatibilities: [
          'Mascotas sociables',
          'Ritmo de juego equilibrado',
          'Encuentros al aire libre',
        ],
        idealContext:
            'Le favorecen conversaciones previas claras y un primer acercamiento en espacios amplios, con energia positiva y tiempos bien leidos.',
        importantNotes:
            'Conviene evitar entornos muy ruidosos en el primer encuentro y priorizar perfiles que disfruten dinamicas activas sin ser invasivas.',
      ),
    ),
    Pet(
      id: 'pet-02',
      name: 'Nina',
      species: 'Gata',
      breed: 'European Shorthair',
      ageLabel: '1 ano',
      status: 'Documentacion al dia',
      colorHex: 0xFFFFE1EA,
      profileId: 'MSC-ES-2088',
      identitySummary:
          'Perfil joven con identidad digital lista para seguimiento, documentacion centralizada y proyeccion social.',
      documentStatus:
          'Documentacion veterinaria centralizada y pendiente de adjuntar esterilizacion.',
      qrStatus: 'QR listo para activarse cuando se asocie la placa.',
      healthSummary:
          'Esquema inicial de salud cargado y recordatorios preparados.',
      quickActions: ['Ver documentos', 'Editar identidad', 'Programar control'],
      qrCodeLabel: 'MSC-NINA-2088',
      qrEnabled: false,
      qrLastUpdate: 'Pendiente de activacion',
      qrPrimaryAction: 'Activar QR',
      qrSecondaryAction: 'Configurar placa',
      sex: 'Hembra',
      location: 'Caballito, Buenos Aires',
      biography:
          'Nina esta en etapa de descubrimiento y se adapta muy bien a entornos tranquilos. Tiene un perfil ideal para conexiones graduales y seguras.',
      personalityTags: ['Curiosa', 'Observadora', 'Suave', 'Hogarena'],
      seekingBreeding: false,
      socialInterest:
          'Interes social moderado con foco en entornos calmos y mascotas compatibles.',
      socialProfileStatus:
          'Perfil social en expansion con matching preparado para el futuro.',
      featuredMoments: [
        'Siestas al sol',
        'Juguetes suaves',
        'Exploracion indoor',
      ],
      matchingPreferences: PetMatchingPreferences(
        preferredBondType: 'Conexion gradual y muy cuidada',
        locationRadiusLabel: 'Hasta 5 km',
        acceptsGradualMeet: true,
        desiredCompatibilities: [
          'Perfiles calmos',
          'Rutinas previsibles',
          'Interacciones suaves',
        ],
        idealContext:
            'Lo ideal es una etapa inicial digital, con intercambio claro entre familias y, si todo va bien, una presentacion breve en un entorno sereno.',
        importantNotes:
            'Necesita tiempos cortos, buena lectura de senales y evitar cambios bruscos o encuentros apurados.',
      ),
    ),
    Pet(
      id: 'pet-03',
      name: 'Bruno',
      species: 'Perro',
      breed: 'Golden Retriever',
      ageLabel: '6 anos',
      status: 'QR listo para activar',
      colorHex: 0xFFFFF2C6,
      profileId: 'MSC-GR-3124',
      identitySummary:
          'Perfil consolidado para trazabilidad, cuidado, presencia social y contacto rapido cuando se necesite.',
      documentStatus:
          'Historial base ordenado, pendiente de sumar proximos estudios.',
      qrStatus:
          'Configuracion avanzada preparada para rastreo y avistamientos.',
      healthSummary:
          'Seguimiento preventivo activo con informacion esencial visible.',
      quickActions: [
        'Configurar QR',
        'Registrar avistamiento',
        'Descargar ficha',
      ],
      qrCodeLabel: 'MSC-BRUNO-3124',
      qrEnabled: false,
      qrLastUpdate: 'Configurado hace 1 semana',
      qrPrimaryAction: 'Configurar placa',
      qrSecondaryAction: 'Probar escaneo',
      sex: 'Macho',
      location: 'Belgrano, Buenos Aires',
      biography:
          'Bruno transmite calma, seguridad y una energia social muy noble. Es ideal para experiencias compartidas, salidas y futuras conexiones de valor.',
      personalityTags: ['Amigable', 'Equilibrado', 'Protector', 'Jugueton'],
      seekingBreeding: true,
      socialInterest:
          'Perfil con potencial alto para matching y conexiones presenciales seguras.',
      socialProfileStatus:
          'Perfil social destacado con senales claras para futuras recomendaciones.',
      featuredMoments: [
        'Parque',
        'Encuentros sociales',
        'Rutina al aire libre',
      ],
      matchingPreferences: PetMatchingPreferences(
        preferredBondType:
            'Vinculo social claro con opcion reproductiva responsable',
        locationRadiusLabel: 'Hasta 12 km',
        acceptsGradualMeet: true,
        desiredCompatibilities: [
          'Mascotas nobles',
          'Familias con criterios claros',
          'Encuentros supervisados',
        ],
        idealContext:
            'Funciona mejor cuando primero hay una conversacion ordenada, compatibilidad bien evaluada y luego un encuentro presencial con seguimiento.',
        importantNotes:
            'Si la conversacion apunta a cria, es importante priorizar bienestar, responsabilidad real y compatibilidad antes de avanzar.',
      ),
    ),
  ];

  static const List<QuickActionItem> quickActions = [
    QuickActionItem(
      title: 'Identidad digital',
      subtitle: 'Centraliza datos, vacunas y contactos.',
      iconKey: 'badge',
    ),
    QuickActionItem(
      title: 'QR de rastreo',
      subtitle: 'Preparado para vincular chapitas seguras.',
      iconKey: 'qr',
    ),
    QuickActionItem(
      title: 'Reportes',
      subtitle: 'Base lista para avistamientos y alertas.',
      iconKey: 'report',
    ),
  ];

  static const List<ProfileOptionItem> profileOptions = [
    ProfileOptionItem(
      title: 'Suscripcion',
      subtitle: 'Gestiona beneficios y proximos upgrades.',
      iconKey: 'workspace_premium',
    ),
    ProfileOptionItem(
      title: 'Notificaciones',
      subtitle: 'Define que alertas queres recibir.',
      iconKey: 'notifications',
    ),
    ProfileOptionItem(
      title: 'Configuracion',
      subtitle: 'Privacidad, seguridad y preferencias.',
      iconKey: 'settings',
    ),
  ];

  const MockData._();
}

class QuickActionItem {
  const QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.iconKey,
  });

  final String title;
  final String subtitle;
  final String iconKey;
}

class ProfileOptionItem {
  const ProfileOptionItem({
    required this.title,
    required this.subtitle,
    required this.iconKey,
  });

  final String title;
  final String subtitle;
  final String iconKey;
}
