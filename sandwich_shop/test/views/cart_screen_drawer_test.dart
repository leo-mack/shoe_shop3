import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CartScreen Drawer Tests', () {
    Cart buildCartWithOneItem() {
      final cart = Cart();
      cart.add(
        Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ),
        quantity: 1,
      );
      return cart;
    }

    testWidgets('drawer opens and shows items', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(home: CartScreen(cart: buildCartWithOneItem())));

      expect(find.byTooltip('Open navigation menu'), findsOneWidget);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Home / Order'), findsOneWidget);
      expect(find.text('View Cart'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('About navigates to About route', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        routes: {
          '/about': (context) => const AboutScreen(),
        },
        home: CartScreen(cart: buildCartWithOneItem()),
      ));

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(find.byType(AboutScreen), findsOneWidget);
    });
  });
}
