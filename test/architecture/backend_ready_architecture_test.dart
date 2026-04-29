import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/local_persistent_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';

import '../test_helpers.dart';

void main() {
  tearDown(() {
    AppData.source = const MockMascotifyDataSource();
  });

  test('AppData keeps a mock data source fallback behind the contract', () {
    final source = const MockMascotifyDataSource();
    AppData.source = source;

    expect(AppData.source, isA<MascotifyDataSource>());
    expect(AppData.currentUser.id, MockData.currentUser.id);
    expect(AppData.pets, isNotEmpty);
  });

  test(
    'persistent local data source is wired through the AppData facade',
    () async {
      final session = await buildPersistentTestAppSession();

      expect(AppData.source, isA<MascotifyDataSource>());
      expect(AppData.source, isA<PersistentLocalMascotifyDataSource>());

      await session.controller.register(
        ownerName: 'Arquitectura Local',
        email: 'backend-ready-local@mascotify.local',
        city: 'Buenos Aires',
        password: 'password123',
        experience: AccountExperience.family,
      );
      await session.controller.completeOnboarding();
      await AppData.syncCurrentUserState();

      expect(AppData.pets, isEmpty);

      final pet = MockData.pets.first.copyWith(
        id: 'pet-backend-ready-local',
        name: 'Contrato Local',
        profileId: 'profile-backend-ready-local',
      );
      await AppData.addPet(pet);

      expect(AppData.findPetById(pet.id)?.name, 'Contrato Local');
      expect(
        AppData.ecosystemActivityFeed.map((item) => item.title),
        contains('Mascota creada'),
      );
    },
  );

  test(
    'local persistence remains available after app data reconstruction',
    () async {
      final firstSession = await buildPersistentTestAppSession();
      await firstSession.controller.register(
        ownerName: 'Arquitectura Persistente',
        email: 'backend-ready-persist@mascotify.local',
        city: 'Buenos Aires',
        password: 'password123',
        experience: AccountExperience.family,
      );
      await firstSession.controller.completeOnboarding();
      await AppData.syncCurrentUserState();

      final pet = MockData.pets.first.copyWith(
        id: 'pet-backend-ready-persist',
        name: 'Persistencia Arquitectura',
        profileId: 'profile-backend-ready-persist',
      );
      await AppData.addPet(pet);

      await buildPersistentTestAppSession(resetPreferences: false);

      expect(AppData.source, isA<PersistentLocalMascotifyDataSource>());
      expect(AppData.findPetById(pet.id)?.name, 'Persistencia Arquitectura');
    },
  );
}
