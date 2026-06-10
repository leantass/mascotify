import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../../../features/explore/data/social_clips_repository.dart';
import '../../../../shared/models/social_models.dart';
import '../../../../shared/widgets/paw_loading_indicator.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import 'clip_web_asset_video_view.dart'
    if (dart.library.js_interop) 'clip_web_asset_video_view_web.dart';

class ExploreClipViewerScreen extends StatefulWidget {
  const ExploreClipViewerScreen({
    super.key,
    required this.clips,
    required this.initialClipId,
    this.onToggleLike,
    this.onShare,
    this.onToggleFollow,
    this.onCloseInline,
    this.statusMessage,
    this.dataSource = SocialClipsDataSource.localFallback,
  });

  final List<ExploreClip> clips;
  final String initialClipId;
  final Future<ExploreClip> Function(ExploreClip clip)? onToggleLike;
  final Future<ExploreClip> Function(ExploreClip clip)? onShare;
  final Future<ExploreClip> Function(ExploreClip clip)? onToggleFollow;
  final ValueChanged<List<ExploreClip>>? onCloseInline;
  final String? statusMessage;
  final SocialClipsDataSource dataSource;

  @override
  State<ExploreClipViewerScreen> createState() =>
      _ExploreClipViewerScreenState();
}

class _ExploreClipViewerScreenState extends State<ExploreClipViewerScreen> {
  late List<ExploreClip> _clips;
  late int _currentIndex;
  late PageController _pageController;
  bool _isMuted = true;

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
  void didUpdateWidget(covariant ExploreClipViewerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clips == widget.clips) return;

    final currentClipId = _currentIndex >= 0 && _currentIndex < _clips.length
        ? _clips[_currentIndex].id
        : widget.initialClipId;
    _clips = widget.clips;
    final nextIndex = _clips.indexWhere((clip) => clip.id == currentClipId);
    _currentIndex = nextIndex < 0 ? 0 : nextIndex;
    if (_pageController.hasClients && _clips.isNotEmpty) {
      _pageController.jumpToPage(_currentIndex);
    }
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
                    isMuted: _isMuted,
                    statusMessage: widget.statusMessage,
                    dataSource: widget.dataSource,
                    onSwipeNext: () => _goToClip(index + 1),
                    onSwipePrevious: () => _goToClip(index - 1),
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
              left: 14,
              right: 14,
              top: 12,
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: _close,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Volver'),
                    style: _viewerNavigationButtonStyle(),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.34),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
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
              right: 17,
              top: 96,
              bottom: 28,
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
            Positioned(
              right: 14,
              top: 58,
              child: Tooltip(
                message: _isMuted ? 'Activar sonido' : 'Silenciar',
                child: Semantics(
                  button: true,
                  label: _isMuted ? 'Activar sonido' : 'Silenciar video',
                  child: IconButton.filled(
                    onPressed: () => setState(() => _isMuted = !_isMuted),
                    icon: Icon(
                      _isMuted
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.42),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(42, 42),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
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

  void _goToClip(int index) {
    if (index < 0 || index >= _clips.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _close() {
    final onCloseInline = widget.onCloseInline;
    if (onCloseInline != null) {
      onCloseInline(_clips);
      return;
    }
    Navigator.of(context).pop<List<ExploreClip>>(_clips);
  }
}

class _ViewerClipPage extends StatelessWidget {
  const _ViewerClipPage({
    super.key,
    required this.clip,
    required this.isActive,
    required this.isMuted,
    required this.statusMessage,
    required this.dataSource,
    required this.onSwipeNext,
    required this.onSwipePrevious,
    required this.onToggleLike,
    required this.onShare,
    required this.onToggleSave,
    required this.onComments,
    required this.onToggleFollow,
  });

  final ExploreClip clip;
  final bool isActive;
  final bool isMuted;
  final String? statusMessage;
  final SocialClipsDataSource dataSource;
  final VoidCallback onSwipeNext;
  final VoidCallback onSwipePrevious;
  final VoidCallback onToggleLike;
  final VoidCallback onShare;
  final VoidCallback onToggleSave;
  final VoidCallback onComments;
  final VoidCallback? onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final hasVideo = clip.hasPlayableVideo || !clip.isDemoContent;
    final thumbnail = clip.thumbnailAssetPath;
    final topMediaLabel = _mediaLabelFor(clip, dataSource);
    final originLabel = _originLabelFor(clip);
    final licenseLabel = _licenseLabelFor(clip);
    final creatorLabel =
        clip.authorDisplayName ??
        (clip.authorId == null ? originLabel : 'Creador ${clip.authorId}');
    final fallbackNotice = dataSource == SocialClipsDataSource.localFallback
        ? statusMessage
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _ClipVideoSurface(
              clip: clip,
              thumbnail: thumbnail,
              isActive: isActive,
              isMuted: isMuted,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.22),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.28),
                    Colors.black.withValues(alpha: 0.84),
                  ],
                  stops: const [0, 0.32, 0.58, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned.fill(
              child: _VerticalSwipeLayer(
                onNext: onSwipeNext,
                onPrevious: onSwipePrevious,
              ),
            ),
            Positioned(
              left: 18,
              right: 86,
              top: 82,
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  _ViewerBadge(label: topMediaLabel),
                  if (originLabel != null) _ViewerBadge(label: originLabel),
                  if (licenseLabel != null) _ViewerBadge(label: licenseLabel),
                  _ViewerBadge(label: clip.category),
                  _ViewerBadge(label: clip.animalType),
                ],
              ),
            ),
            if (fallbackNotice != null && fallbackNotice.trim().isNotEmpty)
              Positioned(
                left: 18,
                right: 86,
                top: 146,
                child: _ViewerNotice(label: fallbackNotice),
              ),
            Positioned(
              right: 10,
              bottom: 24,
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
              right: 90,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!hasVideo) const _ViewerBadge(label: 'Clip demo local'),
                  const SizedBox(height: 10),
                  if (creatorLabel != null) ...[
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.58),
                            ),
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            creatorLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                  ],
                  Text(
                    clip.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.65),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    clip.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.34,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.72),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_vert_rounded,
                        color: Colors.white.withValues(alpha: 0.74),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Desliza para ver mas clips',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.74),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
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

