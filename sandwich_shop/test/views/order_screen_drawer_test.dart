import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';

void main() {
  group('OrderScreen Drawer Tests', () {
    testWidgets('drawer opens and shows items', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

      expect(find.byTooltip('Open navigation menu'), findsOneWidget);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Home / Order'), findsOneWidget);
      expect(find.text('View Cart'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('View Cart navigates to CartScreen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('View Cart'));
      await tester.pumpAndSettle();

      expect(find.byType(CartScreen), findsOneWidget);
    });

    testWidgets('About navigates to About route', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        routes: {
          '/about': (context) => const AboutScreen(),
        },
        home: const OrderScreen(),
      ));

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(find.byType(AboutScreen), findsOneWidget);
    });
  });
}
