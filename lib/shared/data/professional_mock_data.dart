import '../models/professional_models.dart';

const List<ProfessionalProfile> professionalProfiles = [
  ProfessionalProfile(
    name: 'Dra. Paula Mendes',
    specialty: 'Veterinaria preventiva',
    biography:
        'Trabaja sobre prevención, lectura temprana de señales clínicas y acompañamiento cotidiano para familias que buscan decisiones más claras y seguras.',
    description:
        'Comparte criterio clínico breve, pero también puede representar una presencia profesional con servicios y acompañamiento dentro de Mascotify.',
    contentType: 'Charlas breves',
    valueProposition:
        'Convierte información veterinaria en piezas simples, útiles y fáciles de aplicar en el día a día.',
    approachStyle: 'Claro, cercano y preventivo',
    helpSummary:
        'Puede ayudarte a ordenar prioridades de cuidado, entender alertas tempranas y aprovechar mejor la identidad digital de tu mascota para prevención y seguimiento.',
    profileModeLabel: 'Profesional + servicio',
    presenceStatusLabel: 'Perfil validado y visible',
    serviceAvailabilityLabel: 'Recibe consultas y seguimiento breve',
    serviceSummary:
        'Su presencia combina contenido útil con una futura capa de orientación, chequeos preventivos y seguimiento clínico liviano dentro de la app.',
    services: [
      'Veterinaria preventiva',
      'Chequeos y orientación',
      'Seguimiento post consulta',
      'Lectura inicial de señales',
    ],
    trustSignals: [
      'Perfil profesional validado',
      'Contenido frecuente y claro',
      'Presencia apta para servicios futuros',
    ],
    primaryActionLabel: 'Explorar servicios',
    secondaryActionLabel: 'Ver contenido',
    topics: [
      'Prevención',
      'Chequeos',
      'Señales tempranas',
      'Rutinas saludables',
    ],
    featuredContent: [
      ProfessionalContentPreview(
        title: 'Qué debería tener un perfil QR realmente útil',
        category: 'Identidad digital',
        duration: '1 min 30 s',
        summary:
            'Opinión corta sobre información esencial, contacto seguro y claridad para reportes.',
      ),
      ProfessionalContentPreview(
        title: 'Chequeos que conviene no postergar',
        category: 'Veterinaria',
        duration: '2 min',
        summary:
            'Una guía breve para detectar prioridades y ordenar controles preventivos.',
      ),
    ],
    accentColorHex: 0xFFDDF6F6,
  ),
  ProfessionalProfile(
    name: 'Lic. Tomás Ibarra',
    specialty: 'Comportamiento animal',
    biography:
        'Acompaña procesos de socialización y lectura de conducta con foco en encuentros graduales, bienestar emocional y compatibilidad entre mascotas.',
    description:
        'Publica opiniones y microcontenidos sobre socialización, encuentros cuidados y compatibilidades, con una presencia que también puede evolucionar a orientación profesional.',
    contentType: 'Opiniones y reels',
    valueProposition:
        'Traducir el comportamiento en decisiones más seguras para familias, encuentros y vínculos sociales.',
    approachStyle: 'Observacional, didáctico y gradual',
    helpSummary:
        'Puede orientarte para leer energía, preparar presentaciones entre mascotas y detectar si una afinidad merece avanzar o tomarse con más calma.',
    profileModeLabel: 'Experto en contenido + orientación',
    presenceStatusLabel: 'Comunidad activa',
    serviceAvailabilityLabel: 'Orientación y evaluación futura',
    serviceSummary:
        'Hoy se siente fuerte como voz experta en contenidos, pero su ficha también deja espacio para futuras evaluaciones o acompañamientos por comportamiento.',
    services: [
      'Orientación conductual',
      'Lectura de compatibilidad',
      'Presentaciones cuidadas',
      'Acompañamiento gradual',
    ],
    trustSignals: [
      'Voz experta seguida por la comunidad',
      'Enfoque gradual y didáctico',
      'Temas alineados con matching y bienestar',
    ],
    primaryActionLabel: 'Pedir orientación',
    secondaryActionLabel: 'Ver contenido',
    topics: [
      'Socialización',
      'Compatibilidad',
      'Encuentros cuidados',
      'Lectura de conducta',
    ],
    featuredContent: [
      ProfessionalContentPreview(
        title: 'Presentaciones seguras entre mascotas',
        category: 'Comportamiento',
        duration: '2 min',
        summary:
            'Pieza breve para entender energía, distancia y señales antes de un primer encuentro.',
      ),
      ProfessionalContentPreview(
        title: 'Cuando una afinidad parece prometedora',
        category: 'Matching',
        duration: '1 min 40 s',
        summary:
            'Reflexión breve para no apurar vínculos y cuidar mejor la experiencia.',
      ),
    ],
    accentColorHex: 0xFFFFE1EA,
  ),
  ProfessionalProfile(
    name: 'Dra. Valentina Sucre',
    specialty: 'Cría responsable',
    biography:
        'Trabaja sobre decisiones reproductivas responsables, evaluación previa y bienestar integral antes de considerar una cría.',
    description:
        'Aporta criterio profesional para perfiles que exploran vínculos reproductivos con enfoque responsable y una posible capa de asesoría futura.',
    contentType: 'Guías y recomendaciones',
    valueProposition:
        'Ofrecer contexto experto para que la cría no sea una decisión impulsiva, sino un proceso informado y responsable.',
    approachStyle: 'Responsable, criterioso y orientado al bienestar',
    helpSummary:
        'Puede ayudarte a entender cuándo conviene avanzar, qué evaluar antes y cómo conectar matching con responsabilidad real.',
    profileModeLabel: 'Especialista con criterio y servicio',
    presenceStatusLabel: 'Perfil curado por temática',
    serviceAvailabilityLabel: 'Asesoría futura en evaluación reproductiva',
    serviceSummary:
        'Su presencia mezcla guías expertas con una futura capa de consulta para casos donde la decisión requiere más criterio profesional.',
    services: [
      'Evaluación previa',
      'Criterio para cría responsable',
      'Compatibilidad reproductiva',
      'Orientación de bienestar',
    ],
    trustSignals: [
      'Tema sensible tratado con criterio',
      'Enfoque de bienestar antes que impulso',
      'Perfil apto para decisiones complejas',
    ],
    primaryActionLabel: 'Explorar criterio profesional',
    secondaryActionLabel: 'Ver contenido',
    topics: [
      'Cría responsable',
      'Compatibilidad',
      'Bienestar',
      'Evaluación previa',
    ],
    featuredContent: [
      ProfessionalContentPreview(
        title: 'Cuando hablar de cría y cuando no apurarse',
        category: 'Cría responsable',
        duration: '3 min',
        summary:
            'Contenido orientado a decisiones informadas, bienestar y compatibilidad antes de avanzar.',
      ),
      ProfessionalContentPreview(
        title: 'Preguntas clave antes de considerar una cría',
        category: 'Orientación',
        duration: '2 min 20 s',
        summary:
            'Checklist conceptual para ordenar expectativas y cuidar mejor a las mascotas.',
      ),
    ],
    accentColorHex: 0xFFFFF2C6,
  ),
];

