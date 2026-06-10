import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/data/social_clips_api_client.dart';
import 'package:mascotify/features/explore/data/social_clips_repository.dart';
import 'package:mascotify/shared/models/social_models.dart';

void main() {
  test('prioriza feed online cuando esta configurado', () async {
    final repository = SocialClipsRepository(
      apiClient: _FakeApiClient(clips: <ExploreClip>[_onlineClip]),
      fallbackClipsProvider: () => <ExploreClip>[_fallbackClip],
      onlineClipsEnabled: true,
      onlineClipsUseBackend: true,
      fallbackLocalClipsEnabled: true,
    );

    final result = await repository.fetchFeed(userId: 'user');

    expect(result.clips.single.id, 'online-01');
    expect(result.source, SocialClipsDataSource.onlineCurated);
    expect(result.isFallback, isFalse);
  });

  test('si feed online falla usa fallback local con mensaje offline', () async {
    final repository = SocialClipsRepository(
      apiClient: _FakeApiClient(throwsOnFeed: true),
      fallbackClipsProvider: () => <ExploreClip>[_fallbackClip],
      onlineClipsEnabled: true,
      onlineClipsUseBackend: true,
      fallbackLocalClipsEnabled: true,
    );

    final result = await repository.fetchFeed(userId: 'user');

    expect(result.clips.single.id, 'fallback-01');
    expect(result.source, SocialClipsDataSource.localFallback);
    expect(result.fallbackReason, SocialClipsFallbackReason.offlineOrError);
    expect(result.message, 'Sin conexion. Te mostramos clips guardados.');
  });

  test('cuando online esta desactivado usa fallback local demo', () async {
    final repository = SocialClipsRepository(
      apiClient: _FakeApiClient(clips: <ExploreClip>[_onlineClip]),
      fallbackClipsProvider: () => <ExploreClip>[_fallbackClip],
      onlineClipsEnabled: false,
      onlineClipsUseBackend: false,
      fallbackLocalClipsEnabled: true,
    );

    final result = await repository.fetchFeed(userId: 'user');

    expect(result.clips.single.id, 'fallback-01');
    expect(result.source, SocialClipsDataSource.localFallback);
    expect(result.fallbackReason, SocialClipsFallbackReason.onlineDisabled);
  });
}

class _FakeApiClient implements SocialClipsApiClientPort {
  const _FakeApiClient({
    this.clips = const <ExploreClip>[],
    this.throwsOnFeed = false,
  });

  final List<ExploreClip> clips;
  final bool throwsOnFeed;

  @override
  Future<List<ExploreClip>> fetchFeed({required String userId}) async {
    if (throwsOnFeed) throw Exception('offline');
    return clips;
  }

  @override
  Future<ExploreClip> createClip({
    required String userId,
    required ClipUploadDraft draft,
    required CloudinaryUploadResult uploadResult,
  }) => throw UnimplementedError();

  @override
  Future<void> followUser({required String authorId, required String userId}) =>
      throw UnimplementedError();

  @override
  Future<ExploreClip> likeClip({
    required String clipId,
    required String userId,
  }) => throw UnimplementedError();

  @override
  Future<CloudinaryUploadSignature> requestUploadSignature({
    required String userId,
  }) => throw UnimplementedError();

  @override
  Future<ExploreClip> shareClip({
    required String clipId,
    required String userId,
  }) => throw UnimplementedError();

  @override
  Future<void> unfollowUser({
    required String authorId,
    required String userId,
  }) => throw UnimplementedError();

  @override
  Future<ExploreClip> unlikeClip({
    required String clipId,
    required String userId,
  }) => throw UnimplementedError();

  @override
  Future<CloudinaryUploadResult> uploadVideo({
    required CloudinaryUploadSignature signature,
    required SelectedClipVideo video,
  }) => throw UnimplementedError();
}

final _onlineClip = ExploreClip(
  id: 'online-01',
  title: 'Bloopers online',
  description: 'Contenido curado por backend autorizado.',
  category: 'Bloopers',
  animalType: 'Perro',
  videoSourceType: 'network',
  videoUrl: 'https://cdn.example.com/online.mp4',
  likes: 4,
  comments: 1,
  sourceType: 'licensedStock',
  sourceProvider: 'Pexels',
  licenseLabel: 'Pexels License',
  isExternalContent: true,
  isCurated: true,
  moderationStatus: 'published',
  contentOriginLabel: 'Fuente: Pexels',
  isDemoContent: false,
);

const _fallbackClip = ExploreClip(
  id: 'fallback-01',
  title: 'Fallback local',
  description: 'Clip guardado para modo offline.',
  category: 'Juego',
  animalType: 'Perro',
  videoSourceType: 'asset',
  videoAssetPath: 'assets/videos/clips/fallback.mp4',
  likes: 1,
  comments: 0,
);