String _mediaLabelFor(ExploreClip clip, SocialClipsDataSource dataSource) {
  if (dataSource == SocialClipsDataSource.onlineCurated || clip.isCurated) {
    return 'Contenido curado';
  }
  if (clip.sourceType == 'userUpload') return 'Mascotify';
  if (clip.sourceType == 'licensedStock') return 'Video licenciado';
  if (clip.sourceType == 'sponsor') return 'Sponsor';
  if (clip.isDemoContent || clip.sourceType == 'seededDemo') {
    return dataSource == SocialClipsDataSource.localFallback
        ? 'Clip guardado'
        : 'Mascotify recomendado';
  }
  return 'Mascotify recomendado';
}

String? _originLabelFor(ExploreClip clip) {
  final contentOrigin = clip.contentOriginLabel.trim();
  if (contentOrigin.isNotEmpty && contentOrigin != 'Clip guardado') {
    return contentOrigin;
  }

  final provider = clip.sourceProvider.trim();
  if (provider.isNotEmpty && provider != 'Demo') return 'Fuente: $provider';

  return clip.sourceLabel;
}

String? _licenseLabelFor(ExploreClip clip) {
  final license = clip.licenseLabel?.trim();
  if (license == null || license.isEmpty) return null;
  if (license == 'Mascotify demo/local') return null;
  return license;
}

