import 'package:flutter_test/flutter_test.dart';
import 'package:all_in_one_rpg/main.dart';

void main() {
  testWidgets('App title test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HolofoteApp());

    // Verify that the title is present.
    expect(find.text('Holofote manager'), findsOneWidget);
  });
}
