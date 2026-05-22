import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../theme/app_colors.dart';
import '../data/admob_ad_units.dart';
import '../data/admob_ads_service.dart';
import '../data/local_monetization_repository.dart';
import '../domain/ad_placement.dart';
import '../domain/ads_service.dart';
import 'ad_slot.dart';

class AdMobBannerSlot extends StatefulWidget {
  const AdMobBannerSlot({
    super.key,
    required this.placement,
    this.blockedSurface,
    this.repository = const LocalMonetizationRepository(),
    this.adsService = AdMobAdsService.instance,
  });

  final AdPlacement placement;
  final AdBlockedSurface? blockedSurface;
  final LocalMonetizationRepository repository;
  final AdsService adsService;

  @override
  State<AdMobBannerSlot> createState() => _AdMobBannerSlotState();
}

class _AdMobBannerSlotState extends State<AdMobBannerSlot> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _loadBannerIfAllowed();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.repository.shouldShowPlacement(
      widget.placement,
      blockedSurface: widget.blockedSurface,
    )) {
      return const SizedBox.shrink();
    }

    if (!widget.repository.shouldRequestAdMobPlacement(
          widget.placement,
          blockedSurface: widget.blockedSurface,
        ) ||
        !widget.adsService.isMobileAdsSupported ||
        _failed) {
      return AdSlot(
        placement: widget.placement,
        blockedSurface: widget.blockedSurface,
        repository: widget.repository,
      );
    }

    if (!_isLoaded || _bannerAd == null) {
      return const _BannerLoadingPlaceholder();
    }

    return Semantics(
      label: 'admob-banner-${widget.placement.name}',
      child: Center(
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      ),
    );
  }

  void _loadBannerIfAllowed() {
    if (!widget.repository.shouldRequestAdMobPlacement(
          widget.placement,
          blockedSurface: widget.blockedSurface,
        ) ||
        !widget.adsService.isMobileAdsSupported) {
      return;
    }

    final banner = BannerAd(
      adUnitId: AdMobAdUnits.bannerAndroid,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
            _failed = false;
          });
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _failed = true;
            _isLoaded = false;
            _bannerAd = null;
          });
        },
      ),
    );

    banner.load();
  }
}

class _BannerLoadingPlaceholder extends StatelessWidget {
  const _BannerLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cargando anuncio de prueba',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
