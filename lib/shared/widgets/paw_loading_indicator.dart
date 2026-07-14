import 'package:flutter/material.dart';

class PawLoadingIndicator extends StatefulWidget {
  const PawLoadingIndicator({
    super.key,
    this.message = 'Cargando clips...',
    this.foregroundColor,
    this.backgroundColor,
    this.compact = false,
  });

  final String? message;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool compact;

  @override
  State<PawLoadingIndicator> createState() => _PawLoadingIndicatorState();
}

class _PawLoadingIndicatorState extends State<PawLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = widget.foregroundColor ?? colorScheme.primary;
    final background =
        widget.backgroundColor ??
        colorScheme.surface.withValues(alpha: isDark ? 0.9 : 0.92);
    final size = widget.compact ? 44.0 : 58.0;
    final iconSize = widget.compact ? 25.0 : 34.0;
    final message = widget.message;

    return Semantics(
      label: message ?? 'Cargando',
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 18,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: RotationTransition(
              turns: _controller,
              child: Icon(
                Icons.pets_rounded,
                color: foreground,
                size: iconSize,
              ),
            ),
          ),
          if (message != null && message.trim().isNotEmpty) ...[
            SizedBox(height: widget.compact ? 8 : 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
