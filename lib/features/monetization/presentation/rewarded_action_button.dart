import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../data/local_monetization_repository.dart';
import '../domain/ad_placement.dart';

class RewardedActionButton extends StatelessWidget {
  const RewardedActionButton({
    super.key,
    required this.placement,
    required this.label,
    this.repository = const LocalMonetizationRepository(),
  });

  final AdPlacement placement;
  final String label;
  final LocalMonetizationRepository repository;

  @override
  Widget build(BuildContext context) {
    if (!repository.shouldShowRewardedAction(placement)) {
      return const SizedBox.shrink();
    }

    return OutlinedButton.icon(
      onPressed: () => _showRewardedDemoConfirmation(context),
      icon: const Icon(Icons.play_circle_outline_rounded),
      label: Text(label),
    );
  }

  Future<void> _showRewardedDemoConfirmation(BuildContext context) async {
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
                Text(
                  'Recompensa demo aplicada.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'No se reprodujo un anuncio real. Esta accion queda preparada en modo local/demo para una futura integracion.',
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
