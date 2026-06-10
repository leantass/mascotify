import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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
  Future<CloudinaryUploadSignature> requestUploadSignature({
    required String userId,
  });
  Future<CloudinaryUploadResult> uploadVideo({
    required CloudinaryUploadSignature signature,
    required SelectedClipVideo video,
  });
  Future<ExploreClip> createClip({
    required String userId,
    required ClipUploadDraft draft,
    required CloudinaryUploadResult uploadResult,
  });
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
      queryParameters: const <String, String>{'limit': '30', 'source': 'all'},
    );
    final body = _decodeObject(response);
    final items = body['clips'] ?? body['items'];

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

  @override
  Future<CloudinaryUploadSignature> requestUploadSignature({
    required String userId,
  }) async {
    final response = await _send(
      'POST',
      '/clips/upload-signature',
      userId: userId,
    );
    return CloudinaryUploadSignature.fromJson(_decodeObject(response));
  }

  @override
  Future<CloudinaryUploadResult> uploadVideo({
    required CloudinaryUploadSignature signature,
    required SelectedClipVideo video,
  }) async {
    final bytes = video.bytes;
    if (bytes == null) {
      throw const SocialClipsApiException(
        'Selected video bytes are not available for upload.',
      );
    }

    final request =
        http.MultipartRequest('POST', Uri.parse(signature.uploadUrl))
          ..fields['api_key'] = signature.apiKey
          ..fields['timestamp'] = signature.timestamp.toString()
          ..fields['signature'] = signature.signature
          ..fields['folder'] = signature.folder
          ..fields['resource_type'] = signature.resourceType
          ..files.add(
            http.MultipartFile.fromBytes('file', bytes, filename: video.name),
          );
    final streamedResponse = await _httpClient.send(request).timeout(timeout);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw SocialClipsApiException(
        'Cloudinary upload failed with status ${response.statusCode}.',
      );
    }

    final body = _decodeObject(response);
    return CloudinaryUploadResult.fromJson(body);
  }

  @override
  Future<ExploreClip> createClip({
    required String userId,
    required ClipUploadDraft draft,
    required CloudinaryUploadResult uploadResult,
  }) async {
    final response = await _send(
      'POST',
      '/clips',
      userId: userId,
      body: jsonEncode(<String, Object?>{
        'title': draft.title,
        'description': draft.description,
        'animalType': draft.animalType,
        'category': draft.category,
        'videoUrl': uploadResult.secureUrl,
        'thumbnailUrl': uploadResult.thumbnailUrl,
        'cloudinaryPublicId': uploadResult.publicId,
        'durationSeconds': uploadResult.durationSeconds,
      }),
    );
    final body = _decodeObject(response);
    final clip = body['clip'];
    if (clip is! Map) {
      throw const FormatException('Invalid create clip response.');
    }
    return _clipFromBackend(Map<String, dynamic>.from(clip));
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
    Object? body,
  }) async {
    final uri = _baseUri.replace(
      path: '${_baseUri.path}$path',
      queryParameters: queryParameters,
    );
    final headers = <String, String>{
      'accept': 'application/json',
      if (body != null) 'content-type': 'application/json',
      'x-user-id': userId,
    };
    final request = switch (method) {
      'GET' => _httpClient.get(uri, headers: headers),
      'POST' => _httpClient.post(uri, headers: headers, body: body),
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
  final videoAssetPath = _assetPathOrNull(videoUrl, 'assets/videos/clips/');
  final thumbnailAssetPath = _assetPathOrNull(
    thumbnailUrl,
    'assets/images/clips/',
  );
  final sourceType = json['sourceType'] as String? ?? 'userUpload';
  final sourceProvider = json['sourceProvider'] as String? ?? 'Mascotify';

  return ExploreClip(
    id: json['id'] as String,
    title: json['title'] as String,
    description:
        json['description'] as String? ??
        json['caption'] as String? ??
        'Clip de Mascotify.',
    category: json['category'] as String,
    animalType:
        json['animalType'] as String? ??
        json['species'] as String? ??
        'Mascota',
    authorId: json['authorId'] as String?,
    cloudinaryPublicId: json['cloudinaryPublicId'] as String?,
    thumbnailAssetPath: thumbnailAssetPath,
    thumbnailUrl: thumbnailAssetPath == null ? thumbnailUrl : null,
    videoSourceType: videoAssetPath != null
        ? 'asset'
        : videoUrl == null
        ? 'placeholder'
        : 'network',
    videoAssetPath: videoAssetPath,
    videoUrl: videoAssetPath == null ? videoUrl : null,
    durationSeconds: _intFromJson(json['durationSeconds']),
    likes: json['likesCount'] as int? ?? 0,
    comments: json['commentsCount'] as int? ?? 0,
    shares: json['sharesCount'] as int? ?? 0,
    createdAt: _dateFromJson(json['createdAt']),
    fetchedAt: _dateFromJson(json['fetchedAt']),
    publishedAt: _dateFromJson(json['publishedAt']),
    expiresAt: _dateFromJson(json['expiresAt']),
    tags:
        (json['tags'] as List<dynamic>?)?.whereType<String>().toList() ??
        const <String>[],
    source: json['source'] as String? ?? 'backend_feed',
    sourceLabel: json['sourceLabel'] as String?,
    sourceType: sourceType,
    sourceProvider: sourceProvider,
    sourceUrl: json['sourceUrl'] as String?,
    licenseLabel: json['licenseLabel'] as String?,
    attributionText: json['attributionText'] as String?,
    attributionUrl: json['attributionUrl'] as String?,
    providerClipId: json['providerClipId'] as String?,
    isExternalContent:
        json['isExternalContent'] as bool? ?? sourceProvider != 'Mascotify',
    isCurated: json['isCurated'] as bool? ?? sourceType != 'userUpload',
    moderationStatus: json['moderationStatus'] as String? ?? 'published',
    contentOriginLabel:
        json['contentOriginLabel'] as String? ??
        (sourceProvider == 'Mascotify'
            ? 'Mascotify recomendado'
            : 'Fuente: $sourceProvider'),
    isDemoContent: false,
    isLiked: json['isLiked'] as bool? ?? false,
    isFollowingAuthor: json['isFollowingAuthor'] as bool? ?? false,
  );
}

class CloudinaryUploadSignature {
  const CloudinaryUploadSignature({
    required this.cloudName,
    required this.apiKey,
    required this.timestamp,
    required this.signature,
    required this.folder,
    required this.resourceType,
    required this.uploadUrl,
  });

  final String cloudName;
  final String apiKey;
  final int timestamp;
  final String signature;
  final String folder;
  final String resourceType;
  final String uploadUrl;

  factory CloudinaryUploadSignature.fromJson(Map<String, dynamic> json) {
    return CloudinaryUploadSignature(
      cloudName: json['cloudName'] as String,
      apiKey: json['apiKey'] as String,
      timestamp: json['timestamp'] as int,
      signature: json['signature'] as String,
      folder: json['folder'] as String,
      resourceType: json['resourceType'] as String,
      uploadUrl: json['uploadUrl'] as String,
    );
  }
}

class CloudinaryUploadResult {
  const CloudinaryUploadResult({
    required this.secureUrl,
    required this.publicId,
    this.thumbnailUrl,
    this.durationSeconds,
  });

  final String secureUrl;
  final String publicId;
  final String? thumbnailUrl;
  final int? durationSeconds;

  factory CloudinaryUploadResult.fromJson(Map<String, dynamic> json) {
    return CloudinaryUploadResult(
      secureUrl: json['secure_url'] as String,
      publicId: json['public_id'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      durationSeconds: _durationFromJson(json['duration']),
    );
  }
}

class SelectedClipVideo {
  const SelectedClipVideo({required this.name, required this.bytes});

  final String name;
  final Uint8List? bytes;
}

class ClipUploadDraft {
  const ClipUploadDraft({
    required this.title,
    required this.description,
    required this.animalType,
    required this.category,
  });

  final String title;
  final String description;
  final String animalType;
  final String category;
}

int? _durationFromJson(Object? value) {
  if (value is int) return value;
  if (value is double) return value.round();
  return null;
}

int? _intFromJson(Object? value) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _dateFromJson(Object? value) {
  if (value is! String || value.trim().isEmpty) return null;
  return DateTime.tryParse(value);
}

String? _assetPathOrNull(String? value, String prefix) {
  if (value == null || !value.startsWith(prefix)) {
    return null;
  }

  return value;
}
