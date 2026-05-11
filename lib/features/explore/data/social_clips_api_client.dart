import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/models/social_models.dart';

abstract interface class SocialClipsApiClientPort {
  Future<List<ExploreClip>> fetchFeed({required String userId});
  Future<ExploreClip> likeClip({
    required String clipId,
    required String userId,
  });
  Future<ExploreClip> unlikeClip({
    required String clipId,
    required String userId,
  });
  Future<ExploreClip> shareClip({
    required String clipId,
    required String userId,
  });
  Future<void> followUser({required String authorId, required String userId});
  Future<void> unfollowUser({required String authorId, required String userId});
}

class SocialClipsApiClient implements SocialClipsApiClientPort {
  SocialClipsApiClient({
    required String baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(milliseconds: 900),
  }) : _baseUri = Uri.parse(
         baseUrl.endsWith('/')
             ? baseUrl.substring(0, baseUrl.length - 1)
             : baseUrl,
       ),
       _httpClient = httpClient ?? http.Client();

  final Uri _baseUri;
  final http.Client _httpClient;
  final Duration timeout;

  @override
  Future<List<ExploreClip>> fetchFeed({required String userId}) async {
    final response = await _send(
      'GET',
      '/clips/feed',
      userId: userId,
      queryParameters: const <String, String>{'limit': '30'},
    );
    final body = _decodeObject(response);
    final items = body['items'];

    if (items is! List) {
      throw const FormatException('Invalid clips feed response.');
    }

    return items
        .whereType<Map>()
        .map((item) => _clipFromBackend(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<ExploreClip> likeClip({
    required String clipId,
    required String userId,
  }) {
    return _sendClipMutation('POST', '/clips/$clipId/like', userId);
  }

  @override
  Future<ExploreClip> unlikeClip({
    required String clipId,
    required String userId,
  }) {
    return _sendClipMutation('DELETE', '/clips/$clipId/like', userId);
  }

  @override
  Future<ExploreClip> shareClip({
    required String clipId,
    required String userId,
  }) {
    return _sendClipMutation('POST', '/clips/$clipId/share', userId);
  }

  @override
  Future<void> followUser({
    required String authorId,
    required String userId,
  }) async {
    await _send('POST', '/users/$authorId/follow', userId: userId);
  }

  @override
  Future<void> unfollowUser({
    required String authorId,
    required String userId,
  }) async {
    await _send('DELETE', '/users/$authorId/follow', userId: userId);
  }

  Future<ExploreClip> _sendClipMutation(
    String method,
    String path,
    String userId,
  ) async {
    final response = await _send(method, path, userId: userId);
    final body = _decodeObject(response);
    final clip = body['clip'];

    if (clip is! Map) {
      throw const FormatException('Invalid clip mutation response.');
    }

    return _clipFromBackend(Map<String, dynamic>.from(clip));
  }

  Future<http.Response> _send(
    String method,
    String path, {
    required String userId,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _baseUri.replace(
      path: '${_baseUri.path}$path',
      queryParameters: queryParameters,
    );
    final headers = <String, String>{
      'accept': 'application/json',
      'x-user-id': userId,
    };
    final request = switch (method) {
      'GET' => _httpClient.get(uri, headers: headers),
      'POST' => _httpClient.post(uri, headers: headers),
      'DELETE' => _httpClient.delete(uri, headers: headers),
      _ => throw ArgumentError.value(method, 'method', 'Unsupported method'),
    };
    final response = await request.timeout(timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw SocialClipsApiException(
        'Backend clips request failed with status ${response.statusCode}.',
      );
    }

    return response;
  }

  Map<String, dynamic> _decodeObject(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw const FormatException('Expected JSON object.');
    }

    return Map<String, dynamic>.from(decoded);
  }
}

class SocialClipsApiException implements Exception {
  const SocialClipsApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

ExploreClip _clipFromBackend(Map<String, dynamic> json) {
  final thumbnailUrl = json['thumbnailUrl'] as String?;
  final videoUrl = json['videoUrl'] as String?;

  return ExploreClip(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    animalType: json['animalType'] as String,
    authorId: json['authorId'] as String?,
    thumbnailAssetPath: _assetPathOrNull(thumbnailUrl, 'assets/images/clips/'),
    videoAssetPath: _assetPathOrNull(videoUrl, 'assets/videos/clips/'),
    likes: json['likesCount'] as int? ?? 0,
    comments: json['commentsCount'] as int? ?? 0,
    shares: json['sharesCount'] as int? ?? 0,
    sourceLabel: 'Backend social',
    isDemoContent: false,
    isLiked: json['isLiked'] as bool? ?? false,
    isFollowingAuthor: json['isFollowingAuthor'] as bool? ?? false,
  );
}

String? _assetPathOrNull(String? value, String prefix) {
  if (value == null || !value.startsWith(prefix)) {
    return null;
  }

  return value;
}
