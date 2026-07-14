import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/widgets/paw_loading_indicator.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact =
                constraints.maxHeight < 760 || constraints.maxWidth < 430;
            final horizontalPadding = isCompact ? 12.0 : 20.0;
            final topPadding = isCompact ? 8.0 : 12.0;
            final bottomPadding = isCompact ? 8.0 : 18.0;
            final gap = isCompact ? 8.0 : 12.0;

            return ResponsivePageBody(
              maxWidth: 620,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  bottomPadding,
                ),
                child: Column(
                  key: const ValueKey('matching-above-fold-layout'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(
                      onReset: selectedPet == null ? null : _resetDeck,
                      compact: isCompact,
                    ),
                    SizedBox(height: gap),
                    if (selectedPet == null)
                      const Expanded(child: Center(child: _EmptyPetsState()))
                    else ...[
                      _CompactControls(
                        pets: pets,
                        selectedPet: selectedPet,
                        goal: _goal,
                        compact: isCompact,
                        onPetSelected: (pet) {
                          setState(() => _selectedPet = pet);
                          _resetDeck();
                        },
                        onGoalChanged: (goal) {
                          setState(() => _goal = goal);
                          _resetDeck();
                        },
                      ),
                      SizedBox(height: gap),
                      Expanded(
                        child: _isSearching
                            ? const Center(
                                child: PawLoadingIndicator(
                                  message: 'Buscando matches...',
                                ),
                              )
                            : _SwipeDeck(
                                matches: _matches,
                                currentIndex: _currentIndex,
                                selectedPet: selectedPet,
                                compact: isCompact,
                                onPass: _passMatch,
                                onLike: _likeMatch,
                                onReset: _resetDeck,
                              ),
                      ),
                      SizedBox(height: isCompact ? 4 : 8),
                      const Align(
                        alignment: Alignment.center,
                        child: ContextualHelpLink(
                          topic: HelpTopic.matching,
                          label: 'Ver ayuda sobre Matching',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MutualMatchSheet(candidate: candidate);
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
  const _Header({required this.onReset, required this.compact});

  final VoidCallback? onReset;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: compact ? 38 : 46,
          height: compact ? 38 : 46,
          decoration: BoxDecoration(
            color: mascotifyTone(context, AppColors.accentSoft),
            borderRadius: BorderRadius.circular(compact ? 14 : 16),
          ),
          child: Icon(
            Icons.favorite_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Matching de mascotas',
                style: compact
                    ? Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      )
                    : Theme.of(context).textTheme.headlineSmall,
              ),
              if (!compact)
                Text(
                  'Desliza y encontra compatibles cerca.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: mascotifySecondaryText(context),
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
    required this.compact,
    required this.onPetSelected,
    required this.onGoalChanged,
  });

  final List<Pet> pets;
  final Pet selectedPet;
  final PetMatchingGoal goal;
  final bool compact;
  final ValueChanged<Pet> onPetSelected;
  final ValueChanged<PetMatchingGoal> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final selector = DropdownButtonHideUnderline(
      child: DropdownButton<Pet>(
        key: const ValueKey('matching-pet-selector'),
        value: selectedPet,
        borderRadius: BorderRadius.circular(16),
        isDense: true,
        items: pets
            .map(
              (pet) => DropdownMenuItem<Pet>(
                value: pet,
                child: Text(
                  '${pet.name} - ${pet.species}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (pet) {
          if (pet != null) onPetSelected(pet);
        },
      ),
    );
    final goals = SegmentedButton<PetMatchingGoal>(
      key: const ValueKey('matching-goal-selector'),
      showSelectedIcon: false,
      style: compact
          ? ButtonStyle(
              visualDensity: VisualDensity.compact,
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 8),
              ),
            )
          : null,
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
    );

    if (compact) {
      return Column(
        key: const ValueKey('matching-compact-controls'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: mascotifySurface(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: mascotifyBorder(context)),
            ),
            child: selector,
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: goals),
        ],
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [selector, goals],
    );
  }
}

class _SwipeDeck extends StatelessWidget {
  const _SwipeDeck({
    required this.matches,
    required this.currentIndex,
    required this.selectedPet,
    required this.compact,
    required this.onPass,
    required this.onLike,
    required this.onReset,
  });

