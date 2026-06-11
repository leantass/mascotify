import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/widgets/paw_loading_indicator.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import '../../../profile/presentation/screens/help_screen.dart';
import '../../../profile/presentation/widgets/contextual_help_link.dart';
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
  int _currentIndex = 0;
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
          maxWidth: 920,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _Header(onReset: selectedPet == null ? null : _resetDeck),
              const SizedBox(height: 14),
              if (selectedPet == null)
                const _EmptyPetsState()
              else ...[
                _CompactControls(
                  pets: pets,
                  selectedPet: selectedPet,
                  goal: _goal,
                  onPetSelected: (pet) {
                    setState(() => _selectedPet = pet);
                    _resetDeck();
                  },
                  onGoalChanged: (goal) {
                    setState(() => _goal = goal);
                    _resetDeck();
                  },
                ),
                const SizedBox(height: 16),
                if (_isSearching)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: PawLoadingIndicator(message: 'Buscando matches...'),
                  )
                else
                  _SwipeDeck(
                    matches: _matches,
                    currentIndex: _currentIndex,
                    selectedPet: selectedPet,
                    onPass: _passMatch,
                    onLike: _likeMatch,
                    onReset: _resetDeck,
                  ),
                const SizedBox(height: 16),
                const ContextualHelpLink(
                  topic: HelpTopic.matching,
                  label: 'Ver ayuda sobre Matching',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetDeck() async {
    final selectedPet = _selectedPet;
    if (selectedPet == null) return;
    setState(() => _isSearching = true);
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    setState(() {
      _matches = _matchesFor(selectedPet);
      _currentIndex = 0;
      _isSearching = false;
    });
  }

  void _passMatch(PetMatchScore score) {
    _advanceDeck();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${score.candidate.name} queda para mas tarde')),
    );
  }

  void _likeMatch(PetMatchScore score) {
    _advanceDeck();
    if (score.candidate.isMutualMatchDemo) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showMutualMatch(score);
      });
    }
  }

  void _advanceDeck() {
    if (_currentIndex >= _matches.length) return;
    setState(() => _currentIndex += 1);
  }

  void _showMutualMatch(PetMatchScore score) {
    final candidate = score.candidate;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _PetAvatar(candidate: candidate, size: 64),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hicieron match!',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            '${candidate.name} tambien mostro interes demo.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'El contacto real sera mediado por Mascotify con privacidad, consentimiento y seguridad.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.lock_outline_rounded),
                    label: const Text('Contacto seguro proximamente'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PetMatchScore> _matchesFor(Pet pet) {
    return _service.findMatches(
      pet: pet,
      criteria: PetMatchingCriteria(zone: zoneForPet(pet), goal: _goal),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onReset});

  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.accentSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.favorite_rounded,
            color: AppColors.accentDeep,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Matching de mascotas',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Desliza y encontra compatibles cerca.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton.outlined(
          key: const ValueKey('matching-reset-button'),
          tooltip: 'Reiniciar deck',
          onPressed: onReset,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }
}

class _CompactControls extends StatelessWidget {
  const _CompactControls({
    required this.pets,
    required this.selectedPet,
    required this.goal,
    required this.onPetSelected,
    required this.onGoalChanged,
  });

  final List<Pet> pets;
  final Pet selectedPet;
  final PetMatchingGoal goal;
  final ValueChanged<Pet> onPetSelected;
  final ValueChanged<PetMatchingGoal> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DropdownButton<Pet>(
          key: const ValueKey('matching-pet-selector'),
          value: selectedPet,
          borderRadius: BorderRadius.circular(16),
          underline: const SizedBox.shrink(),
          items: pets
              .map(
                (pet) => DropdownMenuItem<Pet>(
                  value: pet,
                  child: Text('${pet.name} - ${pet.species}'),
                ),
              )
              .toList(),
          onChanged: (pet) {
            if (pet != null) onPetSelected(pet);
          },
        ),
        SegmentedButton<PetMatchingGoal>(
          key: const ValueKey('matching-goal-selector'),
          showSelectedIcon: false,
          segments: PetMatchingGoal.values
              .map(
                (item) => ButtonSegment<PetMatchingGoal>(
                  value: item,
                  label: Text(item.label),
                  icon: Icon(_iconForGoal(item)),
                ),
              )
              .toList(),
          selected: {goal},
          onSelectionChanged: (values) => onGoalChanged(values.first),
        ),
      ],
    );
  }
}

class _SwipeDeck extends StatelessWidget {
  const _SwipeDeck({
    required this.matches,
    required this.currentIndex,
    required this.selectedPet,
    required this.onPass,
    required this.onLike,
    required this.onReset,
  });

  final List<PetMatchScore> matches;
  final int currentIndex;
  final Pet selectedPet;
  final ValueChanged<PetMatchScore> onPass;
  final ValueChanged<PetMatchScore> onLike;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final deckHeight = (MediaQuery.sizeOf(context).height - 245).clamp(
      430.0,
      560.0,
    );
    if (currentIndex >= matches.length) {
      return _EmptyDeckState(selectedPet: selectedPet, onReset: onReset);
    }

    final current = matches[currentIndex];
    final next = currentIndex + 1 < matches.length
        ? matches[currentIndex + 1]
        : null;

