import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.eyebrow,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final String? eyebrow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = MascotifyPalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: palette.accentSoft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Text(
                    eyebrow!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(title, style: textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}
