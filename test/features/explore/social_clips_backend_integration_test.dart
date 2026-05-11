import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/data/social_clips_api_client.dart';
import 'package:mascotify/features/explore/data/social_clips_repository.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/clips_mock_data.dart';
import 'package:mascotify/shared/models/social_models.dart';

import '../../test_helpers.dart';

class _FakeSocialClipsRepository implements SocialClipsRepositoryPort {
  _FakeSocialClipsRepository.remote(this.remoteClips)
    : shouldFailFetch = false,
      source = SocialClipsDataSource.remote;

  _FakeSocialClipsRepository.failing()
    : remoteClips = const <ExploreClip>[],
      shouldFailFetch = true,
      source = SocialClipsDataSource.localFallback;

  final List<ExploreClip> remoteClips;
  final bool shouldFailFetch;
  final SocialClipsDataSource source;
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
        message: 'Mostrando clips demo locales',
      );
    }

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
    if (shouldFailFetch) {
      throw Exception('media disabled');
    }
    return ExploreClip(
      id: 'uploaded-remote',
      title: draft.title,
      description: draft.description,
      category: draft.category,
      animalType: draft.animalType,
      authorId: userId,
      cloudinaryPublicId: 'mascotify/clips/uploaded-remote',
      likes: 0,
      comments: 0,
      sourceLabel: 'Backend social',
      isDemoContent: false,
    );
  }
}

void main() {
  tearDown(() {
    AppData.source = const MockMascotifyDataSource();
  });

  testWidgets('si backend responde, Clips muestra feed remoto', (tester) async {
    setDesktopViewport(tester);
    final repository = _FakeSocialClipsRepository.remote(_remoteClips);

    await _openClips(tester, repository);

    expect(find.text('Clips sociales'), findsOneWidget);
    expect(find.text('Rescate remoto con final feliz'), findsOneWidget);
    expect(find.text('El gato que se adueno del sillon'), findsNothing);
  });

  testWidgets('si backend falla, Clips muestra fallback demo', (tester) async {
    setDesktopViewport(tester);

    await _openClips(tester, _FakeSocialClipsRepository.failing());

    expect(find.text('Clips demo locales'), findsOneWidget);
    expect(find.text('Mostrando clips demo locales'), findsOneWidget);
    expect(find.text('El gato que se adueno del sillon'), findsOneWidget);
  });

  testWidgets('like usa endpoint remoto cuando hay backend', (tester) async {
    setDesktopViewport(tester);
    final repository = _FakeSocialClipsRepository.remote(_remoteClips);

    await _openClips(tester, repository);
    await _scrollToText(tester, '10 likes');
    await tester.tap(find.text('10 likes'));
    await tester.pumpAndSettle();

    expect(repository.likeCalls, 1);
    expect(find.text('11 likes'), findsOneWidget);
  });

  testWidgets('share usa endpoint remoto cuando hay backend', (tester) async {
    setDesktopViewport(tester);
    final repository = _FakeSocialClipsRepository.remote(_remoteClips);

    await _openClips(tester, repository);
    await _scrollToText(tester, 'Compartir');
    await tester.tap(find.text('Compartir').first);
    await tester.pumpAndSettle();

    expect(repository.shareCalls, 1);
    expect(find.text('1 compartidos'), findsOneWidget);
  });

  testWidgets('follow usa endpoint remoto cuando hay backend', (tester) async {
    setDesktopViewport(tester);
    final repository = _FakeSocialClipsRepository.remote(_remoteClips);

    await _openClips(tester, repository);
    await _scrollToText(tester, 'Seguir creador');
    await tester.tap(find.text('Seguir creador').first);
    await tester.pumpAndSettle();

    expect(repository.followCalls, 1);
    expect(find.text('Siguiendo'), findsWidgets);
  });

  testWidgets('error de backend no rompe Explorar', (tester) async {
    setDesktopViewport(tester);

    await _openClips(tester, _FakeSocialClipsRepository.failing());
    await tester.tap(find.text('Ecosistema'));
    await tester.pumpAndSettle();

    expect(find.text('Ecosistema social'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filtros siguen funcionando con datos remotos', (tester) async {
    setDesktopViewport(tester);

    await _openClips(tester, _FakeSocialClipsRepository.remote(_remoteClips));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Bloopers'));
    await tester.pumpAndSettle();

    expect(find.text('Bloopers remotos de cachorros'), findsOneWidget);
    expect(find.text('Rescate remoto con final feliz'), findsNothing);
  });

  testWidgets('visor abre clip remoto', (tester) async {
    setDesktopViewport(tester);

    await _openClips(tester, _FakeSocialClipsRepository.remote(_remoteClips));
    await _scrollToText(tester, 'Rescate remoto con final feliz');
    await tester.tap(find.text('Rescate remoto con final feliz'));
    await tester.pumpAndSettle();

    expect(find.text('Visor de clips'), findsOneWidget);
    expect(find.text('Rescate remoto con final feliz'), findsOneWidget);
    expect(find.text('Rescates'), findsWidgets);
  });

  testWidgets('mobile viewport no crashea con feed remoto', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openClips(tester, _FakeSocialClipsRepository.remote(_remoteClips));

    expect(find.text('Clips sociales'), findsOneWidget);
    expect(find.text('Rescate remoto con final feliz'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('boton Subir clip aparece en Clips', (tester) async {
    setDesktopViewport(tester);

    await _openClips(tester, _FakeSocialClipsRepository.remote(_remoteClips));

    expect(find.text('Subir clip'), findsOneWidget);
  });

  testWidgets(
    'si backend de medios no esta configurado muestra feedback seguro',
    (tester) async {
      setDesktopViewport(tester);

      await _openClips(tester, _FakeSocialClipsRepository.failing());
      await tester.tap(find.text('Subir clip'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Publicar'));
      await tester.pumpAndSettle();

      expect(
        find.text('Completa titulo, descripcion y selecciona un video.'),
        findsOneWidget,
      );
    },
  );
}

Future<void> _openClips(
  WidgetTester tester,
  SocialClipsRepositoryPort repository,
) async {
  await tester.pumpWidget(
    buildTestApp(ExploreScreen(socialClipsRepository: repository)),
  );
  await tester.tap(find.text('Clips'));
  await tester.pumpAndSettle();
}

Future<void> _scrollToText(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(
    find.text(text).first,
    320,
    scrollable: find.byType(Scrollable).first,
  );
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
    isDemoContent: false,
  ),
];
