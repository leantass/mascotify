import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/data/location_catalog.dart';
import '../../../../shared/data/pet_catalogs.dart';
import '../../../../shared/models/lost_pet.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../profile/presentation/screens/help_screen.dart';
import '../../../profile/presentation/widgets/contextual_help_link.dart';

const _safetyError =
    'Mascotify no permite pedir dinero por una mascota perdida. Modificá el texto para continuar.';

class LostPetsScreen extends StatelessWidget {
  const LostPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: const [LostPetsSection()],
          ),
        ),
      ),
    );
  }
}

class LostPetsSection extends StatefulWidget {
  const LostPetsSection({super.key, this.showHero = true});

  final bool showHero;

  @override
  State<LostPetsSection> createState() => _LostPetsSectionState();
}

class _LostPetsSectionState extends State<LostPetsSection> {
  final TextEditingController _searchController = TextEditingController();
  String _speciesFilter = 'Todos';
  String _regionFilter = 'Todas';
  String _cityFilter = 'Todas';
  String _statusFilter = 'Todas';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm({LostPet? lostPet}) async {
    final result = await showDialog<LostPet>(
      context: context,
      builder: (_) => _LostPetFormDialog(initialLostPet: lostPet),
    );
    if (result == null) return;
    if (lostPet == null) {
      await AppData.addLostPet(result);
    } else {
      await AppData.updateLostPet(result);
    }
    if (mounted) setState(() {});
  }

  Future<void> _openDetail(LostPet lostPet) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LostPetDetailScreen(
          lostPet: lostPet,
          onChanged: () => setState(() {}),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  List<LostPet> _filteredPets() {
    final query = _searchController.text.trim().toLowerCase();
    final items = AppData.lostPets.where((lostPet) {
      if (_statusFilter == 'Perdida' && lostPet.isFound) return false;
      if (_statusFilter == 'Encontrada' && !lostPet.isFound) return false;
      if (_speciesFilter != 'Todos' && lostPet.species != _speciesFilter) {
        return false;
      }
      if (_regionFilter != 'Todas' && lostPet.region != _regionFilter) {
        return false;
      }
      final city = _displayCity(lostPet);
      if (_cityFilter != 'Todas' && city != _cityFilter) return false;
      if (query.isEmpty) return true;
      final haystack = [
        lostPet.name,
        lostPet.species,
        lostPet.breed,
        lostPet.distinctiveSigns,
        lostPet.lostZone,
        lostPet.city,
        lostPet.locationFreeText,
        lostPet.region,
        lostPet.country,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final allPets = AppData.lostPets;
    final filteredPets = _filteredPets();
    final activeCount = allPets.where((item) => !item.isFound).length;
    final foundCount = allPets.where((item) => item.isFound).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showHero) ...[
          _LostPetsHero(
            activeCount: activeCount,
            foundCount: foundCount,
            onAdd: () => _openForm(),
          ),
          const SizedBox(height: 20),
        ],
        SectionHeader(
          eyebrow: 'Catálogo solidario',
          title: 'Mascotas perdidas',
          subtitle:
              'Avisos gratuitos para ayudar a reunir mascotas con sus familias.',
          trailing: widget.showHero
              ? null
              : ElevatedButton.icon(
                  key: const ValueKey('lost-pet-add-button'),
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Reportar'),
                ),
        ),
        const SizedBox(height: 12),
        const _SafetyNotice(),
        const SizedBox(height: 16),
        _LostPetsFilters(
          searchController: _searchController,
          speciesFilter: _speciesFilter,
          regionFilter: _regionFilter,
          cityFilter: _cityFilter,
          statusFilter: _statusFilter,
          allPets: allPets,
          onChanged:
              ({
                String? species,
                String? region,
                String? city,
                String? status,
              }) {
                setState(() {
                  if (species != null) _speciesFilter = species;
                  if (region != null) {
                    _regionFilter = region;
                    _cityFilter = 'Todas';
                  }
                  if (city != null) _cityFilter = city;
                  if (status != null) _statusFilter = status;
                });
              },
          onSearchChanged: () => setState(() {}),
        ),
        const SizedBox(height: 16),
        if (allPets.isEmpty)
          _LostPetsEmptyState(onAdd: () => _openForm())
        else if (filteredPets.isEmpty)
          _FilteredEmptyState()
        else
          ResponsiveWrapGrid(
            minItemWidth: 310,
            children: filteredPets
                .map(
                  (lostPet) => _LostPetCard(
                    lostPet: lostPet,
                    onDetail: () => _openDetail(lostPet),
                    onSeen: () => _showSeenDialog(context, lostPet),
                    onContact: () => _showSafeContactDialog(context, lostPet),
                    onReport: () => _showReportDialog(context, lostPet),
                  ),
                )
                .toList(),
          ),
        if (widget.showHero) ...[
          const SizedBox(height: 16),
          const ContextualHelpLink(
            topic: HelpTopic.lostPets,
            label: 'Ver ayuda sobre Mascotas perdidas',
          ),
        ],
      ],
    );
  }
}

class LostPetDetailScreen extends StatefulWidget {
  const LostPetDetailScreen({
    super.key,
    required this.lostPet,
    required this.onChanged,
  });

