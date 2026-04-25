import '../models/app_user.dart';
import '../models/pet.dart';
import '../models/profile_option_item.dart';

class MockData {
  // Demo seeds remain intentionally small and deterministic. Real accounts
  // should never inherit this state, but the catalog is still useful for
  // previews and the seeded demo flow.
  static const AppUser currentUser = AppUser(
    id: 'user-01',
    name: 'Camila Rojas',
    email: 'camila@mascotify.app',
    planName: 'Mascotify Plus',
    city: 'Buenos Aires',
    memberSince: 'Enero 2026',
    notificationsEnabled: true,
    strategicNotificationsEnabled: true,
    privacyLevel: 'Equilibrada',
    securityLevel: 'Estándar',
  );

  static const List<Pet> pets = [
    Pet(
      id: 'pet-01',
      name: 'Milo',
      species: 'Perro',
      breed: 'Border Collie',
      ageLabel: '3 años',
      status: 'Perfil verificado',
      colorHex: 0xFFDDF6F6,
      profileId: 'MSC-BC-1042',
      identitySummary:
          'Perfil completo con datos de contacto, verificación activa y presencia lista para crecer dentro del ecosistema.',
      documentStatus: 'Vacunas y datos base cargados, revisión al día.',
      qrStatus: 'QR activo y listo para compartir contacto seguro.',
      healthSummary: 'Controles recientes registrados y seguimiento estable.',
      quickActions: ['Compartir perfil', 'Actualizar datos', 'Activar QR'],
      qrCodeLabel: 'MSC-MILO-1042',
      qrEnabled: true,
      qrLastUpdate: 'Actualizado hace 2 días',
      qrPrimaryAction: 'Ver QR',
      qrSecondaryAction: 'Compartir',
      sex: 'Macho',
      location: 'Palermo, Buenos Aires',
      biography:
          'Milo es curioso, activo y muy compañero. Disfruta espacios abiertos, juegos de inteligencia y vínculos con mascotas equilibradas.',
      personalityTags: ['Activo', 'Sociable', 'Inteligente', 'Compañero'],
      seekingBreeding: false,
      socialInterest:
          'Abierto a vínculos sociales y futuras recomendaciones compatibles.',
      socialProfileStatus:
          'Perfil social completo y visible para futuras conexiones.',
      featuredMoments: [
        'Paseos largos',
        'Juegos de pelota',
        'Encuentros controlados',
      ],
      matchingPreferences: PetMatchingPreferences(
        preferredBondType: 'Vínculo social activo y compañero',
        matchSummary:
            'Suele encajar con perfiles que disfrutan interacción, juego con buena lectura social y encuentros con energía equilibrada.',
        rhythmLabel: 'Activo, pero bien leído',
        locationRadiusLabel: 'Hasta 8 km',
        acceptsGradualMeet: true,
        compatibilitySignals: [
          'Buena energía para juego compartido',
          'Responde mejor a perfiles seguros y sociables',
          'Se beneficia de familias claras con el contexto',
        ],
        desiredCompatibilities: [
          'Mascotas sociables',
          'Ritmo de juego equilibrado',
          'Encuentros al aire libre',
        ],
        softLimits: [
          'Evitar sobreestimulación en el primer encuentro',
          'No conviene mezclarlo con perfiles invasivos de entrada',
        ],
        idealContext:
            'Le favorecen conversaciones previas claras y un primer acercamiento en espacios amplios, con energía positiva y tiempos bien leídos.',
        importantNotes:
            'Conviene evitar entornos muy ruidosos en el primer encuentro y priorizar perfiles que disfruten dinámicas activas sin ser invasivas.',
        suggestedApproach:
            'Funciona mejor si primero se alinea el tipo de juego esperado y luego se propone un encuentro breve, abierto y supervisado.',
      ),
    ),
    Pet(
      id: 'pet-02',
      name: 'Nina',
      species: 'Gata',
      breed: 'European Shorthair',
      ageLabel: '1 año',
      status: 'Documentación al día',
      colorHex: 0xFFFFE1EA,
      profileId: 'MSC-ES-2088',
      identitySummary:
          'Perfil joven con identidad digital lista para seguimiento, documentación centralizada y proyección social.',
      documentStatus:
          'Documentación veterinaria centralizada y pendiente de adjuntar esterilización.',
      qrStatus: 'QR listo para activarse cuando se asocie la placa.',
      healthSummary:
          'Esquema inicial de salud cargado y recordatorios preparados.',
      quickActions: ['Ver documentos', 'Editar identidad', 'Programar control'],
      qrCodeLabel: 'MSC-NINA-2088',
      qrEnabled: false,
      qrLastUpdate: 'Pendiente de activación',
      qrPrimaryAction: 'Activar QR',
      qrSecondaryAction: 'Configurar placa',
      sex: 'Hembra',
      location: 'Caballito, Buenos Aires',
      biography:
          'Nina está en etapa de descubrimiento y se adapta muy bien a entornos tranquilos. Tiene un perfil ideal para conexiones graduales y seguras.',
      personalityTags: ['Curiosa', 'Observadora', 'Suave', 'Hogareña'],
      seekingBreeding: false,
      socialInterest:
          'Interés social moderado con foco en entornos calmos y mascotas compatibles.',
      socialProfileStatus:
          'Perfil social en expansión con matching preparado para el futuro.',
      featuredMoments: [
        'Siestas al sol',
        'Juguetes suaves',
        'Exploración indoor',
      ],
      matchingPreferences: PetMatchingPreferences(
        preferredBondType: 'Conexión gradual y muy cuidada',
        matchSummary:
            'Tiene más afinidad con perfiles calmos, previsibles y familias que valoran la construcción lenta de confianza.',
        rhythmLabel: 'Suave y progresivo',
        locationRadiusLabel: 'Hasta 5 km',
        acceptsGradualMeet: true,
        compatibilitySignals: [
          'Tolera mejor interacciones cortas y serenas',
          'Conecta con rutinas estables y poco invasivas',
          'Necesita buena lectura de señales desde el inicio',
        ],
        desiredCompatibilities: [
          'Perfiles calmos',
          'Rutinas previsibles',
          'Interacciones suaves',
        ],
        softLimits: [
          'No conviene apurar encuentros presenciales',
          'Necesita evitar cambios bruscos de entorno o ritmo',
        ],
        idealContext:
            'Lo ideal es una etapa inicial digital, con intercambio claro entre familias y, si todo va bien, una presentación breve en un entorno sereno.',
        importantNotes:
            'Necesita tiempos cortos, buena lectura de señales y evitar cambios bruscos o encuentros apurados.',
        suggestedApproach:
            'Lo más valioso es abrir una conversación tranquila, ordenar expectativas y recién después evaluar una presentación breve y cuidada.',
      ),
    ),
    Pet(
      id: 'pet-03',
      name: 'Bruno',
      species: 'Perro',
      breed: 'Golden Retriever',
      ageLabel: '6 años',
      status: 'QR listo para activar',
      colorHex: 0xFFFFF2C6,
      profileId: 'MSC-GR-3124',
      identitySummary:
          'Perfil consolidado para trazabilidad, cuidado, presencia social y contacto rápido cuando se necesite.',
      documentStatus:
          'Historial base ordenado, pendiente de sumar próximos estudios.',
      qrStatus:
          'Configuración avanzada preparada para rastreo y avistamientos.',
      healthSummary:
          'Seguimiento preventivo activo con información esencial visible.',
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
          'Bruno transmite calma, seguridad y una energía social muy noble. Es ideal para experiencias compartidas, salidas y futuras conexiones de valor.',
      personalityTags: ['Amigable', 'Equilibrado', 'Protector', 'Juguetón'],
      seekingBreeding: true,
      socialInterest:
          'Perfil con potencial alto para matching y conexiones presenciales seguras.',
      socialProfileStatus:
          'Perfil social destacado con señales claras para futuras recomendaciones.',
      featuredMoments: [
        'Parque',
        'Encuentros sociales',
        'Rutina al aire libre',
      ],
      matchingPreferences: PetMatchingPreferences(
        preferredBondType:
            'Vínculo social claro con opción reproductiva responsable',
        matchSummary:
            'Puede generar afinidades de valor cuando hay claridad, buen tono entre familias y una evaluación responsable del contexto.',
        rhythmLabel: 'Sereno con intención clara',
        locationRadiusLabel: 'Hasta 12 km',
        acceptsGradualMeet: true,
        compatibilitySignals: [
          'Se luce mejor con vínculos nobles y bien guiados',
          'Responde bien a contextos presenciales supervisados',
          'La afinidad mejora cuando hay criterios claros del otro lado',
        ],
        desiredCompatibilities: [
          'Mascotas nobles',
          'Familias con criterios claros',
          'Encuentros supervisados',
        ],
        softLimits: [
          'Si el interés apunta a cría, exige responsabilidad real',
          'No conviene avanzar sin compatibilidad bien conversada',
        ],
        idealContext:
            'Funciona mejor cuando primero hay una conversación ordenada, compatibilidad bien evaluada y luego un encuentro presencial con seguimiento.',
        importantNotes:
            'Si la conversación apunta a cría, es importante priorizar bienestar, responsabilidad real y compatibilidad antes de avanzar.',
        suggestedApproach:
            'El mejor primer paso es validar objetivos, leer compatibilidad con calma y dejar el encuentro para cuando ambas partes tengan criterios alineados.',
      ),
    ),
  ];

  static const List<ProfileOptionItem> profileOptions = [
    ProfileOptionItem(
      title: 'Suscripción',
      subtitle: 'Gestiona beneficios y próximos upgrades.',
      iconKey: 'workspace_premium',
    ),
    ProfileOptionItem(
      title: 'Notificaciones',
      subtitle: 'Define qué alertas querés recibir.',
      iconKey: 'notifications',
    ),
    ProfileOptionItem(
      title: 'Configuración',
      subtitle: 'Privacidad, seguridad y preferencias.',
      iconKey: 'settings',
    ),
  ];

  const MockData._();
}
