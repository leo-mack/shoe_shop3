import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:flutter/material.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as the home screen',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('Cart Model', () {
    test('updateQuantity updates item quantity correctly', () {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      expect(cart.getQuantity(sandwich), 1);
      
      cart.updateQuantity(0, 3);
      expect(cart.getQuantity(sandwich), 3);
    });

    test('updateQuantity removes item when quantity is 0', () {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      expect(cart.length, 1);
      
      cart.updateQuantity(0, 0);
      expect(cart.length, 0);
      expect(cart.isEmpty, true);
    });

    test('updateQuantity throws error for negative quantity', () {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      expect(() => cart.updateQuantity(0, -1), throwsArgumentError);
    });

    test('updateQuantity throws error for invalid index', () {
      final cart = Cart();
      
      expect(() => cart.updateQuantity(0, 1), throwsRangeError);
      expect(() => cart.updateQuantity(-1, 1), throwsRangeError);
    });

    test('removeAt removes item at correct index', () {
      final cart = Cart();
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.wheat,
        isFootlong: true,
      );
      
      cart.add(sandwich1);
      cart.add(sandwich2);
      expect(cart.length, 2);
      
      cart.removeAt(0);
      expect(cart.length, 1);
      expect(cart.getQuantity(sandwich1), 0);
      expect(cart.getQuantity(sandwich2), 1);
    });

    test('removeAt throws error for invalid index', () {
      final cart = Cart();
      
      expect(() => cart.removeAt(0), throwsRangeError);
      expect(() => cart.removeAt(-1), throwsRangeError);
    });

    test('itemsList returns items in list format', () {
      final cart = Cart();
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.wheat,
        isFootlong: true,
      );
      
      cart.add(sandwich1);
      cart.add(sandwich2);
      
      final list = cart.itemsList;
      expect(list.length, 2);
      expect(list[0].value, 1);
      expect(list[1].value, 1);
    });
  });

  group('CartScreen Widget', () {
    testWidgets('shows empty cart message when cart is empty', (WidgetTester tester) async {
      final cart = Cart();
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.delete_sweep), findsNothing);
    });

    testWidgets('displays cart items correctly', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
    });

    testWidgets('increment button increases quantity', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Qty: 1'), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      
      expect(find.text('Qty: 2'), findsOneWidget);
    });

    testWidgets('decrement button decreases quantity', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      cart.updateQuantity(0, 3);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Qty: 3'), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      
      expect(find.text('Qty: 2'), findsOneWidget);
    });

    testWidgets('decrement button is disabled when quantity is 1', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      final decrementButton = tester.widget<IconButton>(
        find.byIcon(Icons.remove_circle_outline),
      );
      
      expect(decrementButton.onPressed, isNull);
    });

    testWidgets('remove button shows confirmation dialog', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      
      expect(find.text('Remove Item'), findsOneWidget);
      expect(find.text('Are you sure you want to remove this item from your cart?'), findsOneWidget);
    });

    testWidgets('remove item confirmed removes item from cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Veggie Delight'), findsOneWidget);
      
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Remove').last);
      await tester.pumpAndSettle();
      
      expect(find.text('Veggie Delight'), findsNothing);
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('remove item cancelled keeps item in cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Veggie Delight'), findsOneWidget);
      
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(cart.length, 1);
    });

    testWidgets('clear cart button shows confirmation dialog', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();
      
      expect(find.text('Clear Cart'), findsNWidgets(2)); // Button + dialog title
      expect(find.text('Are you sure you want to remove all items from your cart?'), findsOneWidget);
    });

    testWidgets('clear cart confirmed empties the cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.wheat,
        isFootlong: true,
      );
      
      cart.add(sandwich1);
      cart.add(sandwich2);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();
      
      expect(find.text('Veggie Delight'), findsNothing);
      expect(find.text('Chicken Teriyaki'), findsNothing);
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Cart cleared'), findsOneWidget);
    });

    testWidgets('clear cart cancelled keeps items in cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(cart.length, 1);
    });

    testWidgets('total price updates when quantity changes', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      // Initial total
      expect(find.textContaining('Total: £'), findsOneWidget);
      final initialTotal = find.textContaining('Total: £');
      final initialText = tester.widget<Text>(initialTotal).data;
      
      // Increase quantity
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      
      // Check total updated
      final updatedTotal = find.textContaining('Total: £');
      final updatedText = tester.widget<Text>(updatedTotal).data;
      
      expect(initialText != updatedText, true);
    });

    testWidgets('displays multiple items correctly', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.wheat,
        isFootlong: true,
      );
      
      cart.add(sandwich1);
      cart.add(sandwich2);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
    });
  });
}


