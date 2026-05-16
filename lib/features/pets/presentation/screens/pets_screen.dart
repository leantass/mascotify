import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/data/location_catalog.dart';
import '../../../../shared/data/pet_catalogs.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/plan_entitlements.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../shared/widgets/pet_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../lost_pets/presentation/screens/lost_pets_screen.dart';
import 'pet_detail_screen.dart';

enum _PetsSection { myPets, lostPets }

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  _PetsSection _selectedSection = _PetsSection.myPets;

  @override
  Widget build(BuildContext context) {
    final pets = AppData.pets;
    final entitlement = planEntitlementFor(AppData.currentUser.planName);
    final showingMyPets = _selectedSection == _PetsSection.myPets;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    SectionHeader(
                      eyebrow: 'Centro de mascotas',
                      title: 'Mascotas',
                      subtitle:
                          'Gestiona perfiles persistidos localmente y reportes comunitarios de mascotas perdidas.',
                      trailing: showingMyPets
                          ? ElevatedButton.icon(
                              onPressed: _handleAddPet,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Agregar'),
                            )
                          : null,
                    ),
                    const SizedBox(height: 18),
                    _PetsSectionSelector(
                      selectedSection: _selectedSection,
                      onChanged: (section) {
                        setState(() => _selectedSection = section);
                      },
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            showingMyPets
                                ? '${pets.length} perfiles activos guardados en este dispositivo para la cuenta actual.'
                                : '${AppData.lostPets.where((item) => !item.isFound).length} reportes activos de mascotas perdidas para esta cuenta.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            showingMyPets
                                ? '${entitlement.planName}: ${entitlement.petLimitDisplayLabel}.'
                                : 'La ubicación se guarda con país, región, ciudad y zona aproximada de pérdida.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (showingMyPets)
                _MyPetsSection(
                  pets: pets,
                  onEditPet: _handleEditPet,
                  onDeletePet: _handleDeletePet,
                )
              else
                const LostPetsSection(showHero: false),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddPet() async {
    final entitlement = planEntitlementFor(AppData.currentUser.planName);
    if (!entitlement.canAddPet(AppData.pets.length)) {
      await _showPetLimitDialog(entitlement);
      return;
    }

    final createdPet = await showDialog<Pet>(
      context: context,
      builder: (_) => const _PetFormDialog(),
    );

    if (!mounted || createdPet == null) return;

    await AppData.addPet(createdPet);
    if (!mounted) return;

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${createdPet.name} ya quedó guardado localmente.'),
      ),
    );
  }

  Future<void> _showPetLimitDialog(PlanEntitlement entitlement) {
    final upgradeMessage = entitlement.shortName == 'Free'
        ? 'Mascotify Free permite hasta 1 mascota. Pasate a Plus por US\$ 1,99 mensual para cargar hasta 5 mascotas.'
        : 'Mascotify Plus permite hasta 5 mascotas. Pasate a Pro por US\$ 4,99 mensual para mascotas ilimitadas, con politica de uso razonable.';

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limite de mascotas del plan'),
        content: Text(upgradeMessage),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEditPet(Pet pet) async {
    final updatedPet = await showDialog<Pet>(
      context: context,
      builder: (_) => _PetFormDialog(initialPet: pet),
    );

    if (!mounted || updatedPet == null) return;

    await AppData.updatePet(updatedPet);
    if (!mounted) return;

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${updatedPet.name} fue actualizado.')),
    );
  }

  Future<void> _handleDeletePet(Pet pet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar mascota'),
        content: Text(
          'Vas a eliminar a ${pet.name} de esta cuenta. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    await AppData.deletePet(pet.id);
    if (!mounted) return;

    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${pet.name} fue eliminado.')));
  }
}

class _PetsSectionSelector extends StatelessWidget {
  const _PetsSectionSelector({
    required this.selectedSection,
    required this.onChanged,
  });

  final _PetsSection selectedSection;
  final ValueChanged<_PetsSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Selector de subseccion de Mascotas',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;
            final buttons = [
              _PetsSectionButton(
                label: 'Mis mascotas',
                icon: Icons.pets_rounded,
                selected: selectedSection == _PetsSection.myPets,
                onTap: () => onChanged(_PetsSection.myPets),
              ),
              _PetsSectionButton(
                label: 'Mascotas perdidas',
                icon: Icons.search_rounded,
                selected: selectedSection == _PetsSection.lostPets,
                onTap: () => onChanged(_PetsSection.lostPets),
              ),
            ];

