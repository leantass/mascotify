import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ads_service.dart';
import 'admob_ad_units.dart';

class AdMobAdsService implements AdsService {
  const AdMobAdsService._();

  static const AdMobAdsService instance = AdMobAdsService._();

  @override
  bool get isMobileAdsSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  Future<bool> initialize() async {
    if (!AdMobAdUnits.admobEnabled || !isMobileAdsSupported) return false;
    await MobileAds.instance.initialize();
    return true;
  }

  @override
  Future<RewardedAdOutcome> showRewardedAd({required String adUnitId}) async {
    if (!AdMobAdUnits.admobEnabled || !isMobileAdsSupported) {
      return RewardedAdOutcome.unavailable;
    }

    final completer = Completer<RewardedAdOutcome>();
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          var earnedReward = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) {
                completer.complete(
                  earnedReward
                      ? RewardedAdOutcome.earned
                      : RewardedAdOutcome.failed,
                );
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (!completer.isCompleted) {
                completer.complete(RewardedAdOutcome.failed);
              }
            },
          );

          ad.show(
            onUserEarnedReward: (_, _) {
              earnedReward = true;
            },
          );
        },
        onAdFailedToLoad: (_) {
          if (!completer.isCompleted) {
            completer.complete(RewardedAdOutcome.failed);
          }
        },
      ),
    );

    return completer.future;
  }
}
