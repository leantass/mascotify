import '../../../core/app_environment.dart';
import '../../../shared/data/app_data_source.dart';
import '../../../shared/models/social_models.dart';
import 'social_clips_api_client.dart';

enum SocialClipsDataSource { remote, onlineCurated, localFallback }

enum SocialClipsFallbackReason { onlineDisabled, emptyFeed, offlineOrError }

class SocialClipsLoadResult {
  const SocialClipsLoadResult({
    required this.clips,
    required this.source,
    this.message,
    this.fallbackReason,
  });

  final List<ExploreClip> clips;
  final SocialClipsDataSource source;
  final String? message;
  final SocialClipsFallbackReason? fallbackReason;

  bool get isRemote =>
      source == SocialClipsDataSource.remote ||
      source == SocialClipsDataSource.onlineCurated;
  bool get isFallback => source == SocialClipsDataSource.localFallback;
}

abstract interface class SocialClipsRepositoryPort {
  Future<SocialClipsLoadResult> fetchFeed({required String userId});
  Future<ExploreClip> likeClip(ExploreClip clip, {required String userId});
  Future<ExploreClip> unlikeClip(ExploreClip clip, {required String userId});
  Future<ExploreClip> shareClip(ExploreClip clip, {required String userId});
  Future<void> followAuthor(ExploreClip clip, {required String userId});
  Future<void> unfollowAuthor(ExploreClip clip, {required String userId});
  Future<ExploreClip> uploadClip({
    required String userId,
    required ClipUploadDraft draft,
    required SelectedClipVideo video,
  });
}

class SocialClipsRepository implements SocialClipsRepositoryPort {
  SocialClipsRepository({
    SocialClipsApiClientPort? apiClient,
    List<ExploreClip> Function()? fallbackClipsProvider,
    bool? onlineClipsEnabled,
    bool? onlineClipsUseBackend,
    bool? fallbackLocalClipsEnabled,
  }) : _apiClient =
           apiClient ??
           SocialClipsApiClient(baseUrl: AppEnvironment.socialClipsApiBaseUrl),
       _fallbackClipsProvider =
           fallbackClipsProvider ?? (() => AppData.exploreClips),
       _onlineClipsEnabled =
           onlineClipsEnabled ?? AppEnvironment.onlineClipsEnabled,
       _onlineClipsUseBackend =
           onlineClipsUseBackend ?? AppEnvironment.onlineClipsUseBackend,
       _fallbackLocalClipsEnabled =
           fallbackLocalClipsEnabled ??
           AppEnvironment.fallbackLocalClipsEnabled;

  final SocialClipsApiClientPort _apiClient;
  final List<ExploreClip> Function() _fallbackClipsProvider;
  final bool _onlineClipsEnabled;
  final bool _onlineClipsUseBackend;
  final bool _fallbackLocalClipsEnabled;

  @override
  Future<SocialClipsLoadResult> fetchFeed({required String userId}) async {
    if (!_onlineClipsEnabled || !_onlineClipsUseBackend) {
      return _fallbackResult(
        message: 'Clips guardados listos',
        reason: SocialClipsFallbackReason.onlineDisabled,
      );
    }

    try {
      final remoteClips = await _apiClient.fetchFeed(userId: userId);

      if (remoteClips.isEmpty) {
        return _fallbackResult(
          message: 'No pudimos actualizar clips ahora.',
          reason: SocialClipsFallbackReason.emptyFeed,
        );
      }

      return SocialClipsLoadResult(
        clips: remoteClips,
        source: remoteClips.any((clip) => clip.isCurated)
            ? SocialClipsDataSource.onlineCurated
            : SocialClipsDataSource.remote,
        message: 'Clips actualizados',
      );
    } catch (_) {
      return _fallbackResult(
        message: 'Sin conexion. Te mostramos clips guardados.',
        reason: SocialClipsFallbackReason.offlineOrError,
      );
    }
  }

  @override
  Future<ExploreClip> likeClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    if (clip.isDemoContent) return _toggleLocalLike(clip);
    return _apiClient.likeClip(clipId: clip.id, userId: userId);
  }

  @override
  Future<ExploreClip> unlikeClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    if (clip.isDemoContent) return _toggleLocalLike(clip);
    return _apiClient.unlikeClip(clipId: clip.id, userId: userId);
  }

  @override
  Future<ExploreClip> shareClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    if (clip.isDemoContent) return clip.copyWith(shares: clip.shares + 1);
    return _apiClient.shareClip(clipId: clip.id, userId: userId);
  }

  @override
  Future<void> followAuthor(ExploreClip clip, {required String userId}) async {
    final authorId = clip.authorId;
    if (clip.isDemoContent || authorId == null) return;
    await _apiClient.followUser(authorId: authorId, userId: userId);
  }

  @override
  Future<void> unfollowAuthor(
    ExploreClip clip, {
    required String userId,
  }) async {
    final authorId = clip.authorId;
    if (clip.isDemoContent || authorId == null) return;
    await _apiClient.unfollowUser(authorId: authorId, userId: userId);
  }

  @override
  Future<ExploreClip> uploadClip({
    required String userId,
    required ClipUploadDraft draft,
    required SelectedClipVideo video,
  }) async {
    final signature = await _apiClient.requestUploadSignature(userId: userId);
    final uploadResult = await _apiClient.uploadVideo(
      signature: signature,
      video: video,
    );
    return _apiClient.createClip(
      userId: userId,
      draft: draft,
      uploadResult: uploadResult,
    );
  }

  SocialClipsLoadResult _fallbackResult({
    required String message,
    required SocialClipsFallbackReason reason,
  }) {
    final fallbackClips = _fallbackLocalClipsEnabled
        ? _fallbackClipsProvider()
        : const <ExploreClip>[];
    return SocialClipsLoadResult(
      clips: fallbackClips,
      source: SocialClipsDataSource.localFallback,
      message: message,
      fallbackReason: reason,
    );
  }
}

ExploreClip _toggleLocalLike(ExploreClip clip) {
  final nextLiked = !clip.isLiked;
  return clip.copyWith(
    isLiked: nextLiked,
    likes: nextLiked ? clip.likes + 1 : clip.likes - 1,
  );
}