  final LostPet lostPet;
  final VoidCallback onChanged;

  @override
  State<LostPetDetailScreen> createState() => _LostPetDetailScreenState();
}

class _LostPetDetailScreenState extends State<LostPetDetailScreen> {
  late LostPet _lostPet;

  @override
  void initState() {
    super.initState();
    _lostPet = AppData.findLostPetById(widget.lostPet.id) ?? widget.lostPet;
  }

  Future<void> _markFound() async {
    await AppData.markLostPetFound(_lostPet.id);
    final updated = AppData.findLostPetById(_lostPet.id);
    if (!mounted || updated == null) return;
    setState(() => _lostPet = updated);
    widget.onChanged();
  }

  Future<void> _edit() async {
    final result = await showDialog<LostPet>(
      context: context,
      builder: (_) => _LostPetFormDialog(initialLostPet: _lostPet),
    );
    if (result == null) return;
    await AppData.updateLostPet(result);
    final updated = AppData.findLostPetById(result.id) ?? result;
    if (!mounted) return;
    setState(() => _lostPet = updated);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ficha de mascota perdida')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 980,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 620;
                          final photo = _LostPetPhoto(
                            colorHex: _lostPet.colorHex,
                            large: true,
                          );
                          final summary = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _lostPet.name,
                                style: textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _StatusPill(lostPet: _lostPet),
                                  const _SafetyPill(label: 'Ayuda gratuita'),
                                  const _SafetyPill(label: 'No pagar rescates'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _lostPet.description,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          );
                          if (isCompact) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                photo,
                                const SizedBox(height: 16),
                                summary,
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              photo,
                              const SizedBox(width: 18),
                              Expanded(child: summary),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const _SafetyNotice(compact: true),
                      const SizedBox(height: 16),
                      _DetailGrid(
                        tiles: [
                          _DetailTileData(
                            Icons.pets_outlined,
                            'Tipo',
                            _lostPet.species,
                          ),
                          _DetailTileData(
                            Icons.badge_outlined,
                            'Raza / tipo',
                            _lostPet.breed,
                          ),
                          _DetailTileData(
                            Icons.cake_outlined,
                            'Edad',
                            _lostPet.ageLabel,
                          ),
                          _DetailTileData(
                            Icons.palette_outlined,
                            'Color',
                            _lostPet.distinctiveSigns,
                          ),
                          _DetailTileData(
                            Icons.info_outline_rounded,
                            'Señas particulares',
                            _lostPet.distinctiveSigns,
                          ),
                          _DetailTileData(
                            Icons.place_outlined,
                            'Ubicación',
                            _lostPet.location,
                          ),
                          _DetailTileData(
                            Icons.map_outlined,
                            'Zona aproximada',
                            _lostPet.lostZone,
                          ),
                          _DetailTileData(
                            Icons.event_outlined,
                            'Fecha de pérdida',
                            _lostPet.lostDateLabel,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _DetailTile(
                        icon: Icons.description_outlined,
                        label: 'Descripción de lo ocurrido',
                        value: _lostPet.description,
                      ),
                      _DetailTile(
                        icon: Icons.verified_user_outlined,
                        label: 'Contacto seguro',
                        value:
                            'Abrí Contacto seguro para ver recomendaciones antes de usar el dato visible.',
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Volver'),
                          ),
                          ElevatedButton.icon(
                            key: const ValueKey('lost-pet-seen-button'),
                            onPressed: () => _showSeenDialog(context, _lostPet),
                            icon: const Icon(Icons.visibility_outlined),
                            label: const Text('Creo haberla visto'),
                          ),
                          OutlinedButton.icon(
                            key: const ValueKey('lost-pet-safe-contact-button'),
                            onPressed: () =>
                                _showSafeContactDialog(context, _lostPet),
                            icon: const Icon(Icons.shield_outlined),
                            label: const Text('Contacto seguro'),
                          ),
                          OutlinedButton.icon(
                            key: const ValueKey('lost-pet-report-button'),
                            onPressed: () =>
                                _showReportDialog(context, _lostPet),
                            icon: const Icon(Icons.flag_outlined),
                            label: const Text('Reportar'),
                          ),
                          OutlinedButton.icon(
                            key: const ValueKey('lost-pet-edit-button'),
                            onPressed: _edit,
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Editar'),
                          ),
                          if (!_lostPet.isFound)
                            ElevatedButton.icon(
                              key: const ValueKey('lost-pet-found-button'),
                              onPressed: _markFound,
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('Marcar como encontrada'),
                            ),
                        ],
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
}

class _LostPetsHero extends StatelessWidget {
  const _LostPetsHero({
    required this.activeCount,
    required this.foundCount,
    required this.onAdd,
  });

  final int activeCount;
  final int foundCount;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 560;
          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mascotas perdidas',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Avisos gratuitos para ayudar a reunir mascotas con sus familias. Sin precios, sin cobros y sin comentarios públicos.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          );
          final action = ElevatedButton.icon(
            key: const ValueKey('lost-pet-add-button'),
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Reportar mascota perdida'),
          );
          final metrics = Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroMetric(label: 'Perdidas', value: '$activeCount'),
              _HeroMetric(label: 'Encontradas', value: '$foundCount'),
            ],
          );
          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text,
                const SizedBox(height: 16),
                metrics,
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: action),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: text),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [metrics, const SizedBox(height: 14), action],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB9E5CA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.volunteer_activism_outlined,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Este catálogo es solidario y gratuito. No pagues rescates ni transferencias; reportá cualquier intento de cobro.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LostPetsFilters extends StatelessWidget {
  const _LostPetsFilters({
    required this.searchController,
    required this.speciesFilter,
    required this.regionFilter,
    required this.cityFilter,
    required this.statusFilter,
    required this.allPets,
    required this.onChanged,
    required this.onSearchChanged,
  });

  final TextEditingController searchController;
  final String speciesFilter;
  final String regionFilter;
  final String cityFilter;
  final String statusFilter;
  final List<LostPet> allPets;
  final void Function({
    String? species,
    String? region,
    String? city,
    String? status,
  })
  onChanged;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final species = [
      'Todos',
      ...PetSpeciesCatalog.species.map((item) => item.label),
    ];
    final regions = [
      'Todas',
      ...{
        for (final pet in allPets)
          if (pet.region.trim().isNotEmpty) pet.region,
      },
    ];
    final cities = [
      'Todas',
      ...{
        for (final pet in allPets)
          if ((regionFilter == 'Todas' || pet.region == regionFilter) &&
              _displayCity(pet).trim().isNotEmpty)
            _displayCity(pet),
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const ValueKey('lost-pets-search-field'),
              controller: searchController,
              onChanged: (_) => onSearchChanged(),
              decoration: _lostPetFieldDecoration(
                'Buscar por nombre, zona, ciudad o seña',
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 12),
            _FormGrid(
              children: [
                _FilterDropdown(
                  key: const ValueKey('lost-pets-species-filter'),
                  label: 'Tipo de animal',
                  value: species.contains(speciesFilter)
                      ? speciesFilter
                      : 'Todos',
                  values: species,
                  onChanged: (value) => onChanged(species: value),
                ),
                _FilterDropdown(
                  key: const ValueKey('lost-pets-region-filter'),
                  label: 'Provincia / región',
                  value: regions.contains(regionFilter)
                      ? regionFilter
                      : 'Todas',
                  values: regions,
                  onChanged: (value) => onChanged(region: value),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FormGrid(
              children: [
                _FilterDropdown(
                  key: const ValueKey('lost-pets-city-filter'),
                  label: 'Ciudad / localidad',
                  value: cities.contains(cityFilter) ? cityFilter : 'Todas',
                  values: cities,
                  onChanged: (value) => onChanged(city: value),
                ),
                _FilterDropdown(
                  key: const ValueKey('lost-pets-status-filter'),
                  label: 'Estado',
                  value: statusFilter,
                  values: const ['Todas', 'Perdida', 'Encontrada'],
                  onChanged: (value) => onChanged(status: value),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Ordenado por fecha: recientes primero.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: _lostPetFieldDecoration(label),
      items: values
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _LostPetsEmptyState extends StatelessWidget {
  const _LostPetsEmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.search_off_rounded, color: AppColors.textPrimary),
            const SizedBox(height: 12),
            Text(
              'Todavía no hay mascotas perdidas reportadas en esta zona.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Podés crear un aviso gratuito para ayudar a encontrar una mascota.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              key: const ValueKey('lost-pet-empty-add-button'),
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Reportar mascota perdida'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilteredEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          'No encontramos avisos con esos filtros.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _LostPetCard extends StatelessWidget {
  const _LostPetCard({
    required this.lostPet,
    required this.onDetail,
    required this.onSeen,
    required this.onContact,
    required this.onReport,
  });

  final LostPet lostPet;
  final VoidCallback onDetail;
  final VoidCallback onSeen;
  final VoidCallback onContact;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LostPetPhoto(colorHex: lostPet.colorHex),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lostPet.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lostPet.breedSummary,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusPill(lostPet: lostPet),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _SafetyPill(label: 'Ayuda gratuita'),
                _SafetyPill(label: 'No pagar rescates'),
              ],
            ),
            const SizedBox(height: 12),
            _MiniInfo(
              icon: Icons.palette_outlined,
              text: lostPet.distinctiveSigns,
            ),
            _MiniInfo(icon: Icons.place_outlined, text: lostPet.location),
            _MiniInfo(icon: Icons.map_outlined, text: lostPet.lostZone),
            _MiniInfo(icon: Icons.event_outlined, text: lostPet.lostDateLabel),
            const SizedBox(height: 8),
            Text(
              lostPet.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  key: ValueKey('lost-pet-detail-${lostPet.id}'),
                  onPressed: onDetail,
                  child: const Text('Ver detalle'),
                ),
                OutlinedButton(
                  key: ValueKey('lost-pet-seen-${lostPet.id}'),
                  onPressed: onSeen,
                  child: const Text('Creo haberla visto'),
                ),
                OutlinedButton(
                  key: ValueKey('lost-pet-contact-${lostPet.id}'),
                  onPressed: onContact,
                  child: const Text('Contacto seguro'),
                ),
                IconButton(
                  key: ValueKey('lost-pet-report-${lostPet.id}'),
                  tooltip: 'Reportar',
                  onPressed: onReport,
                  icon: const Icon(Icons.flag_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LostPetFormDialog extends StatefulWidget {
  const _LostPetFormDialog({this.initialLostPet});

  final LostPet? initialLostPet;

  @override
  State<_LostPetFormDialog> createState() => _LostPetFormDialogState();
}

class _LostPetFormDialogState extends State<_LostPetFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _otherBreedController;
  late final TextEditingController _ageController;
  late final TextEditingController _manualRegionController;
  late final TextEditingController _manualCityController;
  late final TextEditingController _lostZoneController;
  late final TextEditingController _lostDateController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contactController;
  late final TextEditingController _colorController;
  late final TextEditingController _distinctiveSignsController;
  late final TextEditingController _privateVerificationController;

  late String _selectedSpecies;
  late String _selectedBreed;
  late String _selectedCountry;
  String? _selectedRegion;
  String? _selectedCity;
  late String _selectedSex;
  String? _errorMessage;

  bool get _isEditing => widget.initialLostPet != null;
  bool get _isOtherBreed => _selectedBreed == PetSpeciesCatalog.other;
  bool get _isManualCity => _selectedCity == LocationCatalog.otherCity;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialLostPet;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _selectedSpecies = _initialSpecies(initial?.species);
    _selectedBreed = _initialBreed(_selectedSpecies, initial?.breed);
    _otherBreedController = TextEditingController(
      text: _selectedBreed == PetSpeciesCatalog.other
          ? initial?.breed ?? ''
          : '',
    );
    _ageController = TextEditingController(text: initial?.ageLabel ?? '');
    _selectedCountry = initial?.country.trim().isNotEmpty == true
        ? initial!.country
        : LocationCatalog.countries.first.name;
    final regions = LocationCatalog.regionsForCountry(_selectedCountry);
    _selectedRegion = initial?.region.trim().isNotEmpty == true
        ? initial!.region
        : (regions.isEmpty ? null : regions.first.name);
    final cities = _citiesForSelection();
    _selectedCity = initial?.city.trim().isNotEmpty == true
        ? initial!.city
        : (cities.isEmpty ? null : cities.first);
    _manualRegionController = TextEditingController(
      text: regions.isEmpty ? initial?.region ?? '' : '',
    );
    _manualCityController = TextEditingController(
      text: initial?.locationFreeText.trim().isNotEmpty == true
          ? initial!.locationFreeText
          : cities.isEmpty
          ? initial?.city ?? ''
          : '',
    );
    _lostZoneController = TextEditingController(text: initial?.lostZone ?? '');
    _lostDateController = TextEditingController(
      text: initial?.lostDateLabel ?? '',
    );
    _descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );
    _contactController = TextEditingController(text: initial?.contact ?? '');
    _colorController = TextEditingController(text: _initialColor(initial));
    _distinctiveSignsController = TextEditingController(
      text: _initialSigns(initial),
    );
    _privateVerificationController = TextEditingController(
      text: initial?.privateVerificationNote ?? '',
    );
    _selectedSex = initial?.sex ?? 'No informado';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _otherBreedController.dispose();
    _ageController.dispose();
    _manualRegionController.dispose();
    _manualCityController.dispose();
    _lostZoneController.dispose();
    _lostDateController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _colorController.dispose();
    _distinctiveSignsController.dispose();
    _privateVerificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 760, maxHeight: size.height - 40),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing ? 'Editar aviso solidario' : 'Crear aviso solidario',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Completá una ficha clara. Este aviso es gratuito y Mascotify no permite cobrar por devolver, rescatar o informar sobre una mascota perdida.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 12),
              Text(
                'No publiques dirección exacta si no querés compartirla.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-name-field'),
                controller: _nameController,
                label: 'Nombre de la mascota',
              ),
              const SizedBox(height: 12),
              _FormGrid(
                children: [
                  DropdownButtonFormField<String>(
                    key: const ValueKey('lost-pet-species-dropdown'),
                    initialValue: _selectedSpecies,
                    isExpanded: true,
                    decoration: _lostPetFieldDecoration('Tipo de animal'),
                    items: PetSpeciesCatalog.species
                        .map(
                          (species) => DropdownMenuItem<String>(
                            value: species.label,
                            child: Text(species.label),
                          ),
                        )
                        .toList(),
                    onChanged: _handleSpeciesChanged,
                  ),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('lost-pet-breed-dropdown'),
                    initialValue: _selectedBreed,
                    isExpanded: true,
                    decoration: _lostPetFieldDecoration('Raza / tipo'),
                    items:
                        PetSpeciesCatalog.breedOptionsForSpecies(
                              _selectedSpecies,
                            )
                            .map(
                              (breed) => DropdownMenuItem<String>(
                                value: breed,
                                child: Text(breed),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedBreed = value;
                        if (!_isOtherBreed) _otherBreedController.clear();
                      });
                    },
                  ),
                ],
              ),
              if (_isOtherBreed) ...[
                const SizedBox(height: 12),
                _LostPetField(
                  fieldKey: const ValueKey('lost-pet-other-breed-field'),
                  controller: _otherBreedController,
                  label: 'Raza / tipo manual',
                ),
              ],
              const SizedBox(height: 12),
              _FormGrid(
                children: [
                  _LostPetField(
                    fieldKey: const ValueKey('lost-pet-age-field'),
                    controller: _ageController,
                    label: 'Edad',
                    hintText: 'Ej: 4',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('lost-pet-sex-dropdown'),
                    initialValue: _selectedSex,
                    isExpanded: true,
                    decoration: _lostPetFieldDecoration('Sexo'),
                    items: const [
                      DropdownMenuItem(
                        value: 'No informado',
                        child: Text('No informado'),
                      ),
                      DropdownMenuItem(value: 'Macho', child: Text('Macho')),
                      DropdownMenuItem(value: 'Hembra', child: Text('Hembra')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedSex = value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-color-field'),
                controller: _colorController,
                label: 'Color',
                hintText: 'Ej: marrón con blanco',
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-signs-field'),
                controller: _distinctiveSignsController,
                label: 'Señas particulares visibles',
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _LostPetLocationFields(
                selectedCountry: _selectedCountry,
                selectedRegion: _selectedRegion,
                selectedCity: _selectedCity,
                manualRegionController: _manualRegionController,
                manualCityController: _manualCityController,
                onCountryChanged: _handleCountryChanged,
                onRegionChanged: _handleRegionChanged,
                onCityChanged: _handleCityChanged,
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-zone-field'),
                controller: _lostZoneController,
                label: 'Zona aproximada donde se perdió',
                hintText: 'Ej: plaza, barrio, esquina o referencia',
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-date-field'),
                controller: _lostDateController,
                label: 'Fecha aproximada de pérdida',
                hintText: 'Ej: 15/05/2026 o ayer por la tarde',
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-description-field'),
                controller: _descriptionController,
                label: 'Descripción de lo ocurrido',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-contact-field'),
                controller: _contactController,
                label: 'Contacto visible',
                hintText: 'Ej: teléfono, email o instrucción de contacto',
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-private-verification-field'),
                controller: _privateVerificationController,
                label: 'Dato privado para verificar identidad de la mascota',
                hintText: 'No se muestra públicamente',
                maxLines: 2,
              ),
              const SizedBox(height: 6),
              Text(
                'No se muestra públicamente. Sirve para confirmar si alguien realmente vio o encontró a tu mascota.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 14),
                _ErrorBox(message: _errorMessage!),
              ],
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 420;
                  final cancel = OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  );
                  final save = ElevatedButton(
                    key: const ValueKey('lost-pet-save-button'),
                    onPressed: _save,
                    child: const Text('Guardar aviso'),
                  );
                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [save, const SizedBox(height: 10), cancel],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: cancel),
                      const SizedBox(width: 12),
                      Expanded(child: save),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSpeciesChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedSpecies = value;
      _selectedBreed = PetSpeciesCatalog.breedOptionsForSpecies(value).first;
      _otherBreedController.clear();
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    final species = _selectedSpecies.trim();
    final breed = _isOtherBreed
        ? _otherBreedController.text.trim()
        : _selectedBreed.trim();
    final ageLabel = _ageController.text.trim();
    final locationParts = _currentLocationParts();
    final location = LocationCatalog.display(
      country: locationParts.country,
      region: locationParts.region,
      city: locationParts.city,
      freeText: locationParts.freeText,
    );
    final color = _colorController.text.trim();
    final signs = _distinctiveSignsController.text.trim();
    final lostZone = _lostZoneController.text.trim();
    final lostDate = _lostDateController.text.trim();
    final description = _descriptionController.text.trim();
    final contact = _contactController.text.trim();
    final privateVerification = _privateVerificationController.text.trim();

    if (name.isEmpty ||
        species.isEmpty ||
        breed.isEmpty ||
        location.isEmpty ||
        lostZone.isEmpty ||
        contact.isEmpty) {
      setState(
        () => _errorMessage =
            'Completá nombre, tipo de animal, raza, ubicación, zona y contacto.',
      );
      return;
    }

    final age = int.tryParse(ageLabel);
    if (ageLabel.isNotEmpty && age == null) {
      setState(() => _errorMessage = 'La edad debe ser un valor numérico.');
      return;
    }
    if (age != null && age > 20) {
      setState(() => _errorMessage = 'La edad máxima permitida es 20 años.');
      return;
    }

    final sensitiveText = [
      lostZone,
      description,
      contact,
      signs,
      privateVerification,
    ].join(' ');
    if (_containsPaymentIntent(sensitiveText)) {
      setState(() => _errorMessage = _safetyError);
      return;
    }

    final now = DateTime.now();
    final initial = widget.initialLostPet;
    final colorAndSigns = [
      if (color.isNotEmpty) 'Color: $color',
      if (signs.isNotEmpty) signs,
    ].join(' · ');
    final lostPet = LostPet(
      id: initial?.id ?? 'lost-pet-${now.microsecondsSinceEpoch}',
      name: name,
      species: species,
      breed: breed,
      ageLabel: ageLabel,
      sex: _selectedSex,
      colorHex: _colorForSpecies(species),
      country: locationParts.country,
      region: locationParts.region,
      city: locationParts.city,
      locationFreeText: locationParts.freeText,
      location: location,
      lostZone: lostZone,
      lostDateLabel: lostDate.isEmpty ? 'Sin fecha exacta' : lostDate,
      description: description.isEmpty
          ? 'Aviso solidario creado para ayudar a encontrar a $name.'
          : description,
      contact: contact,
      distinctiveSigns: colorAndSigns.isEmpty
          ? 'Sin señas informadas'
          : colorAndSigns,
      isFound: initial?.isFound ?? false,
      createdAt: initial?.createdAt ?? now,
      photoLabel: initial?.photoLabel ?? '',
      privateVerificationNote: privateVerification,
    );

    Navigator.of(context).pop(lostPet);
  }

  String _initialSpecies(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PetSpeciesCatalog.species.first.label;
    }
    final normalized = value.trim().toLowerCase();
    for (final species in PetSpeciesCatalog.species) {
      if (species.label.toLowerCase() == normalized) return species.label;
    }
    return PetSpeciesCatalog.species.last.label;
  }

  String _initialBreed(String species, String? breed) {
    final options = PetSpeciesCatalog.breedOptionsForSpecies(species);
    if (breed == null || breed.trim().isEmpty) return options.first;
    for (final option in options) {
      if (option.toLowerCase() == breed.trim().toLowerCase()) return option;
    }
    return PetSpeciesCatalog.other;
  }

  String _initialColor(LostPet? initial) {
    final signs = initial?.distinctiveSigns ?? '';
    if (signs.startsWith('Color: ')) {
      final value = signs.substring(7).split(' · ').first.trim();
      return value;
    }
    return '';
  }

  String _initialSigns(LostPet? initial) {
    final signs = initial?.distinctiveSigns ?? '';
    if (signs.startsWith('Color: ') && signs.contains(' · ')) {
      return signs.split(' · ').skip(1).join(' · ');
    }
    return signs;
  }

  List<String> _citiesForSelection() {
    final regions = LocationCatalog.regionsForCountry(_selectedCountry);
    if (regions.isEmpty || _selectedRegion == null) return const <String>[];
    for (final region in regions) {
      if (region.name == _selectedRegion) return region.cities;
    }
    return const <String>[];
  }

  void _handleCountryChanged(String country) {
    final regions = LocationCatalog.regionsForCountry(country);
    setState(() {
      _selectedCountry = country;
      _selectedRegion = regions.isEmpty ? null : regions.first.name;
      final cities = _citiesForSelection();
      _selectedCity = cities.isEmpty ? null : cities.first;
      _manualRegionController.clear();
      _manualCityController.clear();
    });
  }

  void _handleRegionChanged(String region) {
    setState(() {
      _selectedRegion = region;
      final cities = _citiesForSelection();
      _selectedCity = cities.isEmpty ? null : cities.first;
      _manualCityController.clear();
    });
  }

  void _handleCityChanged(String city) {
    setState(() {
      _selectedCity = city;
      if (!_isManualCity) _manualCityController.clear();
    });
  }

  _LocationParts _currentLocationParts() {
    final hasRegions = LocationCatalog.regionsForCountry(
      _selectedCountry,
    ).isNotEmpty;
    final region = hasRegions
        ? _selectedRegion?.trim() ?? ''
        : _manualRegionController.text.trim();
    final city = hasRegions && !_isManualCity
        ? _selectedCity?.trim() ?? ''
        : '';
    final freeText = hasRegions && !_isManualCity
        ? ''
        : _manualCityController.text.trim();
    return _LocationParts(
      country: _selectedCountry,
      region: region,
      city: city,
      freeText: freeText,
    );
  }

  int _colorForSpecies(String species) {
    final normalized = species.trim().toLowerCase();
    if (normalized.contains('gato')) return 0xFFFFE1EA;
    if (normalized.contains('perro')) return 0xFFDDF6F6;
    return 0xFFFFF2C6;
  }
}

class _LostPetLocationFields extends StatelessWidget {
  const _LostPetLocationFields({
    required this.selectedCountry,
    required this.selectedRegion,
    required this.selectedCity,
    required this.manualRegionController,
    required this.manualCityController,
    required this.onCountryChanged,
    required this.onRegionChanged,
    required this.onCityChanged,
  });

  final String selectedCountry;
  final String? selectedRegion;
  final String? selectedCity;
  final TextEditingController manualRegionController;
  final TextEditingController manualCityController;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onRegionChanged;
  final ValueChanged<String> onCityChanged;

  @override
  Widget build(BuildContext context) {
    final regions = LocationCatalog.regionsForCountry(selectedCountry);
    LocationRegion? selectedRegionData;
    for (final region in regions) {
      if (region.name == selectedRegion) selectedRegionData = region;
    }
    final cities = selectedRegionData?.cities ?? const <String>[];
    final needsManualLocation = regions.isEmpty;
    final needsManualCity = selectedCity == LocationCatalog.otherCity;

    return Column(
      children: [
        _FormGrid(
          children: [
            DropdownButtonFormField<String>(
              key: const ValueKey('lost-pet-country-dropdown'),
              initialValue: selectedCountry,
              isExpanded: true,
              decoration: _lostPetFieldDecoration('País'),
              items: LocationCatalog.countries
                  .map(
                    (country) => DropdownMenuItem<String>(
                      value: country.name,
                      child: Text(country.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onCountryChanged(value);
              },
            ),
            if (needsManualLocation)
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-manual-region-field'),
                controller: manualRegionController,
                label: 'Provincia / Estado / Región',
              )
            else
              DropdownButtonFormField<String>(
                key: const ValueKey('lost-pet-region-dropdown'),
                initialValue: selectedRegion,
                isExpanded: true,
                decoration: _lostPetFieldDecoration(
                  'Provincia / Estado / Región',
                ),
                items: regions
                    .map(
                      (region) => DropdownMenuItem<String>(
                        value: region.name,
                        child: Text(region.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) onRegionChanged(value);
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (needsManualLocation)
          _LostPetField(
            fieldKey: const ValueKey('lost-pet-manual-city-field'),
            controller: manualCityController,
            label: 'Ciudad / localidad',
          )
        else
          DropdownButtonFormField<String>(
            key: const ValueKey('lost-pet-city-dropdown'),
            initialValue: cities.contains(selectedCity)
                ? selectedCity
                : (cities.isEmpty ? null : cities.first),
            isExpanded: true,
            decoration: _lostPetFieldDecoration('Ciudad / localidad'),
            items: cities
                .map(
                  (city) =>
                      DropdownMenuItem<String>(value: city, child: Text(city)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onCityChanged(value);
            },
          ),
        if (needsManualCity) ...[
          const SizedBox(height: 12),
          _LostPetField(
            fieldKey: const ValueKey('lost-pet-other-city-field'),
            controller: manualCityController,
            label: 'Localidad manual',
          ),
        ],
      ],
    );
  }
}

Future<void> _showSeenDialog(BuildContext context, LostPet lostPet) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _SeenDialog(lostPet: lostPet),
  );
}

Future<void> _showSafeContactDialog(
  BuildContext context,
  LostPet lostPet,
) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _SafeContactDialog(lostPet: lostPet),
  );
}

Future<void> _showReportDialog(BuildContext context, LostPet lostPet) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _ReportDialog(lostPet: lostPet),
  );
}

class _SeenDialog extends StatefulWidget {
  const _SeenDialog({required this.lostPet});

  final LostPet lostPet;

  @override
  State<_SeenDialog> createState() => _SeenDialogState();
}

class _SeenDialogState extends State<_SeenDialog> {
  final _whereController = TextEditingController();
  final _whenController = TextEditingController();
  final _commentController = TextEditingController();
  final _contactController = TextEditingController();
  String? _error;
  bool _sent = false;

  @override
  void dispose() {
    _whereController.dispose();
    _whenController.dispose();
    _commentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) {
      return _SimpleDialogShell(
        title: 'Información cargada',
        children: [
          const Text(
            'Gracias. Avisamos a la familia con la información cargada.',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
    }
    return _SimpleDialogShell(
      title: 'Creo haberla visto: ${widget.lostPet.name}',
      children: [
        const _SafetyNotice(compact: true),
        const SizedBox(height: 12),
        _LostPetField(
          fieldKey: const ValueKey('seen-where-field'),
          controller: _whereController,
          label: 'Dónde la viste',
        ),
        const SizedBox(height: 12),
        _LostPetField(
          fieldKey: const ValueKey('seen-when-field'),
          controller: _whenController,
          label: 'Cuándo la viste',
        ),
        const SizedBox(height: 12),
        _LostPetField(
          fieldKey: const ValueKey('seen-comment-field'),
          controller: _commentController,
          label: 'Comentario opcional',
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        _LostPetField(
          fieldKey: const ValueKey('seen-contact-field'),
          controller: _contactController,
          label: 'Contacto opcional',
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _ErrorBox(message: _error!),
        ],
        const SizedBox(height: 16),
        ElevatedButton(
          key: const ValueKey('seen-submit-button'),
          onPressed: () {
            final text = [
              _whereController.text,
              _whenController.text,
              _commentController.text,
              _contactController.text,
            ].join(' ');
            if (_whereController.text.trim().isEmpty ||
                _whenController.text.trim().isEmpty) {
              setState(() => _error = 'Completá dónde y cuándo la viste.');
              return;
            }
            if (_containsPaymentIntent(text)) {
              setState(() => _error = _safetyError);
              return;
            }
            setState(() => _sent = true);
          },
          child: const Text('Enviar aviso local'),
        ),
      ],
    );
  }
}

class _SafeContactDialog extends StatefulWidget {
  const _SafeContactDialog({required this.lostPet});

  final LostPet lostPet;

  @override
  State<_SafeContactDialog> createState() => _SafeContactDialogState();
}

class _SafeContactDialogState extends State<_SafeContactDialog> {
  bool _showContact = false;

  @override
  Widget build(BuildContext context) {
    return _SimpleDialogShell(
      title: 'Contacto seguro',
      children: [
        const _SafetyBullet(text: 'No pagues rescates ni transferencias.'),
        const _SafetyBullet(text: 'Verificá señas de la mascota.'),
        const _SafetyBullet(text: 'Encontrate en un lugar público.'),
        const _SafetyBullet(text: 'Andá acompañado si podés.'),
        const _SafetyBullet(text: 'Reportá cualquier intento de cobro.'),
        const SizedBox(height: 14),
        if (_showContact)
          _DetailTile(
            icon: Icons.call_outlined,
            label: 'Contacto visible',
            value: widget.lostPet.contact,
          )
        else
          ElevatedButton(
            key: const ValueKey('show-safe-contact-button'),
            onPressed: () => setState(() => _showContact = true),
            child: const Text('Entiendo, mostrar contacto'),
          ),
      ],
    );
  }
}

class _ReportDialog extends StatefulWidget {
  const _ReportDialog({required this.lostPet});

  final LostPet lostPet;

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  String _reason = 'Me pidió dinero';
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    if (_sent) {
      return _SimpleDialogShell(
        title: 'Reporte recibido',
        children: [
          const Text('Gracias. Revisaremos este reporte.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
    }
    return _SimpleDialogShell(
      title: 'Reportar aviso de ${widget.lostPet.name}',
      children: [
        DropdownButtonFormField<String>(
          key: const ValueKey('report-reason-dropdown'),
          initialValue: _reason,
          isExpanded: true,
          decoration: _lostPetFieldDecoration('Motivo'),
          items: const [
            DropdownMenuItem(
              value: 'Me pidió dinero',
              child: Text('Me pidió dinero'),
            ),
            DropdownMenuItem(
              value: 'Sospecha de estafa',
              child: Text('Sospecha de estafa'),
            ),
            DropdownMenuItem(
              value: 'Información falsa',
              child: Text('Información falsa'),
            ),
            DropdownMenuItem(
              value: 'Contenido ofensivo',
              child: Text('Contenido ofensivo'),
            ),
            DropdownMenuItem(
              value: 'Mascota duplicada',
              child: Text('Mascota duplicada'),
            ),
            DropdownMenuItem(value: 'Otro', child: Text('Otro')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _reason = value);
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          key: const ValueKey('report-submit-button'),
          onPressed: () => setState(() => _sent = true),
          child: const Text('Enviar reporte'),
        ),
      ],
    );
  }
}

class _SimpleDialogShell extends StatelessWidget {
  const _SimpleDialogShell({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 520, maxHeight: size.height - 40),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _FormGrid extends StatelessWidget {
  const _FormGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 560) {
          return Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                if (index > 0) const SizedBox(height: 12),
                children[index],
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(width: 12),
              Expanded(child: children[index]),
            ],
          ],
        );
      },
    );
  }
}

class _LostPetField extends StatelessWidget {
  const _LostPetField({
    required this.controller,
    required this.label,
    this.fieldKey,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final Key? fieldKey;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: fieldKey,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: _lostPetFieldDecoration(label, hintText: hintText),
    );
  }
}

class _LocationParts {
  const _LocationParts({
    required this.country,
    required this.region,
    required this.city,
    required this.freeText,
  });

  final String country;
  final String region;
  final String city;
  final String freeText;
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _LostPetPhoto extends StatelessWidget {
  const _LostPetPhoto({required this.colorHex, this.large = false});

  final int colorHex;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 150.0 : 70.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(colorHex),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        Icons.pets_rounded,
        size: large ? 54 : 30,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.lostPet});

  final LostPet lostPet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: lostPet.isFound ? AppColors.primarySoft : AppColors.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        lostPet.statusLabel,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SafetyPill extends StatelessWidget {
  const _SafetyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailGrid extends StatelessWidget {
  const _DetailGrid({required this.tiles});

  final List<_DetailTileData> tiles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 640;
        if (isCompact) {
          return Column(
            children: tiles
                .map(
                  (tile) => _DetailTile(
                    icon: tile.icon,
                    label: tile.label,
                    value: tile.value,
                  ),
                )
                .toList(),
          );
        }
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tiles
              .map(
                (tile) => SizedBox(
                  width: (constraints.maxWidth - 10) / 2,
                  child: _DetailTile(
                    icon: tile.icon,
                    label: tile.label,
                    value: tile.value,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _DetailTileData {
  const _DetailTileData(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.trim().isEmpty ? 'Sin dato informado' : value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyBullet extends StatelessWidget {
  const _SafetyBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

InputDecoration _lostPetFieldDecoration(
  String label, {
  String? hintText,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hintText,
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: AppColors.surfaceAlt,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
  );
}

String _displayCity(LostPet lostPet) {
  if (lostPet.city.trim().isNotEmpty) return lostPet.city.trim();
  return lostPet.locationFreeText.trim();
}

bool _containsPaymentIntent(String text) {
  final normalized = text.toLowerCase();
  const blocked = [
    'cobro',
    'cobrar',
    'pagame',
    'pago',
    'plata',
    'rescate',
    'recompensa obligatoria',
    'transferencia',
    'alias',
    'cbu',
    'mercado pago',
    'depósito',
    'deposito',
  ];
  return blocked.any(normalized.contains);
}
