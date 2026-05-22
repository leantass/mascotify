class AdMobAdUnits {
  const AdMobAdUnits._();

  static const bool admobEnabled = bool.fromEnvironment(
    'ADMOB_ENABLED',
    defaultValue: false,
  );

  static const bool useRealAdMobIds = bool.fromEnvironment(
    'ADMOB_USE_REAL_IDS',
    defaultValue: false,
  );

  static const String androidAppId = 'ca-app-pub-7918381399703521~3080162315';

  static const String realBannerAndroid =
      'ca-app-pub-7918381399703521/2571375944';
  static const String realNativeAndroid =
      'ca-app-pub-7918381399703521/2786998366';
  static const String realRewardedAndroid =
      'ca-app-pub-7918381399703521/3651007955';

  static const String testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testNativeAndroid =
      'ca-app-pub-3940256099942544/2247696110';
  static const String testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';

  static String get bannerAndroid =>
      useRealAdMobIds ? realBannerAndroid : testBannerAndroid;

  static String get nativeAndroid =>
      useRealAdMobIds ? realNativeAndroid : testNativeAndroid;

  static String get rewardedAndroid =>
      useRealAdMobIds ? realRewardedAndroid : testRewardedAndroid;

  static bool get usesTestIds => !useRealAdMobIds;
}
