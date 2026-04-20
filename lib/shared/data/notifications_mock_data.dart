import '../models/notification_models.dart';
import '../models/pet.dart';
import '../models/social_models.dart';
import 'professional_mock_data.dart';
import 'reporting_mock_data.dart';
import 'social_mock_data.dart';

List<EcosystemNotification> buildMockNotifications([
  List<Pet>? sourcePets,
  List<MessageThread>? sourceThreads,
]) {
  final pets = _resolveNotificationPets(sourcePets);
  if (pets.isEmpty) {
    return const <EcosystemNotification>[];
  }

  final inboxItems = buildMockSocialInboxEntries(pets);
  final threads = sourceThreads ?? buildMockMessageThreads(pets);
  final savedProfiles = buildMockSavedProfiles(pets);
  final featuredContent = professionalLibraryContents.first;
  final notifications = <EcosystemNotification>[];

  if (inboxItems.isNotEmpty) {
    final inboxItem = inboxItems.first;
    notifications.add(
      EcosystemNotification(
        id: 'notif-social-${inboxItem.pet.id}',
        type: EcosystemNotificationType.socialInterest,
        title: 'Nuevo interés recibido por ${inboxItem.pet.name}',
        description: inboxItem.message,
        timeLabel: 'Hace 5 min',
        accentColorHex: inboxItem.accentColorHex,
        priority: EcosystemNotificationPriority.attention,
        isUnread: true,
        actionLabel: 'Abrir bandeja social',
        action: EcosystemNotificationAction.openConnectionsInbox,
        petId: inboxItem.pet.id,
      ),
    );
  }

  if (threads.isNotEmpty) {
    final thread = threads.first;
    notifications.add(
      EcosystemNotification(
        id: 'notif-message-${thread.pet.id}',
        type: EcosystemNotificationType.message,
        title: 'Conversación activa con ${thread.ownerName}',
        description: thread.lastMessage,
        timeLabel: thread.lastActivity,
        accentColorHex: thread.accentColorHex,
        priority: EcosystemNotificationPriority.attention,
        isUnread: true,
        actionLabel: 'Ir a mensajes',
        action: EcosystemNotificationAction.openMessagesInbox,
        petId: thread.pet.id,
      ),
    );
  }

  if (pets.length >= 3) {
    final qrPet = pets[2];
    final qrLocation = buildSuggestedLocationForPet(qrPet);
    notifications.add(
      EcosystemNotification(
        id: 'notif-qr-${qrPet.id}',
        type: EcosystemNotificationType.qrReport,
        title: 'Nuevo avistamiento QR sobre ${qrPet.name}',
        description:
            'Se registró una referencia aproximada en ${qrLocation.zoneReference} y quedó visible dentro del historial QR.',
        timeLabel: 'Hace 18 min',
        accentColorHex: 0xFFFFF2C6,
        priority: EcosystemNotificationPriority.attention,
        isUnread: true,
        actionLabel: 'Ver historial QR',
        action: EcosystemNotificationAction.openPetQrTraceability,
        petId: qrPet.id,
      ),
    );
  }

  notifications.add(
    EcosystemNotification(
      id: 'notif-qr-history-${pets.first.id}',
      type: EcosystemNotificationType.qrReport,
      title: 'El historial QR de ${pets.first.name} sumó una nueva señal',
      description:
          'Ya hay más contexto de escaneos, contacto protegido y actividad reciente dentro de la ficha.',
      timeLabel: 'Hace 1 h',
      accentColorHex: 0xFFDDF6F6,
      priority: EcosystemNotificationPriority.useful,
      isUnread: false,
      actionLabel: 'Ver historial QR',
      action: EcosystemNotificationAction.openPetQrTraceability,
      petId: pets.first.id,
    ),
  );

  notifications.add(
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
  );

  notifications.add(
    EcosystemNotification(
      id: 'notif-reminder-${pets.first.id}',
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
  );

  if (savedProfiles.isNotEmpty) {
    final savedProfile = savedProfiles.last;
    notifications.add(
      EcosystemNotification(
        id: 'notif-saved-${savedProfile.pet.id}',
        type: EcosystemNotificationType.reminder,
        title: 'Retomar perfil guardado de ${savedProfile.pet.name}',
        description:
            '${savedProfile.reason} ${savedProfile.savedAtLabel}.',
        timeLabel: 'Ayer',
        accentColorHex: 0xFFFFE1EA,
        priority: EcosystemNotificationPriority.info,
        isUnread: false,
        actionLabel: 'Abrir perfil',
        action: EcosystemNotificationAction.openPetDetail,
        petId: savedProfile.pet.id,
      ),
    );
  }

  notifications.add(
    EcosystemNotification(
      id: 'notif-professionals-feed',
      type: EcosystemNotificationType.professionalContent,
      title: 'La comunidad experta sumó nuevas piezas breves',
      description:
          'Hay nuevas charlas y recomendaciones para cuidado, matching responsable y contacto seguro.',
      timeLabel: 'Hace 2 días',
      accentColorHex: 0xFFFFF2C6,
      priority: EcosystemNotificationPriority.info,
      isUnread: false,
      actionLabel: 'Ver profesionales',
      action: EcosystemNotificationAction.openProfessionals,
    ),
  );

  return notifications;
}

List<Pet> _resolveNotificationPets(List<Pet>? sourcePets) {
  return sourcePets ?? const <Pet>[];
}
