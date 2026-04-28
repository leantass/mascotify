import 'package:flutter/material.dart';

import '../../../../features/explore/presentation/screens/conversation_screen.dart';
import '../../../../features/pets/presentation/screens/pet_detail_screen.dart';
import '../../../../features/pets/presentation/screens/qr_traceability_screen.dart';
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
  final _searchController = TextEditingController();
  EcosystemActivityFeedType? _selectedType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = AppData.ecosystemActivityFeed;
    final filteredItems = _filteredItems(items);
    final hasActiveFilters =
        _searchController.text.trim().isNotEmpty || _selectedType != null;
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
                      if (items.isNotEmpty) ...[
                        _ActivityFeedControls(
                          controller: _searchController,
                          selectedType: _selectedType,
                          hasActiveFilters: hasActiveFilters,
                          onSearchChanged: (_) => setState(() {}),
                          onTypeSelected: (type) {
                            setState(() {
                              _selectedType = type;
                            });
                          },
                          onClear: _clearFilters,
                        ),
                        const SizedBox(height: 18),
                      ],
                      if (items.isEmpty)
                        const _EmptyActivityState()
                      else if (filteredItems.isEmpty)
                        _FilteredEmptyState(onClear: _clearFilters)
                      else
                        ...filteredItems.map(
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

  List<EcosystemActivityFeedItem> _filteredItems(
    List<EcosystemActivityFeedItem> items,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return items.where((item) {
      final matchesType = _selectedType == null || item.type == _selectedType;
      final matchesQuery =
          query.isEmpty || _searchableTextFor(item).contains(query);
      return matchesType && matchesQuery;
    }).toList();
  }

  String _searchableTextFor(EcosystemActivityFeedItem item) {
    return [
      item.title,
      item.description,
      item.sourceLabel,
      item.timeLabel,
      _labelForType(item.type),
      item.relatedEntityId,
      item.relatedEntityType,
      item.petId,
      item.threadId,
      item.notificationId,
    ].whereType<String>().join(' ').toLowerCase();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedType = null;
    });
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
        if (item.type == EcosystemActivityFeedType.qr) {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => QrTraceabilityScreen(pet: pet)),
          );
          if (mounted) setState(() {});
          return;
        }
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

class _ActivityFeedControls extends StatelessWidget {
  const _ActivityFeedControls({
    required this.controller,
    required this.selectedType,
    required this.hasActiveFilters,
    required this.onSearchChanged,
    required this.onTypeSelected,
    required this.onClear,
  });

  final TextEditingController controller;
  final EcosystemActivityFeedType? selectedType;
  final bool hasActiveFilters;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<EcosystemActivityFeedType?> onTypeSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('activity-search-field'),
          controller: controller,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            labelText: 'Buscar actividad',
            hintText: 'Buscar por título, mascota, descripción u origen',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Limpiar búsqueda',
                    onPressed: onClear,
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              key: const ValueKey('activity-filter-all'),
              label: 'Todas',
              isSelected: selectedType == null,
              onTap: () => onTypeSelected(null),
            ),
            ...EcosystemActivityFeedType.values.map(
              (type) => _FilterChip(
                key: ValueKey('activity-filter-${type.name}'),
                label: _labelForType(type),
                isSelected: selectedType == type,
                onTap: () => onTypeSelected(type),
              ),
            ),
            if (hasActiveFilters)
              _FilterChip(
                key: const ValueKey('activity-filter-clear'),
                label: 'Limpiar',
                isSelected: false,
                onTap: onClear,
              ),
          ],
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
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
            'Una línea de tiempo local para volver rápido a mascotas, mensajes, social y notificaciones importantes.',
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

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({required this.onClear});

  final VoidCallback onClear;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No hay actividad para esos filtros',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Probá con otra búsqueda o volvé a ver todo el feed.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton(onPressed: onClear, child: const Text('Limpiar')),
        ],
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

String _labelForType(EcosystemActivityFeedType type) {
  switch (type) {
    case EcosystemActivityFeedType.pet:
      return 'Mascotas';
    case EcosystemActivityFeedType.qr:
      return 'QR';
    case EcosystemActivityFeedType.social:
      return 'Intereses sociales';
    case EcosystemActivityFeedType.message:
      return 'Mensajes';
    case EcosystemActivityFeedType.notification:
      return 'Notificaciones';
    case EcosystemActivityFeedType.professional:
      return 'Perfil profesional';
  }
}
