import 'package:flutter_test/flutter_test.dart';
import 'package:snorvy/src/app/snorvy_app.dart';

void main() {
  testWidgets('shows the Snorvy tonight surface', (tester) async {
    await tester.pumpWidget(const SnorvyApp());

    expect(find.text('Snorvy'), findsWidgets);
    expect(find.text('Ready for tonight'), findsOneWidget);
    expect(find.text('Start local recording'), findsOneWidget);
    expect(find.text('No subscription. No trial.'), findsNothing);
  });
}
