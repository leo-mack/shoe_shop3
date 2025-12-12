# Feature Prompt: User Authentication (Sign-In Screen)

## Quick Summary
Add a user authentication sign-in screen to the sandwich shop app, accessible via a floating action button on the order screen's bottom-left corner.

---

## Feature Request

**Title**: Implement User Authentication with Sign-In Screen

**User Story**: 
As a customer of the sandwich shop app, I want to sign in to my account so that I can access personalized features, save my preferences, and view my order history.

---

## What to Build

### 1. Sign-In Screen (`lib/views/sign_in_screen.dart`)

Create a new StatefulWidget screen with the following components:

**Header Section:**
- App logo (displayed at top)
- "Welcome Back!" heading (large, centered)
- "Sign in to your account" subtitle (smaller, centered)

**Form Section:**
- Email input field
  - Label: "Email"
  - Hint: "Enter your email"
  - Icon: email icon (prefix)
  - Keyboard type: email
  - Validation: must not be empty, must contain "@"
  
- Password input field
  - Label: "Password"
  - Hint: "Enter your password"
  - Icon: lock icon (prefix)
  - Obscured text by default
  - Visibility toggle icon (suffix)
  - Validation: must not be empty, minimum 6 characters

**Action Buttons:**
- "Sign In" button (full width, orange background, white text)
- "Forgot Password?" link (centered, blue text)
- "Don't have an account? Sign Up" text with clickable "Sign Up" link (orange, bold)

**Functionality:**
- Form validation on submit
- Display validation errors inline
- Show success SnackBar: "Signing in as [email]..." (green background)
- Navigate back to order screen after 1 second delay
- Placeholder messages for forgot password and sign-up ("coming soon!")
- Password visibility toggle (eye icon with/without slash)

---

### 2. Order Screen Updates (`lib/views/order_screen.dart`)

**Add Floating Action Button:**
- Widget: `FloatingActionButton.extended`
- Position: `FloatingActionButtonLocation.startFloat` (bottom-left)
- Icon: `Icons.person`
- Label: "Sign In"
- Background color: Orange (`Colors.orange`)
- Foreground color: White (`Colors.white`)
- Action: Navigate to SignInScreen

**Add Navigation Method:**
```dart
void _navigateToSignIn() {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const SignInScreen(),
    ),
  );
}
```

---

## Technical Requirements

### Form Validation Rules
- **Email**:
  - Required (show error: "Please enter your email")
  - Must contain "@" symbol (show error: "Please enter a valid email")
  
- **Password**:
  - Required (show error: "Please enter your password")
  - Minimum 6 characters (show error: "Password must be at least 6 characters")

### State Management
- Use `TextEditingController` for email and password
- Use `GlobalKey<FormState>` for form validation
- Use boolean state for password visibility toggle
- Properly dispose controllers to prevent memory leaks

### User Feedback
- Show validation errors inline below form fields
- Show success SnackBar with green background when form is valid
- Show placeholder SnackBars for "Forgot Password" and "Sign Up" links
- Auto-navigate back to order screen after successful sign-in

---

## UI/UX Guidelines

### Design Consistency
- Use existing `app_styles.dart` for text styles (heading1, heading2, normalText)
- Match app's orange color theme
- Maintain consistent spacing (use SizedBox with heights: 10, 20, 40)
- Keep professional and clean appearance

### Layout
- Center all content vertically and horizontally
- Make screen scrollable (use `SingleChildScrollView`)
- Add padding around form (24.0 on all sides)
- Input fields span full width
- Sign-in button spans full width with 16px vertical padding

### Icons
- Email field: `Icons.email`
- Password field: `Icons.lock`
- Password hidden: `Icons.visibility_off`
- Password visible: `Icons.visibility`
- Floating button: `Icons.person`

### Colors
- Primary action (Sign In button): Orange
- Success messages: Green
- Links: Blue (forgot password), Orange (sign up)
- Default text: Inherit from theme

---

## Example Code Structure

### Sign-In Screen Skeleton
```dart
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      // Navigate back after delay
    }
  }
  
  String? _validateEmail(String? value) {
    // Validation logic
  }
  
  String? _validatePassword(String? value) {
    // Validation logic
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(...),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Logo, heading, form fields, buttons
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Acceptance Checklist

Before considering the feature complete, verify:

- [ ] Floating action button appears on order screen (bottom-left)
- [ ] Button navigates to sign-in screen when tapped
- [ ] Sign-in screen displays all required UI elements
- [ ] Email validation works (empty check, @ symbol check)
- [ ] Password validation works (empty check, minimum length)
- [ ] Password visibility toggle works
- [ ] Form submission shows success message
- [ ] Screen auto-navigates back after sign-in
- [ ] Forgot password link shows placeholder message
- [ ] Sign-up link shows placeholder message
- [ ] Back button in AppBar returns to order screen
- [ ] No compiler errors or warnings
- [ ] Consistent styling with rest of app
- [ ] Works on both iOS and Android
- [ ] Keyboard doesn't cover form fields
- [ ] Form is scrollable on smaller screens

---

## Future Enhancements (Not in Scope)

These features are planned for later but NOT part of this implementation:
- Backend authentication integration
- Actual password reset functionality
- Real sign-up flow
- Social media login (Google, Facebook)
- Biometric authentication
- Session persistence
- User profile management

---

## Notes for Implementation

1. **Start with the sign-in screen** - Create the full UI and validation first
2. **Test form validation thoroughly** - Try various invalid inputs
3. **Add the floating button last** - Once sign-in screen is working
4. **Use const constructors** - Where possible for better performance
5. **Handle keyboard properly** - Ensure form remains accessible when keyboard appears
6. **Test on real devices** - Emulators may not show keyboard issues

---

## Success Criteria

The feature is successful when:
- Users can tap the floating button and reach the sign-in screen
- Email and password validation prevents invalid submissions
- Users receive clear feedback for both errors and success
- The experience feels professional and polished
- Code is clean, well-structured, and follows Flutter best practices