  final List<PetMatchScore> matches;
  final int currentIndex;
  final Pet selectedPet;
  final bool compact;
  final ValueChanged<PetMatchScore> onPass;
  final ValueChanged<PetMatchScore> onLike;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= matches.length) {
      return _EmptyDeckState(selectedPet: selectedPet, onReset: onReset);
    }

    final current = matches[currentIndex];
    final next = currentIndex + 1 < matches.length
        ? matches[currentIndex + 1]
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.70;
        final deckCompact = compact || maxHeight < 560;
        final actionSize = deckCompact ? 54.0 : 62.0;
        final actionGap = deckCompact ? 8.0 : 14.0;
        final availableCardHeight = (maxHeight - actionSize - actionGap).clamp(
          0.0,
          double.infinity,
        );
        final cardHeight = availableCardHeight.clamp(
          deckCompact ? 320.0 : 410.0,
          deckCompact ? 430.0 : 540.0,
        );

        return Column(
          key: const ValueKey('matching-swipe-deck'),
          children: [
            SizedBox(
              height: cardHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (next != null)
                    Transform.scale(
                      scale: 0.94,
                      child: Opacity(
                        opacity: 0.62,
                        child: _MatchSwipeCard(
                          score: next,
                          isPreview: true,
                          compact: deckCompact,
                        ),
                      ),
                    ),
                  _SwipeableMatchCard(
                    key: ValueKey('swipeable-${current.candidate.id}'),
                    score: current,
                    compact: deckCompact,
                    onPass: () => onPass(current),
                    onLike: () => onLike(current),
                  ),
                ],
              ),
            ),
            SizedBox(height: actionGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundActionButton(
                  key: const ValueKey('matching-pass-button'),
                  icon: Icons.close_rounded,
                  foreground: Theme.of(context).colorScheme.secondary,
                  compact: deckCompact,
                  onPressed: () => onPass(current),
                ),
                SizedBox(width: deckCompact ? 18 : 22),
                _RoundActionButton(
                  key: const ValueKey('matching-like-button'),
                  icon: Icons.favorite_rounded,
                  foreground: Theme.of(context).colorScheme.primary,
                  compact: deckCompact,
                  onPressed: () => onLike(current),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SwipeableMatchCard extends StatefulWidget {
  const _SwipeableMatchCard({
    super.key,
    required this.score,
    required this.compact,
    required this.onPass,
    required this.onLike,
  });

  final PetMatchScore score;
  final bool compact;
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
                _MatchSwipeCard(score: widget.score, compact: widget.compact),
                Positioned(
                  top: widget.compact ? 18 : 28,
                  left: widget.compact ? 16 : 22,
                  child: _SwipeFeedbackBadge(
                    label: 'Me gusta',
                    color: Theme.of(context).colorScheme.primary,
                    opacity: progress.clamp(0.0, 1.0),
                  ),
                ),
                Positioned(
                  top: widget.compact ? 18 : 28,
                  right: widget.compact ? 16 : 22,
                  child: _SwipeFeedbackBadge(
                    label: 'Pasar',
                    color: Theme.of(context).colorScheme.secondary,
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
  const _MatchSwipeCard({
    required this.score,
    this.isPreview = false,
    this.compact = false,
  });

  final PetMatchScore score;
  final bool isPreview;
  final bool compact;

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
          color: mascotifySurface(context),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: mascotifyBorder(context)),
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
            _CardHero(candidate: candidate, score: score, compact: compact),
            Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 14 : 18,
                compact ? 9 : 12,
                compact ? 14 : 18,
                compact ? 10 : 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          candidate.name,
                          style:
                              (compact
                                      ? Theme.of(context).textTheme.titleLarge
                                      : Theme.of(
                                          context,
                                        ).textTheme.headlineSmall)
                                  ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      _InfoPill(
                        label: '${score.percent}%',
                        color: mascotifyTone(context, AppColors.accentSoft),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 4 : 6),
                  Text(
                    '${candidate.species} - ${candidate.breed} - ${candidate.ageLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: mascotifySecondaryText(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: compact ? 7 : 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: compact ? 6 : 8,
                    children: [
                      _InfoPill(
                        label: candidate.zone,
                        color: mascotifyTone(context, AppColors.primarySoft),
                      ),
                      if (!compact)
                        _InfoPill(
                          label: candidate.sizeLabel,
                          color: mascotifySurfaceAlt(context),
                        ),
                      _InfoPill(
                        label: candidate.energyLabel,
                        color: mascotifyTone(context, AppColors.supportSoft),
                      ),
                    ],
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 10),
                    Text(
                      candidate.summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.35),
                    ),
                  ],
                  SizedBox(height: compact ? 7 : 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: compact ? 6 : 8,
                    children: score.reasons
                        .take(compact ? 2 : 3)
                        .map(
                          (reason) => _InfoPill(
                            label: reason,
                            color: mascotifySurfaceTint(context),
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
  const _CardHero({
    required this.candidate,
    required this.score,
    required this.compact,
  });

  final PetMatchCandidate candidate;
  final PetMatchScore score;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 150 : 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mascotifyTone(context, Color(candidate.colorHex)),
            mascotifySurface(context),
            mascotifyTone(context, AppColors.primarySoft),
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
          Center(
            child: _PetAvatar(candidate: candidate, size: compact ? 82 : 116),
          ),
          Positioned(
            left: compact ? 14 : 18,
            top: compact ? 14 : 18,
            child: _InfoPill(
              label: score.label,
              color: mascotifySurfaceTint(context),
            ),
          ),
          Positioned(
            right: compact ? 14 : 18,
            bottom: compact ? 14 : 18,
            child: _InfoPill(
              label: candidate.distanceLabel,
              color: mascotifyTone(context, AppColors.supportSoft),
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
        border: Border.all(
          color: mascotifyIsDark(context)
              ? mascotifySurfaceTint(context)
              : Colors.white,
          width: 5,
        ),
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
        color: Theme.of(context).colorScheme.primary,
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
            color: mascotifySurface(context),
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
    required this.compact,
    required this.onPressed,
  });

  final IconData icon;
  final Color foreground;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 54 : 62,
      height: compact ? 54 : 62,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon, size: compact ? 27 : 30),
        style: IconButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: mascotifySurfaceTint(context),
          side: BorderSide(color: mascotifyBorder(context)),
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
        color: mascotifySurface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: mascotifyBorder(context)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: mascotifySecondaryText(context),
            ),
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

class _MutualMatchSheet extends StatefulWidget {
  const _MutualMatchSheet({required this.candidate});

  final PetMatchCandidate candidate;

  @override
  State<_MutualMatchSheet> createState() => _MutualMatchSheetState();
}

class _MutualMatchSheetState extends State<_MutualMatchSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pop;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 880),
    );
    _pop = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.58, curve: Curves.elasticOut),
    );
    _float = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.12, 1, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final candidate = widget.candidate;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Container(
          key: const ValueKey('matching-mutual-sheet'),
          decoration: BoxDecoration(
            color: mascotifySurface(context),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: mascotifyBorder(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        mascotifyTone(context, AppColors.accentSoft),
                        mascotifySurface(context),
                        mascotifyTone(context, AppColors.primarySoft),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Stack(
                        children: [
                          _FloatingMatchHeart(
                            progress: _float.value,
                            left: 34,
                            top: 68,
                            size: 18,
                            opacity: 0.55,
                          ),
                          _FloatingMatchHeart(
                            progress: _float.value,
                            right: 44,
                            top: 48,
                            size: 22,
                            opacity: 0.50,
                          ),
                          _FloatingMatchHeart(
                            progress: _float.value,
                            left: 74,
                            bottom: 88,
                            size: 14,
                            opacity: 0.42,
                            delay: 0.18,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pop,
                      builder: (context, child) {
                        final scale = 0.72 + (_pop.value * 0.28);
                        return Opacity(
                          opacity: _controller.value.clamp(0.0, 1.0),
                          child: Transform.scale(scale: scale, child: child),
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          _PetAvatar(candidate: candidate, size: 88),
                          Positioned(
                            right: -6,
                            bottom: -2,
                            child: Container(
                              key: const ValueKey('matching-heart-pop'),
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.accentDeep,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: mascotifySurface(context),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentDeep.withValues(
                                      alpha: 0.30,
                                    ),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: 23,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      key: const ValueKey('matching-match-badge'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: mascotifyTone(
                          context,
                          Colors.white.withValues(alpha: 0.78),
                        ),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.36),
                        ),
                      ),
                      child: Text(
                        'Match demo',
                        style: textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hicieron match!',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: mascotifyPrimaryText(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${candidate.name} tambien mostro interes demo.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: mascotifySecondaryText(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'El contacto real sera mediado por Mascotify con privacidad y seguridad.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(height: 1.35),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingMatchHeart extends StatelessWidget {
  const _FloatingMatchHeart({
    required this.progress,
    required this.size,
    required this.opacity,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.delay = 0,
  });

  final double progress;
  final double size;
  final double opacity;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final adjusted = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
    final fade = math.sin(adjusted * math.pi).clamp(0.0, 1.0);
    return Positioned(
      left: left,
      right: right,
      top: top == null ? null : top! - (adjusted * 22),
      bottom: bottom == null ? null : bottom! + (adjusted * 18),
      child: Opacity(
        opacity: opacity * fade,
        child: Transform.rotate(
          angle: (adjusted - 0.5) * math.pi / 18,
          child: Icon(
            Icons.favorite_rounded,
            key: const ValueKey('matching-floating-heart'),
            color: AppColors.accentDeep,
            size: size,
          ),
        ),
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
        color: mascotifySurface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: mascotifyBorder(context)),
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
        color: mascotifyTone(context, color),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: mascotifyBorder(context)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: mascotifyPrimaryText(context),
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
