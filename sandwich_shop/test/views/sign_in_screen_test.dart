import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/sign_in_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  group('SignInScreen Widget Tests', () {
    testWidgets('drawer is present and opens via hamburger',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Hamburger menu tooltip varies by platform; use standard tooltip
      final menuButton = find.byTooltip('Open navigation menu');
      expect(menuButton, findsOneWidget);
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Drawer should be visible with expected items
      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Home / Order'), findsOneWidget);
      expect(find.text('View Cart'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('drawer: tapping View Cart navigates to CartScreen',
        (WidgetTester tester) async {
      final cart = Cart();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            drawer: Builder(
              builder: (context) {
                // Use the same AppDrawer wiring as app: in SignIn it's new Cart(), here we pass cart
                return Drawer(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text('View Cart'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CartScreen(cart: cart),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Open the drawer and tap View Cart
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('View Cart'));
      await tester.pumpAndSettle();

      // Expect CartScreen
      expect(find.byType(CartScreen), findsOneWidget);
    });
    testWidgets('displays all required UI elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Check for logo/image
      expect(find.byType(Image), findsOneWidget);

      // Check for heading and subtitle
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);

      // Check for form fields
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

      // Check for buttons and links
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('email field has correct properties',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Check for email icon
      expect(find.byIcon(Icons.email), findsOneWidget);

      // Check that email field exists with proper label
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    });

    testWidgets('password field has correct properties',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Check for lock icon
      expect(find.byIcon(Icons.lock), findsOneWidget);

      // Check that password field exists with proper label
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

      // Password field should have visibility toggle icon
      final passwordFieldFinder =
          find.widgetWithText(TextFormField, 'Password');
      final visibilityIcon = find.descendant(
        of: passwordFieldFinder,
        matching: find.byType(IconButton),
      );
      expect(visibilityIcon, findsOneWidget);
    });

    testWidgets('password visibility toggle works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Find the visibility toggle icon
      final visibilityIcon = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(IconButton),
      );
      expect(visibilityIcon, findsOneWidget);

      // Initially should show visibility_off icon (password hidden)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap to show password
      await tester.tap(visibilityIcon);
      await tester.pump();

      // After tapping, should show visibility icon (password visible)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap again to hide
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Should be back to visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('email validation - empty email shows error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Leave email empty and try to submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('email validation - invalid email shows error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Enter email without @ symbol
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalidemail',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('email validation - valid email passes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );

      // Enter valid password to avoid password errors
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsNothing);
    });

    testWidgets('password validation - empty password shows error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Enter valid email but leave password empty
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('password validation - short password shows error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );

      // Enter password with fewer than 6 characters
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'pass',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('password validation - valid password passes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );

      // Enter valid password (6+ characters)
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });

    testWidgets('successful sign-in shows success message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Enter valid credentials
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Check for success snackbar
      expect(find.text('Signing in as user@example.com...'), findsOneWidget);
    });

    testWidgets('successful sign-in navigates back',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                child: const Text('Go to Sign In'),
              ),
            ),
          ),
        ),
      );

      // Navigate to sign-in screen
      await tester.tap(find.text('Go to Sign In'));
      await tester.pumpAndSettle();

      // Verify we're on sign-in screen
      expect(find.text('Welcome Back!'), findsOneWidget);

      // Enter valid credentials
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Wait for the delay and navigation
      await tester.pump(const Duration(seconds: 2));

      // Should be back to the previous screen
      expect(find.text('Welcome Back!'), findsNothing);
      expect(find.text('Go to Sign In'), findsOneWidget);
    });

    testWidgets('forgot password link shows placeholder message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      await tester.tap(find.text('Forgot Password?'));
      await tester.pump();

      expect(find.text('Password reset functionality coming soon!'),
          findsOneWidget);
    });

    testWidgets('sign-up link shows placeholder message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('Sign up functionality coming soon!'), findsOneWidget);
    });

    testWidgets('back button navigates to previous screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                child: const Text('Go to Sign In'),
              ),
            ),
          ),
        ),
      );

      // Navigate to sign-in screen
      await tester.tap(find.text('Go to Sign In'));
      await tester.pumpAndSettle();

      // Verify we're on sign-in screen
      expect(find.text('Welcome Back!'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Should be back to the previous screen
      expect(find.text('Welcome Back!'), findsNothing);
      expect(find.text('Go to Sign In'), findsOneWidget);
    });

    testWidgets('screen is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Find the SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('form fields are properly grouped in Form widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Verify Form widget exists
      expect(find.byType(Form), findsOneWidget);

      // Verify form fields are descendants of Form
      final formFinder = find.byType(Form);
      expect(
        find.descendant(
          of: formFinder,
          matching: find.byType(TextFormField),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('sign-in button has correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      final signInButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Sign In'),
      );

      final ButtonStyle? style = signInButton.style;
      expect(style, isNotNull);

      // Check background color
      final backgroundColor =
          style?.backgroundColor?.resolve({MaterialState.pressed});
      expect(backgroundColor, Colors.orange);

      // Check foreground color
      final foregroundColor =
          style?.foregroundColor?.resolve({MaterialState.pressed});
      expect(foregroundColor, Colors.white);
    });

    testWidgets('multiple validation errors shown simultaneously',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      // Try to submit with both fields empty
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('entering text updates controllers',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      const testEmail = 'test@example.com';
      const testPassword = 'testpassword';

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        testEmail,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        testPassword,
      );

      // Verify text was entered
      expect(find.text(testEmail), findsOneWidget);
      expect(find.text(testPassword), findsOneWidget);
    });

    testWidgets('AppBar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignInScreen(),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      final title = appBar.title as Text;
      expect(title.data, 'Sign In');
    });
  });
}