            if (compact) {
              return Column(
                children: [
                  buttons.first,
                  const SizedBox(height: 6),
                  buttons.last,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: buttons.first),
                const SizedBox(width: 6),
                Expanded(child: buttons.last),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PetsSectionButton extends StatelessWidget {
  const _PetsSectionButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : AppColors.textPrimary;

    return Material(
      color: selected ? AppColors.primaryDeep : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: ValueKey('pets-section-$label'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foreground, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
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

class _MyPetsSection extends StatelessWidget {
  const _MyPetsSection({
    required this.pets,
    required this.onEditPet,
    required this.onDeletePet,
  });

  final List<Pet> pets;
  final ValueChanged<Pet> onEditPet;
  final ValueChanged<Pet> onDeletePet;

  @override
  Widget build(BuildContext context) {
    if (pets.isEmpty) return const _PetsEmptyState();

    return ResponsiveWrapGrid(
      minItemWidth: 340,
      children: pets
          .map(
            (pet) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PetCard(
                  pet: pet,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PetDetailScreen(pet: pet),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => onEditPet(pet),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Editar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => onDeletePet(pet),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Eliminar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _PetsEmptyState extends StatelessWidget {
  const _PetsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Todavía no hay mascotas cargadas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'En browser conviene dejar clara la base operativa desde el primer paso: cuando agregues tu primera mascota, esta vista va a crecer con identidad, QR, matching y seguimiento persistido.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PetFormDialog extends StatefulWidget {
  const _PetFormDialog({this.initialPet});

  final Pet? initialPet;

  @override
  State<_PetFormDialog> createState() => _PetFormDialogState();
}

class _PetFormDialogState extends State<_PetFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _otherBreedController;
  late final TextEditingController _ageController;
  late final TextEditingController _manualRegionController;
  late final TextEditingController _manualCityController;
  late final TextEditingController _biographyController;

  String _selectedSex = 'Macho';
  String _selectedSpecies = PetSpeciesCatalog.species.first.label;
  String _selectedBreed = PetSpeciesCatalog.mixedBreed;
  String _selectedCountry = LocationCatalog.countries.first.name;
  String? _selectedRegion;
  String? _selectedCity;
  String? _errorMessage;
  bool _isSaving = false;
  bool get _isEditing => widget.initialPet != null;
  bool get _isOtherBreed => _selectedBreed == PetSpeciesCatalog.other;
  bool get _isManualCity => _selectedCity == LocationCatalog.otherCity;

  @override
  void initState() {
    super.initState();
    final initialPet = widget.initialPet;
    _nameController = TextEditingController(text: initialPet?.name ?? '');
    _selectedSpecies = _initialSpecies(initialPet?.species);
    _selectedBreed = _initialBreed(_selectedSpecies, initialPet?.breed);
    _otherBreedController = TextEditingController(
      text: _selectedBreed == PetSpeciesCatalog.other
          ? initialPet?.breed ?? ''
          : '',
    );
    _ageController = TextEditingController(text: initialPet?.ageLabel ?? '');
    _selectedCountry = initialPet?.country.trim().isNotEmpty == true
        ? initialPet!.country
        : LocationCatalog.countries.first.name;
    final regions = LocationCatalog.regionsForCountry(_selectedCountry);
    _selectedRegion = initialPet?.region.trim().isNotEmpty == true
        ? initialPet!.region
        : (regions.isEmpty ? null : regions.first.name);
    final cities = _citiesForSelection();
    _selectedCity = initialPet?.city.trim().isNotEmpty == true
        ? initialPet!.city
        : (cities.isEmpty ? null : cities.first);
    _manualRegionController = TextEditingController(
      text: regions.isEmpty ? initialPet?.region ?? '' : '',
    );
    _manualCityController = TextEditingController(
      text: initialPet?.locationFreeText.trim().isNotEmpty == true
          ? initialPet!.locationFreeText
          : cities.isEmpty
          ? initialPet?.city ?? ''
          : '',
    );
    _biographyController = TextEditingController(
      text: initialPet?.biography ?? '',
    );
    _selectedSex = initialPet?.sex ?? 'Macho';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _otherBreedController.dispose();
    _ageController.dispose();
    _manualRegionController.dispose();
    _manualCityController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isEditing ? 'Editar mascota' : 'Alta de mascota',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _isEditing
                    ? 'Actualizá los datos principales de esta mascota sin duplicar su perfil.'
                    : 'Este formulario ya crea una mascota real en almacenamiento local para la cuenta actual.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  key: const ValueKey('pet-save-button'),
                  onPressed: _isSaving ? null : _savePet,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(_isSaving ? 'Guardando...' : 'Guardar'),
                ),
              ),
              const SizedBox(height: 18),
              _PetField(
                fieldKey: const ValueKey('pet-name-field'),
                controller: _nameController,
                label: 'Nombre',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: const ValueKey('pet-species-dropdown'),
                initialValue: _selectedSpecies,
                isExpanded: true,
                decoration: _petFieldDecoration('Tipo de animal'),
                items: PetSpeciesCatalog.species
                    .map(
                      (species) => DropdownMenuItem<String>(
                        value: species.label,
                        child: Text(species.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedSpecies = value;
                    _selectedBreed = PetSpeciesCatalog.breedOptionsForSpecies(
                      value,
                    ).first;
                    _otherBreedController.clear();
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: const ValueKey('pet-breed-dropdown'),
                initialValue: _selectedBreed,
                isExpanded: true,
                decoration: _petFieldDecoration('Raza / tipo'),
                items:
                    PetSpeciesCatalog.breedOptionsForSpecies(_selectedSpecies)
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
              if (_isOtherBreed) ...[
                const SizedBox(height: 12),
                _PetField(
                  fieldKey: const ValueKey('pet-other-breed-field'),
                  controller: _otherBreedController,
                  label: 'Raza / tipo manual',
                  hintText: 'Ej: cruza local, variedad no listada',
                ),
              ],
              const SizedBox(height: 12),
              _PetField(
                fieldKey: const ValueKey('pet-age-field'),
                controller: _ageController,
                label: 'Edad',
                hintText: 'Ej: 2',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              _LocationFields(
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
              DropdownButtonFormField<String>(
                initialValue: _selectedSex,
                isExpanded: true,
                decoration: _petFieldDecoration('Sexo'),
                items: const [
                  DropdownMenuItem(value: 'Macho', child: Text('Macho')),
                  DropdownMenuItem(value: 'Hembra', child: Text('Hembra')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedSex = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _PetField(
                fieldKey: const ValueKey('pet-biography-field'),
                controller: _biographyController,
                label: 'Descripción breve',
                maxLines: 3,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _savePet,
                      child: Text(_isSaving ? 'Guardando...' : 'Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePet() {
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
    final biography = _biographyController.text.trim();

    if (name.isEmpty ||
        species.isEmpty ||
        breed.isEmpty ||
        ageLabel.isEmpty ||
        location.isEmpty) {
      setState(() {
        _errorMessage =
            'Completá al menos nombre, tipo de animal, raza, edad y ubicación.';
      });
      return;
    }

    final age = int.tryParse(ageLabel);
    if (age == null) {
      setState(() {
        _errorMessage = 'La edad debe ser un valor numérico.';
      });
      return;
    }
    if (age < 0) {
      setState(() {
        _errorMessage = 'La edad mínima permitida es 0 años.';
      });
      return;
    }
    if (age > 20) {
      setState(() {
        _errorMessage = 'La edad máxima permitida es 20 años.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final initialPet = widget.initialPet;
    if (initialPet != null) {
      Navigator.of(context).pop(
        initialPet.copyWith(
          name: name,
          species: species,
          breed: breed,
          ageLabel: ageLabel,
          colorHex: _colorForSpecies(species),
          sex: _selectedSex,
          location: location,
          country: locationParts.country,
          region: locationParts.region,
          city: locationParts.city,
          locationFreeText: locationParts.freeText,
          biography: biography.isEmpty
              ? '$name ya tiene una base persistida y lista para seguir completándose.'
              : biography,
          personalityTags: _tagsForSpecies(species),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final shortName = name
        .replaceAll(RegExp(r'[^A-Za-z]'), '')
        .toUpperCase()
        .padRight(4, 'X')
        .substring(0, 4);
    final profileSuffix = (now.microsecondsSinceEpoch % 10000)
        .toString()
        .padLeft(4, '0');

    final pet = Pet(
      id: 'pet-${now.microsecondsSinceEpoch}',
      name: name,
      species: species,
      breed: breed,
      ageLabel: ageLabel,
      status: 'Perfil base guardado',
      colorHex: _colorForSpecies(species),
      profileId: 'MSC-$shortName-$profileSuffix',
      identitySummary:
          'Perfil base persistido localmente para empezar a centralizar identidad y evolución dentro de Mascotify.',
      documentStatus:
          'Base creada. Queda pendiente completar documentos y controles.',
      qrStatus: 'QR listo para activarse cuando decidas configurarlo.',
      healthSummary:
          'Resumen inicial creado. Luego podrás sumar más contexto de salud.',
      quickActions: const ['Ver perfil', 'Actualizar datos', 'Activar QR'],
      qrCodeLabel: 'MSC-$shortName-$profileSuffix',
      qrEnabled: false,
      qrLastUpdate: 'Creado hoy',
      qrPrimaryAction: 'Activar QR',
      qrSecondaryAction: 'Configurar placa',
      sex: _selectedSex,
      location: location,
      country: locationParts.country,
      region: locationParts.region,
      city: locationParts.city,
      locationFreeText: locationParts.freeText,
      biography: biography.isEmpty
          ? '$name ya tiene una base persistida y lista para seguir completándose.'
          : biography,
      personalityTags: _tagsForSpecies(species),
      seekingBreeding: false,
      socialInterest:
          'Perfil inicial listo para crecer hacia matching y conexiones futuras.',
      socialProfileStatus:
          'Base social creada. Todavía puede enriquecerse con más señales.',
      featuredMoments: const [
        'Primer perfil',
        'Base persistida',
        'Listo para crecer',
      ],
      matchingPreferences: const PetMatchingPreferences(
        preferredBondType: 'Vínculo gradual y seguro',
        matchSummary:
            'Base inicial creada para que después puedas ajustar mejor compatibilidades, ritmo y contexto.',
        rhythmLabel: 'A definir',
        locationRadiusLabel: 'Hasta 8 km',
        acceptsGradualMeet: true,
        compatibilitySignals: [
          'Perfil inicial persistido',
          'Listo para sumar más contexto',
          'Base preparada para matching futuro',
        ],
        desiredCompatibilities: [
          'Entornos cuidados',
          'Interacciones claras',
          'Ritmo gradual',
        ],
        softLimits: [
          'Conviene completar mejor el perfil antes de exponerlo mucho',
          'La compatibilidad todavía necesita más señales reales',
        ],
        idealContext:
            'Primero conviene completar identidad, salud y señales básicas del perfil.',
        importantNotes:
            'Es una base local real, pero todavía no representa una ficha plenamente curada.',
        suggestedApproach:
            'Completa datos esenciales y luego suma QR, social y preferencias con más criterio.',
      ),
    );

    Navigator.of(context).pop(pet);
  }

  String _initialSpecies(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PetSpeciesCatalog.species.first.label;
    }
    final normalized = value.trim().toLowerCase();
    for (final species in PetSpeciesCatalog.species) {
      if (species.label.toLowerCase() == normalized) {
        return species.label;
      }
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

  _PetLocationParts _currentLocationParts() {
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
    return _PetLocationParts(
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

  List<String> _tagsForSpecies(String species) {
    final normalized = species.trim().toLowerCase();
    if (normalized.contains('gato')) {
      return const ['Curioso', 'Observador', 'En crecimiento'];
    }
    if (normalized.contains('perro')) {
      return const ['Compañero', 'Activo', 'En crecimiento'];
    }
    return const ['Perfil base', 'En crecimiento', 'Mascotify'];
  }
}

class _PetLocationParts {
  const _PetLocationParts({
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

class _LocationFields extends StatelessWidget {
  const _LocationFields({
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
        DropdownButtonFormField<String>(
          key: const ValueKey('pet-country-dropdown'),
          initialValue: selectedCountry,
          isExpanded: true,
          decoration: _petFieldDecoration('País'),
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
        const SizedBox(height: 12),
        if (needsManualLocation)
          _PetField(
            fieldKey: const ValueKey('pet-manual-region-field'),
            controller: manualRegionController,
            label: 'Provincia / Estado / Región',
            hintText: 'Ej: Montevideo, Florida, São Paulo',
          )
        else
          DropdownButtonFormField<String>(
            key: const ValueKey('pet-region-dropdown'),
            initialValue: selectedRegion,
            isExpanded: true,
            decoration: _petFieldDecoration('Provincia / Estado / Región'),
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
        const SizedBox(height: 12),
        if (needsManualLocation)
          _PetField(
            fieldKey: const ValueKey('pet-manual-city-field'),
            controller: manualCityController,
            label: 'Ciudad / localidad',
            hintText: 'Ej: ciudad o localidad',
          )
        else
          DropdownButtonFormField<String>(
            key: const ValueKey('pet-city-dropdown'),
            initialValue: cities.contains(selectedCity)
                ? selectedCity
                : (cities.isEmpty ? null : cities.first),
            isExpanded: true,
            decoration: _petFieldDecoration('Ciudad / localidad'),
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
          _PetField(
            fieldKey: const ValueKey('pet-other-city-field'),
            controller: manualCityController,
            label: 'Localidad manual',
            hintText: 'Escribí tu ciudad o localidad',
          ),
        ],
      ],
    );
  }
}

class _PetField extends StatelessWidget {
  const _PetField({
    this.fieldKey,
    required this.controller,
    required this.label,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });

  final Key? fieldKey;
  final TextEditingController controller;
  final String label;
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
      decoration: _petFieldDecoration(label, hintText: hintText),
    );
  }
}

InputDecoration _petFieldDecoration(String label, {String? hintText}) {
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
