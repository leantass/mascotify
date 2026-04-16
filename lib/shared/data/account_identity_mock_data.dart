import '../models/account_identity_models.dart';

class AccountIdentityMockData {
  static const MascotifyAccount familyAccount = MascotifyAccount(
    id: 'account-family-01',
    ownerName: 'Camila Rojas',
    email: 'camila@mascotify.app',
    planName: 'Mascotify Plus',
    city: 'Buenos Aires',
    memberSince: 'Enero 2026',
    baseSummary:
        'Una cuenta base pensada para centralizar identidad, mascotas, seguridad y futuras expansiones de uso dentro del ecosistema.',
    linkedProfilesSummary:
        'Hoy usa Mascotify como familia, pero la estructura ya admite sumar un perfil profesional o de negocio sin rehacer la cuenta.',
    availableExperiences: [
      AccountExperience.family,
      AccountExperience.professional,
    ],
    familyProfile: FamilyAccountProfile(
      householdName: 'Familia Rojas',
      petsSummaryLabel: '3 mascotas dentro del hogar',
      primaryGoal:
          'Cuidar identidad, seguridad QR, matching social y seguimiento cotidiano de las mascotas.',
      nextSetupStep:
          'Completar más datos de cuenta y dejar preparado un posible segundo perfil dentro de la misma base.',
      capabilities: [
        'Gestión de mascotas',
        'Seguridad QR',
        'Social y matching',
        'Notificaciones y seguimiento',
      ],
    ),
    professionalProfile: ProfessionalAccountProfile(
      businessName: 'Perfil profesional futuro',
      category: 'Disponible para activar',
      operationLabel: 'Sin publicar todavía',
      primaryGoal:
          'La misma cuenta podría sumar una capa profesional para ofrecer servicios sin duplicar identidad.',
      nextSetupStep:
          'Activar un perfil profesional cuando haga falta ofrecer servicios o gestionar presencia comercial.',
      services: ['Veterinaria', 'Comportamiento', 'Guardería', 'Peluquería'],
      capabilities: [
        'Servicios dentro de la app',
        'Presencia profesional',
        'Contenido y confianza',
      ],
    ),
  );

  static const MascotifyAccount professionalAccount = MascotifyAccount(
    id: 'account-pro-01',
    ownerName: 'Dra. Paula Mendes',
    email: 'paula@mascotify.pro',
    planName: 'Mascotify Pro',
    city: 'Buenos Aires',
    memberSince: 'Febrero 2026',
    baseSummary:
        'Una cuenta base diseñada para sostener identidad profesional, servicios, visibilidad y futuras variantes de negocio dentro de Mascotify.',
    linkedProfilesSummary:
        'La cuenta puede convivir con más de un perfil a futuro: profesional independiente, negocio, equipo o incluso una capa familiar.',
    availableExperiences: [
      AccountExperience.professional,
      AccountExperience.family,
    ],
    familyProfile: FamilyAccountProfile(
      householdName: 'Uso personal disponible',
      petsSummaryLabel: 'Base preparada para mascotas propias',
      primaryGoal:
          'La misma cuenta podría tener un uso familiar sin mezclarlo con la identidad profesional.',
      nextSetupStep:
          'Activar una capa familiar si en el futuro necesitara gestionar mascotas personales.',
      capabilities: [
        'Cuenta unificada',
        'Perfiles separados por uso',
        'Escalabilidad futura',
      ],
    ),
    professionalProfile: ProfessionalAccountProfile(
      businessName: 'Clínica Preventiva Paula Mendes',
      category: 'Veterinaria preventiva',
      operationLabel: 'Atiende presencial y asesoría breve',
      primaryGoal:
          'Ofrecer servicios con una presencia clara, confiable y lista para crecer dentro del ecosistema.',
      nextSetupStep:
          'Terminar onboarding profesional, definir servicios visibles y preparar una ficha pública de negocio.',
      services: [
        'Veterinaria',
        'Nutrición',
        'Comportamiento',
        'Tienda de alimentos',
        'Guardería',
        'Paseo',
        'Crematorio',
        'Cementerio',
      ],
      capabilities: [
        'Servicios y agenda futura',
        'Perfil comercial',
        'Contenido experto',
        'Confianza y reputación',
      ],
    ),
  );

