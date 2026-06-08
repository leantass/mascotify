// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

class WebAssetClipVideoView extends StatefulWidget {
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
  State<WebAssetClipVideoView> createState() => _WebAssetClipVideoViewState();
}

class _WebAssetClipVideoViewState extends State<WebAssetClipVideoView> {
  late final String _viewType;
  late html.VideoElement _videoElement;
  StreamSubscription<html.Event>? _readySubscription;
  StreamSubscription<html.Event>? _errorSubscription;

  @override
  void initState() {
    super.initState();
    _viewType = 'mascotify-web-clip-${identityHashCode(this)}';
    _createVideoElement();
  }

  @override
  void didUpdateWidget(covariant WebAssetClipVideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _disposeVideoElement();
      _createVideoElement();
      return;
    }

    _videoElement.muted = widget.isMuted;
    _syncPlayback();
  }

  @override
  void dispose() {
    _disposeVideoElement();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }

  void _createVideoElement() {
    final source = Uri.base.resolve('assets/${widget.assetPath}').toString();
    _videoElement = html.VideoElement()
      ..src = source
      ..autoplay = true
      ..loop = true
      ..muted = widget.isMuted
      ..preload = 'auto'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.border = '0'
      ..style.backgroundColor = 'transparent';
    _videoElement.setAttribute('playsinline', 'true');
    _videoElement.setAttribute('webkit-playsinline', 'true');

    _readySubscription = _videoElement.onCanPlay.listen((_) {
      widget.onReady();
      _syncPlayback();
    });
    _errorSubscription = _videoElement.onError.listen((_) {
      widget.onError();
    });

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (_) => _videoElement,
    );
    _videoElement.load();
    _syncPlayback();
  }

  void _disposeVideoElement() {
    _readySubscription?.cancel();
    _errorSubscription?.cancel();
    _readySubscription = null;
    _errorSubscription = null;
    _videoElement.pause();
    _videoElement.removeAttribute('src');
    _videoElement.load();
  }

  void _syncPlayback() {
    _videoElement.muted = widget.isMuted;
    if (widget.isActive) {
      _videoElement.play().catchError((_) {});
    } else {
      _videoElement.pause();
    }
  }
}
