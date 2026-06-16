import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../models/profile_option_item.dart';

class ProfileOptionTile extends StatelessWidget {
  const ProfileOptionTile({super.key, required this.item});

  final ProfileOptionItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = MascotifyPalette.of(context);
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
            color: palette.surfaceTint,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Icon(_mapIcon(item.iconKey), color: colorScheme.primary),
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
            color: palette.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
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
