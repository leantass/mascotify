import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../models/profile_option_item.dart';

class ProfileOptionTile extends StatelessWidget {
  const ProfileOptionTile({super.key, required this.item});

  final ProfileOptionItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.surfaceTint,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(_mapIcon(item.iconKey), color: AppColors.primaryDeep),
        ),
        title: Text(item.title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(item.subtitle),
        ),
        trailing: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  IconData _mapIcon(String key) {
    switch (key) {
      case 'workspace_premium':
        return Icons.workspace_premium_outlined;
      case 'notifications':
        return Icons.notifications_none_rounded;
      case 'settings':
        return Icons.tune_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
