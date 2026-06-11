import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/professional/presentation/screens/professional_dashboard_screen.dart';
import 'package:mascotify/features/professional/presentation/screens/professional_workspace_screen.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('professional screens are beta preview only', (tester) async {
    await tester.pumpWidget(buildTestApp(const ProfessionalDashboardScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Profesionales pet beta'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Por ahora es solo preview'),
      500,
    );
    expect(find.text('Por ahora es solo preview'), findsOneWidget);
    expect(find.textContaining('Ver perfil p'), findsNothing);

    await tester.pumpWidget(buildTestApp(const ProfessionalWorkspaceScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Profesionales pet beta'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Por ahora es solo preview'),
      500,
    );
    expect(find.text('Por ahora es solo preview'), findsOneWidget);
    expect(find.textContaining('Abrir perfil p'), findsNothing);
  });
}
