import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CheckoutScreen Drawer Tests', () {
    Cart buildCartWithOneItem() {
      final cart = Cart();
      cart.add(
        Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.white,
        ),
        quantity: 1,
      );
      return cart;
    }

    testWidgets('drawer opens and shows items', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(home: CheckoutScreen(cart: buildCartWithOneItem())));

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
