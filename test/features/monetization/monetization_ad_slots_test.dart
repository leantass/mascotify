import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/data/social_clips_api_client.dart';
import 'package:mascotify/features/explore/data/social_clips_repository.dart';
import 'package:mascotify/features/explore/presentation/screens/conversation_screen.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/features/explore/presentation/screens/messages_inbox_screen.dart';
import 'package:mascotify/features/explore/presentation/screens/professionals_screen.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/home/presentation/screens/activity_feed_screen.dart';
import 'package:mascotify/features/lost_pets/presentation/screens/lost_pets_screen.dart';
import 'package:mascotify/features/monetization/data/admob_ad_units.dart';
import 'package:mascotify/features/monetization/data/local_monetization_repository.dart';
import 'package:mascotify/features/monetization/domain/ad_placement.dart';
import 'package:mascotify/features/monetization/domain/ads_service.dart';
import 'package:mascotify/features/monetization/presentation/ad_slot.dart';
import 'package:mascotify/features/monetization/presentation/rewarded_action_button.dart';
import 'package:mascotify/features/monetization/presentation/sponsored_card.dart';
import 'package:mascotify/features/pets/presentation/screens/pet_detail_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/pet_health_screen.dart';
import 'package:mascotify/features/pets/presentation/screens/qr_traceability_screen.dart';
import 'package:mascotify/features/profile/presentation/screens/profile_screen.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/app_user.dart';
import 'package:mascotify/shared/models/social_models.dart';

import '../../test_helpers.dart';