ButtonStyle _viewerNavigationButtonStyle() {
  return TextButton.styleFrom(
    backgroundColor: Colors.black.withValues(alpha: 0.34),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    minimumSize: const Size(0, 38),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(999),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
    ),
    textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
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

class _ViewerNotice extends StatelessWidget {
  const _ViewerNotice({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _VerticalSwipeLayer extends StatefulWidget {
  const _VerticalSwipeLayer({required this.onNext, required this.onPrevious});

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<_VerticalSwipeLayer> createState() => _VerticalSwipeLayerState();
}

class _VerticalSwipeLayerState extends State<_VerticalSwipeLayer> {
  double _dragDelta = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (_) => _dragDelta = 0,
      onVerticalDragUpdate: (details) {
        _dragDelta += details.primaryDelta ?? 0;
      },
      onVerticalDragEnd: (_) {
        final delta = _dragDelta;
        _dragDelta = 0;
        if (delta <= -80) {
          widget.onNext();
        } else if (delta >= 80) {
          widget.onPrevious();
        }
      },
    );
  }
}

class _ClipVideoSurface extends StatelessWidget {
  const _ClipVideoSurface({
    required this.clip,
    required this.thumbnail,
    required this.isActive,
    required this.isMuted,
  });

  final ExploreClip clip;
  final String? thumbnail;
  final bool isActive;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    if (clip.videoSourceType == 'asset' && clip.videoAssetPath != null) {
      return _AssetClipVideoPlayer(
        assetPath: clip.videoAssetPath!,
        isActive: isActive,
        isMuted: isMuted,
        loading: _buildLoadingSurface(context),
        fallback: _buildFallback('No pudimos reproducir este video'),
      );
    }

    if (clip.videoSourceType == 'network' && clip.videoUrl != null) {
      return _NetworkClipVideoPlayer(
        videoUrl: clip.videoUrl!,
        isActive: isActive,
        isMuted: isMuted,
        loading: _buildLoadingSurface(context),
        fallback: _buildFallback('No pudimos reproducir este video'),
      );
    }

    return _buildFallback('Fallback demo animado');
  }

  Widget _buildFallback(String message) {
    if (thumbnail == null && clip.thumbnailUrl == null) {
      return _ViewerPlaceholder(message: message);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        _ClipThumbnailImage(clip: clip, thumbnailAssetPath: thumbnail),
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

  Widget _buildLoadingSurface(BuildContext context) {
    final thumbnailPath = thumbnail;
    final thumbnailUrl = clip.thumbnailUrl;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnailPath != null || thumbnailUrl != null)
          _ClipThumbnailImage(clip: clip, thumbnailAssetPath: thumbnailPath)
        else
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF132326), Color(0xFF182A30)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.18),
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: PawLoadingIndicator(
              message: 'Cargando video...',
              foregroundColor: Colors.white,
              backgroundColor: AppColors.primaryDeep.withValues(alpha: 0.82),
              compact: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _ClipThumbnailImage extends StatelessWidget {
  const _ClipThumbnailImage({
    required this.clip,
    required this.thumbnailAssetPath,
  });

  final ExploreClip clip;
  final String? thumbnailAssetPath;

  @override
  Widget build(BuildContext context) {
    final assetPath = thumbnailAssetPath;
    if (assetPath != null) {
      return Image.asset(assetPath, fit: BoxFit.cover);
    }

    final url = clip.thumbnailUrl;
    if (url != null && url.trim().isNotEmpty) {
      return Image.network(url, fit: BoxFit.cover);
    }

    return const SizedBox.shrink();
  }
}

class _AssetClipVideoPlayer extends StatefulWidget {
  const _AssetClipVideoPlayer({
    required this.assetPath,
    required this.isActive,
    required this.isMuted,
    required this.loading,
    required this.fallback,
  });

  final String assetPath;
  final bool isActive;
  final bool isMuted;
  final Widget loading;
  final Widget fallback;

  @override
  State<_AssetClipVideoPlayer> createState() => _AssetClipVideoPlayerState();
}

class _AssetClipVideoPlayerState extends State<_AssetClipVideoPlayer> {
  VideoPlayerController? _controller;
  bool _hasError = false;
  bool _webVideoReady = false;

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
      _webVideoReady = false;
      _initialize();
    } else if (oldWidget.isActive != widget.isActive) {
      _syncPlayback();
    }
    if (oldWidget.isMuted != widget.isMuted) {
      _syncMuted();
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _initialize() async {
    if (kIsWeb) return;
    final controller = VideoPlayerController.asset(widget.assetPath);
    _controller = controller;
    controller.addListener(_onControllerChanged);
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(widget.isMuted ? 0 : 1);
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

  Future<void> _syncMuted() async {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      await controller.setVolume(widget.isMuted ? 0 : 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (_hasError) {
        return widget.fallback;
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          WebAssetClipVideoView(
            assetPath: widget.assetPath,
            isActive: widget.isActive,
            isMuted: widget.isMuted,
            onReady: () {
              if (mounted && !_webVideoReady) {
                setState(() => _webVideoReady = true);
              }
            },
            onError: () {
              if (mounted) {
                setState(() => _hasError = true);
              }
            },
          ),
          if (!_webVideoReady) widget.loading,
        ],
      );
    }

    final controller = _controller;
    if (_hasError || controller == null) {
      return widget.fallback;
    }
    if (!controller.value.isInitialized) {
      return widget.loading;
    }

    return _VideoPlayerFrame(controller: controller);
  }
}

class _NetworkClipVideoPlayer extends StatefulWidget {
  const _NetworkClipVideoPlayer({
    required this.videoUrl,
    required this.isActive,
    required this.isMuted,
    required this.loading,
    required this.fallback,
  });

  final String videoUrl;
  final bool isActive;
  final bool isMuted;
  final Widget loading;
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
    if (oldWidget.isMuted != widget.isMuted) {
      _syncMuted();
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
      await controller.setVolume(widget.isMuted ? 0 : 1);
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

  Future<void> _syncMuted() async {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      await controller.setVolume(widget.isMuted ? 0 : 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (_hasError || controller == null) {
      return widget.fallback;
    }
    if (!controller.value.isInitialized) {
      return widget.loading;
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          height: 1,
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
          const SizedBox(height: 2),
          _ReelActionButton(
            icon: Icons.mode_comment_outlined,
            label: '${clip.comments} comentarios',
            selected: false,
            onPressed: onComments,
          ),
          const SizedBox(height: 2),
          _ReelActionButton(
            icon: clip.isSaved
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            label: clip.isSaved ? 'Guardado' : 'Guardar',
            selected: clip.isSaved,
            selectedColor: AppColors.accentDeep,
            onPressed: onToggleSave,
          ),
          const SizedBox(height: 2),
          _ReelActionButton(
            icon: Icons.ios_share_rounded,
            label: clip.shares > 0 ? '${clip.shares} compartidos' : 'Compartir',
            selected: false,
            onPressed: onShare,
          ),
          if (clip.authorId != null && !clip.isDemoContent) ...[
            const SizedBox(height: 2),
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
      padding: const EdgeInsets.only(bottom: 9),
      child: SizedBox(
        width: 76,
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
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 25),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
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
