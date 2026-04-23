import 'package:flutter_test/flutter_test.dart';

import 'package:safrapp1/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SafarApp());
    expect(find.text('Safar'), findsOneWidget);
  });
}
