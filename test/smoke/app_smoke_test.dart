import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/app.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('Mascotify opens on the unauthenticated screen', (tester) async {
    final controller = await buildTestAuthController();

    await tester.pumpWidget(MascotifyApp(sessionController: controller));
    await tester.pumpAndSettle();

    expect(find.text('Mascotify'), findsWidgets);
    expect(find.text('Iniciar sesión'), findsWidgets);
    expect(find.text('Crear cuenta'), findsWidgets);
  });
}
