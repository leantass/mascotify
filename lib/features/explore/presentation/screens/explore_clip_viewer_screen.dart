import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _clips = widget.clips;
    _currentIndex = _clips.indexWhere(
      (clip) => clip.id == widget.initialClipId,
    );
    _pageController = PageController(
      initialPage: _currentIndex < 0 ? 0 : _currentIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
    return ResponsivePageBody(
      maxWidth: 560,
      child: SizedBox.expand(
        child: Stack(
          children: [
            Semantics(
              label: 'Feed vertical de clips',
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _clips.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final clip = _clips[index];
                  return _ViewerClipPage(
                    key: ValueKey(clip.id),
                    clip: clip,
                    isActive: index == _currentIndex,
                    onToggleLike: () => _toggleClipLike(clip.id),
                    onShare: () => _shareClip(clip.id),
                    onToggleSave: () => _toggleClipSave(clip.id),
                    onComments: _showCommentsComingSoon,
                    onToggleFollow: clip.authorId == null
                        ? null
                        : () => _toggleClipFollow(clip.id),
                  );
                },
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              top: 10,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _close,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Volver a Clips'),
                    style: _viewerNavigationButtonStyle(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.38),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${_clips.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 74,
              bottom: 22,
              child: RotatedBox(
                quarterTurns: 1,
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _clips.length,
                  minHeight: 3,
                  color: AppColors.accent,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                ),
              ),
            ),
          ],
        ),
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
    if (remoteShare != null) {
      final updatedClip = await remoteShare(clip);
      if (!mounted) return;
      setState(() => _replaceClip(updatedClip));
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Clip listo para compartir')));
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

  void _showCommentsComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comentarios disponibles en la proxima etapa'),
      ),
    );
  }

  void _close() {
    Navigator.of(context).pop<List<ExploreClip>>(_clips);
  }
}

class _ViewerClipPage extends StatelessWidget {
  const _ViewerClipPage({
    super.key,
    required this.clip,
    required this.isActive,
    required this.onToggleLike,
    required this.onShare,
    required this.onToggleSave,
    required this.onComments,
    required this.onToggleFollow,
  });

  final ExploreClip clip;
  final bool isActive;
  final VoidCallback onToggleLike;
  final VoidCallback onShare;
  final VoidCallback onToggleSave;
  final VoidCallback onComments;
  final VoidCallback? onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final hasVideo = clip.hasPlayableVideo || !clip.isDemoContent;
    final thumbnail = clip.thumbnailAssetPath;
    final topMediaLabel = clip.videoSourceType == 'asset'
        ? 'Video local'
        : clip.videoSourceType == 'network'
        ? 'Video remoto'
        : clip.isDemoContent
        ? 'Demo'
        : 'Video remoto';
    final creatorLabel =
        clip.authorDisplayName ??
        (clip.authorId == null ? clip.sourceLabel : 'Creador ${clip.authorId}');

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _ClipVideoSurface(
              clip: clip,
              thumbnail: thumbnail,
              isActive: isActive,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.16),
                    Colors.black.withValues(alpha: 0.82),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 96,
              top: 64,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ViewerBadge(label: topMediaLabel),
                  if (clip.sourceLabel != null)
                    _ViewerBadge(label: clip.sourceLabel!),
                  _ViewerBadge(label: clip.category),
                  _ViewerBadge(label: clip.animalType),
                ],
              ),
            ),
            Positioned(
              right: 12,
              bottom: 22,
              child: _ReelActionRail(
                clip: clip,
                onToggleLike: onToggleLike,
                onComments: onComments,
                onToggleSave: onToggleSave,
                onShare: onShare,
                onToggleFollow: onToggleFollow,
              ),
            ),
            Positioned(
              left: 18,
              right: 96,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!hasVideo) const _ViewerBadge(label: 'Clip demo local'),
                  const SizedBox(height: 12),
                  if (creatorLabel != null) ...[
                    Text(
                      creatorLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    clip.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    clip.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }
}

