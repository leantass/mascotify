import '../../../core/app_environment.dart';
import '../../../shared/data/app_data_source.dart';
import '../../../shared/models/plan_entitlements.dart';
import '../domain/ad_format.dart';
import '../domain/ad_placement.dart';
import '../domain/monetization_entitlement.dart';
import 'admob_ad_units.dart';

class MonetizationFeatureFlags {
  const MonetizationFeatureFlags({
    required this.adsEnabled,
    required this.admobEnabled,
    required this.useRealAdMobIds,
    required this.admobTestModeEnabled,
    required this.nativeAdsEnabled,
    required this.bannerAdsEnabled,
    required this.rewardedAdsEnabled,
    required this.interstitialAdsEnabled,
    required this.sponsorsEnabled,
    required this.placeholderModeEnabled,
  });

  factory MonetizationFeatureFlags.demoDefaults() {
    return MonetizationFeatureFlags(
      adsEnabled: AppEnvironment.isDemoLocal,
      admobEnabled: AdMobAdUnits.admobEnabled,
      useRealAdMobIds: AdMobAdUnits.useRealAdMobIds,
      admobTestModeEnabled: true,
      nativeAdsEnabled: true,
      bannerAdsEnabled: true,
      rewardedAdsEnabled: true,
      interstitialAdsEnabled: false,
      sponsorsEnabled: true,
      placeholderModeEnabled: true,
    );
  }

  final bool adsEnabled;
  final bool admobEnabled;
  final bool useRealAdMobIds;
  final bool admobTestModeEnabled;
  final bool nativeAdsEnabled;
  final bool bannerAdsEnabled;
  final bool rewardedAdsEnabled;
  final bool interstitialAdsEnabled;
  final bool sponsorsEnabled;
  final bool placeholderModeEnabled;

  bool allowsFormat(AdFormat format) {
    if (!adsEnabled) return false;
    switch (format) {
      case AdFormat.native:
        return nativeAdsEnabled;
      case AdFormat.banner:
        return bannerAdsEnabled;
      case AdFormat.rewarded:
        return rewardedAdsEnabled;
      case AdFormat.interstitial:
        return interstitialAdsEnabled;
      case AdFormat.sponsor:
        return sponsorsEnabled;
    }
  }
}

class LocalMonetizationRepository {
  const LocalMonetizationRepository({
    MonetizationFeatureFlags? flags,
    String? planNameOverride,
  }) : _flags = flags,
       _planNameOverride = planNameOverride;

  final MonetizationFeatureFlags? _flags;
  final String? _planNameOverride;

  MonetizationFeatureFlags get flags =>
      _flags ?? MonetizationFeatureFlags.demoDefaults();

  MonetizationEntitlement get entitlement {
    final planName = _planNameOverride ?? AppData.currentUser.planName;
    return MonetizationEntitlement.fromPlan(planEntitlementFor(planName));
  }

  bool shouldShowPlacement(
    AdPlacement placement, {
    AdBlockedSurface? blockedSurface,
  }) {
    if (blockedSurface != null) return false;
    final format = placement.format;
    return flags.allowsFormat(format) && entitlement.allowsFormat(format);
  }

  bool shouldRequestAdMobPlacement(
    AdPlacement placement, {
    AdBlockedSurface? blockedSurface,
  }) {
    if (!flags.admobEnabled) return false;
    return shouldShowPlacement(placement, blockedSurface: blockedSurface);
  }

  bool shouldShowRewardedAction(AdPlacement placement) {
    return placement.format == AdFormat.rewarded &&
        shouldShowPlacement(placement);
  }
}
