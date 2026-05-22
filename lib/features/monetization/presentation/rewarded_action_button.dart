import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../data/admob_ad_units.dart';
import '../data/admob_ads_service.dart';
import '../data/local_monetization_repository.dart';
import '../domain/ad_placement.dart';
import '../domain/ads_service.dart';

class RewardedActionButton extends StatelessWidget {
  const RewardedActionButton({
    super.key,
    required this.placement,
    required this.label,
    this.repository = const LocalMonetizationRepository(),
    this.adsService = AdMobAdsService.instance,
  });

  final AdPlacement placement;
  final String label;
  final LocalMonetizationRepository repository;
  final AdsService adsService;

  @override
  Widget build(BuildContext context) {
    if (!repository.shouldShowRewardedAction(placement)) {
      return const SizedBox.shrink();
    }

    return OutlinedButton.icon(
      onPressed: () => _handlePressed(context),
      icon: const Icon(Icons.play_circle_outline_rounded),
      label: Text(label),
    );
  }

  Future<void> _handlePressed(BuildContext context) async {
    if (!repository.flags.admobEnabled || !adsService.isMobileAdsSupported) {
      await _showRewardedDemoConfirmation(context);
      return;
    }

    final outcome = await adsService.showRewardedAd(
      adUnitId: AdMobAdUnits.rewardedAndroid,
    );
    if (!context.mounted) return;

    switch (outcome) {
      case RewardedAdOutcome.earned:
        await _showRewardedEarnedConfirmation(context);
      case RewardedAdOutcome.failed:
      case RewardedAdOutcome.unavailable:
        await _showRewardedFailedConfirmation(context);
    }
  }

  Future<void> _showRewardedDemoConfirmation(BuildContext context) async {
    await _showRewardedDialog(
      context,
      title: 'Recompensa demo aplicada.',
      message:
          'No se reprodujo un anuncio real. Esta accion queda preparada en modo local/demo para una futura integracion.',
      icon: Icons.card_giftcard_rounded,
    );
  }

  Future<void> _showRewardedEarnedConfirmation(BuildContext context) async {
    await _showRewardedDialog(
      context,
      title: 'Recompensa de prueba aplicada.',
      message:
          'El anuncio recompensado termino correctamente. Esta integracion usa IDs de prueba salvo que se active una build futura con flags reales.',
      icon: Icons.card_giftcard_rounded,
    );
  }

  Future<void> _showRewardedFailedConfirmation(BuildContext context) async {
    await _showRewardedDialog(
      context,
      title: 'No se aplico la recompensa.',
      message:
          'El anuncio no se completo o no estuvo disponible. No se otorga recompensa si el anuncio no termina.',
      icon: Icons.error_outline_rounded,
    );
  }

  Future<void> _showRewardedDialog(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Entendido'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
