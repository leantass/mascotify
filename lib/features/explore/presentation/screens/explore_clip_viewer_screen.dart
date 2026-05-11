import 'package:flutter/material.dart';

import '../../../../shared/models/social_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

class ExploreClipViewerScreen extends StatefulWidget {
  const ExploreClipViewerScreen({
    super.key,
    required this.clips,
    required this.initialClipId,
    this.onToggleLike,
    this.onShare,
    this.onToggleFollow,
  });

  final List<ExploreClip> clips;
  final String initialClipId;
  final Future<ExploreClip> Function(ExploreClip clip)? onToggleLike;
  final Future<ExploreClip> Function(ExploreClip clip)? onShare;
  final Future<ExploreClip> Function(ExploreClip clip)? onToggleFollow;

  @override
  State<ExploreClipViewerScreen> createState() =>
      _ExploreClipViewerScreenState();
}

class _ExploreClipViewerScreenState extends State<ExploreClipViewerScreen> {
  late List<ExploreClip> _clips;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _clips = widget.clips;
    _currentIndex = _clips.indexWhere(
      (clip) => clip.id == widget.initialClipId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: _currentIndex == -1
            ? _buildMissingState(context)
            : _buildViewer(),
      ),
    );
  }

  Widget _buildViewer() {
    final clip = _clips[_currentIndex];
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == _clips.length - 1;

    return ResponsivePageBody(
      maxWidth: 560,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _close,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Volver a Clips'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.58),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Visor de clips',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${_currentIndex + 1}/${_clips.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _ViewerClipPage(
                key: ValueKey(clip.id),
                clip: clip,
                isFirst: isFirst,
                isLast: isLast,
                onPrevious: isFirst ? null : _showPrevious,
                onNext: isLast ? null : _showNext,
                onToggleLike: () => _toggleClipLike(clip.id),
                onShare: () => _shareClip(clip.id),
                onToggleSave: () => _toggleClipSave(clip.id),
                onToggleFollow: clip.authorId == null
                    ? null
                    : () => _toggleClipFollow(clip.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingState(BuildContext context) {
    return ResponsivePageBody(
      maxWidth: 520,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.play_disabled_rounded,
                    color: AppColors.accentDeep,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Clip no disponible',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'No pudimos encontrar ese clip local. Podes volver a Explorar y abrir otro desde la lista.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _close,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Volver a Clips'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPrevious() {
    if (_currentIndex == 0) return;
    setState(() => _currentIndex--);
  }

  void _showNext() {
    if (_currentIndex >= _clips.length - 1) return;
    setState(() => _currentIndex++);
  }

  Future<void> _toggleClipLike(String clipId) async {
    final clip = _clipById(clipId);
    if (clip == null) return;
    final nextLiked = !clip.isLiked;
    final optimisticClip = clip.copyWith(
      isLiked: nextLiked,
      likes: nextLiked ? clip.likes + 1 : clip.likes - 1,
    );
    setState(() => _replaceClip(optimisticClip));
    final remoteToggle = widget.onToggleLike;
    if (remoteToggle == null) return;
    final updatedClip = await remoteToggle(clip);
    if (!mounted) return;
    setState(() => _replaceClip(updatedClip));
  }

  void _toggleClipSave(String clipId) {
    setState(() {
      _clips = _clips.map((clip) {
        if (clip.id != clipId) return clip;
        return clip.copyWith(isSaved: !clip.isSaved);
      }).toList();
    });
  }

  Future<void> _shareClip(String clipId) async {
    final clip = _clipById(clipId);
    if (clip == null) return;
    final optimisticClip = clip.copyWith(shares: clip.shares + 1);
    setState(() => _replaceClip(optimisticClip));
    final remoteShare = widget.onShare;
    if (remoteShare == null) return;
    final updatedClip = await remoteShare(clip);
    if (!mounted) return;
    setState(() => _replaceClip(updatedClip));
  }

  Future<void> _toggleClipFollow(String clipId) async {
    final clip = _clipById(clipId);
    if (clip == null || clip.authorId == null) return;
    final optimisticClip = clip.copyWith(
      isFollowingAuthor: !clip.isFollowingAuthor,
    );
    setState(() => _replaceClip(optimisticClip));
    final remoteFollow = widget.onToggleFollow;
    if (remoteFollow == null) return;
    final updatedClip = await remoteFollow(clip);
    if (!mounted) return;
    setState(() => _replaceClip(updatedClip));
  }

  ExploreClip? _clipById(String clipId) {
    for (final clip in _clips) {
      if (clip.id == clipId) return clip;
    }
    return null;
  }

  void _replaceClip(ExploreClip updatedClip) {
    _clips = _clips
        .map((clip) => clip.id == updatedClip.id ? updatedClip : clip)
        .toList();
  }

  void _close() {
    Navigator.of(context).pop<List<ExploreClip>>(_clips);
  }
}

class _ViewerClipPage extends StatelessWidget {
  const _ViewerClipPage({
    super.key,
    required this.clip,
    required this.isFirst,
    required this.isLast,
    required this.onPrevious,
    required this.onNext,
    required this.onToggleLike,
    required this.onShare,
    required this.onToggleSave,
    required this.onToggleFollow,
  });

  final ExploreClip clip;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onToggleLike;
  final VoidCallback onShare;
  final VoidCallback onToggleSave;
  final VoidCallback? onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final hasVideo = clip.videoAssetPath != null;
    final thumbnail = clip.thumbnailAssetPath;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final reelHeight = (viewportHeight * 0.68).clamp(360.0, 680.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: reelHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (thumbnail == null)
                    const _ViewerPlaceholder()
                  else
                    Image.asset(thumbnail, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.34),
                          Colors.black.withValues(alpha: 0.82),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.primaryDeep,
                        size: 52,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    top: 18,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ViewerBadge(label: hasVideo ? 'Video local' : 'Demo'),
                        _ViewerBadge(label: clip.category),
                        _ViewerBadge(label: clip.animalType),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hasVideo)
                          const _ViewerBadge(label: 'Clip demo local'),
                        const SizedBox(height: 12),
                        Text(
                          clip.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          clip.description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.88),
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ViewerActionButton(
                icon: clip.isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: '${clip.likes} likes',
                selected: clip.isLiked,
                onPressed: onToggleLike,
              ),
              _ViewerActionButton(
                icon: Icons.mode_comment_outlined,
                label: '${clip.comments} comentarios',
                selected: false,
                onPressed: () {},
              ),
              _ViewerActionButton(
                icon: clip.isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                label: clip.isSaved ? 'Guardado' : 'Guardar',
                selected: clip.isSaved,
                onPressed: onToggleSave,
              ),
              _ViewerActionButton(
                icon: Icons.ios_share_rounded,
                label: clip.shares > 0
                    ? '${clip.shares} compartidos'
                    : 'Compartir',
                selected: false,
                onPressed: onShare,
              ),
              if (clip.authorId != null)
                _ViewerActionButton(
                  icon: clip.isFollowingAuthor
                      ? Icons.check_circle_rounded
                      : Icons.person_add_alt_1_rounded,
                  label: clip.isFollowingAuthor ? 'Siguiendo' : 'Seguir',
                  selected: clip.isFollowingAuthor,
                  onPressed: onToggleFollow ?? () {},
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  label: const Text('Clip anterior'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(
                        alpha: isFirst ? 0.22 : 0.7,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  label: const Text('Siguiente clip'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewerPlaceholder extends StatelessWidget {
  const _ViewerPlaceholder();

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
          padding: EdgeInsets.all(24),
          child: Icon(Icons.pets_rounded, color: AppColors.dark, size: 52),
        ),
      ),
    );
  }
}

class _ViewerBadge extends StatelessWidget {
  const _ViewerBadge({required this.label});

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

class _ViewerActionButton extends StatelessWidget {
  const _ViewerActionButton({
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
        foregroundColor: selected ? AppColors.primaryDeep : Colors.white,
        backgroundColor: selected ? AppColors.primarySoft : null,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.62)),
      ),
    );
  }
}
