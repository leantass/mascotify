import '../models/professional_models.dart';

const List<ProfessionalProfile> professionalProfiles = [
  ProfessionalProfile(
    name: 'Dra. Paula Mendes',
    specialty: 'Veterinaria preventiva',
    biography:
        'Trabaja sobre prevencion, lectura temprana de senales clinicas y acompanamiento cotidiano para familias que buscan decisiones mas claras y seguras.',
    description:
        'Comparte recomendaciones breves sobre chequeos, prevencion y lectura temprana de senales importantes.',
    contentType: 'Charlas breves',
    valueProposition:
        'Convierte informacion veterinaria en piezas simples, utiles y faciles de aplicar dentro del dia a dia.',
    approachStyle: 'Claro, cercano y preventivo',
    helpSummary:
        'Puede ayudarte a ordenar prioridades de cuidado, entender alertas tempranas y aprovechar mejor la identidad digital de tu mascota para prevencion y seguimiento.',
    topics: [
      'Prevencion',
      'Chequeos',
      'Senales tempranas',
      'Rutinas saludables',
    ],
    featuredContent: [
      ProfessionalContentPreview(
        title: 'Que deberia tener un perfil QR realmente util',
        category: 'Identidad digital',
        duration: '1 min 30 s',
        summary:
            'Opinion corta sobre informacion esencial, contacto seguro y claridad para reportes.',
      ),
      ProfessionalContentPreview(
        title: 'Chequeos que conviene no postergar',
        category: 'Veterinaria',
        duration: '2 min',
        summary:
            'Una guia breve para detectar prioridades y ordenar controles preventivos.',
      ),
    ],
    accentColorHex: 0xFFDDF6F6,
  ),
  ProfessionalProfile(
    name: 'Lic. Tomas Ibarra',
    specialty: 'Comportamiento animal',
    biography:
        'Acompana procesos de socializacion y lectura de conducta con foco en encuentros graduales, bienestar emocional y compatibilidad entre mascotas.',
    description:
        'Publica opiniones y micro contenidos sobre socializacion, encuentros cuidados y compatibilidades.',
    contentType: 'Opiniones y reels',
    valueProposition:
        'Traducir el comportamiento en decisiones mas seguras para familias, encuentros y vinculos sociales.',
    approachStyle: 'Observacional, didactico y gradual',
    helpSummary:
        'Puede orientarte para leer energia, preparar presentaciones entre mascotas y detectar si una afinidad merece avanzar o tomarse con mas calma.',
    topics: [
      'Socializacion',
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
            'Pieza breve para entender energia, distancia y senales antes de un primer encuentro.',
      ),
      ProfessionalContentPreview(
        title: 'Cuando una afinidad parece prometedora',
        category: 'Matching',
        duration: '1 min 40 s',
        summary:
            'Reflexion breve para no apurar vinculos y cuidar mejor la experiencia.',
      ),
    ],
    accentColorHex: 0xFFFFE1EA,
  ),
  ProfessionalProfile(
    name: 'Dra. Valentina Sucre',
    specialty: 'Cria responsable',
    biography:
        'Trabaja sobre decisiones reproductivas responsables, evaluacion previa y bienestar integral antes de considerar una cria.',
    description:
        'Aporta criterio profesional para perfiles que exploran vinculos reproductivos con enfoque responsable.',
    contentType: 'Guias y recomendaciones',
    valueProposition:
        'Ofrecer contexto experto para que la cria no sea una decision impulsiva sino un proceso informado y responsable.',
    approachStyle: 'Responsable, criterioso y orientado al bienestar',
    helpSummary:
        'Puede ayudarte a entender cuando conviene avanzar, que evaluar antes y como conectar matching con responsabilidad real.',
    topics: [
      'Cria responsable',
      'Compatibilidad',
      'Bienestar',
      'Evaluacion previa',
    ],
    featuredContent: [
      ProfessionalContentPreview(
        title: 'Cuando hablar de cria y cuando no apurarse',
        category: 'Cria responsable',
        duration: '3 min',
        summary:
            'Contenido orientado a decisiones informadas, bienestar y compatibilidad antes de avanzar.',
      ),
      ProfessionalContentPreview(
        title: 'Preguntas clave antes de considerar una cria',
        category: 'Orientacion',
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
    professional: 'Lic. Tomas Ibarra',
    category: 'Comportamiento',
    duration: '2 min',
    summary:
        'Pieza breve para entender energia, distancia y senales antes de un primer encuentro.',
    accentColorHex: 0xFFFFE1EA,
  ),
  ProfessionalLibraryContent(
    title: 'Que deberia tener un perfil QR realmente util',
    professional: 'Dra. Paula Mendes',
    category: 'Identidad digital',
    duration: '1 min 30 s',
    summary:
        'Opinion corta sobre informacion esencial, contacto seguro y claridad para reportes.',
    accentColorHex: 0xFFDDF6F6,
  ),
  ProfessionalLibraryContent(
    title: 'Cuando hablar de cria y cuando no apurarse',
    professional: 'Dra. Valentina Sucre',
    category: 'Cria responsable',
    duration: '3 min',
    summary:
        'Contenido orientado a decisiones informadas, bienestar y compatibilidad antes de avanzar.',
    accentColorHex: 0xFFFFF2C6,
  ),
];

const List<ProfessionalRecommendation> professionalRecommendations = [
  ProfessionalRecommendation(
    title: 'Como leer compatibilidades antes de un encuentro',
    subtitle: 'Micro charla guiada por comportamiento y presentacion segura.',
    accentColorHex: 0xFFDDF6F6,
  ),
  ProfessionalRecommendation(
    title: 'Placas QR y contacto seguro: que deberia tener un buen perfil',
    subtitle: 'Opinion breve enfocada en identidad digital y prevencion.',
    accentColorHex: 0xFFFFE1EA,
  ),
  ProfessionalRecommendation(
    title: 'Cuando conviene consultar a un profesional antes de criar',
    subtitle:
        'Contenido orientado a decisiones responsables dentro del ecosistema.',
    accentColorHex: 0xFFFFF2C6,
  ),
];

const List<String> professionalSpecialties = [
  'Comportamiento',
  'Veterinaria',
  'Nutricion',
  'Cria responsable',
  'Bienestar',
];

ProfessionalProfile findProfessionalByName(String name) {
  return professionalProfiles.firstWhere(
    (professional) => professional.name == name,
  );
}
