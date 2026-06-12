import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../../../../shared/models/social_models.dart';
import '../../../../shared/widgets/paw_loading_indicator.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import '../../../profile/presentation/screens/help_screen.dart';

const double _clipViewerAspectRatio = 480 / 854;
const double _clipViewerDesktopBreakpoint = 700;
const double _clipViewerDesktopMaxWidth = 420;
const double _clipViewerDesktopSideGutter = 48;
const double _clipViewerDesktopVerticalGutter = 16;
const double _clipPlaybackHudHeight = 58;
const double _clipPlaybackHudBottomMargin = 14;
const double _clipPlaybackHudReservedHeight =
    _clipPlaybackHudHeight + _clipPlaybackHudBottomMargin + 8;

class ExploreClipViewerScreen extends StatefulWidget {
  const ExploreClipViewerScreen({
    super.key,
    required this.clips,
    required this.initialClipId,
    this.onToggleLike,
    this.onShare,
    this.onToggleFollow,
    this.onCloseInline,
  });

  final List<ExploreClip> clips;
  final String initialClipId;
  final Future<ExploreClip> Function(ExploreClip clip)? onToggleLike;
  final Future<ExploreClip> Function(ExploreClip clip)? onShare;
  final Future<ExploreClip> Function(ExploreClip clip)? onToggleFollow;
  final ValueChanged<List<ExploreClip>>? onCloseInline;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final frameSize = _viewerFrameSizeFor(constraints);
        final isDesktopFrame =
            constraints.maxWidth >= _clipViewerDesktopBreakpoint;

