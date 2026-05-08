import 'package:flutter/material.dart';

import '../../../../features/pets/presentation/screens/express_interest_screen.dart';
import '../../../../features/pets/presentation/screens/pet_public_profile_screen.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/data/clips_mock_data.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/social_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import 'connections_inbox_screen.dart';
import 'professionals_screen.dart';

enum _ExploreSection { ecosystem, clips }

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
  static const _allClipCategories = 'Todos';

  _ExploreSection _selectedSection = _ExploreSection.ecosystem;
  String _selectedSpecies = _allSpecies;
  String _selectedSex = _anySex;
  String _selectedLocation = _allLocations;
  String _selectedBreeding = _anyBreeding;
  String _selectedClipCategory = _allClipCategories;
  late List<ExploreClip> _clips;

  @override
  void initState() {
    super.initState();
    _clips = AppData.exploreClips;
  }

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

    if (_selectedSection == _ExploreSection.clips) {
      return Scaffold(
        body: SafeArea(
          child: ResponsivePageBody(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                _ExploreSectionSelector(
                  selectedSection: _selectedSection,
                  onChanged: (section) =>
                      setState(() => _selectedSection = section),
                ),
                const SizedBox(height: 16),
                _ExploreClipsFeed(
                  clips: _filteredClips(),
                  categories: _clipCategoriesFor(_clips),
                  selectedCategory: _selectedClipCategory,
                  onCategoryChanged: (category) =>
                      setState(() => _selectedClipCategory = category),
                  onShowAll: () => setState(
                    () => _selectedClipCategory = _allClipCategories,
                  ),
                  onToggleLike: _toggleClipLike,
                  onToggleSave: _toggleClipSave,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _ExploreSectionSelector(
                selectedSection: _selectedSection,
                onChanged: (section) =>
                    setState(() => _selectedSection = section),
              ),
              const SizedBox(height: 16),
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

  List<ExploreClip> _filteredClips() {
    if (_selectedClipCategory == _allClipCategories) return _clips;

    return _clips
        .where((clip) => clip.category == _selectedClipCategory)
        .toList();
  }

  List<String> _clipCategoriesFor(List<ExploreClip> clips) {
    final categories = <String>{
      ...ClipsMockData.categories.where(
        (category) => category != _allClipCategories,
      ),
      ...clips.map((clip) => clip.category),
    }.toList()..sort();
    return <String>[_allClipCategories, ...categories];
  }

  void _toggleClipLike(String clipId) {
    setState(() {
      _clips = _clips.map((clip) {
        if (clip.id != clipId) return clip;
        final nextLiked = !clip.isLiked;
        return clip.copyWith(
          isLiked: nextLiked,
          likes: nextLiked ? clip.likes + 1 : clip.likes - 1,
        );
      }).toList();
    });
  }

  void _toggleClipSave(String clipId) {
    setState(() {
      _clips = _clips.map((clip) {
        if (clip.id != clipId) return clip;
        return clip.copyWith(isSaved: !clip.isSaved);
      }).toList();
    });
  }
}

class _ExploreSectionSelector extends StatelessWidget {
  const _ExploreSectionSelector({
    required this.selectedSection,
    required this.onChanged,
  });

  final _ExploreSection selectedSection;
  final ValueChanged<_ExploreSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Selector de seccion de Explorar',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: _SectionButton(
                label: 'Ecosistema',
                icon: Icons.groups_rounded,
                selected: selectedSection == _ExploreSection.ecosystem,
                onTap: () => onChanged(_ExploreSection.ecosystem),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _SectionButton(
                label: 'Clips',
                icon: Icons.play_circle_fill_rounded,
                selected: selectedSection == _ExploreSection.clips,
                onTap: () => onChanged(_ExploreSection.clips),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  const _SectionButton({
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
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

class _ExploreClipsFeed extends StatelessWidget {
  const _ExploreClipsFeed({
    required this.clips,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onShowAll,
    required this.onToggleLike,
    required this.onToggleSave,
  });

  final List<ExploreClip> clips;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onShowAll;
  final ValueChanged<String> onToggleLike;
  final ValueChanged<String> onToggleSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ClipsHero(),
        const SizedBox(height: 16),
        _ClipCategoryFilters(
          categories: categories,
          selectedCategory: selectedCategory,
          onSelected: onCategoryChanged,
        ),
        const SizedBox(height: 16),
        if (clips.isEmpty)
          _ExploreEmptyStateWithAction(
            title: 'No hay clips en esta categoria',
            description:
                'Proba volver a Todos para seguir viendo clips demo locales de animales.',
            actionLabel: 'Volver a Todos',
            onPressed: onShowAll,
          )
        else
          Column(
            children: clips
                .map(
                  (clip) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ExploreClipCard(
                      clip: clip,
                      onToggleLike: () => onToggleLike(clip.id),
                      onToggleSave: () => onToggleSave(clip.id),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _ClipsHero extends StatelessWidget {
  const _ClipsHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primarySoft, Color(0xFFEAFBFF), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
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
              'Clips demo locales',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Videos cortos de animales para descubrir, aprender y sonreir.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Feed preparado para videos propios: si todavia no hay asset de video, Mascotify muestra un placeholder seguro sin depender de internet.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ClipCategoryFilters extends StatelessWidget {
  const _ClipCategoryFilters({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) => onSelected(category),
                  selectedColor: AppColors.primarySoft,
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selectedCategory == category
                        ? AppColors.primaryDeep
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ExploreClipCard extends StatelessWidget {
  const _ExploreClipCard({
    required this.clip,
    required this.onToggleLike,
    required this.onToggleSave,
  });

  final ExploreClip clip;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleSave;

  @override
  Widget build(BuildContext context) {
    final hasVideo = clip.videoAssetPath != null;
    final thumbnail = clip.thumbnailAssetPath;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (thumbnail == null)
                  const _ClipPlaceholder()
                else
                  Image.asset(thumbnail, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.12),
                        Colors.black.withValues(alpha: 0.48),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.primaryDeep,
                      size: 42,
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 14,
                  child: _VideoBadge(label: hasVideo ? 'Video local' : 'Demo'),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _VideoBadge(label: clip.category),
                      _VideoBadge(label: clip.animalType),
                      if (clip.sourceLabel != null)
                        _VideoBadge(label: clip.sourceLabel!),
                      if (!hasVideo)
                        const _VideoBadge(label: 'Clip demo local'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clip.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  clip.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ClipActionButton(
                      icon: clip.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      label: '${clip.likes} likes',
                      selected: clip.isLiked,
                      onPressed: onToggleLike,
                    ),
                    _ClipActionButton(
                      icon: Icons.mode_comment_outlined,
                      label: '${clip.comments} comentarios',
                      selected: false,
                      onPressed: () {},
                    ),
                    _ClipActionButton(
                      icon: clip.isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      label: clip.isSaved ? 'Guardado' : 'Guardar',
                      selected: clip.isSaved,
                      onPressed: onToggleSave,
                    ),
                    _ClipActionButton(
                      icon: Icons.ios_share_rounded,
                      label: 'Compartir',
                      selected: false,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClipPlaceholder extends StatelessWidget {
  const _ClipPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accentSoft, AppColors.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Icon(Icons.pets_rounded, color: AppColors.dark, size: 42),
        ),
      ),
    );
  }
}

class _VideoBadge extends StatelessWidget {
  const _VideoBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ClipActionButton extends StatelessWidget {
  const _ClipActionButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: selected
            ? AppColors.primaryDeep
            : AppColors.textPrimary,
        backgroundColor: selected ? AppColors.primarySoft : null,
      ),
    );
  }
}

class _ExploreEmptyStateWithAction extends StatelessWidget {
  const _ExploreEmptyStateWithAction({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onPressed;

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
          const SizedBox(height: 14),
          OutlinedButton(onPressed: onPressed, child: Text(actionLabel)),
        ],
      ),
    );
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
