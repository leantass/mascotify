import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/explore/presentation/screens/explore_screen.dart';
import 'package:mascotify/features/profile/presentation/screens/help_screen.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('HelpScreen contiene temas principales y contenido breve', (
    tester,
  ) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const HelpScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Centro de ayuda'), findsOneWidget);
    expect(find.text('Primeros pasos'), findsWidgets);
    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Mascotas'), findsWidgets);
    expect(find.text('Perfil de mascota'), findsWidgets);
    expect(find.text('QR seguro'), findsWidgets);
    expect(find.text('Salud y vacunas'), findsWidgets);
    expect(find.text('Calendario y recordatorios'), findsWidgets);
    expect(find.text('Mascotas perdidas'), findsWidgets);
    expect(find.text('Explorar'), findsWidgets);
    expect(find.text('Clips'), findsWidgets);
    expect(find.text('Matching'), findsWidgets);
    expect(find.text('Comunidad'), findsWidgets);
    expect(find.text('Actividad'), findsWidgets);
    expect(find.text('Perfil y configuracion'), findsWidgets);
    expect(find.text('Apariencia y modo oscuro'), findsWidgets);
    expect(find.text('Privacidad y seguridad'), findsWidgets);
    expect(find.text('Profesionales pet beta'), findsWidgets);
    expect(find.text('Planes Free / Plus / Pro'), findsWidgets);
    expect(find.text('Publicidad'), findsWidgets);
    expect(find.text('Preguntas frecuentes'), findsWidgets);
  });

  testWidgets('HelpScreen abre el tema contextual expandido', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(
      buildTestApp(const HelpScreen(initialTopic: HelpTopic.matching)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tema abierto: Matching.'), findsOneWidget);
    expect(find.text('Que es'), findsOneWidget);
    expect(find.textContaining('Deck local'), findsOneWidget);
    expect(find.textContaining('contacto real sera mediado'), findsOneWidget);
    expect(find.textContaining('@'), findsNothing);
    expect(find.textContaining('+54'), findsNothing);
  });

  testWidgets('copy largo de Explorar se mueve a Ayuda', (tester) async {
    setDesktopViewport(tester);

    await tester.pumpWidget(buildTestApp(const ExploreScreen()));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('futuras oportunidades de matching'),
      findsNothing,
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('contextual-help-explore')),
      600,
    );
    await tester.pumpAndSettle();
    expect(find.text('Ver ayuda sobre Explorar'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('contextual-help-explore')));
    await tester.pumpAndSettle();

    expect(find.text('Tema abierto: Explorar.'), findsOneWidget);
    expect(find.textContaining('descubrir perfiles'), findsWidgets);
  });
}
