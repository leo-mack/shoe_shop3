import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/about_screen.dart';

void main() {
  group('AboutScreen Drawer Tests', () {
    testWidgets('drawer opens and shows items', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutScreen()));

      expect(find.byTooltip('Open navigation menu'), findsOneWidget);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Home / Order'), findsOneWidget);
      expect(find.text('View Cart'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });
  });
}
