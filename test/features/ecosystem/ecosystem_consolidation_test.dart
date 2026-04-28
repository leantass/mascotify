import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/data/app_data_source.dart';
import 'package:mascotify/shared/data/mock_data.dart';
import 'package:mascotify/shared/models/account_identity_models.dart';
import 'package:mascotify/shared/models/pet.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets(
    'family flow preserves QR, history, feed and notification after reconstruction',
    (tester) async {
      await _buildSession(
        ownerName: 'Familia Consolidada',
        email: 'ecosystem-family@mascotify.local',
        experience: AccountExperience.family,
      );
      final pet = _pet(id: 'pet-ecosystem-family', name: 'Ecosistema Local');
      await AppData.addPet(pet);
      await AppData.registerQrTraceabilityReview(pet.id);
      final qrCode = AppData.pets.single.qrCodeLabel;

      final restoredSession = await buildPersistentTestAppSession(
        resetPreferences: false,
      );
      await AppData.syncCurrentUserState();

      expect(
        restoredSession.controller.currentAccount?.email,
        'ecosystem-family@mascotify.local',
      );
      expect(AppData.pets.single.qrCodeLabel, qrCode);
      expect(
        AppData.petActivityEventsForPet(pet.id).map((event) => event.title),
        contains('Historial QR revisado'),
      );
      expect(
        AppData.ecosystemActivityFeed.map((item) => item.title),
        contains('Historial QR revisado'),
      );
      expect(
        AppData.notifications.any(
          (notification) => notification.title.contains('Ecosistema Local'),
        ),
        isTrue,
      );
    },
  );

  testWidgets('professional account does not see family QR activity', (
    tester,
  ) async {
    final session = await _buildSession(
      ownerName: 'Familia Base',
      email: 'ecosystem-family-isolated@mascotify.local',
      experience: AccountExperience.family,
    );
    final pet = _pet(id: 'pet-ecosystem-isolated', name: 'Dato Familiar');
    await AppData.addPet(pet);
    await AppData.registerQrTraceabilityReview(pet.id);

    await session.controller.register(
      ownerName: 'Veterinaria Consolidada',
      email: 'ecosystem-professional@mascotify.local',
      city: 'Buenos Aires',
      password: 'password123',
      experience: AccountExperience.professional,
    );
    await session.controller.completeOnboarding();
    await AppData.syncCurrentUserState();

    expect(AppData.pets, isEmpty);
    expect(AppData.petActivityEventsForPet(pet.id), isEmpty);
    expect(
      AppData.ecosystemActivityFeed.where(
        (item) => item.description.contains('Dato Familiar'),
      ),
      isEmpty,
    );
  });

  testWidgets('new account has no ghost pets, messages or notifications', (
    tester,
  ) async {
    await _buildSession(
      ownerName: 'Cuenta Limpia',
      email: 'ecosystem-empty@mascotify.local',
      experience: AccountExperience.family,
    );

    expect(AppData.pets, isEmpty);
    expect(AppData.messageThreads, isEmpty);
    expect(AppData.notifications, isEmpty);
    expect(AppData.ecosystemActivityFeed, isEmpty);
  });
}

Future<TestAppSession> _buildSession({
  required String ownerName,
  required String email,
  required AccountExperience experience,
}) async {
  final session = await buildPersistentTestAppSession();
  await session.controller.register(
    ownerName: ownerName,
    email: email,
    city: 'Buenos Aires',
    password: 'password123',
    experience: experience,
  );
  await session.controller.completeOnboarding();
  await AppData.syncCurrentUserState();
  return session;
}

Pet _pet({required String id, required String name}) {
  return MockData.pets.first.copyWith(
    id: id,
    name: name,
    profileId: 'MSC-$id',
    qrCodeLabel: 'MSC-$id',
  );
}
