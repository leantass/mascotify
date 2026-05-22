enum RewardedAdOutcome { earned, failed, unavailable }

abstract interface class AdsService {
  bool get isMobileAdsSupported;

  Future<bool> initialize();

  Future<RewardedAdOutcome> showRewardedAd({required String adUnitId});
}
