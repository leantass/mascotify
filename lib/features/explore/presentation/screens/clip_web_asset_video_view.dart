import 'package:flutter/widgets.dart';

class WebAssetClipVideoView extends StatelessWidget {
  const WebAssetClipVideoView({
    super.key,
    required this.assetPath,
    required this.isActive,
    required this.isMuted,
    required this.onReady,
    required this.onError,
  });

  final String assetPath;
  final bool isActive;
  final bool isMuted;
  final VoidCallback onReady;
  final VoidCallback onError;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
