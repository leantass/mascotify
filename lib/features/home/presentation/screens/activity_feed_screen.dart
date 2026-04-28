import 'package:flutter/material.dart';

import '../../../../features/explore/presentation/screens/conversation_screen.dart';
import '../../../../features/pets/presentation/screens/pet_detail_screen.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/ecosystem_activity_feed_item.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

class ActivityFeedScreen extends StatefulWidget {
  const ActivityFeedScreen({super.key});

  @override
  State<ActivityFeedScreen> createState() => _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends State<ActivityFeedScreen> {
  @override
  Widget build(BuildContext context) {
    final items = AppData.ecosystemActivityFeed;
    final petsCount = items
        .where((item) => item.type == EcosystemActivityFeedType.pet)
        .length;
    final messagesCount = items
        .where((item) => item.type == EcosystemActivityFeedType.message)
        .length;
    final notificationsCount = items
        .where((item) => item.type == EcosystemActivityFeedType.notification)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Actividad')),
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _ActivityHero(
                totalCount: items.length,
                petsCount: petsCount,
                messagesCount: messagesCount,
                notificationsCount: notificationsCount,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feed general',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Eventos locales de mascotas, mensajes, social, QR y notificaciones reunidos para esta cuenta.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      if (items.isEmpty)
                        const _EmptyActivityState()
                      else
                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ActivityFeedTile(
                              item: item,
                              onTap: () => _openItem(item),
                            ),
                          ),
                        ),
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

  Future<void> _openItem(EcosystemActivityFeedItem item) async {
    final notificationId = item.notificationId;
    if (notificationId != null) {
      await AppData.markNotificationRead(notificationId);
    }

    final threadId = item.threadId;
    if (threadId != null) {
      final thread = AppData.findMessageThreadById(threadId);
      if (thread != null && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ConversationScreen(thread: thread)),
        );
        if (mounted) setState(() {});
        return;
      }
    }

    final petId = item.petId;
    if (petId != null) {
      final pet = AppData.findPetById(petId);
      if (pet != null && mounted) {
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => PetDetailScreen(pet: pet)));
        if (mounted) setState(() {});
        return;
      }
    }

    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No hay un destino disponible para esta actividad.'),
      ),
    );
  }
}

class _ActivityHero extends StatelessWidget {
  const _ActivityHero({
    required this.totalCount,
    required this.petsCount,
    required this.messagesCount,
    required this.notificationsCount,
  });

  final int totalCount;
  final int petsCount;
  final int messagesCount;
  final int notificationsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primarySoft,
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
              'Pulso del ecosistema',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Actividad reciente de tu cuenta',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Una linea de tiempo local para volver rapido a mascotas, mensajes, social y notificaciones importantes.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          ResponsiveWrapGrid(
            minItemWidth: 180,
            children: [
              _HeroMetric(label: 'Eventos', value: '$totalCount visibles'),
              _HeroMetric(label: 'Mascotas', value: '$petsCount acciones'),
              _HeroMetric(label: 'Mensajes', value: '$messagesCount hilos'),
              _HeroMetric(
                label: 'Notificaciones',
                value: '$notificationsCount señales',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyActivityState extends StatelessWidget {
  const _EmptyActivityState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Todavia no hay actividad en esta cuenta. Cuando agregues mascotas, envies mensajes o recibas notificaciones, el feed va a mostrar esos eventos aca.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          height: 1.45,
        ),
      ),
    );
  }
}

class _ActivityFeedTile extends StatelessWidget {
  const _ActivityFeedTile({required this.item, required this.onTap});

  final EcosystemActivityFeedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(item.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_iconFor(item.type), color: AppColors.textPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ActivityPill(label: item.sourceLabel),
                        _ActivityPill(label: item.timeLabel),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(EcosystemActivityFeedType type) {
    switch (type) {
      case EcosystemActivityFeedType.pet:
        return Icons.pets_rounded;
      case EcosystemActivityFeedType.qr:
        return Icons.qr_code_2_rounded;
      case EcosystemActivityFeedType.social:
        return Icons.favorite_border_rounded;
      case EcosystemActivityFeedType.message:
        return Icons.forum_outlined;
      case EcosystemActivityFeedType.notification:
        return Icons.notifications_none_rounded;
      case EcosystemActivityFeedType.professional:
        return Icons.workspace_premium_outlined;
    }
  }

  Color _colorFor(EcosystemActivityFeedType type) {
    switch (type) {
      case EcosystemActivityFeedType.message:
      case EcosystemActivityFeedType.social:
        return AppColors.accentSoft;
      case EcosystemActivityFeedType.qr:
      case EcosystemActivityFeedType.pet:
        return AppColors.primarySoft;
      case EcosystemActivityFeedType.notification:
        return AppColors.supportSoft;
      case EcosystemActivityFeedType.professional:
        return AppColors.surface;
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

class _ActivityPill extends StatelessWidget {
  const _ActivityPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
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
    );
  }
}
