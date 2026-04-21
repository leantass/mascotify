import 'package:flutter/material.dart';

import '../../../../features/pets/presentation/screens/pet_public_profile_screen.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/social_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import 'conversation_screen.dart';
import 'messages_inbox_screen.dart';

class ConnectionsInboxScreen extends StatelessWidget {
  const ConnectionsInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inboxItems = AppData.socialInboxEntries;
    final sentItems = inboxItems
        .where((item) => item.direction == 'Enviado')
        .toList();
    final receivedItems = inboxItems
        .where((item) => item.direction == 'Recibido')
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Bandeja social')),
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _InboxHero(totalItems: inboxItems.length),
            const SizedBox(height: 20),
            _InboxSection(
              title: 'Intereses recibidos',
              subtitle:
                  'Señales que llegaron a tu ecosistema social para revisar con calma.',
              items: receivedItems,
            ),
            const SizedBox(height: 16),
            _InboxSection(
              title: 'Intereses enviados',
              subtitle:
                  'Conexiones que iniciaste y que pueden evolucionar dentro de Mascotify.',
              items: sentItems,
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _InboxHero extends StatelessWidget {
  const _InboxHero({required this.totalItems});

  final int totalItems;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.accentSoft,
            AppColors.surface,
            AppColors.primarySoft,
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
              'Actividad social',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Seguí el movimiento social de tus conexiones.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Esta bandeja conecta intereses, afinidades y mensajería para que la transición hacia una conversación se sienta natural y ordenada.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Actividad',
                  value: '$totalItems movimientos',
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _HeroMetric(
                  label: 'Estado',
                  value: 'Seguimiento activo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MessagesInboxScreen()),
              ),
              child: const Text('Abrir mensajería'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InboxSection extends StatelessWidget {
  const _InboxSection({
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String title;
  final String subtitle;
  final List<SocialInboxEntry> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const _InboxEmptyState(
                description:
                    'Todavía no hay señales persistidas en esta bandeja para la cuenta activa.',
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InboxCard(item: item),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InboxCard extends StatelessWidget {
  const _InboxCard({required this.item});

  final SocialInboxEntry item;

  @override
  Widget build(BuildContext context) {
    final thread = AppData.findMessageThreadForPet(item.pet);
    final hasThread = thread != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Color(item.pet.colorHex),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.pets_rounded, color: AppColors.dark),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.pet.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _InboxPill(
                          label: item.direction,
                          backgroundColor: Color(item.accentColorHex),
                          textColor: AppColors.textPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.pet.species} • ${item.pet.breed}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.pet.location,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniInfoTile(
                  label: 'Interés',
                  value: item.interestType,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniInfoTile(label: 'Estado', value: item.status),
              ),
            ],
          ),
          if (hasThread) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chat ya disponible',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${thread.connectionType} • ${thread.stageLabel}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    thread.lastMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            item.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              hasThread
                  ? 'Esta afinidad ya dio paso a una conversación persistida. Si entrás al chat, el contexto del interés se mantiene visible.'
                  : 'Todavía no hay chat abierto, pero la transición natural sería llevar esta afinidad a la mensajería cuando tenga sentido.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PetPublicProfileScreen(pet: item.pet),
                    ),
                  ),
                  child: const Text('Ver perfil'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!hasThread) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MessagesInboxScreen(),
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ConversationScreen(thread: thread),
                      ),
                    );
                  },
                  child: Text(hasThread ? 'Abrir chat' : 'Ir a mensajes'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showReviewLaterDialog(context, item: item),
                  child: const Text('Revisar luego'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _showReviewLaterDialog(
  BuildContext context, {
  required SocialInboxEntry item,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.supportSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Queda en seguimiento',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Esta interacción con ${item.pet.name} quedaría marcada para revisar después dentro del flujo social de Mascotify.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'La idea es sostener conversaciones y afinidades sin presión, con espacio para volver cuando el contexto sea mejor.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Entendido'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
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

class _MiniInfoTile extends StatelessWidget {
  const _MiniInfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InboxPill extends StatelessWidget {
  const _InboxPill({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

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
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InboxEmptyState extends StatelessWidget {
  const _InboxEmptyState({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          height: 1.45,
        ),
      ),
    );
  }
}