        return Center(
          child: Container(
            key: const ValueKey('clips-vertical-frame'),
            width: frameSize.width,
            height: frameSize.height,
            decoration: BoxDecoration(
              color: const Color(0xFF070B0D),
              borderRadius: BorderRadius.circular(isDesktopFrame ? 28 : 0),
              border: isDesktopFrame
                  ? Border.all(color: Colors.white.withValues(alpha: 0.08))
                  : null,
              boxShadow: isDesktopFrame
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.38),
                        blurRadius: 36,
                        offset: const Offset(0, 20),
                      ),
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Semantics(
                  label: 'Feed vertical de clips',
                  child: PageView.builder(
                    key: const ValueKey('clips-vertical-page-view'),
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    clipBehavior: Clip.hardEdge,
                    itemCount: _clips.length,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemBuilder: (context, index) {
                      final clip = _clips[index];
                      return _ViewerClipPage(
                        key: ValueKey('clip-page-${clip.id}'),
                        clip: clip,
                        isActive: index == _currentIndex,
                        isMuted: _isMuted,
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
                      IconButton.filledTonal(
                        key: const ValueKey('clips-contextual-help'),
                        tooltip: 'Ayuda sobre Clips',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                const HelpScreen(initialTopic: HelpTopic.clips),
                          ),
                        ),
                        icon: const Icon(Icons.help_outline_rounded),
                      ),
                      const SizedBox(width: 8),
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                  bottom: _clipPlaybackHudReservedHeight + 18,
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
      },
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

Size _viewerFrameSizeFor(BoxConstraints constraints) {
  final availableWidth = constraints.maxWidth.isFinite
      ? constraints.maxWidth
      : _clipViewerDesktopMaxWidth;
  final availableHeight = constraints.maxHeight.isFinite
      ? constraints.maxHeight
      : _clipViewerDesktopMaxWidth / _clipViewerAspectRatio;
  final isDesktopFrame = availableWidth >= _clipViewerDesktopBreakpoint;

  if (!isDesktopFrame) {
    return Size(availableWidth, availableHeight);
  }

  final maxFrameHeight = (availableHeight - _clipViewerDesktopVerticalGutter)
      .clamp(0.0, double.infinity);
  final maxFrameWidth = (availableWidth - _clipViewerDesktopSideGutter).clamp(
    0.0,
    _clipViewerDesktopMaxWidth,
  );

  var width = maxFrameHeight * _clipViewerAspectRatio;
  if (width > maxFrameWidth) {
    width = maxFrameWidth;
  }
  var height = width / _clipViewerAspectRatio;
  if (height > maxFrameHeight) {
    height = maxFrameHeight;
    width = height * _clipViewerAspectRatio;
  }

  return Size(width, height);
}

class _ClipPlaybackState {
  const _ClipPlaybackState({
    this.progress = 0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.onSeek,
  });

  final double progress;
  final Duration position;
  final Duration duration;
  final ValueChanged<double>? onSeek;
}

class _ViewerClipPage extends StatefulWidget {
  const _ViewerClipPage({
    super.key,
    required this.clip,
    required this.isActive,
    required this.isMuted,
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
  final VoidCallback onSwipeNext;
  final VoidCallback onSwipePrevious;
  final VoidCallback onToggleLike;
  final VoidCallback onShare;
  final VoidCallback onToggleSave;
  final VoidCallback onComments;
  final VoidCallback? onToggleFollow;

  @override
  State<_ViewerClipPage> createState() => _ViewerClipPageState();
}

class _ViewerClipPageState extends State<_ViewerClipPage> {
  final ValueNotifier<_ClipPlaybackState> _playback = ValueNotifier(
    const _ClipPlaybackState(),
  );

  @override
  void didUpdateWidget(covariant _ViewerClipPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clip.id != widget.clip.id) {
      _playback.value = const _ClipPlaybackState();
    }
  }

  @override
  void dispose() {
    _playback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clip = widget.clip;
    final hasVideo = clip.hasPlayableVideo || !clip.isDemoContent;
    final thumbnail = clip.thumbnailAssetPath;
    final topMediaLabel = _mediaLabelFor(clip);
    final creatorLabel =
        clip.sourceLabel ??
        clip.authorDisplayName ??
        (clip.authorId == null ? null : 'Creador ${clip.authorId}');

    return RepaintBoundary(
      child: ColoredBox(
        color: const Color(0xFF070B0D),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              children: [
                _ClipVideoSurface(
                  clip: clip,
                  thumbnail: thumbnail,
                  isActive: widget.isActive,
                  isMuted: widget.isMuted,
                  playback: _playback,
                ),
                IgnorePointer(
                  child: Container(
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
                ),
                Positioned.fill(
                  bottom: _clipPlaybackHudReservedHeight,
                  child: _VerticalSwipeLayer(
                    onNext: widget.onSwipeNext,
                    onPrevious: widget.onSwipePrevious,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final metrics = ClipViewerMetrics.fromSize(
                      Size(constraints.maxWidth, constraints.maxHeight),
                    );
                    return Stack(
                      children: [
                        Positioned(
                          left: metrics.horizontalPadding,
                          right: metrics.actionRailWidth + 18,
                          top: metrics.topChipsOffset,
                          child: _ClipBadgeRow(
                            badges: _topBadgesFor(clip, topMediaLabel),
                            metrics: metrics,
                          ),
                        ),
                        Positioned(
                          right: metrics.horizontalPadding - 4,
                          bottom: metrics.actionRailBottom,
                          child: _ReelActionRail(
                            clip: clip,
                            metrics: metrics,
                            onToggleLike: widget.onToggleLike,
                            onComments: widget.onComments,
                            onToggleSave: widget.onToggleSave,
                            onShare: widget.onShare,
                            onToggleFollow: widget.onToggleFollow,
                          ),
                        ),
                        Positioned(
                          left: metrics.horizontalPadding,
                          right: metrics.actionRailWidth + 18,
                          bottom: metrics.bottomPadding,
                          child: _ClipBottomInfo(
                            clip: clip,
                            creatorLabel: creatorLabel,
                            hasVideo: hasVideo,
                            metrics: metrics,
                          ),
                        ),
                        Positioned(
                          left: metrics.horizontalPadding,
                          right: metrics.horizontalPadding,
                          bottom: _clipPlaybackHudBottomMargin,
                          child: ValueListenableBuilder<_ClipPlaybackState>(
                            valueListenable: _playback,
                            builder: (context, playback, _) {
                              return _ClipPlaybackHud(playback: playback);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ClipViewerMetrics {
  const ClipViewerMetrics({
    required this.frameWidth,
    required this.frameHeight,
    required this.scaleFactor,
    required this.actionButtonSize,
    required this.actionIconSize,
    required this.actionLabelFontSize,
    required this.chipFontSize,
    required this.chipHeight,
    required this.bottomTitleSize,
    required this.bottomCaptionSize,
    required this.bottomPadding,
    required this.sideRailSpacing,
    required this.seekBarHeight,
    required this.horizontalPadding,
    required this.topChipsOffset,
    required this.actionRailWidth,
    required this.actionRailBottom,
  });

  final double frameWidth;
  final double frameHeight;
  final double scaleFactor;
  final double actionButtonSize;
  final double actionIconSize;
  final double actionLabelFontSize;
  final double chipFontSize;
  final double chipHeight;
  final double bottomTitleSize;
  final double bottomCaptionSize;
  final double bottomPadding;
  final double sideRailSpacing;
  final double seekBarHeight;
  final double horizontalPadding;
  final double topChipsOffset;
  final double actionRailWidth;
  final double actionRailBottom;

  factory ClipViewerMetrics.fromSize(Size size) {
    final width = size.width.clamp(320.0, 460.0);
    final scale = (width / 390).clamp(0.9, 1.08);
    return ClipViewerMetrics(
      frameWidth: size.width,
      frameHeight: size.height,
      scaleFactor: scale,
      actionButtonSize: (44 * scale).clamp(42.0, 50.0),
      actionIconSize: (23 * scale).clamp(22.0, 26.0),
      actionLabelFontSize: (10.5 * scale).clamp(10.0, 12.0),
      chipFontSize: (11.5 * scale).clamp(11.0, 13.0),
      chipHeight: (30 * scale).clamp(28.0, 32.0),
      bottomTitleSize: (19 * scale).clamp(18.0, 21.0),
      bottomCaptionSize: (13 * scale).clamp(12.0, 14.0),
      bottomPadding:
          _clipPlaybackHudReservedHeight + (20 * scale).clamp(18.0, 28.0),
      sideRailSpacing: (7 * scale).clamp(5.0, 9.0),
      seekBarHeight: (6 * scale).clamp(5.0, 7.0),
      horizontalPadding: (16 * scale).clamp(14.0, 20.0),
      topChipsOffset: (76 * scale).clamp(68.0, 86.0),
      actionRailWidth: (62 * scale).clamp(58.0, 68.0),
      actionRailBottom:
          _clipPlaybackHudReservedHeight + (48 * scale).clamp(44.0, 58.0),
    );
  }
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
    required this.playback,
  });

  final ExploreClip clip;
  final String? thumbnail;
  final bool isActive;
  final bool isMuted;
  final ValueNotifier<_ClipPlaybackState> playback;

  @override
  Widget build(BuildContext context) {
    if (clip.videoSourceType == 'asset' && clip.videoAssetPath != null) {
      return _AssetClipVideoPlayer(
        assetPath: clip.videoAssetPath!,
        isActive: isActive,
        isMuted: isMuted,
        playback: playback,
        loading: _buildLoadingSurface(context),
        fallback: _buildFallback('No pudimos cargar este clip'),
      );
    }

    if (clip.videoSourceType == 'network' && clip.videoUrl != null) {
      return _NetworkClipVideoPlayer(
        videoUrl: clip.videoUrl!,
        isActive: isActive,
        isMuted: isMuted,
        playback: playback,
        loading: _buildLoadingSurface(context),
        fallback: _buildFallback('No pudimos cargar este clip'),
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

  Widget _buildLoadingSurface(BuildContext context) {
    final thumbnailPath = thumbnail;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (thumbnailPath != null)
          Image.asset(thumbnailPath, fit: BoxFit.cover)
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

String _mediaLabelFor(ExploreClip clip) {
  if (clip.sourceType == 'officialMascotify') return 'Mascotify';
  if (clip.videoSourceType == 'asset') return 'Video local';
  if (clip.videoSourceType == 'network') return 'Video remoto';
  if (clip.isDemoContent) return 'Demo';
  return 'Video remoto';
}

List<String> _topBadgesFor(ExploreClip clip, String mediaLabel) {
  final values = <String>[
    mediaLabel,
    if (clip.contentOriginLabel != null) clip.contentOriginLabel!,
    if (clip.sourceType != 'officialMascotify') clip.category,
  ];
  final maxBadges = clip.sourceType == 'officialMascotify' ? 2 : 3;
  return values.take(maxBadges).toList(growable: false);
}

class _ClipBadgeRow extends StatelessWidget {
  const _ClipBadgeRow({required this.badges, required this.metrics});

  final List<String> badges;
  final ClipViewerMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('clip-badge-row'),
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (var index = 0; index < badges.length; index++) ...[
              _ViewerBadge(label: badges[index], metrics: metrics),
              if (index < badges.length - 1) const SizedBox(width: 7),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClipBottomInfo extends StatelessWidget {
  const _ClipBottomInfo({
    required this.clip,
    required this.creatorLabel,
    required this.hasVideo,
    required this.metrics,
  });

  final ExploreClip clip;
  final String? creatorLabel;
  final bool hasVideo;
  final ClipViewerMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final creator = creatorLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hasVideo) _ViewerBadge(label: 'Clip demo local', metrics: metrics),
        if (!hasVideo) const SizedBox(height: 8),
        if (creator != null) ...[
          Row(
            children: [
              Container(
                width: 23,
                height: 23,
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
                  size: 13,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  creator,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontWeight: FontWeight.w800,
                    fontSize: metrics.bottomCaptionSize - 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
        ],
        Text(
          clip.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: metrics.bottomTitleSize,
            height: 1.05,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.65),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          clip.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: metrics.bottomCaptionSize,
            height: 1.26,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.72),
                blurRadius: 10,
              ),
            ],
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
    required this.isMuted,
    required this.playback,
    required this.loading,
    required this.fallback,
  });

  final String assetPath;
  final bool isActive;
  final bool isMuted;
  final ValueNotifier<_ClipPlaybackState> playback;
  final Widget loading;
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
    final controller = kIsWeb
        ? VideoPlayerController.networkUrl(
            Uri.base.resolve('assets/${widget.assetPath}'),
          )
        : VideoPlayerController.asset(widget.assetPath);
    _controller = controller;
    controller.addListener(_onControllerChanged);
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(widget.isMuted ? 0 : 1);
      await _syncPlayback();
      _publishPlayback();
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
    widget.playback.value = const _ClipPlaybackState();
  }

  void _onControllerChanged() {
    _publishPlayback();
    if (mounted) setState(() {});
  }

  void _publishPlayback() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      widget.playback.value = const _ClipPlaybackState();
      return;
    }
    final duration = controller.value.duration;
    final position = controller.value.position;
    final progress = duration.inMilliseconds <= 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    widget.playback.value = _ClipPlaybackState(
      progress: progress,
      position: position,
      duration: duration,
      onSeek: (value) {
        final target = duration * value;
        controller.seekTo(target);
      },
    );
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

class _NetworkClipVideoPlayer extends StatefulWidget {
  const _NetworkClipVideoPlayer({
    required this.videoUrl,
    required this.isActive,
    required this.isMuted,
    required this.playback,
    required this.loading,
    required this.fallback,
  });

  final String videoUrl;
  final bool isActive;
  final bool isMuted;
  final ValueNotifier<_ClipPlaybackState> playback;
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
      widget.playback.value = const _ClipPlaybackState();
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
    widget.playback.value = const _ClipPlaybackState();
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
      _publishPlayback();
      if (!mounted) return;
      setState(() {});
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasError = true);
    }
  }

  void _onControllerChanged() {
    _publishPlayback();
    if (mounted) setState(() {});
  }

  void _publishPlayback() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      widget.playback.value = const _ClipPlaybackState();
      return;
    }
    final duration = controller.value.duration;
    final position = controller.value.position;
    final progress = duration.inMilliseconds <= 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    widget.playback.value = _ClipPlaybackState(
      progress: progress,
      position: position,
      duration: duration,
      onSeek: (value) {
        final target = duration * value;
        controller.seekTo(target);
      },
    );
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
          ColoredBox(
            color: const Color(0xFF070B0D),
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
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
        ],
      ),
    );
  }
}

class _ClipPlaybackHud extends StatelessWidget {
  const _ClipPlaybackHud({required this.playback});

  final _ClipPlaybackState playback;

  @override
  Widget build(BuildContext context) {
    final onSeek = playback.onSeek;
    return SizedBox(
      key: const ValueKey('clip-video-seekbar-hud'),
      height: _clipPlaybackHudHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ClipTimeRow(
            position: playback.position,
            duration: playback.duration,
          ),
          const SizedBox(height: 5),
          ClipVideoSeekBar(
            progress: playback.progress,
            height: 9,
            onSeek: onSeek ?? (_) {},
          ),
        ],
      ),
    );
  }
}

class _ClipTimeRow extends StatelessWidget {
  const _ClipTimeRow({required this.position, required this.duration});

  final Duration position;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontFeatures: const [FontFeature.tabularFigures()],
      height: 1,
      letterSpacing: 0,
      shadows: [
        Shadow(color: Colors.black.withValues(alpha: 0.32), blurRadius: 6),
      ],
    );

    return Row(
      key: const ValueKey('clip-video-time-row'),
      children: [
        Text(
          _formatClipTime(position),
          key: const ValueKey('clip-video-current-time'),
          style: style,
        ),
        const Spacer(),
        Text(
          _formatClipTime(duration),
          key: const ValueKey('clip-video-duration-time'),
          style: style,
        ),
      ],
    );
  }
}

String _formatClipTime(Duration value) {
  final safeValue = value.isNegative ? Duration.zero : value;
  final minutes = safeValue.inMinutes.remainder(60);
  final seconds = safeValue.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class ClipVideoSeekBar extends StatelessWidget {
  const ClipVideoSeekBar({
    super.key,
    required this.progress,
    required this.onSeek,
    this.height = 10,
  });

  final double progress;
  final ValueChanged<double> onSeek;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        void seek(Offset localPosition) {
          final width = constraints.maxWidth <= 0 ? 1.0 : constraints.maxWidth;
          onSeek((localPosition.dx / width).clamp(0.0, 1.0));
        }

        return GestureDetector(
          key: const ValueKey('clip-video-seekbar'),
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => seek(details.localPosition),
          onHorizontalDragUpdate: (details) => seek(details.localPosition),
          child: Container(
            key: const ValueKey('clip-video-seekbar-control'),
            height: 28,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(999)),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  key: const ValueKey('clip-video-seekbar-track'),
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 1,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    key: const ValueKey('clip-video-seekbar-progress'),
                    height: height,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.42),
                          blurRadius: 14,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment((progress.clamp(0.0, 1.0) * 2) - 1, 0),
                  child: Container(
                    key: const ValueKey('clip-video-seekbar-thumb'),
                    width: height + 10,
                    height: height + 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF111820),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.42),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewerBadge extends StatelessWidget {
  const _ViewerBadge({required this.label, this.metrics});

  final String label;
  final ClipViewerMetrics? metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: metrics?.chipHeight,
      padding: const EdgeInsets.symmetric(horizontal: 9),
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
          fontSize: metrics?.chipFontSize ?? 11,
          height: 1,
        ),
      ),
    );
  }
}

class _ReelActionRail extends StatelessWidget {
  const _ReelActionRail({
    required this.clip,
    required this.metrics,
    required this.onToggleLike,
    required this.onComments,
    required this.onToggleSave,
    required this.onShare,
    required this.onToggleFollow,
  });

  final ExploreClip clip;
  final ClipViewerMetrics metrics;
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
            metrics: metrics,
            onPressed: onToggleLike,
          ),
          SizedBox(height: metrics.sideRailSpacing),
          _ReelActionButton(
            icon: Icons.mode_comment_outlined,
            label: '${clip.comments} comentarios',
            selected: false,
            metrics: metrics,
            onPressed: onComments,
          ),
          SizedBox(height: metrics.sideRailSpacing),
          _ReelActionButton(
            icon: clip.isSaved
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            label: clip.isSaved ? 'Guardado' : 'Guardar',
            selected: clip.isSaved,
            selectedColor: AppColors.accentDeep,
            metrics: metrics,
            onPressed: onToggleSave,
          ),
          SizedBox(height: metrics.sideRailSpacing),
          _ReelActionButton(
            icon: Icons.ios_share_rounded,
            label: clip.shares > 0 ? '${clip.shares} compartidos' : 'Compartir',
            selected: false,
            metrics: metrics,
            onPressed: onShare,
          ),
          if (clip.authorId != null && !clip.isDemoContent) ...[
            SizedBox(height: metrics.sideRailSpacing),
            _ReelActionButton(
              icon: clip.isFollowingAuthor
                  ? Icons.check_circle_rounded
                  : Icons.person_add_alt_1_rounded,
              label: clip.isFollowingAuthor ? 'Siguiendo' : 'Seguir',
              selected: clip.isFollowingAuthor,
              selectedColor: AppColors.success,
              metrics: metrics,
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
    required this.metrics,
    required this.onPressed,
    this.selectedColor = AppColors.primaryDeep,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final ClipViewerMetrics metrics;
  final VoidCallback onPressed;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? selectedColor : Colors.white;
    final backgroundColor = selected
        ? Colors.white.withValues(alpha: 0.94)
        : Colors.black.withValues(alpha: 0.38);

    return Padding(
      padding: EdgeInsets.zero,
      child: SizedBox(
        key: const ValueKey('clip-action-button'),
        width: metrics.actionRailWidth,
        child: Tooltip(
          message: label,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: metrics.actionButtonSize,
                  height: metrics.actionButtonSize,
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
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: metrics.actionIconSize,
                  ),
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
                    fontSize: metrics.actionLabelFontSize,
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
