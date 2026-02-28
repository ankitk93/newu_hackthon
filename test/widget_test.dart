import 'package:flutter_test/flutter_test.dart';
import 'package:newu_health/app.dart';

void main() {
  testWidgets('App launches and shows setup screen', (tester) async {
    await tester.pumpWidget(const NewUApp());
    await tester.pumpAndSettle();

    // Verify the setup screen title is shown
    expect(find.text('Set your pace'), findsOneWidget);
  });
}
