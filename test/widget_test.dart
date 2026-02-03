import 'package:flutter_test/flutter_test.dart';
import 'package:yollr_admin_panel/main.dart';

void main() {
  testWidgets('Admin panel smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const YollrAdminApp());

    // Verify that dashboard is shown
    expect(find.text('Dashboard Overview'), findsOneWidget);
  });
}
