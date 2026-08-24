import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('SaarAI app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SaarAIApp());

    expect(find.text('SAARAI'), findsOneWidget);
  });
}