    return Column(
      key: const ValueKey('matching-swipe-deck'),
      children: [
        SizedBox(
          height: deckHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (next != null)
                Transform.scale(
                  scale: 0.94,
                  child: Opacity(
                    opacity: 0.62,
                    child: _MatchSwipeCard(score: next, isPreview: true),
                  ),
                ),
              _SwipeableMatchCard(
                key: ValueKey('swipeable-${current.candidate.id}'),
                score: current,
                onPass: () => onPass(current),
                onLike: () => onLike(current),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RoundActionButton(
              key: const ValueKey('matching-pass-button'),
              icon: Icons.close_rounded,
              foreground: AppColors.accentDeep,
              onPressed: () => onPass(current),
            ),
            const SizedBox(width: 22),
            _RoundActionButton(
              key: const ValueKey('matching-like-button'),
              icon: Icons.favorite_rounded,
              foreground: AppColors.primaryDeep,
              onPressed: () => onLike(current),
            ),
          ],
        ),
      ],
    );
  }
}

class _SwipeableMatchCard extends StatefulWidget {
  const _SwipeableMatchCard({
    super.key,
    required this.score,
    required this.onPass,
    required this.onLike,
  });

  final PetMatchScore score;
  final VoidCallback onPass;
  final VoidCallback onLike;

  @override
  State<_SwipeableMatchCard> createState() => _SwipeableMatchCardState();
}

class _SwipeableMatchCardState extends State<_SwipeableMatchCard> {
  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 920.0);
    final progress = (_dragOffset.dx / (width * 0.28)).clamp(-1.0, 1.0);
    final angle = progress * 0.10;

    return GestureDetector(
      key: const ValueKey('matching-active-card'),
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        setState(() => _dragOffset += Offset(details.delta.dx, 0));
      },
      onHorizontalDragEnd: (_) {
        final accepted = _dragOffset.dx.abs() > 95;
        final like = _dragOffset.dx > 0;
        setState(() => _dragOffset = Offset.zero);
        if (!accepted) return;
        if (like) {
          widget.onLike();
        } else {
          widget.onPass();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Transform.translate(
          offset: _dragOffset,
          child: Transform.rotate(
            angle: angle,
            child: Stack(
              children: [
                _MatchSwipeCard(score: widget.score),
                Positioned(
                  top: 28,
                  left: 22,
                  child: _SwipeFeedbackBadge(
                    label: 'Me gusta',
                    color: AppColors.primaryDeep,
                    opacity: progress.clamp(0.0, 1.0),
                  ),
                ),
                Positioned(
                  top: 28,
                  right: 22,
                  child: _SwipeFeedbackBadge(
                    label: 'Pasar',
                    color: AppColors.accentDeep,
                    opacity: (-progress).clamp(0.0, 1.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MatchSwipeCard extends StatelessWidget {
  const _MatchSwipeCard({required this.score, this.isPreview = false});

  final PetMatchScore score;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final candidate = score.candidate;
    return Center(
      child: Container(
        key: ValueKey('matching-swipe-card-${candidate.id}'),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 460),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isPreview ? 0.08 : 0.18),
              blurRadius: isPreview ? 18 : 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHero(candidate: candidate, score: score),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          candidate.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      _InfoPill(
                        label: '${score.percent}%',
                        color: AppColors.accentSoft,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${candidate.species} - ${candidate.breed} - ${candidate.ageLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    candidate.summary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: score.reasons
                        .take(3)
                        .map(
                          (reason) => _InfoPill(
                            label: reason,
                            color: AppColors.surfaceTint,
                          ),
                        )
                        .toList(growable: false),
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

class _CardHero extends StatelessWidget {
  const _CardHero({required this.candidate, required this.score});

  final PetMatchCandidate candidate;
  final PetMatchScore score;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(candidate.colorHex),
            AppColors.surface,
            AppColors.primarySoft,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -20,
            child: Icon(
              Icons.pets_rounded,
              size: 170,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
          Center(child: _PetAvatar(candidate: candidate, size: 116)),
          Positioned(
            left: 18,
            top: 18,
            child: _InfoPill(label: score.label, color: Colors.white),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: _InfoPill(
              label: candidate.distanceLabel,
              color: AppColors.supportSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  const _PetAvatar({required this.candidate, required this.size});

  final PetMatchCandidate candidate;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(candidate.colorHex),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        candidate.species.toLowerCase().contains('gat')
            ? Icons.cruelty_free_rounded
            : Icons.pets_rounded,
        size: size * 0.48,
        color: AppColors.primaryDeep,
      ),
    );
  }
}

class _SwipeFeedbackBadge extends StatelessWidget {
  const _SwipeFeedbackBadge({
    required this.label,
    required this.color,
    required this.opacity,
  });

  final String label;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: label == 'Me gusta' ? -math.pi / 18 : math.pi / 18,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    super.key,
    required this.icon,
    required this.foreground,
    required this.onPressed,
  });

  final IconData icon;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 62,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon, size: 30),
        style: IconButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          shadowColor: Colors.black.withValues(alpha: 0.18),
          elevation: 4,
        ),
      ),
    );
  }
}

class _EmptyDeckState extends StatelessWidget {
  const _EmptyDeckState({required this.selectedPet, required this.onReset});

  final Pet selectedPet;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('matching-empty-deck'),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 52,
            color: AppColors.primaryDeep,
          ),
          const SizedBox(height: 12),
          Text(
            'No hay mas matches por ahora',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Probemos de nuevo para ${selectedPet.name}.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Volver a buscar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyPetsState extends StatelessWidget {
  const _EmptyPetsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text('Agrega una mascota para buscar matches compatibles.'),
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
