import 'package:flutter/material.dart';

import '../../../../features/explore/presentation/screens/connections_inbox_screen.dart';
import '../../../../features/explore/presentation/screens/messages_inbox_screen.dart';
import '../../../../features/explore/presentation/screens/professional_content_detail_screen.dart';
import '../../../../features/explore/presentation/screens/professionals_screen.dart';
import '../../../../features/pets/presentation/screens/pet_detail_screen.dart';
import '../../../../features/pets/presentation/screens/qr_traceability_screen.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/notification_models.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/professional_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Set<String> _readIds = <String>{};
  final Set<String> _dismissedIds = <String>{};
  bool _showHistory = true;

  @override
  Widget build(BuildContext context) {
    final baseNotifications = AppData.notifications
        .where((item) => !_dismissedIds.contains(item.id))
        .toList();
    final notifications = _sortedNotifications(baseNotifications);
    final unreadNotifications = notifications.where(_isUnread).toList();
    final historyNotifications = notifications
        .where((item) => !_isUnread(item))
        .toList();
    final unreadCount = unreadNotifications.length;
    final attentionCount = unreadNotifications
        .where(
          (item) => item.priority == EcosystemNotificationPriority.attention,
        )
        .length;
    final actionableCount = notifications
        .where((item) => item.action != null)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Actividad y notificaciones')),
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _NotificationsHero(
              totalCount: notifications.length,
              unreadCount: unreadCount,
              attentionCount: attentionCount,
              actionableCount: actionableCount,
              historyCount: historyNotifications.length,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feed del ecosistema',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ordenado por lectura real: primero lo nuevo y lo importante, después el historial útil para volver cuando lo necesites.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _ActionChip(
                          label: unreadCount > 0
                              ? 'Marcar todo como visto'
                              : 'Todo al día',
                          onTap: unreadCount > 0 ? _markAllAsRead : null,
                        ),
                        _ActionChip(
                          label: _showHistory
                              ? 'Ocultar historial'
                              : 'Mostrar historial',
                          onTap: () {
                            setState(() {
                              _showHistory = !_showHistory;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _NotificationsSection(
                      title: 'Nuevo y pendiente',
                      subtitle: unreadNotifications.isEmpty
                          ? 'No hay novedades sin leer.'
                          : 'Lo que conviene abrir primero dentro del ecosistema.',
                      notifications: unreadNotifications,
                      isUnread: _isUnread,
                      onOpen: (notification) =>
                          _openAndMarkRead(context, notification),
                      onMarkAsRead: _markAsRead,
                      onDismiss: _dismiss,
                    ),
                    if (_showHistory) ...[
                      const SizedBox(height: 16),
                      _NotificationsSection(
                        title: 'Historial reciente',
                        subtitle: historyNotifications.isEmpty
                            ? 'No hay actividad archivada por ahora.'
                            : 'Actividad útil, ya vista o más informativa.',
                        notifications: historyNotifications,
                        isUnread: _isUnread,
                        onOpen: (notification) =>
                            _openAndMarkRead(context, notification),
                        onMarkAsRead: _markAsRead,
                        onDismiss: _dismiss,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }

  bool _isUnread(EcosystemNotification notification) {
    return notification.isUnread && !_readIds.contains(notification.id);
  }

  List<EcosystemNotification> _sortedNotifications(
    List<EcosystemNotification> notifications,
  ) {
    final indexed = notifications.asMap().entries.toList();
    indexed.sort((a, b) {
      final aUnread = _isUnread(a.value) ? 0 : 1;
      final bUnread = _isUnread(b.value) ? 0 : 1;
      if (aUnread != bUnread) return aUnread.compareTo(bUnread);

      final priorityComparison = _priorityRank(
        a.value.priority,
      ).compareTo(_priorityRank(b.value.priority));
      if (priorityComparison != 0) return priorityComparison;

      final actionComparison =
          (b.value.action != null ? 1 : 0) - (a.value.action != null ? 1 : 0);
      if (actionComparison != 0) return actionComparison;

      return a.key.compareTo(b.key);
    });
    return indexed.map((entry) => entry.value).toList();
  }

  int _priorityRank(EcosystemNotificationPriority priority) {
    switch (priority) {
      case EcosystemNotificationPriority.attention:
        return 0;
      case EcosystemNotificationPriority.useful:
        return 1;
      case EcosystemNotificationPriority.info:
        return 2;
    }
  }

  void _markAsRead(String id) {
    setState(() {
      _readIds.add(id);
    });
  }

  void _markAllAsRead() {
    setState(() {
      _readIds.addAll(
        AppData.notifications
            .where((item) => !_dismissedIds.contains(item.id) && item.isUnread)
            .map((item) => item.id),
      );
    });
  }

  void _dismiss(String id) {
    setState(() {
      _dismissedIds.add(id);
    });
  }

  Future<void> _openAndMarkRead(
    BuildContext context,
    EcosystemNotification notification,
  ) async {
    _markAsRead(notification.id);
    await _handleNotificationAction(context, notification);
  }

  Future<void> _handleNotificationAction(
    BuildContext context,
    EcosystemNotification notification,
  ) async {
    switch (notification.action) {
      case EcosystemNotificationAction.openConnectionsInbox:
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ConnectionsInboxScreen()),
        );
        return;
      case EcosystemNotificationAction.openMessagesInbox:
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MessagesInboxScreen()));
        return;
      case EcosystemNotificationAction.openPetDetail:
        final pet = _findPet(notification.petId);
        if (pet == null) return;
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => PetDetailScreen(pet: pet)));
        return;
      case EcosystemNotificationAction.openPetQrTraceability:
        final pet = _findPet(notification.petId);
        if (pet == null) return;
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => QrTraceabilityScreen(pet: pet)),
        );
        return;
      case EcosystemNotificationAction.openProfessionals:
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProfessionalsScreen()));
        return;
      case EcosystemNotificationAction.openProfessionalContent:
        final professional = _findProfessional(notification.professionalName);
        if (professional == null) return;
        final content = _findContent(professional, notification.contentTitle);
        if (content == null) return;
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfessionalContentDetailScreen(
              professional: professional,
              content: content,
            ),
          ),
        );
        return;
      case null:
        return;
    }
  }

  Pet? _findPet(String? petId) {
    if (petId == null) return null;
    return AppData.findPetById(petId);
  }

  ProfessionalProfile? _findProfessional(String? professionalName) {
    if (professionalName == null) return null;
    return AppData.findProfessionalByName(professionalName);
  }

  ProfessionalContentPreview? _findContent(
    ProfessionalProfile professional,
    String? contentTitle,
  ) {
    if (contentTitle == null) return null;
    return AppData.findFeaturedContent(professional, contentTitle);
  }
}

