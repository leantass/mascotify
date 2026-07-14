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
        'Una cuenta base para cuidar mascotas, QR seguro, actividad y preferencias familiares.',
    linkedProfilesSummary:
        'Mascotify esta disponible hoy para familias y tutores. Profesionales queda como beta visible para mas adelante.',
    availableExperiences: [AccountExperience.family],
    familyProfile: FamilyAccountProfile(
      householdName: 'Familia Rojas',
      petsSummaryLabel: '3 mascotas dentro del hogar',
      primaryGoal:
          'Cuidar identidad, seguridad QR, matching social y seguimiento cotidiano de las mascotas.',
      nextSetupStep:
          'Completar datos de mascotas y revisar ayuda si hace falta.',
      capabilities: [
        'Gestion de mascotas',
        'Seguridad QR',
        'Social y matching',
        'Notificaciones y seguimiento',
      ],
    ),
    professionalProfile: ProfessionalAccountProfile(
      businessName: 'Profesionales pet beta',
      category: 'Beta / proximamente',
      operationLabel: 'Preview sin operacion real',
      primaryGoal:
          'Mostrar la vision futura sin activar agenda, reservas, pagos ni contacto real.',
      nextSetupStep: 'Ver la preview beta cuando quieras conocer la vision.',
      services: ['Veterinaria', 'Paseo', 'Cuidado', 'Peluqueria'],
      capabilities: ['Preview beta', 'Servicios futuros', 'Contacto mediado'],
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
        'Cuenta demo para mostrar la preview beta de profesionales pet sin activar operaciones reales.',
    linkedProfilesSummary:
        'La experiencia principal disponible hoy sigue siendo familias y tutores.',
    availableExperiences: [
      AccountExperience.family,
      AccountExperience.professional,
    ],
    familyProfile: FamilyAccountProfile(
      householdName: 'Uso familiar demo',
      petsSummaryLabel: 'Base preparada para mascotas propias',
      primaryGoal:
          'Usar Mascotify como tutor mientras la capa profesional permanece en beta.',
      nextSetupStep: 'Recorrer la experiencia familiar activa.',
      capabilities: [
        'Cuenta unificada',
        'Perfil familia activo',
        'Preview profesional bloqueada',
      ],
    ),
    professionalProfile: ProfessionalAccountProfile(
      businessName: 'Clinica Preventiva Paula Mendes',
      category: 'Veterinaria preventiva',
      operationLabel: 'Beta sin agenda real',
      primaryGoal:
          'Mostrar una vision futura para servicios pet sin pedir datos profesionales reales.',
      nextSetupStep:
          'Agenda, reservas, contacto seguro y servicios reales estaran disponibles mas adelante.',
      services: [
        'Veterinaria',
        'Nutricion',
        'Comportamiento',
        'Tienda de alimentos',
        'Guarderia',
        'Paseo',
        'Crematorio',
        'Cementerio',
      ],
      capabilities: [
        'Beta read-only',
        'Sin pagos',
        'Sin reservas reales',
        'Contacto futuro mediado',
      ],
    ),
  );

  static const List<ExperienceOption> experienceOptions = [
    ExperienceOption(
      experience: AccountExperience.family,
      title: 'Familia o tutor',
      subtitle: 'Para cuidar, organizar y disfrutar tus mascotas.',
      description:
          'Pensado para identidad, QR, salud, recordatorios, matching social y actividad diaria.',
      ctaLabel: 'Entrar como familia',
      accentColorHex: 0xFFDDF6F6,
      highlights: ['Mascotas y hogar', 'Seguridad QR', 'Conexiones sociales'],
      futureHint:
          'Mas adelante podras conocer herramientas beta para profesionales pet.',
    ),
    ExperienceOption(
      experience: AccountExperience.professional,
      title: 'Profesionales pet beta',
      subtitle: 'Estamos preparando herramientas para servicios pet.',
      description:
          'Preview futura para veterinarias, paseadores, cuidadores, peluqueria y otros servicios. La experiencia activa hoy es para familias.',
      ctaLabel: 'Ver preview beta',
      accentColorHex: 0xFFFFE1EA,
      highlights: ['Beta', 'Sin agenda real', 'Sin pagos ni reservas'],
      futureHint:
          'Agenda, reservas, contacto y servicios reales llegaran mas adelante.',
    ),
  ];

  static const OnboardingTrack familyTrack = OnboardingTrack(
    experience: AccountExperience.family,
    title: 'Onboarding inicial para familias',
    subtitle: 'Entrada simple para cuidar mascotas y usar Mascotify hoy.',
    architectureNote:
        'La cuenta queda enfocada en mascotas, seguridad, salud, actividad y conexiones sociales.',
    ctaLabel: 'Continuar como familia',
    steps: [
      OnboardingStepPreview(
        title: 'Crear la cuenta base',
        description: 'Definir nombre, email y ciudad para empezar.',
      ),
      OnboardingStepPreview(
        title: 'Activar el perfil familia',
        description: 'Entrar con una experiencia centrada en tus mascotas.',
      ),
      OnboardingStepPreview(
        title: 'Sumar la primera mascota',
        description: 'Completar perfil, QR, salud y datos importantes.',
      ),
    ],
    supportingHighlights: ['Mascotas y hogar', 'Identidad y QR', 'Uso simple'],
  );

  static const OnboardingTrack professionalTrack = OnboardingTrack(
    experience: AccountExperience.professional,
    title: 'Profesionales pet beta',
    subtitle:
        'Preview beta para conocer la vision futura sin activar un modo profesional real.',
    architectureNote:
        'La primera salida prioriza familias y tutores. Profesionales queda visible como beta bloqueada.',
    ctaLabel: 'Ver preview beta',
    steps: [
      OnboardingStepPreview(
        title: 'Preview beta',
        description:
            'Muestra una idea visual de herramientas futuras para servicios pet.',
      ),
      OnboardingStepPreview(
        title: 'Sin datos reales',
        description:
            'No se piden matriculas, telefonos, emails profesionales ni datos sensibles.',
      ),
      OnboardingStepPreview(
        title: 'Funciones futuras',
        description:
            'Agenda, reservas, contacto y servicios reales quedan para mas adelante.',
      ),
    ],
    supportingHighlights: ['Beta', 'Preview read-only', 'Family-first'],
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
