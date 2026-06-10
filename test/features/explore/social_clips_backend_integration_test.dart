import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/data/social_clips_api_client.dart';
import 'package:mascotify/features/explore/data/social_clips_repository.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/clips_mock_data.dart';
import 'package:mascotify/shared/models/social_models.dart';
import 'package:mascotify/shared/widgets/paw_loading_indicator.dart';

import '../../test_helpers.dart';

class _FakeSocialClipsRepository implements SocialClipsRepositoryPort {
  _FakeSocialClipsRepository.remote(this.remoteClips)
    : shouldFailFetch = false,
      source = SocialClipsDataSource.remote,
      completer = null;

  _FakeSocialClipsRepository.failing()
    : remoteClips = const <ExploreClip>[],
      shouldFailFetch = true,
      source = SocialClipsDataSource.localFallback,
      completer = null;

  _FakeSocialClipsRepository.delayed(this.completer)
    : remoteClips = const <ExploreClip>[],
      shouldFailFetch = false,
      source = SocialClipsDataSource.remote;

  final List<ExploreClip> remoteClips;
  final bool shouldFailFetch;
  final SocialClipsDataSource source;
  final Completer<SocialClipsLoadResult>? completer;
  int likeCalls = 0;
  int unlikeCalls = 0;
  int shareCalls = 0;
  int followCalls = 0;
  int unfollowCalls = 0;
  int uploadCalls = 0;

  @override
  Future<SocialClipsLoadResult> fetchFeed({required String userId}) async {
    if (shouldFailFetch) {
      return SocialClipsLoadResult(
        clips: ClipsMockData.clips,
        source: SocialClipsDataSource.localFallback,
        message: 'Sin conexion. Te mostramos clips guardados.',
        fallbackReason: SocialClipsFallbackReason.offlineOrError,
      );
    }
    final delayedResult = completer;
    if (delayedResult != null) return delayedResult.future;

    return SocialClipsLoadResult(clips: remoteClips, source: source);
  }

  @override
  Future<ExploreClip> likeClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    likeCalls += 1;
    return clip.copyWith(isLiked: true, likes: clip.likes + 1);
  }

  @override
  Future<ExploreClip> unlikeClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    unlikeCalls += 1;
    return clip.copyWith(isLiked: false, likes: clip.likes - 1);
  }

  @override
  Future<ExploreClip> shareClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    shareCalls += 1;
    return clip.copyWith(shares: clip.shares + 1);
  }

  @override
  Future<void> followAuthor(ExploreClip clip, {required String userId}) async {
    followCalls += 1;
  }

  @override
  Future<void> unfollowAuthor(
    ExploreClip clip, {
    required String userId,
  }) async {
    unfollowCalls += 1;
  }

  @override
  Future<ExploreClip> uploadClip({
    required String userId,
    required ClipUploadDraft draft,
    required SelectedClipVideo video,
  }) async {
    uploadCalls += 1;
    throw Exception('media disabled');
  }
}

