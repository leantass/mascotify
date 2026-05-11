import '../../../core/app_environment.dart';
import '../../../shared/data/app_data_source.dart';
import '../../../shared/models/social_models.dart';
import 'social_clips_api_client.dart';

enum SocialClipsDataSource { remote, localFallback }

class SocialClipsLoadResult {
  const SocialClipsLoadResult({
    required this.clips,
    required this.source,
    this.message,
  });

  final List<ExploreClip> clips;
  final SocialClipsDataSource source;
  final String? message;

  bool get isRemote => source == SocialClipsDataSource.remote;
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
  }) : _apiClient =
           apiClient ??
           SocialClipsApiClient(baseUrl: AppEnvironment.socialClipsApiBaseUrl),
       _fallbackClipsProvider =
           fallbackClipsProvider ?? (() => AppData.exploreClips);

  final SocialClipsApiClientPort _apiClient;
  final List<ExploreClip> Function() _fallbackClipsProvider;

  @override
  Future<SocialClipsLoadResult> fetchFeed({required String userId}) async {
    try {
      final remoteClips = await _apiClient.fetchFeed(userId: userId);

      if (remoteClips.isEmpty) {
        return SocialClipsLoadResult(
          clips: _fallbackClipsProvider(),
          source: SocialClipsDataSource.localFallback,
          message: 'Mostrando clips demo locales',
        );
      }

      return SocialClipsLoadResult(
        clips: remoteClips,
        source: SocialClipsDataSource.remote,
      );
    } catch (_) {
      return SocialClipsLoadResult(
        clips: _fallbackClipsProvider(),
        source: SocialClipsDataSource.localFallback,
        message: 'Mostrando clips demo locales',
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
}

ExploreClip _toggleLocalLike(ExploreClip clip) {
  final nextLiked = !clip.isLiked;
  return clip.copyWith(
    isLiked: nextLiked,
    likes: nextLiked ? clip.likes + 1 : clip.likes - 1,
  );
}
