import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/models/social_models.dart';

void main() {
  test('ExploreClip soporta fuente online, licencia y atribucion', () {
    final fetchedAt = DateTime.utc(2026, 6, 10);
    final clip = ExploreClip(
      id: 'pexels-123',
      title: 'Bloopers de perros',
      description: 'Clip curado con licencia permitida.',
      category: 'Bloopers',
      animalType: 'Perro',
      videoSourceType: 'network',
      videoUrl: 'https://cdn.example.com/clip.mp4',
      thumbnailUrl: 'https://cdn.example.com/clip.jpg',
      likes: 12,
      comments: 3,
      sourceType: 'licensedStock',
      sourceProvider: 'Pexels',
      sourceUrl: 'https://www.pexels.com/video/example',
      licenseLabel: 'Pexels License',
      attributionText: 'Video by Creator on Pexels',
      attributionUrl: 'https://www.pexels.com/@creator',
      providerClipId: '123',
      fetchedAt: fetchedAt,
      publishedAt: fetchedAt,
      isExternalContent: true,
      isCurated: true,
      moderationStatus: 'published',
      contentOriginLabel: 'Fuente: Pexels',
      isDemoContent: false,
    );

    final restored = ExploreClip.fromJson(clip.toJson());

    expect(restored.sourceType, 'licensedStock');
    expect(restored.sourceProvider, 'Pexels');
    expect(restored.licenseLabel, 'Pexels License');
    expect(restored.attributionText, 'Video by Creator on Pexels');
    expect(restored.providerClipId, '123');
    expect(restored.isExternalContent, isTrue);
    expect(restored.isCurated, isTrue);
    expect(restored.contentOriginLabel, 'Fuente: Pexels');
    expect(restored.hasPlayableVideo, isTrue);
  });

  test('clips demo existentes mantienen fallback local funcionando', () {
    const clip = ExploreClip(
      id: 'demo',
      title: 'Demo',
      description: 'Clip guardado',
      category: 'Juego',
      animalType: 'Perro',
      videoSourceType: 'asset',
      videoAssetPath: 'assets/videos/clips/demo.mp4',
      likes: 1,
      comments: 0,
    );

    expect(clip.sourceType, 'seededDemo');
    expect(clip.sourceProvider, 'Demo');
    expect(clip.licenseLabel, 'Mascotify demo/local');
    expect(clip.hasPlayableVideo, isTrue);
  });
}
