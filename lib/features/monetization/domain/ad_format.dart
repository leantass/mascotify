enum AdFormat { native, banner, rewarded, interstitial, sponsor }

extension AdFormatLabels on AdFormat {
  String get label {
    switch (this) {
      case AdFormat.native:
        return 'Native';
      case AdFormat.banner:
        return 'Banner';
      case AdFormat.rewarded:
        return 'Rewarded';
      case AdFormat.interstitial:
        return 'Interstitial';
      case AdFormat.sponsor:
        return 'Sponsor';
    }
  }
}
