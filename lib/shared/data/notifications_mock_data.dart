import '../models/notification_models.dart';
import '../models/pet.dart';
import '../models/report_models.dart';
import '../models/social_models.dart';
import 'professional_mock_data.dart';
import 'reporting_mock_data.dart';
import 'social_mock_data.dart';

List<EcosystemNotification> buildMockNotifications([
  List<Pet>? sourcePets,
  List<MessageThread>? sourceThreads,
  SightingLocationReference Function(Pet pet)? locationResolver,
  List<SocialInboxEntry>? sourceInboxItems,
  List<SavedProfileEntry>? sourceSavedProfiles,
  List<QrActivityEntry> Function(Pet pet)? activityResolver,
]) {
  final pets = _resolveNotificationPets(sourcePets);
  if (pets.isEmpty) {
    return const <EcosystemNotification>[];
  }

  final inboxItems = sourceInboxItems ?? buildMockSocialInboxEntries(pets);
  final threads = sourceThreads ?? buildMockMessageThreads(pets);
  final savedProfiles = sourceSavedProfiles ?? buildMockSavedProfiles(pets);
  final featuredContent = professionalLibraryContents.first;
  final notifications = <EcosystemNotification>[];

  if (inboxItems.isNotEmpty) {
    final inboxItem = inboxItems.first;
    notifications.add(
      EcosystemNotification(
        id: 'notif-social-${inboxItem.pet.id}',
        type: EcosystemNotificationType.socialInterest,
        title: 'Nuevo interes recibido por ${inboxItem.pet.name}',
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
        title: 'Conversacion activa con ${thread.ownerName}',
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
    final qrActivity =
        activityResolver?.call(qrPet) ?? const <QrActivityEntry>[];
    final latestQrSignal = _latestOperationalQrSignal(qrActivity);

    if (latestQrSignal != null) {
      final qrLocation =
          locationResolver?.call(qrPet) ?? buildSuggestedLocationForPet(qrPet);
      notifications.add(
        EcosystemNotification(
          id: 'notif-qr-${qrPet.id}',
          type: EcosystemNotificationType.qrReport,
          title: latestQrSignal.iconKey == 'location'
              ? 'Nuevo avistamiento QR sobre ${qrPet.name}'
              : 'Nuevo escaneo QR sobre ${qrPet.name}',
          description: latestQrSignal.iconKey == 'location'
              ? 'Se registro una referencia aproximada en ${qrLocation.zoneReference} y quedo visible dentro del historial QR.'
              : latestQrSignal.detail,
          timeLabel: latestQrSignal.timeLabel,
          accentColorHex: latestQrSignal.iconKey == 'location'
              ? 0xFFFFF2C6
              : latestQrSignal.accentColorHex,
          priority: EcosystemNotificationPriority.attention,
          isUnread: true,
          actionLabel: 'Ver historial QR',
          action: EcosystemNotificationAction.openPetQrTraceability,
          petId: qrPet.id,
        ),
      );
    }
  }

  final primaryPetQrActivity =
      activityResolver?.call(pets.first) ?? const <QrActivityEntry>[];
  final primaryPetLatestSignal =
      _latestOperationalQrSignal(primaryPetQrActivity);

  if (primaryPetLatestSignal != null) {
    notifications.add(
      EcosystemNotification(
        id: 'notif-qr-history-${pets.first.id}',
        type: EcosystemNotificationType.qrReport,
        title: 'El historial QR de ${pets.first.name} sumo una nueva senal',
        description: primaryPetLatestSignal.detail,
        timeLabel: primaryPetLatestSignal.timeLabel,
        accentColorHex: primaryPetLatestSignal.accentColorHex,
        priority: EcosystemNotificationPriority.useful,
        isUnread: false,
        actionLabel: 'Ver historial QR',
        action: EcosystemNotificationAction.openPetQrTraceability,
        petId: pets.first.id,
      ),
    );
  }

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
          'Su ficha interna ya expresa mejor que busca, como le gustaria vincularse y en que contexto podria sentirse comodo.',
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
        description: '${savedProfile.reason} ${savedProfile.savedAtLabel}.',
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
      title: 'La comunidad experta sumo nuevas piezas breves',
      description:
          'Hay nuevas charlas y recomendaciones para cuidado, matching responsable y contacto seguro.',
      timeLabel: 'Hace 2 dias',
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

QrActivityEntry? _latestOperationalQrSignal(List<QrActivityEntry> activity) {
  for (final entry in activity) {
    if (_isOperationalQrSignal(entry)) {
      return entry;
    }
  }

  return null;
}

bool _isOperationalQrSignal(QrActivityEntry entry) {
  return entry.iconKey == 'qr' || entry.iconKey == 'location';
}
