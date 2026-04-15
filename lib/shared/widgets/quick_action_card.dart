import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../data/mock_data.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.item});

  final QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _mapIcon(item.iconKey),
                    color: AppColors.primaryDeep,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.north_east_rounded,
                    color: AppColors.accentDeep,
                    size: 18,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(item.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(item.subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  IconData _mapIcon(String key) {
    switch (key) {
      case 'badge':
        return Icons.verified_user_outlined;
      case 'qr':
        return Icons.qr_code_2_rounded;
      case 'report':
        return Icons.campaign_outlined;
      default:
        return Icons.grid_view_rounded;
    }
  }
}