void main() {
  tearDown(() {
    AppData.source = const MockMascotifyDataSource();
  });

  testWidgets('si backend responde, Clips abre feed remoto en visor', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final repository = _FakeSocialClipsRepository.remote(_remoteClips);

    await _openClips(tester, repository);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Rescate remoto con final feliz'), findsOneWidget);
    expect(find.text('Fuente: Pexels'), findsOneWidget);
    expect(find.text('Pexels License'), findsOneWidget);
    expect(find.text('Comunidad inicial'), findsNothing);
    expect(find.text('El gato que se adueno del sillon'), findsNothing);
  });

  testWidgets('si backend falla, Clips abre fallback local reproducible', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await _openClips(tester, _FakeSocialClipsRepository.failing());

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('El gato que se adueno del sillon'), findsOneWidget);
    expect(
      find.text('Sin conexion. Te mostramos clips guardados.'),
      findsOneWidget,
    );
  });

  testWidgets('Clips muestra PawLoadingIndicator durante carga inicial', (
    tester,
  ) async {
    setDesktopViewport(tester);
    final completer = Completer<SocialClipsLoadResult>();
    final repository = _FakeSocialClipsRepository.delayed(completer);

    await tester.pumpWidget(
      buildTestApp(ExploreScreen(socialClipsRepository: repository)),
    );
    await tester.pump();
    await tester.tap(find.text('Clips'));
    await tester.pump();

    expect(find.byType(PawLoadingIndicator), findsOneWidget);
    expect(find.text('Cargando clips...'), findsOneWidget);

    completer.complete(
      SocialClipsLoadResult(
        clips: _remoteClips,
        source: SocialClipsDataSource.remote,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PageView), findsOneWidget);
  });

  testWidgets('like usa endpoint remoto cuando hay backend', (tester) async {
    setDesktopViewport(tester);
    final repository = _FakeSocialClipsRepository.remote(_remoteClips);

    await _openClips(tester, repository);
    await tester.tap(find.text('10 likes'));
    await tester.pumpAndSettle();

    expect(repository.likeCalls, 1);
    expect(find.text('11 likes'), findsOneWidget);
  });

  testWidgets('share usa endpoint remoto cuando hay backend', (tester) async {
    setDesktopViewport(tester);
    final repository = _FakeSocialClipsRepository.remote(_remoteClips);

    await _openClips(tester, repository);
    await tester.tap(find.text('Compartir'));
    await tester.pumpAndSettle();

    expect(repository.shareCalls, 1);
    expect(find.text('1 compartidos'), findsOneWidget);
  });

  testWidgets('follow usa endpoint remoto cuando hay backend', (tester) async {
    setDesktopViewport(tester);
    final repository = _FakeSocialClipsRepository.remote(_remoteClips);

    await _openClips(tester, repository);
    await tester.tap(find.text('Seguir'));
    await tester.pumpAndSettle();

    expect(repository.followCalls, 1);
    expect(find.text('Siguiendo'), findsOneWidget);
  });

  testWidgets('volver desde fallback no rompe Explorar', (tester) async {
    setDesktopViewport(tester);

    await _openClips(tester, _FakeSocialClipsRepository.failing());
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();

    expect(find.text('Ecosistema social'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile viewport no crashea con feed remoto', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openClips(tester, _FakeSocialClipsRepository.remote(_remoteClips));

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Rescate remoto con final feliz'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _openClips(
  WidgetTester tester,
  SocialClipsRepositoryPort repository,
) async {
  await tester.pumpWidget(
    buildTestApp(ExploreScreen(socialClipsRepository: repository)),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Clips'));
  await tester.pumpAndSettle();
}

final _remoteClips = <ExploreClip>[
  const ExploreClip(
    id: 'remote-01',
    title: 'Rescate remoto con final feliz',
    description: 'Un clip servido por el backend social de Mascotify.',
    category: 'Rescates',
    animalType: 'Perro',
    authorId: 'author-remote-01',
    likes: 10,
    comments: 2,
    sourceLabel: 'Backend social',
    sourceType: 'licensedStock',
    sourceProvider: 'Pexels',
    licenseLabel: 'Pexels License',
    isExternalContent: true,
    isCurated: true,
    contentOriginLabel: 'Fuente: Pexels',
    isDemoContent: false,
  ),
  const ExploreClip(
    id: 'remote-02',
    title: 'Bloopers remotos de cachorros',
    description: 'Cachorros aprendiendo con mucho humor.',
    category: 'Bloopers',
    animalType: 'Perro',
    authorId: 'author-remote-02',
    likes: 3,
    comments: 1,
    sourceLabel: 'Backend social',
    sourceType: 'licensedStock',
    sourceProvider: 'Pixabay',
    licenseLabel: 'Pixabay Content License',
    isExternalContent: true,
    isCurated: true,
    contentOriginLabel: 'Fuente: Pixabay',
    isDemoContent: false,
  ),
];
