import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/data/location_catalog.dart';
import '../../../../shared/data/pet_catalogs.dart';
import '../../../../shared/models/lost_pet.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';

class LostPetsScreen extends StatefulWidget {
  const LostPetsScreen({super.key});

  @override
  State<LostPetsScreen> createState() => _LostPetsScreenState();
}

class _LostPetsScreenState extends State<LostPetsScreen> {
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

  @override
  Widget build(BuildContext context) {
    final lostPets = AppData.lostPets;
    final activeCount = lostPets.where((item) => !item.isFound).length;
    final foundCount = lostPets.where((item) => item.isFound).length;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _LostPetsHero(
                activeCount: activeCount,
                foundCount: foundCount,
                onAdd: () => _openForm(),
              ),
              const SizedBox(height: 20),
              const SectionHeader(
                eyebrow: 'Comunidad',
                title: 'Mascotas perdidas',
                subtitle:
                    'Reportes locales para ayudar a ubicar animales y ordenar la información de contacto.',
              ),
              const SizedBox(height: 16),
              if (lostPets.isEmpty)
                _LostPetsEmptyState(onAdd: () => _openForm())
              else
                ResponsiveWrapGrid(
                  minItemWidth: 300,
                  children: lostPets
                      .map(
                        (lostPet) => _LostPetCard(
                          lostPet: lostPet,
                          onTap: () => _openDetail(lostPet),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('lost-pet-add-fab'),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Reportar'),
      ),
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
      appBar: AppBar(title: const Text('Detalle de mascota perdida')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 900,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Color(_lostPet.colorHex),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.pets_rounded,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _lostPet.name,
                                  style: textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _StatusPill(lostPet: _lostPet),
                                    _SoftPill(label: _lostPet.breedSummary),
                                    _SoftPill(label: _lostPet.sex),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _DetailTile(
                        icon: Icons.place_outlined,
                        label: 'Ubicación',
                        value: _lostPet.readableLocation,
                      ),
                      _DetailTile(
                        icon: Icons.map_outlined,
                        label: 'Zona donde se perdió',
                        value: _lostPet.lostZone,
                      ),
                      _DetailTile(
                        icon: Icons.event_outlined,
                        label: 'Fecha aproximada',
                        value: _lostPet.lostDateLabel,
                      ),
                      _DetailTile(
                        icon: Icons.info_outline_rounded,
                        label: 'Señas particulares',
                        value: _lostPet.distinctiveSigns,
                      ),
                      _DetailTile(
                        icon: Icons.description_outlined,
                        label: 'Descripción',
                        value: _lostPet.description,
                      ),
                      _DetailTile(
                        icon: Icons.call_outlined,
                        label: 'Contacto visible',
                        value: _lostPet.contact,
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Volver'),
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
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 520;
          final metrics = Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroMetric(label: 'Perdidas', value: '$activeCount'),
              _HeroMetric(label: 'Encontradas', value: '$foundCount'),
            ],
          );
          final action = ElevatedButton.icon(
            key: const ValueKey('lost-pet-add-button'),
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Agregar mascota perdida'),
          );

          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mascotas perdidas',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Creá reportes locales con ubicación, zona, fecha y contacto para que testers puedan probar el flujo comunitario completo.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              'Todavía no hay mascotas perdidas reportadas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando cargues el primer reporte, va a aparecer en este listado con acceso a detalle, edición y estado.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
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

class _LostPetCard extends StatelessWidget {
  const _LostPetCard({required this.lostPet, required this.onTap});

  final LostPet lostPet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        key: ValueKey('lost-pet-card-${lostPet.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(18),
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
                      color: Color(lostPet.colorHex),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.pets_rounded),
                  ),
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
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  _StatusPill(lostPet: lostPet),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                lostPet.readableLocation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: onTap,
                  child: const Text('Ver detalle'),
                ),
              ),
            ],
          ),
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
  late final TextEditingController _distinctiveSignsController;

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
      text: initial?.lostDateLabel ?? 'Hoy',
    );
    _descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );
    _contactController = TextEditingController(text: initial?.contact ?? '');
    _distinctiveSignsController = TextEditingController(
      text: initial?.distinctiveSigns ?? '',
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
    _distinctiveSignsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 720, maxHeight: size.height - 40),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing
                    ? 'Editar mascota perdida'
                    : 'Agregar mascota perdida',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Cargá datos claros de identificación, ubicación y contacto visible para que el reporte sea útil.',
                style: Theme.of(context).textTheme.bodyMedium,
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
                label: 'Zona donde se perdió',
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
                fieldKey: const ValueKey('lost-pet-signs-field'),
                controller: _distinctiveSignsController,
                label: 'Color / señas particulares',
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-description-field'),
                controller: _descriptionController,
                label: 'Descripción',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _LostPetField(
                fieldKey: const ValueKey('lost-pet-contact-field'),
                controller: _contactController,
                label: 'Contacto visible',
                hintText: 'Ej: teléfono, email o instrucción de contacto',
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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
                    child: const Text('Guardar reporte'),
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
    final lostZone = _lostZoneController.text.trim();
    final lostDate = _lostDateController.text.trim();
    final description = _descriptionController.text.trim();
    final contact = _contactController.text.trim();
    final signs = _distinctiveSignsController.text.trim();

    if (name.isEmpty ||
        species.isEmpty ||
        breed.isEmpty ||
        location.isEmpty ||
        lostZone.isEmpty ||
        contact.isEmpty) {
      setState(() {
        _errorMessage =
            'Completá nombre, tipo de animal, raza, ubicación, zona y contacto.';
      });
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

    final now = DateTime.now();
    final initial = widget.initialLostPet;
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
          ? 'Reporte local creado para ayudar a encontrar a $name.'
          : description,
      contact: contact,
      distinctiveSigns: signs.isEmpty ? 'Sin señas informadas' : signs,
      isFound: initial?.isFound ?? false,
      createdAt: initial?.createdAt ?? now,
      photoLabel: initial?.photoLabel ?? '',
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

class _SoftPill extends StatelessWidget {
  const _SoftPill({required this.label});

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

InputDecoration _lostPetFieldDecoration(String label, {String? hintText}) {
  return InputDecoration(
    labelText: label,
    hintText: hintText,
    filled: true,
    fillColor: AppColors.surfaceAlt,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
  );
}
