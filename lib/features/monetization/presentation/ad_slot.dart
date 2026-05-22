import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../data/local_monetization_repository.dart';
import '../domain/ad_format.dart';
import '../domain/ad_placement.dart';

class AdSlot extends StatelessWidget {
  const AdSlot({
    super.key,
    required this.placement,
    this.blockedSurface,
    this.repository = const LocalMonetizationRepository(),
  });

  final AdPlacement placement;
  final AdBlockedSurface? blockedSurface;
  final LocalMonetizationRepository repository;

  @override
  Widget build(BuildContext context) {
    if (!repository.shouldShowPlacement(
      placement,
      blockedSurface: blockedSurface,
    )) {
      return const SizedBox.shrink();
    }

    final format = placement.format;
    if (!repository.flags.placeholderModeEnabled) {
      return const SizedBox.shrink();
    }

    final isBanner = format == AdFormat.banner;
    final isSponsor = format == AdFormat.sponsor;
    final label = isSponsor ? 'Patrocinado' : 'Anuncio';
    final title = isSponsor
        ? placement.label
        : 'Espacio publicitario reservado';
    final description = isSponsor
        ? 'Espacio reservado para sponsor directo identificado.'
        : 'Placeholder local/demo sin SDK, IDs ni requests externos.';

    return Semantics(
      label: 'ad-slot-${placement.name}',
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: isBanner ? 84 : 132),
        padding: EdgeInsets.all(isBanner ? 14 : 18),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isBanner ? 38 : 46,
              height: isBanner ? 38 : 46,
              decoration: BoxDecoration(
                color: isSponsor ? AppColors.supportSoft : AppColors.accentSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isSponsor
                    ? Icons.workspace_premium_outlined
                    : Icons.campaign_outlined,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AdLabel(label: label),
                  const SizedBox(height: 8),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdLabel extends StatelessWidget {
  const _AdLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
