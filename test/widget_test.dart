import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/app.dart';
import 'package:mascotify/features/auth/data/local_auth_models.dart';
import 'package:mascotify/features/auth/data/local_auth_repository.dart';
import 'package:mascotify/features/auth/presentation/auth_session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Mascotify renders main navigation labels', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(preferences);
    final sessionController = AuthSessionController(repository: repository);

    await sessionController.initialize();
    await sessionController.login(
      email: LocalAuthSeedData.familyEmail,
      password: LocalAuthSeedData.demoPassword,
    );

    await tester.pumpWidget(MascotifyApp(sessionController: sessionController));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Mascotas'), findsOneWidget);
    expect(find.text('Explorar'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });
}