class _NotificationsHero extends StatelessWidget {
  const _NotificationsHero({
    required this.totalCount,
    required this.unreadCount,
    required this.attentionCount,
    required this.actionableCount,
    required this.historyCount,
  });

  final int totalCount;
  final int unreadCount;
  final int attentionCount;
  final int actionableCount;
  final int historyCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.accentSoft,
            AppColors.surface,
            AppColors.supportSoft,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Actividad transversal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Todo lo relevante del ecosistema en una sola capa más clara.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'El feed ahora prioriza lo sin leer, separa mejor lo urgente de lo informativo y permite pequeñas acciones mock sin volverse un panel pesado.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Sin leer',
                  value: '$unreadCount activos',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroMetric(
                  label: 'Atención',
                  value: '$attentionCount primero',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroMetric(
                  label: 'Historial',
                  value: '$historyCount vistos',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              '$actionableCount eventos todavía tienen un camino de acción útil dentro de Mascotify.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({
    required this.title,
    required this.subtitle,
    required this.notifications,
    required this.isUnread,
    required this.onOpen,
    required this.onMarkAsRead,
    required this.onDismiss,
  });

  final String title;
  final String subtitle;
  final List<EcosystemNotification> notifications;
  final bool Function(EcosystemNotification notification) isUnread;
  final ValueChanged<EcosystemNotification> onOpen;
  final ValueChanged<String> onMarkAsRead;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        if (notifications.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
            ),
          )
        else
          ...notifications.map(
            (notification) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _NotificationCard(
                notification: notification,
                isUnread: isUnread(notification),
                onOpen: () => onOpen(notification),
                onMarkAsRead: isUnread(notification)
                    ? () => onMarkAsRead(notification.id)
                    : null,
                onDismiss: notification.isDismissible
                    ? () => onDismiss(notification.id)
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.isUnread,
    required this.onOpen,
    this.onMarkAsRead,
    this.onDismiss,
  });

  final EcosystemNotification notification;
  final bool isUnread;
  final VoidCallback onOpen;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final iconData = _iconForType(notification.type);
    final typeLabel = _labelForType(notification.type);
    final priorityLabel = _labelForPriority(notification.priority);
    final tone = Color(notification.accentColorHex);
    final borderColor =
        isUnread &&
            notification.priority == EcosystemNotificationPriority.attention
        ? AppColors.accent
        : AppColors.border;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: isUnread ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: tone,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(iconData, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TypePill(
                          label: typeLabel,
                          backgroundColor: AppColors.surfaceAlt,
                        ),
                        _TypePill(
                          label: priorityLabel,
                          backgroundColor: _priorityColor(
                            notification.priority,
                          ),
                        ),
                        if (isUnread)
                          const _TypePill(
                            label: 'Sin leer',
                            backgroundColor: AppColors.supportSoft,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                notification.timeLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notification.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (notification.actionLabel != null)
                ElevatedButton(
                  onPressed: onOpen,
                  child: Text(notification.actionLabel!),
                ),
              if (onMarkAsRead != null)
                OutlinedButton(
                  onPressed: onMarkAsRead,
                  child: const Text('Marcar visto'),
                ),
              if (onDismiss != null)
                TextButton(onPressed: onDismiss, child: const Text('Ocultar')),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconForType(EcosystemNotificationType type) {
    switch (type) {
      case EcosystemNotificationType.socialInterest:
        return Icons.favorite_border_rounded;
      case EcosystemNotificationType.message:
        return Icons.forum_rounded;
      case EcosystemNotificationType.qrReport:
        return Icons.qr_code_2_rounded;
      case EcosystemNotificationType.professionalContent:
        return Icons.play_circle_outline_rounded;
      case EcosystemNotificationType.reminder:
        return Icons.notifications_active_outlined;
    }
  }

  String _labelForType(EcosystemNotificationType type) {
    switch (type) {
      case EcosystemNotificationType.socialInterest:
        return 'Social';
      case EcosystemNotificationType.message:
        return 'Mensajería';
      case EcosystemNotificationType.qrReport:
        return 'QR y reportes';
      case EcosystemNotificationType.professionalContent:
        return 'Contenido experto';
      case EcosystemNotificationType.reminder:
        return 'Recordatorio';
    }
  }

  String _labelForPriority(EcosystemNotificationPriority priority) {
    switch (priority) {
      case EcosystemNotificationPriority.attention:
        return 'Requiere atención';
      case EcosystemNotificationPriority.useful:
        return 'Útil';
      case EcosystemNotificationPriority.info:
        return 'Informativo';
    }
  }

  Color _priorityColor(EcosystemNotificationPriority priority) {
    switch (priority) {
      case EcosystemNotificationPriority.attention:
        return AppColors.accentSoft;
      case EcosystemNotificationPriority.useful:
        return AppColors.primarySoft;
      case EcosystemNotificationPriority.info:
        return Colors.white;
    }
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.label, required this.backgroundColor});

  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: onTap == null ? AppColors.surfaceAlt : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