ButtonStyle _viewerNavigationButtonStyle({EdgeInsetsGeometry? padding}) {
  return ElevatedButton.styleFrom(
    backgroundColor: AppColors.accent,
    foregroundColor: Colors.white,
    disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.34),
    disabledForegroundColor: Colors.white.withValues(alpha: 0.72),
    elevation: 0,
    padding:
        padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    textStyle: const TextStyle(fontWeight: FontWeight.w800),
  );
}

class _ViewerPlaceholder extends StatelessWidget {
  const _ViewerPlaceholder({this.message});

  final String? message;

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
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 900),
        builder: (context, value, child) {
          return Stack(
            children: [
              Positioned(
                right: 24 + (value * 22),
                top: 24 + (value * 16),
                child: const Icon(
                  Icons.pets_rounded,
                  color: AppColors.dark,
                  size: 52,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.86),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    message ?? 'Vista demo segura',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ClipVideoSurface extends StatelessWidget {
  const _ClipVideoSurface({
    required this.clip,
    required this.thumbnail,
    required this.isActive,
  });

  final ExploreClip clip;
  final String? thumbnail;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (clip.videoSourceType == 'asset' && clip.videoAssetPath != null) {
      return _AssetClipVideoPlayer(
        assetPath: clip.videoAssetPath!,
        isActive: isActive,
        fallback: _buildFallback('Video demo no disponible'),
      );
    }

    if (clip.videoSourceType == 'network' && clip.videoUrl != null) {
      return _NetworkClipVideoPlayer(
        videoUrl: clip.videoUrl!,
        isActive: isActive,
        fallback: _buildFallback('Video remoto no disponible'),
      );
    }

    return _buildFallback('Fallback demo animado');
  }

  Widget _buildFallback(String message) {
    if (thumbnail == null) {
      return _ViewerPlaceholder(message: message);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(thumbnail!, fit: BoxFit.cover),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AssetClipVideoPlayer extends StatefulWidget {
  const _AssetClipVideoPlayer({
    required this.assetPath,
    required this.isActive,
    required this.fallback,
  });

  final String assetPath;
  final bool isActive;
  final Widget fallback;

  @override
  State<_AssetClipVideoPlayer> createState() => _AssetClipVideoPlayerState();
}

class _AssetClipVideoPlayerState extends State<_AssetClipVideoPlayer> {
  VideoPlayerController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant _AssetClipVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _disposeController();
      _hasError = false;
      _initialize();
    } else if (oldWidget.isActive != widget.isActive) {
      _syncPlayback();
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _initialize() async {
    final controller = VideoPlayerController.asset(widget.assetPath);
    _controller = controller;
    controller.addListener(_onControllerChanged);
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await _syncPlayback();
      if (!mounted) return;
      setState(() {});
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasError = true);
    }
  }

  void _disposeController() {
    final controller = _controller;
    if (controller == null) return;
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    _controller = null;
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _syncPlayback() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    try {
      if (widget.isActive) {
        await controller.play();
      } else {
        await controller.pause();
      }
    } catch (_) {
      // Some browsers can still reject autoplay; the tap control remains usable.
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (_hasError || controller == null) return widget.fallback;
    if (!controller.value.isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          widget.fallback,
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      );
    }

    return _VideoPlayerFrame(controller: controller);
  }
}

class _NetworkClipVideoPlayer extends StatefulWidget {
  const _NetworkClipVideoPlayer({
    required this.videoUrl,
    required this.isActive,
    required this.fallback,
  });

  final String videoUrl;
  final bool isActive;
  final Widget fallback;

  @override
  State<_NetworkClipVideoPlayer> createState() =>
      _NetworkClipVideoPlayerState();
}

class _NetworkClipVideoPlayerState extends State<_NetworkClipVideoPlayer> {
  VideoPlayerController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant _NetworkClipVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      final controller = _controller;
      if (controller != null) {
        controller.removeListener(_onControllerChanged);
        controller.dispose();
      }
      _controller = null;
      _hasError = false;
      _initialize();
    } else if (oldWidget.isActive != widget.isActive) {
      _syncPlayback();
    }
  }

  @override
  void dispose() {
    final controller = _controller;
    if (controller != null) {
      controller.removeListener(_onControllerChanged);
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initialize() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    _controller = controller;
    controller.addListener(_onControllerChanged);
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await _syncPlayback();
      if (!mounted) return;
      setState(() {});
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasError = true);
    }
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _syncPlayback() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    try {
      if (widget.isActive) {
        await controller.play();
      } else {
        await controller.pause();
      }
    } catch (_) {
      // Some browsers can still reject autoplay; the tap control remains usable.
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (_hasError || controller == null) return widget.fallback;
    if (!controller.value.isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          widget.fallback,
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      );
    }

    return _VideoPlayerFrame(controller: controller);
  }
}

class _VideoPlayerFrame extends StatelessWidget {
  const _VideoPlayerFrame({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final duration = controller.value.duration;
    final position = controller.value.position;
    final progress = duration.inMilliseconds <= 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: controller.value.isPlaying ? 0 : 1,
              duration: const Duration(milliseconds: 180),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.primaryDeep,
                  size: 38,
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                color: AppColors.accent,
                backgroundColor: Colors.white.withValues(alpha: 0.34),
              ),
            ),
          ),
        ],
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

