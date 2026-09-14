import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/main.dart';

void main() {
  testWidgets('catalog search filters products', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Wool Coat'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'trousers');
    await tester.pump();
    expect(find.text('Wide Trousers'), findsOneWidget);
    expect(find.text('Wool Coat'), findsNothing);
  });
}