void main() {
  group('App', () {
    testWidgets('renders OrderScreen as the home screen',
        (WidgetTester tester) async {
      const App app = App();
      await tester.pumpWidget(app);
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('Cart Model', () {
    test('updateQuantity updates item quantity correctly', () {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'Test Sandwich',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      expect(cart.getQuantity(sandwich), 1);
      
      cart.updateQuantity(0, 3);
      expect(cart.getQuantity(sandwich), 3);
    });

    test('updateQuantity removes item when quantity is 0', () {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'Test Sandwich',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      expect(cart.length, 1);
      
      cart.updateQuantity(0, 0);
      expect(cart.length, 0);
      expect(cart.isEmpty, true);
    });

    test('updateQuantity throws error for negative quantity', () {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'Test Sandwich',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      expect(() => cart.updateQuantity(0, -1), throwsArgumentError);
    });

    test('updateQuantity throws error for invalid index', () {
      final cart = Cart();
      
      expect(() => cart.updateQuantity(0, 1), throwsRangeError);
      expect(() => cart.updateQuantity(-1, 1), throwsRangeError);
    });

    test('removeAt removes item at correct index', () {
      final cart = Cart();
      final sandwich1 = Sandwich(
        name: 'Sandwich 1',
        breadType: BreadType.white,
        isFootlong: false,
      );
      final sandwich2 = Sandwich(
        name: 'Sandwich 2',
        breadType: BreadType.wheat,
        isFootlong: true,
      );
      
      cart.add(sandwich1);
      cart.add(sandwich2);
      expect(cart.length, 2);
      
      cart.removeAt(0);
      expect(cart.length, 1);
      expect(cart.getQuantity(sandwich1), 0);
      expect(cart.getQuantity(sandwich2), 1);
    });

    test('removeAt throws error for invalid index', () {
      final cart = Cart();
      
      expect(() => cart.removeAt(0), throwsRangeError);
      expect(() => cart.removeAt(-1), throwsRangeError);
    });

    test('itemsList returns items in list format', () {
      final cart = Cart();
      final sandwich1 = Sandwich(
        name: 'Sandwich 1',
        breadType: BreadType.white,
        isFootlong: false,
      );
      final sandwich2 = Sandwich(
        name: 'Sandwich 2',
        breadType: BreadType.wheat,
        isFootlong: true,
      );
      
      cart.add(sandwich1);
      cart.add(sandwich2);
      
      final list = cart.itemsList;
      expect(list.length, 2);
      expect(list[0].value, 1);
      expect(list[1].value, 1);
    });
  });

  group('CartScreen Widget', () {
    testWidgets('shows empty cart message when cart is empty', (WidgetTester tester) async {
      final cart = Cart();
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.delete_sweep), findsNothing);
    });

    testWidgets('displays cart items correctly', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('BLT'), findsOneWidget);
      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
    });

    testWidgets('increment button increases quantity', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Qty: 1'), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      
      expect(find.text('Qty: 2'), findsOneWidget);
    });

    testWidgets('decrement button decreases quantity', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      cart.updateQuantity(0, 3);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('Qty: 3'), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      
      expect(find.text('Qty: 2'), findsOneWidget);
    });

    testWidgets('decrement button is disabled when quantity is 1', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      final decrementButton = tester.widget<IconButton>(
        find.byIcon(Icons.remove_circle_outline),
      );
      
      expect(decrementButton.onPressed, isNull);
    });

    testWidgets('remove button shows confirmation dialog', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      
      expect(find.text('Remove Item'), findsOneWidget);
      expect(find.text('Are you sure you want to remove this item from your cart?'), findsOneWidget);
    });

    testWidgets('remove item confirmed removes item from cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('BLT'), findsOneWidget);
      
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Remove').last);
      await tester.pumpAndSettle();
      
      expect(find.text('BLT'), findsNothing);
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('remove item cancelled keeps item in cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('BLT'), findsOneWidget);
      
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      expect(find.text('BLT'), findsOneWidget);
      expect(cart.length, 1);
    });

    testWidgets('clear cart button shows confirmation dialog', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();
      
      expect(find.text('Clear Cart'), findsNWidgets(2)); // Button + dialog title
      expect(find.text('Are you sure you want to remove all items from your cart?'), findsOneWidget);
    });

    testWidgets('clear cart confirmed empties the cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      final sandwich2 = Sandwich(
        name: 'Turkey',
        breadType: BreadType.wheat,
        isFootlong: true,
      );
      
      cart.add(sandwich1);
      cart.add(sandwich2);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('BLT'), findsOneWidget);
      expect(find.text('Turkey'), findsOneWidget);
      
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();
      
      expect(find.text('BLT'), findsNothing);
      expect(find.text('Turkey'), findsNothing);
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Cart cleared'), findsOneWidget);
    });

    testWidgets('clear cart cancelled keeps items in cart', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      expect(find.text('BLT'), findsOneWidget);
      expect(cart.length, 1);
    });

    testWidgets('total price updates when quantity changes', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      
      cart.add(sandwich);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      // Initial total
      expect(find.textContaining('Total: £'), findsOneWidget);
      final initialTotal = find.textContaining('Total: £');
      final initialText = tester.widget<Text>(initialTotal).data;
      
      // Increase quantity
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      
      // Check total updated
      final updatedTotal = find.textContaining('Total: £');
      final updatedText = tester.widget<Text>(updatedTotal).data;
      
      expect(initialText != updatedText, true);
    });

    testWidgets('displays multiple items correctly', (WidgetTester tester) async {
      final cart = Cart();
      final sandwich1 = Sandwich(
        name: 'BLT',
        breadType: BreadType.white,
        isFootlong: false,
      );
      final sandwich2 = Sandwich(
        name: 'Turkey',
        breadType: BreadType.wheat,
        isFootlong: true,
      );
      
      cart.add(sandwich1);
      cart.add(sandwich2);
      
      await tester.pumpWidget(
        MaterialApp(
          home: CartScreen(cart: cart),
        ),
      );
      
      expect(find.text('BLT'), findsOneWidget);
      expect(find.text('Turkey'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
    });
  });
}
