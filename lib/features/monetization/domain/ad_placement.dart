import 'ad_format.dart';

enum AdPlacement {
  exploreFeedNative,
  clipsFeedNative,
  professionalsListNative,
  activityFeedBanner,
  generalPassiveBanner,
  clipExtraRewarded,
  clipHighlightRewarded,
  temporaryPlusFeatureRewarded,
  sponsoredProfessionalCard,
  sponsoredCategoryCard,
  sponsoredCouponCard,
}

enum AdBlockedSurface {
  login,
  register,
  onboarding,
  petProfile,
  petQr,
  petHealth,
  lostPets,
  lostPetReport,
  petSightingReport,
  criticalHistory,
  messages,
  conversations,
  importantNotifications,
  emergency,
  checkout,
  subscription,
  privacySettings,
}

extension AdPlacementPolicy on AdPlacement {
  AdFormat get format {
    switch (this) {
      case AdPlacement.exploreFeedNative:
      case AdPlacement.clipsFeedNative:
      case AdPlacement.professionalsListNative:
        return AdFormat.native;
      case AdPlacement.activityFeedBanner:
      case AdPlacement.generalPassiveBanner:
        return AdFormat.banner;
      case AdPlacement.clipExtraRewarded:
      case AdPlacement.clipHighlightRewarded:
      case AdPlacement.temporaryPlusFeatureRewarded:
        return AdFormat.rewarded;
      case AdPlacement.sponsoredProfessionalCard:
      case AdPlacement.sponsoredCategoryCard:
      case AdPlacement.sponsoredCouponCard:
        return AdFormat.sponsor;
    }
  }

  String get label {
    switch (this) {
      case AdPlacement.exploreFeedNative:
        return 'Explorar';
      case AdPlacement.clipsFeedNative:
        return 'Clips';
      case AdPlacement.professionalsListNative:
        return 'Profesionales';
      case AdPlacement.activityFeedBanner:
        return 'Actividad';
      case AdPlacement.generalPassiveBanner:
        return 'Navegacion general';
      case AdPlacement.clipExtraRewarded:
        return 'Clip extra';
      case AdPlacement.clipHighlightRewarded:
        return 'Destacar clip';
      case AdPlacement.temporaryPlusFeatureRewarded:
        return 'Prueba Plus';
      case AdPlacement.sponsoredProfessionalCard:
        return 'Profesional destacado';
      case AdPlacement.sponsoredCategoryCard:
        return 'Categoria patrocinada';
      case AdPlacement.sponsoredCouponCard:
        return 'Cupon patrocinado';
    }
  }
}
