import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/widgets/paw_loading_indicator.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import '../../data/pet_matching_models.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final PetMatchingService _service = const PetMatchingService();
  Pet? _selectedPet;
  PetMatchingGoal _goal = PetMatchingGoal.walk;
  bool _isSearching = false;
  List<PetMatchScore> _matches = const <PetMatchScore>[];

  @override
  void initState() {
    super.initState();
    final pets = AppData.pets;
    if (pets.isEmpty) return;
    _selectedPet = pets.first;
    _matches = _matchesFor(pets.first);
  }

  @override
  Widget build(BuildContext context) {
    final pets = AppData.pets;
    final selectedPet = _selectedPet;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _Header(matchCount: _matches.length),
              const SizedBox(height: 18),
              if (selectedPet == null)
                const _Panel(
                  title: 'Tu mascota',
                  child: Text(
                    'Agrega una mascota para buscar matches compatibles.',
                  ),
                )
              else ...[
                _PetSelector(
                  pets: pets,
                  selectedPet: selectedPet,
                  onSelected: (pet) {
                    setState(() {
                      _selectedPet = pet;
                      _matches = const <PetMatchScore>[];
                    });
                  },
                ),
                const SizedBox(height: 14),
                _GoalSelector(
                  value: _goal,
                  onChanged: (goal) => setState(() => _goal = goal),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    key: const ValueKey('matching-search-button'),
                    onPressed: _isSearching ? null : _search,
                    icon: const Icon(Icons.favorite_border_rounded),
                    label: Text(
                      _isSearching ? 'Buscando...' : 'Buscar matches',
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                if (_isSearching)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: PawLoadingIndicator(message: 'Buscando matches...'),
                  )
                else
                  _MatchingResults(selectedPet: selectedPet, matches: _matches),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _search() async {
    final selectedPet = _selectedPet;
    if (selectedPet == null) return;
    setState(() => _isSearching = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() {
      _matches = _matchesFor(selectedPet);
      _isSearching = false;
    });
  }

  List<PetMatchScore> _matchesFor(Pet pet) {
    return _service.findMatches(
      pet: pet,
      criteria: PetMatchingCriteria(zone: zoneForPet(pet), goal: _goal),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.matchCount});

  final int matchCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.accentDeep,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matching de mascotas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Elegi una mascota y encontra compatibles cerca.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (matchCount > 0)
            _InfoPill(
              label: '$matchCount matches',
              color: AppColors.primarySoft,
            ),
        ],
      ),
    );
  }
}

class _PetSelector extends StatelessWidget {
  const _PetSelector({
    required this.pets,
    required this.selectedPet,
    required this.onSelected,
  });

  final List<Pet> pets;
  final Pet selectedPet;
  final ValueChanged<Pet> onSelected;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Tu mascota',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: pets.map((pet) {
          final selected = pet.id == selectedPet.id;
          return ChoiceChip(
            key: ValueKey('matching-pet-${pet.id}'),
            selected: selected,
            label: Text('${pet.name}  ${pet.species}'),
            avatar: Icon(
              Icons.pets_rounded,
              size: 18,
              color: selected ? Colors.white : AppColors.primaryDeep,
            ),
            selectedColor: AppColors.primaryDeep,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
            onSelected: (_) => onSelected(pet),
          );
        }).toList(),
      ),
    );
  }
}

class _GoalSelector extends StatelessWidget {
  const _GoalSelector({required this.value, required this.onChanged});

  final PetMatchingGoal value;
  final ValueChanged<PetMatchingGoal> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Objetivo',
      child: SegmentedButton<PetMatchingGoal>(
        key: const ValueKey('matching-goal-selector'),
        segments: PetMatchingGoal.values
            .map(
              (goal) => ButtonSegment<PetMatchingGoal>(
                value: goal,
                label: Text(goal.label),
                icon: Icon(_iconForGoal(goal)),
              ),
            )
            .toList(),
        selected: {value},
        onSelectionChanged: (values) => onChanged(values.first),
      ),
    );
  }
}

class _MatchingResults extends StatelessWidget {
  const _MatchingResults({required this.selectedPet, required this.matches});

  final Pet selectedPet;
  final List<PetMatchScore> matches;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return _Panel(
        title: 'Resultados',
        child: Text(
          'Busca matches para ${selectedPet.name}.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resultados', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        ResponsiveWrapGrid(
          minItemWidth: 280,
          children: matches
              .map((match) => _MatchCard(score: match))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.score});

  final PetMatchScore score;

  @override
  Widget build(BuildContext context) {
    final candidate = score.candidate;
    return Card(
      key: ValueKey('matching-result-${candidate.id}'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(candidate.colorHex),
                  child: const Icon(
                    Icons.pets_rounded,
                    color: AppColors.primaryDeep,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '${candidate.species} - ${candidate.breed}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _InfoPill(
                  label: '${score.percent}%',
                  color: AppColors.accentSoft,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(label: candidate.zone, color: AppColors.primarySoft),
                _InfoPill(
                  label: candidate.ageLabel,
                  color: AppColors.surfaceAlt,
                ),
                _InfoPill(
                  label: candidate.distanceLabel,
                  color: AppColors.supportSoft,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              candidate.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              score.label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.primaryDeep,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: score.reasons
                  .map(
                    (reason) =>
                        _InfoPill(label: reason, color: AppColors.surfaceTint),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDetail(context, score),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Ver detalle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

IconData _iconForGoal(PetMatchingGoal goal) {
  return switch (goal) {
    PetMatchingGoal.walk => Icons.directions_walk_rounded,
    PetMatchingGoal.play => Icons.sports_baseball_rounded,
    PetMatchingGoal.company => Icons.favorite_border_rounded,
  };
}

void _showDetail(BuildContext context, PetMatchScore score) {
  final candidate = score.candidate;
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                candidate.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('${candidate.species} - ${candidate.breed}'),
              const SizedBox(height: 12),
              Text(candidate.summary),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoPill(
                    label: candidate.zone,
                    color: AppColors.primarySoft,
                  ),
                  _InfoPill(
                    label: candidate.sizeLabel,
                    color: AppColors.surfaceAlt,
                  ),
                  _InfoPill(
                    label: candidate.energyLabel,
                    color: AppColors.supportSoft,
                  ),
                  _InfoPill(label: score.label, color: AppColors.accentSoft),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.lock_outline_rounded),
                  label: const Text('Solicitud segura proximamente'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
