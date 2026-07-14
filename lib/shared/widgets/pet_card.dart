import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../models/pet.dart';

class PetCard extends StatelessWidget {
  const PetCard({
    super.key,
    required this.pet,
    this.compact = false,
    this.onTap,
  });

  final Pet pet;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = MascotifyPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final petTone = isDark
        ? Color.alphaBlend(
            Color(pet.colorHex).withValues(alpha: 0.24),
            palette.surfaceAlt,
          )
        : Color(pet.colorHex);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(compact ? 16 : 18),
            child: Row(
              children: [
                Container(
                  width: compact ? 58 : 68,
                  height: compact ? 58 : 68,
                  decoration: BoxDecoration(
                    color: petTone,
                    borderRadius: BorderRadius.circular(22),
                    border: isDark
                        ? Border.all(color: colorScheme.outlineVariant)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const Icon(Icons.pets_rounded, color: AppColors.dark),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(pet.name, style: textTheme.titleMedium),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: palette.primarySoft,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            child: Text(
                              pet.species,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pet.breed,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoPill(
                            label: pet.ageLabel,
                            backgroundColor: palette.surfaceAlt,
                            textColor: colorScheme.onSurface,
                          ),
                          _InfoPill(
                            label: pet.status,
                            backgroundColor: palette.supportSoft,
                            textColor: colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
