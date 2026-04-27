import 'package:flutter/material.dart';

import '../../../../features/pets/presentation/screens/express_interest_screen.dart';
import '../../../../features/pets/presentation/screens/pet_public_profile_screen.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/social_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import 'connections_inbox_screen.dart';
import 'professionals_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const _allSpecies = 'Todas';
  static const _anySex = 'Cualquiera';
  static const _allLocations = 'Todas';
  static const _anyBreeding = 'Indistinto';

  String _selectedSpecies = _allSpecies;
  String _selectedSex = _anySex;
  String _selectedLocation = _allLocations;
  String _selectedBreeding = _anyBreeding;

  @override
  Widget build(BuildContext context) {
    final pets = AppData.pets;
    final filteredPets = pets.where(_matchesFilters).toList();
    final locationOptions = _locationOptionsFor(pets);
    final savedProfiles = AppData.savedProfiles;
    final inboxItems = AppData.socialInboxEntries;
    final sentCount = inboxItems
        .where((item) => item.direction == 'Enviado')
        .length;
    final receivedCount = inboxItems
        .where((item) => item.direction == 'Recibido')
        .length;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              const _ExploreHero(),
              const SizedBox(height: 16),
              ResponsiveWrapGrid(
                minItemWidth: 340,
                children: [
                  _ConnectionsEntryCard(
                    sentCount: sentCount,
                    receivedCount: receivedCount,
                    onOpenInbox: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ConnectionsInboxScreen(),
                      ),
                    ),
                  ),
                  _ProfessionalsEntryCard(
                    onOpenProfessionals: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProfessionalsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ExploreFilters(
                selectedSpecies: _selectedSpecies,
                selectedSex: _selectedSex,
                selectedLocation: _selectedLocation,
                selectedBreeding: _selectedBreeding,
                locationOptions: locationOptions,
                onSpeciesChanged: (value) =>
                    setState(() => _selectedSpecies = value),
                onSexChanged: (value) => setState(() => _selectedSex = value),
                onLocationChanged: (value) =>
                    setState(() => _selectedLocation = value),
                onBreedingChanged: (value) =>
                    setState(() => _selectedBreeding = value),
              ),
              const SizedBox(height: 20),
              Text(
                'Mascotas sugeridas',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Perfiles con potencial de conexión, afinidad social y futuras oportunidades de matching.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (pets.isEmpty)
                const _ExploreEmptyState(
                  title: 'Todavía no hay perfiles para explorar',
                  description:
                      'Cuando la cuenta tenga mascotas persistidas, esta vista podrá mostrar afinidades, guardados e intereses con más contexto.',
                )
              else if (filteredPets.isEmpty)
                const _ExploreEmptyState(
                  title: 'No hay perfiles con esos filtros',
                  description:
                      'Probá ajustar especie, sexo, ubicación o búsqueda de cría para ampliar los resultados.',
                )
              else
                ResponsiveWrapGrid(
                  minItemWidth: 360,
                  spacing: 14,
                  runSpacing: 14,
                  children: filteredPets
                      .map((pet) => _ExplorePetCard(pet: pet))
                      .toList(),
                ),
              const SizedBox(height: 10),
              Text(
                'Perfiles guardados',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Una base persistida para volver a perfiles que te interesaron y seguir descubriendo con más calma.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.surfaceAlt, AppColors.primarySoft],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discovery progresivo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mascotify también puede acompañar un descubrimiento más pausado: guardar, revisar después y retomar conexiones cuando el momento sea el indicado.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (savedProfiles.isEmpty)
                const _ExploreEmptyState(
                  title: 'Todavía no guardaste perfiles',
                  description:
                      'Cuando marques una mascota para revisar después, va a quedar persistida acá dentro de tu cuenta.',
                )
              else
                ResponsiveWrapGrid(
                  minItemWidth: 360,
                  children: savedProfiles
                      .map((entry) => _SavedProfileCard(entry: entry))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _matchesFilters(Pet pet) {
    return _matchesSpecies(pet) &&
        _matchesSex(pet) &&
        _matchesLocation(pet) &&
        _matchesBreeding(pet);
  }

  bool _matchesSpecies(Pet pet) {
    if (_selectedSpecies == _allSpecies) return true;

    final normalized = _normalize(pet.species);
    return switch (_selectedSpecies) {
      'Perro' => normalized.contains('perro'),
      'Gato' => normalized.contains('gato') || normalized.contains('gata'),
      'Otros' =>
        !normalized.contains('perro') &&
            !normalized.contains('gato') &&
            !normalized.contains('gata'),
      _ => true,
    };
  }

  bool _matchesSex(Pet pet) {
    if (_selectedSex == _anySex) return true;
    return _normalize(pet.sex) == _normalize(_selectedSex);
  }

  bool _matchesLocation(Pet pet) {
    if (_selectedLocation == _allLocations) return true;
    return _normalize(pet.location).contains(_normalize(_selectedLocation));
  }

  bool _matchesBreeding(Pet pet) {
    return switch (_selectedBreeding) {
      'Sólo crías' => pet.seekingBreeding,
      'Sólo adultos' => !pet.seekingBreeding,
      _ => true,
    };
  }

  List<String> _locationOptionsFor(List<Pet> pets) {
    final locations = <String>{
      _allLocations,
      'Buenos Aires',
      'CABA',
      'Córdoba',
      ...pets.map((pet) => _locationOptionFrom(pet.location)),
    };

    return [
      _allLocations,
      ...locations.where((location) => location != _allLocations).toList()
        ..sort(),
    ];
  }

  String _locationOptionFrom(String location) {
    final parts = location.split(',');
    return parts.length > 1 ? parts.last.trim() : location.trim();
  }

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }
}

class _ExploreHero extends StatelessWidget {
  const _ExploreHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentSoft, AppColors.surface, Color(0xFFEAFBFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Color(0xFFCFEFF5)),
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
              'Ecosistema social',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Descubrí mascotas compatibles dentro del ecosistema Mascotify.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Explorar es la base donde identidad digital, afinidad social, comunidad experta y futuras conexiones se unen para generar descubrimiento real.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _HeroPill(label: 'Matching futuro'),
              _HeroPill(label: 'Perfiles visibles'),
              _HeroPill(label: 'Conexiones seguras'),
              _HeroPill(label: 'Voces expertas'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConnectionsEntryCard extends StatelessWidget {
  const _ConnectionsEntryCard({
    required this.sentCount,
    required this.receivedCount,
    required this.onOpenInbox,
  });

  final int sentCount;
  final int receivedCount;
  final VoidCallback onOpenInbox;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.forum_rounded,
                    color: AppColors.accentDeep,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bandeja social',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Revisa intereses enviados, recibidos y posibles afinidades dentro del ecosistema.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MiniMetric(
                    label: 'Recibidos',
                    value: '$receivedCount activos',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniMetric(
                    label: 'Enviados',
                    value: '$sentCount activos',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onOpenInbox,
                child: const Text('Abrir bandeja social'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfessionalsEntryCard extends StatelessWidget {
  const _ProfessionalsEntryCard({required this.onOpenProfessionals});

  final VoidCallback onOpenProfessionals;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.supportSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_outlined,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profesionales y contenido',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Accede a especialistas, charlas y piezas breves que amplían el ecosistema Mascotify.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: _MiniMetric(
                    label: 'Profesionales',
                    value: '3 destacados',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MiniMetric(
                    label: 'Contenidos',
                    value: 'Charlas breves',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onOpenProfessionals,
                child: const Text('Explorar profesionales'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreFilters extends StatelessWidget {
  const _ExploreFilters({
    required this.selectedSpecies,
    required this.selectedSex,
    required this.selectedLocation,
    required this.selectedBreeding,
    required this.locationOptions,
    required this.onSpeciesChanged,
    required this.onSexChanged,
    required this.onLocationChanged,
    required this.onBreedingChanged,
  });

  final String selectedSpecies;
  final String selectedSex;
  final String selectedLocation;
  final String selectedBreeding;
  final List<String> locationOptions;
  final ValueChanged<String> onSpeciesChanged;
  final ValueChanged<String> onSexChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onBreedingChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filtros', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Controles base para refinar descubrimiento social y compatibilidad.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ResponsiveWrapGrid(
              minItemWidth: 210,
              spacing: 12,
              runSpacing: 12,
              children: [
                _FilterDropdown(
                  label: 'Especie',
                  value: selectedSpecies,
                  options: const ['Todas', 'Perro', 'Gato', 'Otros'],
                  onChanged: onSpeciesChanged,
                ),
                _FilterDropdown(
                  label: 'Sexo',
                  value: selectedSex,
                  options: const ['Cualquiera', 'Macho', 'Hembra'],
                  onChanged: onSexChanged,
                ),
                _FilterDropdown(
                  label: 'Ubicación',
                  value: selectedLocation,
                  options: locationOptions,
                  onChanged: onLocationChanged,
                ),
                _FilterDropdown(
                  label: 'Busca cría',
                  value: selectedBreeding,
                  options: const ['Indistinto', 'Sólo crías', 'Sólo adultos'],
                  onChanged: onBreedingChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      items: options
          .map(
            (option) =>
                DropdownMenuItem<String>(value: option, child: Text(option)),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class _ExplorePetCard extends StatelessWidget {
  const _ExplorePetCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final currentPet = AppData.findPetById(pet.id) ?? pet;
    final isSaved = AppData.savedProfiles.any(
      (entry) => entry.pet.id == currentPet.id,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(currentPet.colorHex),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.pets_rounded,
                    color: AppColors.dark,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentPet.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              currentPet.sex,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.primaryDeep,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${currentPet.species} • ${currentPet.breed}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentPet.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              currentPet.biography,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                currentPet.socialInterest,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                currentPet.matchingPreferences.matchSummary,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentPet.personalityTags
                  .map((tag) => _TagChip(label: tag))
                  .toList(),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentPet.matchingPreferences.compatibilitySignals
                  .take(3)
                  .map((item) => _AffinityChip(label: item))
                  .toList(),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetaTile(
                    label: 'Ritmo',
                    value: currentPet.matchingPreferences.rhythmLabel,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetaTile(
                    label: 'Afinidad',
                    value: currentPet.matchingPreferences.preferredBondType,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.supportSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                currentPet.matchingPreferences.suggestedApproach,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ExpressInterestScreen(pet: currentPet),
                      ),
                    ),
                    child: const Text('Me interesa'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PetPublicProfileScreen(pet: currentPet),
                      ),
                    ),
                    child: const Text('Ver perfil'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await AppData.saveProfile(currentPet.id);
                      if (!context.mounted) return;
                      await _showSavedProfileDialog(context, currentPet);
                    },
                    child: Text(isSaved ? 'Guardado' : 'Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedProfileCard extends StatelessWidget {
  const _SavedProfileCard({required this.entry});

  final SavedProfileEntry entry;

  @override
  Widget build(BuildContext context) {
    final pet = AppData.findPetById(entry.pet.id) ?? entry.pet;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(pet.colorHex),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.bookmark_added_rounded,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.supportSoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Guardado',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pet.species} • ${pet.breed}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pet.location,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${entry.reason} ${entry.savedAtLabel}.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      pet.matchingPreferences.matchSummary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pet.personalityTags
                        .take(2)
                        .map((tag) => _SavedTag(label: tag))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PetPublicProfileScreen(pet: pet),
                        ),
                      ),
                      child: const Text('Ver perfil'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
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

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
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

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.accentDeep,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AffinityChip extends StatelessWidget {
  const _AffinityChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SavedTag extends StatelessWidget {
  const _SavedTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
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
          Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showSavedProfileDialog(BuildContext context, Pet pet) async {
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
                  Icons.bookmark_added_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Perfil guardado',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Guardaste a ${pet.name} para volver más tarde, comparar afinidades y retomar esta conexión cuando tenga sentido.',
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
                  'Este guardado ya queda persistido dentro de tu cuenta y refuerza una lógica de discovery progresivo más real dentro de Mascotify.',
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

class _ExploreEmptyState extends StatelessWidget {
  const _ExploreEmptyState({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            description,
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
