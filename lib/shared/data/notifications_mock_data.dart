import '../models/notification_models.dart';
import 'mock_data.dart';
import 'professional_mock_data.dart';
import 'reporting_mock_data.dart';
import 'social_mock_data.dart';

List<EcosystemNotification> buildMockNotifications() {
  final pets = MockData.pets;
  final inboxItems = buildMockSocialInboxEntries();
  final threads = buildMockMessageThreads();
  final savedProfiles = buildMockSavedProfiles();
  final qrLocation = buildSuggestedLocationForPet(pets[2]);
  final featuredContent = professionalLibraryContents.first;

  return [
    EcosystemNotification(
      id: 'notif-social-nina',
      type: EcosystemNotificationType.socialInterest,
      title: 'Nuevo interés recibido por Nina',
      description: inboxItems.first.message,
      timeLabel: 'Hace 5 min',
      accentColorHex: inboxItems.first.accentColorHex,
      priority: EcosystemNotificationPriority.attention,
      isUnread: true,
      actionLabel: 'Abrir bandeja social',
      action: EcosystemNotificationAction.openConnectionsInbox,
      petId: inboxItems.first.pet.id,
    ),
    EcosystemNotification(
      id: 'notif-message-thread',
      type: EcosystemNotificationType.message,
      title: 'Conversación activa con ${threads.first.ownerName}',
      description: threads.first.lastMessage,
      timeLabel: threads.first.lastActivity,
      accentColorHex: threads.first.accentColorHex,
      priority: EcosystemNotificationPriority.attention,
      isUnread: true,
      actionLabel: 'Ir a mensajes',
      action: EcosystemNotificationAction.openMessagesInbox,
      petId: threads.first.pet.id,
    ),
    EcosystemNotification(
      id: 'notif-qr-bruno',
      type: EcosystemNotificationType.qrReport,
      title: 'Nuevo avistamiento QR sobre ${pets[2].name}',
      description:
          'Se registró una referencia aproximada en ${qrLocation.zoneReference} y quedó visible dentro del historial QR.',
      timeLabel: 'Hace 18 min',
      accentColorHex: 0xFFFFF2C6,
      priority: EcosystemNotificationPriority.attention,
      isUnread: true,
      actionLabel: 'Ver historial QR',
      action: EcosystemNotificationAction.openPetQrTraceability,
      petId: pets[2].id,
    ),
    EcosystemNotification(
      id: 'notif-qr-history',
      type: EcosystemNotificationType.qrReport,
      title: 'El historial QR de ${pets[0].name} sumó una nueva señal',
      description:
          'Ya hay más contexto de escaneos, contacto protegido y actividad reciente dentro de la ficha.',
      timeLabel: 'Hace 1 h',
      accentColorHex: 0xFFDDF6F6,
      priority: EcosystemNotificationPriority.useful,
      isUnread: false,
      actionLabel: 'Ver historial QR',
      action: EcosystemNotificationAction.openPetQrTraceability,
      petId: pets[0].id,
    ),
    EcosystemNotification(
      id: 'notif-content-professional',
      type: EcosystemNotificationType.professionalContent,
      title: 'Nuevo contenido profesional disponible',
      description: '${featuredContent.title}. ${featuredContent.summary}',
      timeLabel: 'Hace 42 min',
      accentColorHex: featuredContent.accentColorHex,
      priority: EcosystemNotificationPriority.useful,
      isUnread: false,
      actionLabel: 'Ver contenido',
      action: EcosystemNotificationAction.openProfessionalContent,
      professionalName: featuredContent.professional,
      contentTitle: featuredContent.title,
    ),
    EcosystemNotification(
      id: 'notif-reminder-milo',
      type: EcosystemNotificationType.reminder,
      title: '${pets.first.name} ya tiene matching listo para explorar',
      description:
          'Su ficha interna ya expresa mejor qué busca, cómo le gustaría vincularse y en qué contexto podría sentirse cómodo.',
      timeLabel: 'Hoy',
      accentColorHex: 0xFFDDF6F6,
      priority: EcosystemNotificationPriority.useful,
      isUnread: false,
      actionLabel: 'Ver preferencias',
      action: EcosystemNotificationAction.openPetDetail,
      petId: pets.first.id,
    ),
    EcosystemNotification(
      id: 'notif-saved-profile',
      type: EcosystemNotificationType.reminder,
      title: 'Retomar perfil guardado de ${savedProfiles.last.pet.name}',
      description:
          '${savedProfiles.last.reason} ${savedProfiles.last.savedAtLabel}.',
      timeLabel: 'Ayer',
      accentColorHex: 0xFFFFE1EA,
      priority: EcosystemNotificationPriority.info,
      isUnread: false,
      actionLabel: 'Abrir perfil',
      action: EcosystemNotificationAction.openPetDetail,
      petId: savedProfiles.last.pet.id,
    ),
    EcosystemNotification(
      id: 'notif-professionals-feed',
      type: EcosystemNotificationType.professionalContent,
      title: 'La comunidad experta sumó nuevas piezas breves',
      description:
          'Hay nuevas charlas y recomendaciones para cuidado, matching responsable y contacto seguro.',
      timeLabel: 'Hace 2 dias',
      accentColorHex: 0xFFFFF2C6,
      priority: EcosystemNotificationPriority.info,
      isUnread: false,
      actionLabel: 'Ver profesionales',
      action: EcosystemNotificationAction.openProfessionals,
    ),
  ];
}