  static const List<ExperienceOption> experienceOptions = [
    ExperienceOption(
      experience: AccountExperience.family,
      title: 'Familia o dueño de mascota',
      subtitle: 'Para cuidar, organizar y seguir la vida de tus mascotas.',
      description:
          'Pensado para identidad, QR, seguridad, matching social y una cuenta que pueda crecer sin perder claridad.',
      ctaLabel: 'Entrar como familia',
      accentColorHex: 0xFFDDF6F6,
      highlights: ['Mascotas y hogar', 'Seguridad QR', 'Conexiones sociales'],
      futureHint:
          'Más adelante podrías sumar una capa profesional sin cambiar de cuenta base.',
    ),
    ExperienceOption(
      experience: AccountExperience.professional,
      title: 'Profesional, negocio o prestador',
      subtitle:
          'Para ofrecer servicios y construir presencia dentro de Mascotify.',
      description:
          'Preparado para veterinarios, alimentos, crematorio, cementerio, comportamiento, peluquería, paseo, guardería y otros servicios futuros.',
      ctaLabel: 'Entrar como profesional',
      accentColorHex: 0xFFFFE1EA,
      highlights: [
        'Servicios dentro de la app',
        'Presencia comercial',
        'Perfil escalable',
      ],
      futureHint:
          'La arquitectura queda lista para sumar más roles o perfiles por cuenta.',
    ),
  ];

  static const OnboardingTrack familyTrack = OnboardingTrack(
    experience: AccountExperience.family,
    title: 'Onboarding inicial para familias',
    subtitle:
        'Una entrada orientada a mascotas, seguridad, organización y vida diaria.',
    architectureNote:
        'La cuenta base queda separada del perfil de uso para que después puedas sumar más capas sin rehacer la identidad.',
    ctaLabel: 'Continuar como familia',
    steps: [
      OnboardingStepPreview(
        title: 'Crear la cuenta base',
        description:
            'Definir identidad principal, email, ciudad y base administrativa de Mascotify.',
      ),
      OnboardingStepPreview(
        title: 'Activar el perfil familia',
        description:
            'Entrar con un uso centrado en mascotas, QR, seguridad y seguimiento cotidiano.',
      ),
      OnboardingStepPreview(
        title: 'Preparar expansión futura',
        description:
            'Dejar lista la cuenta para sumar nuevos perfiles o usos dentro del mismo ecosistema.',
      ),
    ],
    supportingHighlights: [
      'Mascotas y hogar',
      'Identidad y QR',
      'Base escalable',
    ],
  );

  static const OnboardingTrack professionalTrack = OnboardingTrack(
    experience: AccountExperience.professional,
    title: 'Onboarding inicial para profesionales y negocios',
    subtitle:
        'Una entrada orientada a servicios, presencia, confianza y crecimiento dentro del ecosistema.',
    architectureNote:
        'La cuenta base queda lista para separar negocio, servicios y futuras variantes de perfil sin mezclar todo en un solo actor rígido.',
    ctaLabel: 'Continuar como profesional',
    steps: [
      OnboardingStepPreview(
        title: 'Crear la cuenta base',
        description:
            'Definir identidad principal, email, ciudad y administración general de la cuenta.',
      ),
      OnboardingStepPreview(
        title: 'Activar el perfil profesional',
        description:
            'Configurar negocio, especialidad, servicios y tono de presencia dentro de Mascotify.',
      ),
      OnboardingStepPreview(
        title: 'Preparar publicación futura',
        description:
            'Dejar lista la estructura para ofrecer servicios, mostrar expertise y crecer sin rehacer la base.',
      ),
    ],
    supportingHighlights: [
      'Servicios',
      'Presencia comercial',
      'Escalabilidad multirol',
    ],
  );

  static MascotifyAccount accountFor(AccountExperience experience) {
    switch (experience) {
      case AccountExperience.family:
        return familyAccount;
      case AccountExperience.professional:
        return professionalAccount;
    }
  }

  static OnboardingTrack trackFor(AccountExperience experience) {
    switch (experience) {
      case AccountExperience.family:
        return familyTrack;
      case AccountExperience.professional:
        return professionalTrack;
    }
  }
}
