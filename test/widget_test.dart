import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:widget/main.dart';

void main() {
  testWidgets('Ultra.X splash renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Top Up Cepat & Mudah'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
