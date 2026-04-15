import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/core/app.dart';

void main() {
  testWidgets('Mascotify renders main navigation labels', (tester) async {
    await tester.pumpWidget(const MascotifyApp());

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Mascotas'), findsOneWidget);
    expect(find.text('Explorar'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });
}
