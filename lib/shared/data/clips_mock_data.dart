import '../models/social_models.dart';

class ClipsMockData {
  static const List<String> categories = [
    'Todos',
    'Tiernos',
    'Bloopers',
    'Consejos',
    'Rescates',
    'Profesionales',
  ];

  static const List<ExploreClip> clips = [
    ExploreClip(
      id: 'clip-01',
      title: 'El gato que se adueno del sillon',
      description:
          'Nina practica mirada de reina mientras decide si comparte o no el lugar.',
      category: 'Tiernos',
      animalType: 'Gato',
      likes: 128,
      comments: 18,
      sourceLabel: 'Mascotify demo',
    ),
    ExploreClip(
      id: 'clip-02',
      title: 'Perro aprende a usar su QR',
      description:
          'Milo espera su premio despues de mostrar la placa como todo un profesional.',
      category: 'Consejos',
      animalType: 'Perro',
      likes: 94,
      comments: 11,
      sourceLabel: 'Mascotify demo',
    ),
    ExploreClip(
      id: 'clip-03',
      title: 'Bloopers de cachorros',
      description:
          'Tres intentos, cero coordinacion y mucha energia para volver a probar.',
      category: 'Bloopers',
      animalType: 'Perro',
      likes: 212,
      comments: 36,
      sourceLabel: 'Mascotify demo',
    ),
    ExploreClip(
      id: 'clip-04',
      title: 'Consejo rapido: hidratacion en verano',
      description:
          'Una guia corta para revisar agua, sombra y horarios de paseo en dias calurosos.',
      category: 'Consejos',
      animalType: 'Perro y gato',
      likes: 176,
      comments: 24,
      sourceLabel: 'Mascotify demo',
    ),
    ExploreClip(
      id: 'clip-05',
      title: 'Rescate con final feliz',
      description:
          'Una familia muestra como ordeno los primeros cuidados despues del reencuentro.',
      category: 'Rescates',
      animalType: 'Gato',
      likes: 305,
      comments: 49,
      sourceLabel: 'Mascotify demo',
    ),
    ExploreClip(
      id: 'clip-06',
      title: 'Veterinaria responde: senales de alerta',
      description:
          'Checklist breve para saber cuando conviene consultar sin esperar.',
      category: 'Profesionales',
      animalType: 'General',
      likes: 143,
      comments: 20,
      sourceLabel: 'Mascotify demo',
    ),
  ];

  const ClipsMockData._();
}
