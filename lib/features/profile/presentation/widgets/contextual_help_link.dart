import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../screens/help_screen.dart';

class ContextualHelpLink extends StatelessWidget {
  const ContextualHelpLink({
    super.key,
    required this.topic,
    required this.label,
    this.compact = false,
  });

  final HelpTopic topic;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final button = TextButton.icon(
      key: ValueKey('contextual-help-${topic.name}'),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => HelpScreen(initialTopic: topic),
        ),
      ),
      icon: const Icon(Icons.help_outline_rounded, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryDeep,
        textStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    );

    if (compact) return Align(alignment: Alignment.centerLeft, child: button);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Align(alignment: Alignment.centerLeft, child: button),
    );
  }
}