class _ReelActionRail extends StatelessWidget {
  const _ReelActionRail({
    required this.clip,
    required this.onToggleLike,
    required this.onComments,
    required this.onToggleSave,
    required this.onShare,
    required this.onToggleFollow,
  });

  final ExploreClip clip;
  final VoidCallback onToggleLike;
  final VoidCallback onComments;
  final VoidCallback onToggleSave;
  final VoidCallback onShare;
  final VoidCallback? onToggleFollow;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Acciones del clip',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ReelActionButton(
            icon: clip.isLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            label: '${clip.likes} likes',
            selected: clip.isLiked,
            selectedColor: AppColors.primaryDeep,
            onPressed: onToggleLike,
          ),
          _ReelActionButton(
            icon: Icons.mode_comment_outlined,
            label: '${clip.comments} comentarios',
            selected: false,
            onPressed: onComments,
          ),
          _ReelActionButton(
            icon: clip.isSaved
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            label: clip.isSaved ? 'Guardado' : 'Guardar',
            selected: clip.isSaved,
            selectedColor: AppColors.accentDeep,
            onPressed: onToggleSave,
          ),
          _ReelActionButton(
            icon: Icons.ios_share_rounded,
            label: clip.shares > 0 ? '${clip.shares} compartidos' : 'Compartir',
            selected: false,
            onPressed: onShare,
          ),
          if (clip.authorId != null && !clip.isDemoContent)
            _ReelActionButton(
              icon: clip.isFollowingAuthor
                  ? Icons.check_circle_rounded
                  : Icons.person_add_alt_1_rounded,
              label: clip.isFollowingAuthor ? 'Siguiendo' : 'Seguir',
              selected: clip.isFollowingAuthor,
              selectedColor: AppColors.success,
              onPressed: onToggleFollow ?? () {},
            ),
        ],
      ),
    );
  }
}

class _ReelActionButton extends StatelessWidget {
  const _ReelActionButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
    this.selectedColor = AppColors.primaryDeep,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? selectedColor : Colors.white;
    final backgroundColor = selected
        ? Colors.white.withValues(alpha: 0.94)
        : Colors.black.withValues(alpha: 0.38);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: 72,
        child: Tooltip(
          message: label,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.44),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.24),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.65),
                        blurRadius: 8,
                      ),
                    ],
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
