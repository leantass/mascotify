import '../../../shared/models/plan_entitlements.dart';
import 'ad_format.dart';

class MonetizationEntitlement {
  const MonetizationEntitlement({
    required this.planName,
    required this.adsEnabled,
    required this.nativeAdsEnabled,
    required this.bannerAdsEnabled,
    required this.rewardedAdsEnabled,
    required this.interstitialAdsEnabled,
    required this.sponsorsEnabled,
  });

  factory MonetizationEntitlement.fromPlan(PlanEntitlement plan) {
    return MonetizationEntitlement(
      planName: plan.shortName.toLowerCase(),
      adsEnabled: plan.adsEnabled,
      nativeAdsEnabled: plan.nativeAdsEnabled,
      bannerAdsEnabled: plan.bannerAdsEnabled,
      rewardedAdsEnabled: plan.rewardedAdsEnabled,
      interstitialAdsEnabled: plan.interstitialAdsEnabled,
      sponsorsEnabled: plan.sponsorsEnabled,
    );
  }

  final String planName;
  final bool adsEnabled;
  final bool nativeAdsEnabled;
  final bool bannerAdsEnabled;
  final bool rewardedAdsEnabled;
  final bool interstitialAdsEnabled;
  final bool sponsorsEnabled;

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
