import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CartScreen', () {
    testWidgets('displays empty cart message when cart is empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      final CartScreen cartScreen = CartScreen(cart: emptyCart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('displays cart items when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Qty: 2 - £22.00'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('displays multiple cart items correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Six-inch on wheat bread'), findsOneWidget);
      expect(find.text('Qty: 1 - £11.00'), findsOneWidget);
      expect(find.text('Qty: 3 - £21.00'), findsOneWidget);
      expect(find.text('Total: £32.00'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      final Finder backButtonFinder =
          find.widgetWithText(StyledButton, 'Back to Order');
      expect(backButtonFinder, findsOneWidget);

      final StyledButton backButton =
          tester.widget<StyledButton>(backButtonFinder);
      expect(backButton.onPressed, isNotNull);
    });

    testWidgets('displays logo in app bar', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final appBarImagesFinder = find.descendant(
        of: appBarFinder,
        matching: find.byType(Image),
      );
      expect(appBarImagesFinder, findsOneWidget);

      final Image logoImage = tester.widget(appBarImagesFinder);
      expect(
          (logoImage.image as AssetImage).assetName, 'assets/images/logo.png');
    });

    testWidgets('displays correct pricing for different sandwich types',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 3);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Qty: 3 - £33.00'), findsOneWidget);
      expect(find.text('Total: £33.00'), findsOneWidget);
    });

    testWidgets('shows empty cart message when removing all items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.add(sandwich);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Your cart is empty'), findsNothing);

      // Tap remove button
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Confirm removal
      await tester.tap(find.text('Remove').last);
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('increment button increases quantity',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Qty: 1'), findsOneWidget);

      // Tap increment button
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();

      expect(find.text('Qty: 2'), findsOneWidget);
    });

    testWidgets('decrement button decreases quantity',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      cart.add(sandwich, quantity: 3);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Qty: 3'), findsOneWidget);

      // Tap decrement button
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();

      expect(find.text('Qty: 2'), findsOneWidget);
    });

    testWidgets('decrement button is disabled when quantity is 1',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      final IconButton decrementButton = tester.widget<IconButton>(
        find.byIcon(Icons.remove_circle_outline),
      );

      expect(decrementButton.onPressed, isNull);
    });

    testWidgets('remove button shows confirmation dialog',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(find.text('Remove Item'), findsOneWidget);
      expect(
          find.text(
              'Are you sure you want to remove this item from your cart?'),
          findsOneWidget);
    });

    testWidgets('remove button cancel keeps item in cart',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Chicken Teriyaki'), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Item removed from cart'), findsNothing);
    });

    testWidgets('clear cart button shows confirmation dialog',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Clear Cart'), findsNWidgets(2));
      expect(
          find.text(
              'Are you sure you want to remove all items from your cart?'),
          findsOneWidget);
    });

    testWidgets('clear cart confirmed removes all items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1);
      cart.add(sandwich2);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Meatball Marinara'), findsOneWidget);

      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsNothing);
      expect(find.text('Meatball Marinara'), findsNothing);
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Cart cleared'), findsOneWidget);
    });

    testWidgets('clear cart cancel keeps items in cart',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.add(sandwich);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Chicken Teriyaki'), findsOneWidget);

      await tester.tap(find.text('Clear Cart'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Cart cleared'), findsNothing);
    });

    testWidgets('total price updates when quantity changes',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      // Get initial total
      expect(find.textContaining('Total: £'), findsOneWidget);
      String initialTotal =
          tester.widget<Text>(find.textContaining('Total: £')).data ?? '';

      // Increment quantity
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();

      // Verify total changed
      String updatedTotal =
          tester.widget<Text>(find.textContaining('Total: £')).data ?? '';
      expect(initialTotal != updatedTotal, true);
    });
  });
}
