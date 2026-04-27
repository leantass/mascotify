import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/features/professional/presentation/screens/professional_dashboard_screen.dart';
import 'package:mascotify/features/professional/presentation/screens/professional_workspace_screen.dart';

import '../../test_helpers.dart';

void main() {
  testWidgets('professional screens expose public profile actions', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(const ProfessionalDashboardScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Ver perfil público'), findsOneWidget);

    await tester.pumpWidget(buildTestApp(const ProfessionalWorkspaceScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Abrir perfil público'), findsOneWidget);
  });
}