void main() {
  tearDown(() {
    AppData.source = const MockMascotifyDataSource();
  });

  test('plan flags keep interstitial ads disabled by default', () {
    final repository = const LocalMonetizationRepository(
      planNameOverride: 'Mascotify Free',
    );

    expect(repository.flags.interstitialAdsEnabled, isFalse);
    expect(
      repository.shouldShowPlacement(AdPlacement.activityFeedBanner),
      isTrue,
    );
  });

  test(
    'AdMob configuration keeps real IDs registered but disabled by default',
    () {
      final repository = const LocalMonetizationRepository(
        planNameOverride: 'Mascotify Free',
      );

      expect(
        AdMobAdUnits.androidAppId,
        'ca-app-pub-7918381399703521~3080162315',
      );
      expect(
        AdMobAdUnits.realBannerAndroid,
        'ca-app-pub-7918381399703521/2571375944',
      );
      expect(
        AdMobAdUnits.realNativeAndroid,
        'ca-app-pub-7918381399703521/2786998366',
      );
      expect(
        AdMobAdUnits.realRewardedAndroid,
        'ca-app-pub-7918381399703521/3651007955',
      );
      expect(AdMobAdUnits.admobEnabled, isFalse);
      expect(AdMobAdUnits.useRealAdMobIds, isFalse);
      expect(AdMobAdUnits.bannerAndroid, AdMobAdUnits.testBannerAndroid);
      expect(AdMobAdUnits.nativeAndroid, AdMobAdUnits.testNativeAndroid);
      expect(AdMobAdUnits.rewardedAndroid, AdMobAdUnits.testRewardedAndroid);
      expect(repository.flags.admobEnabled, isFalse);
      expect(repository.flags.useRealAdMobIds, isFalse);
    },
  );

  testWidgets('AdSlot is hidden on explicitly blocked sensitive surfaces', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        const AdSlot(
          placement: AdPlacement.generalPassiveBanner,
          blockedSurface: AdBlockedSurface.petHealth,
          repository: LocalMonetizationRepository(
            planNameOverride: 'Mascotify Free',
          ),
        ),
      ),
    );

    expect(find.text('Anuncio'), findsNothing);
    expect(find.byType(AdSlot), findsOneWidget);
  });

  testWidgets('Free can see ad placeholders in Explorar', (tester) async {
    setDesktopViewport(tester);
    AppData.source = const _PlanDataSource('Mascotify Free');

    await tester.pumpWidget(
      buildTestApp(
        ExploreScreen(socialClipsRepository: const _FakeClipsRepository()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Anuncio'), findsOneWidget);
    expect(find.text('Espacio publicitario reservado'), findsOneWidget);
  });

  testWidgets('Free can see clips placeholder and rewarded demo action', (
    tester,
  ) async {
    setDesktopViewport(tester);
    AppData.source = const _PlanDataSource('Mascotify Free');

    await tester.pumpWidget(
      buildTestApp(
        ExploreScreen(socialClipsRepository: const _FakeClipsRepository()),
      ),
    );
    await tester.tap(find.text('Clips'));
    await tester.pumpAndSettle();

    expect(find.text('Anuncio'), findsOneWidget);
    expect(find.text('Ver anuncio para subir un clip extra'), findsOneWidget);

    await tester.tap(find.text('Ver anuncio para subir un clip extra'));
    await tester.pumpAndSettle();
    expect(find.text('Recompensa demo aplicada.'), findsOneWidget);
  });

  testWidgets('rewarded action only grants test reward after completion', (
    tester,
  ) async {
    final service = _FakeAdsService(RewardedAdOutcome.earned);
    await tester.pumpWidget(
      buildTestApp(
        RewardedActionButton(
          placement: AdPlacement.clipExtraRewarded,
          label: 'Ver anuncio para subir un clip extra',
          repository: _admobEnabledFreeRepository,
          adsService: service,
        ),
      ),
    );

    expect(service.showCount, 0);
    await tester.tap(find.text('Ver anuncio para subir un clip extra'));
    await tester.pumpAndSettle();

    expect(service.showCount, 1);
    expect(find.text('Recompensa de prueba aplicada.'), findsOneWidget);
  });

  testWidgets(
    'rewarded action does not grant reward when ad is not completed',
    (tester) async {
      final service = _FakeAdsService(RewardedAdOutcome.failed);
      await tester.pumpWidget(
        buildTestApp(
          RewardedActionButton(
            placement: AdPlacement.clipExtraRewarded,
            label: 'Ver anuncio para subir un clip extra',
            repository: _admobEnabledFreeRepository,
            adsService: service,
          ),
        ),
      );

      await tester.tap(find.text('Ver anuncio para subir un clip extra'));
      await tester.pumpAndSettle();

      expect(service.showCount, 1);
      expect(find.text('No se aplico la recompensa.'), findsOneWidget);
      expect(find.text('Recompensa de prueba aplicada.'), findsNothing);
    },
  );

  testWidgets('Free can see activity feed controlled banner', (tester) async {
    setDesktopViewport(tester);
    AppData.source = const _PlanDataSource('Mascotify Free');

    await tester.pumpWidget(buildTestApp(const ActivityFeedScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Anuncio'), findsOneWidget);
    expect(find.text('Espacio publicitario reservado'), findsOneWidget);
  });

  testWidgets('Plus and Pro do not see ad monetization placeholders', (
    tester,
  ) async {
    setDesktopViewport(tester);

    for (final planName in ['Mascotify Plus', 'Mascotify Pro']) {
      AppData.source = _PlanDataSource(planName);
      await tester.pumpWidget(
        buildTestApp(
          ExploreScreen(socialClipsRepository: const _FakeClipsRepository()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Anuncio'), findsNothing);
      expect(find.text('Espacio publicitario reservado'), findsNothing);

      await tester.tap(find.text('Clips'));
      await tester.pumpAndSettle();
      expect(find.text('Ver anuncio para subir un clip extra'), findsNothing);
    }
  });

  testWidgets('SponsoredCard is always visibly identified', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        const SponsoredCard(
          placement: AdPlacement.sponsoredProfessionalCard,
          badgeLabel: 'Profesional destacado',
          title: 'Profesional destacado',
          description: 'Sponsor directo identificado.',
          repository: LocalMonetizationRepository(
            planNameOverride: 'Mascotify Free',
          ),
        ),
      ),
    );

    expect(find.text('Profesional destacado'), findsWidgets);
    expect(find.text('Sponsor directo identificado.'), findsOneWidget);
  });

  testWidgets('Free can see sponsored professional card', (tester) async {
    setDesktopViewport(tester);
    AppData.source = const _PlanDataSource('Mascotify Free');

    await tester.pumpWidget(buildTestApp(const ProfessionalsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Profesional destacado'), findsWidgets);
    expect(
      find.textContaining('Espacio reservado para sponsor'),
      findsOneWidget,
    );
  });

  testWidgets('sensitive screens do not show ad labels', (tester) async {
    setDesktopViewport(tester);
    final session = await buildPersistentTestAppSession();
    await session.controller.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );
    await AppData.setPlanName('Mascotify Free');
    final pet = AppData.pets.first;
    final thread = AppData.messageThreads.first;

    final sensitiveScreens = <Widget>[
      PetDetailScreen(pet: pet),
      QrTraceabilityScreen(pet: pet),
      PetHealthScreen(pet: pet),
      const LostPetsScreen(),
      const MessagesInboxScreen(),
      ConversationScreen(thread: thread),
      const ProfileScreen(experience: AccountExperience.family),
    ];

    for (final screen in sensitiveScreens) {
      await tester.pumpWidget(
        buildTestApp(screen, controller: session.controller),
      );
      await tester.pumpAndSettle();

      expect(find.text('Anuncio'), findsNothing);
      expect(find.text('Patrocinado'), findsNothing);
      expect(find.byType(AdSlot), findsNothing);
      expect(find.byType(RewardedActionButton), findsNothing);
    }
  });

  testWidgets('ad placeholders do not overflow on mobile', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    AppData.source = const _PlanDataSource('Mascotify Free');

    await tester.pumpWidget(buildTestApp(const ActivityFeedScreen()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Anuncio'),
      240,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Anuncio'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _PlanDataSource extends MockMascotifyDataSource {
  const _PlanDataSource(this.planName);

  final String planName;

  @override
  AppUser getCurrentUser() {
    final user = MockData.currentUser;
    return AppUser(
      id: user.id,
      name: user.name,
      email: user.email,
      planName: planName,
      city: user.city,
      memberSince: user.memberSince,
      notificationsEnabled: user.notificationsEnabled,
      messagesNotificationsEnabled: user.messagesNotificationsEnabled,
      petActivityNotificationsEnabled: user.petActivityNotificationsEnabled,
      ecosystemUpdatesNotificationsEnabled:
          user.ecosystemUpdatesNotificationsEnabled,
      strategicNotificationsEnabled: user.strategicNotificationsEnabled,
      privacyLevel: user.privacyLevel,
      securityLevel: user.securityLevel,
      publicProfileEnabled: user.publicProfileEnabled,
      showBasicInfoOnPublicProfile: user.showBasicInfoOnPublicProfile,
      ecosystemSuggestionsEnabled: user.ecosystemSuggestionsEnabled,
    );
  }
}

const _admobEnabledFreeRepository = LocalMonetizationRepository(
  planNameOverride: 'Mascotify Free',
  flags: MonetizationFeatureFlags(
    adsEnabled: true,
    admobEnabled: true,
    useRealAdMobIds: false,
    admobTestModeEnabled: true,
    nativeAdsEnabled: true,
    bannerAdsEnabled: true,
    rewardedAdsEnabled: true,
    interstitialAdsEnabled: false,
    sponsorsEnabled: true,
    placeholderModeEnabled: true,
  ),
);

class _FakeAdsService implements AdsService {
  _FakeAdsService(this.outcome);

  final RewardedAdOutcome outcome;
  int showCount = 0;

  @override
  bool get isMobileAdsSupported => true;

  @override
  Future<bool> initialize() async => true;

  @override
  Future<RewardedAdOutcome> showRewardedAd({required String adUnitId}) async {
    showCount += 1;
    expect(adUnitId, AdMobAdUnits.testRewardedAndroid);
    return outcome;
  }
}

class _FakeClipsRepository implements SocialClipsRepositoryPort {
  const _FakeClipsRepository();

  @override
  Future<SocialClipsLoadResult> fetchFeed({required String userId}) async {
    return SocialClipsLoadResult(
      clips: AppData.exploreClips,
      source: SocialClipsDataSource.localFallback,
      message: 'Mostrando clips demo locales',
    );
  }

  @override
  Future<void> followAuthor(ExploreClip clip, {required String userId}) async {}

  @override
  Future<ExploreClip> likeClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    return clip.copyWith(isLiked: true, likes: clip.likes + 1);
  }

  @override
  Future<ExploreClip> shareClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    return clip.copyWith(shares: clip.shares + 1);
  }

  @override
  Future<void> unfollowAuthor(
    ExploreClip clip, {
    required String userId,
  }) async {}

  @override
  Future<ExploreClip> unlikeClip(
    ExploreClip clip, {
    required String userId,
  }) async {
    return clip.copyWith(isLiked: false, likes: clip.likes - 1);
  }

  @override
  Future<ExploreClip> uploadClip({
    required String userId,
    required ClipUploadDraft draft,
    required SelectedClipVideo video,
  }) async {
    return ExploreClip(
      id: 'uploaded-demo',
      title: draft.title,
      description: draft.description,
      category: draft.category,
      animalType: draft.animalType,
      likes: 0,
      comments: 0,
    );
  }
}
