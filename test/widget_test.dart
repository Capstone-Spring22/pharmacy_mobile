import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_mobile/views/user/widget/info_card.dart';

void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: InfoCard(
          text: "test",
          color: Colors.blue.shade800,
          icon: Icons.home,
        ),
      ),
    ));

    final stringFinder = find.text('test');
    final iconFinder = find.byIcon(Icons.home);

    expect(stringFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
  });
}