const List<ProfessionalLibraryContent> professionalLibraryContents = [
  ProfessionalLibraryContent(
    title:
        'Presentaciones seguras entre mascotas: lo que conviene mirar primero',
    professional: 'Lic. Tomás Ibarra',
    category: 'Comportamiento',
    duration: '2 min',
    summary:
        'Pieza breve para entender energía, distancia y señales antes de un primer encuentro.',
    accentColorHex: 0xFFFFE1EA,
  ),
  ProfessionalLibraryContent(
    title: 'Qué debería tener un perfil QR realmente útil',
    professional: 'Dra. Paula Mendes',
    category: 'Identidad digital',
    duration: '1 min 30 s',
    summary:
        'Opinión corta sobre información esencial, contacto seguro y claridad para reportes.',
    accentColorHex: 0xFFDDF6F6,
  ),
  ProfessionalLibraryContent(
    title: 'Cuando hablar de cría y cuando no apurarse',
    professional: 'Dra. Valentina Sucre',
    category: 'Cría responsable',
    duration: '3 min',
    summary:
        'Contenido orientado a decisiones informadas, bienestar y compatibilidad antes de avanzar.',
    accentColorHex: 0xFFFFF2C6,
  ),
];

const List<ProfessionalRecommendation> professionalRecommendations = [
  ProfessionalRecommendation(
    title: 'Cómo leer compatibilidades antes de un encuentro',
    subtitle: 'Microcharla guiada por comportamiento y presentación segura.',
    accentColorHex: 0xFFDDF6F6,
  ),
  ProfessionalRecommendation(
    title: 'Placas QR y contacto seguro: qué debería tener un buen perfil',
    subtitle: 'Opinión breve enfocada en identidad digital y prevención.',
    accentColorHex: 0xFFFFE1EA,
  ),
  ProfessionalRecommendation(
    title: 'Cuándo conviene consultar a un profesional antes de criar',
    subtitle:
        'Contenido orientado a decisiones responsables dentro del ecosistema.',
    accentColorHex: 0xFFFFF2C6,
  ),
];

const List<ProfessionalServiceSpotlight> professionalServiceSpotlights = [
  ProfessionalServiceSpotlight(
    title: 'Veterinaria y chequeos',
    subtitle:
        'Perfiles pensados para prevención, orientación clínica y seguimiento básico.',
    availabilityLabel: 'Servicios futuros dentro de la red',
    accentColorHex: 0xFFDDF6F6,
  ),
  ProfessionalServiceSpotlight(
    title: 'Comportamiento y compatibilidad',
    subtitle:
        'Lectura conductual, presentaciones cuidadas y acompañamiento gradual.',
    availabilityLabel: 'Orientación y evaluación',
    accentColorHex: 0xFFFFE1EA,
  ),
  ProfessionalServiceSpotlight(
    title: 'Nutrición y alimentos',
    subtitle:
        'Recomendaciones, tiendas futuras y decisiones mejor explicadas para cada mascota.',
    availabilityLabel: 'Servicios y comercio futuro',
    accentColorHex: 0xFFFFF2C6,
  ),
  ProfessionalServiceSpotlight(
    title: 'Guardería, paseo y peluquería',
    subtitle:
        'Capas de servicio pensadas para operación, confianza y presencia comercial.',
    availabilityLabel: 'Prestadores y negocios',
    accentColorHex: 0xFFDDF6F6,
  ),
  ProfessionalServiceSpotlight(
    title: 'Crematorio y cementerio',
    subtitle:
        'Servicios sensibles que exigen confianza, claridad y presencia profesional cuidada.',
    availabilityLabel: 'Servicios especializados',
    accentColorHex: 0xFFFFE1EA,
  ),
];

const List<String> professionalSpecialties = [
  'Comportamiento',
  'Veterinaria',
  'Nutrición',
  'Cría responsable',
  'Bienestar',
];

ProfessionalProfile findProfessionalByName(String name) {
  return professionalProfiles.firstWhere(
    (professional) => professional.name == name,
  );
}
