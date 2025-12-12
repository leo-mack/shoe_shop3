# Requirements Document: Cart Item Modification Feature

## 1. Feature Description and Purpose

### Overview
The Cart Item Modification feature allows users to manage items in their shopping cart after they have been added. This includes adjusting quantities, removing individual items, and clearing the entire cart.

### Purpose
- **Enhance User Control**: Give users full control over their cart contents without requiring them to return to the order screen
- **Improve User Experience**: Allow users to correct mistakes or change their minds about order quantities
- **Reduce Friction**: Minimize the steps required to modify an order, leading to higher conversion rates
- **Prevent Cart Abandonment**: Make it easy for users to adjust their orders, reducing the likelihood they abandon their cart due to inability to make changes

### Business Value
- Improved customer satisfaction through better cart management
- Reduced support requests related to order modifications
- Higher order completion rates
- Better alignment with standard e-commerce UX patterns

---

## 2. User Stories

### US-1: Adjust Item Quantity
**As a** customer who has added items to my cart  
**I want to** increase or decrease the quantity of items already in my cart  
**So that** I can adjust my order without having to remove and re-add items

**Priority**: High  
**Story Points**: 5

---

### US-2: Remove Single Item
**As a** customer reviewing my cart  
**I want to** remove a specific item from my cart  
**So that** I can eliminate items I no longer want to purchase

**Priority**: High  
**Story Points**: 3

---

### US-3: Clear Entire Cart
**As a** customer who wants to start over  
**I want to** remove all items from my cart at once  
**So that** I can quickly reset my order without removing items one by one

**Priority**: Medium  
**Story Points**: 3

---

### US-4: Prevent Accidental Deletions
**As a** customer managing my cart  
**I want to** be asked to confirm before removing items or clearing my cart  
**So that** I don't accidentally delete items I want to keep

**Priority**: High  
**Story Points**: 2

---

### US-5: See Updated Totals
**As a** customer modifying my cart  
**I want to** see the updated total price immediately after making changes  
**So that** I know exactly how much my order will cost

**Priority**: High  
**Story Points**: 2

---

## 3. Acceptance Criteria

### Feature-Level Acceptance Criteria
- [ ] All cart modifications update the UI without requiring page refresh
- [ ] All cart modifications persist during the user's session
- [ ] Total price recalculates correctly after every modification
- [ ] UI remains responsive during all operations
- [ ] No data loss occurs during cart modifications

---

### AC-1: Change Item Quantity (Increase)

**Given** I am on the cart screen with at least one item in my cart  
**When** I tap the "+" button next to an item  
**Then** the item quantity increases by 1  
**And** the item's subtotal updates to reflect the new quantity  
**And** the cart total price updates immediately  
**And** the change is reflected in the UI without page refresh

**Additional Criteria**:
- [ ] The "+" button is always enabled (no maximum quantity limit)
- [ ] The quantity display updates immediately
- [ ] Price calculations are accurate (quantity × unit price)
- [ ] Multiple rapid taps are handled correctly

---

### AC-2: Change Item Quantity (Decrease)

**Given** I am on the cart screen with an item that has quantity > 1  
**When** I tap the "-" button next to that item  
**Then** the item quantity decreases by 1  
**And** the item's subtotal updates to reflect the new quantity  
**And** the cart total price updates immediately  
**And** the change is reflected in the UI without page refresh

**Additional Criteria**:
- [ ] When quantity = 1, the "-" button is disabled or visually indicates it cannot be pressed
- [ ] Attempting to decrease below 1 has no effect
- [ ] The quantity display updates immediately
- [ ] Price calculations are accurate

---

### AC-3: Remove Single Item from Cart

**Given** I am on the cart screen with at least one item  
**When** I tap the remove/delete button next to an item  
**Then** a confirmation dialog appears asking "Remove this item from cart?"  
**And** the dialog has "Cancel" and "Remove" options

**When** I tap "Remove" in the confirmation dialog  
**Then** the item is removed from the cart  
**And** the cart display updates to show remaining items  
**And** the total price updates to exclude the removed item  
**And** if the cart is now empty, an empty cart message is displayed

**When** I tap "Cancel" in the confirmation dialog  
**Then** the dialog closes  
**And** the item remains in the cart  
**And** no changes are made

**Additional Criteria**:
- [ ] Remove button is clearly visible for each cart item
- [ ] Confirmation dialog prevents accidental removal
- [ ] Removing the last item shows appropriate empty state
- [ ] UI handles removal of any item (first, last, or middle of list)

---

### AC-4: Clear Entire Cart

**Given** I am on the cart screen with at least one item  
**When** I tap the "Clear Cart" button  
**Then** a confirmation dialog appears asking "Remove all items from cart?"  
**And** the dialog has "Cancel" and "Clear" options

**When** I tap "Clear" in the confirmation dialog  
**Then** all items are removed from the cart  
**And** an empty cart message is displayed  
**And** the total price shows $0.00 or is hidden

**When** I tap "Cancel" in the confirmation dialog  
**Then** the dialog closes  
**And** all items remain in the cart  
**And** no changes are made

**Additional Criteria**:
- [ ] "Clear Cart" button is only visible when cart has items
- [ ] "Clear Cart" button is easily accessible (AppBar or prominent location)
- [ ] Confirmation prevents accidental clearing
- [ ] Empty state is user-friendly and helpful

---

### AC-5: Empty Cart State

**Given** my cart is empty (no items)  
**When** I navigate to the cart screen  
**Then** I see a message indicating the cart is empty  
**And** I see a suggestion or button to return to the order screen  
**And** the "Clear Cart" button is not visible

**Additional Criteria**:
- [ ] Empty state is visually clear and not confusing
- [ ] Message is friendly and guides user to next action
- [ ] No error states or broken UI elements

---

### AC-6: Real-Time Price Updates

**Given** I am on the cart screen  
**When** I modify any item quantity (increase or decrease)  
**Then** the item's subtotal updates immediately  
**And** the cart total updates immediately  
**And** all prices are formatted correctly (e.g., $XX.XX)  
**And** calculations are mathematically accurate

**Additional Criteria**:
- [ ] Price updates are smooth (no flicker or delay)
- [ ] All currency formatting is consistent
- [ ] Floating-point arithmetic is handled correctly (no rounding errors)

---

## 4. Technical Requirements

### 4.1 Cart Model Updates (`lib/models/cart.dart`)
- [ ] Implement `updateQuantity(int index, int newQuantity)` method
- [ ] Implement `removeAt(int index)` method  
- [ ] Implement `clear()` method
- [ ] Ensure all methods trigger proper state updates
- [ ] Maintain existing functionality (add items, calculate totals)

### 4.2 CartScreen UI Updates (`lib/views/cart_screen.dart`)
- [ ] Add quantity control buttons (+ and -) for each item
- [ ] Add remove button/icon for each item
- [ ] Add "Clear Cart" button in AppBar or bottom of screen
- [ ] Implement confirmation dialogs for destructive actions
- [ ] Display empty cart state when no items present
- [ ] Use `setState()` or state management to trigger UI rebuilds

### 4.3 Code Quality
- [ ] Follow existing code style and conventions
- [ ] Use meaningful variable and function names
- [ ] Add comments for complex logic
- [ ] Handle edge cases gracefully
- [ ] No console errors or warnings

---

## 5. Testing Requirements

### 5.1 Unit Tests
- [ ] Test `updateQuantity()` method with various quantities
- [ ] Test `removeAt()` method with different indices
- [ ] Test `clear()` method
- [ ] Test edge cases (empty cart, single item, etc.)

### 5.2 Widget Tests
- [ ] Test quantity increment button functionality
- [ ] Test quantity decrement button functionality
- [ ] Test decrement button disabled state when quantity = 1
- [ ] Test remove item with confirmation dialog (confirm and cancel paths)
- [ ] Test clear cart with confirmation dialog (confirm and cancel paths)
- [ ] Test price updates after quantity changes
- [ ] Test empty cart state display
- [ ] Test UI state after removing last item

### 5.3 Integration Tests (Optional)
- [ ] Test complete user flow: add items → modify quantities → remove items
- [ ] Test navigation between order screen and cart screen with modifications

---

## 6. UI/UX Requirements

### 6.1 Visual Design
- [ ] Quantity controls are clearly labeled and easy to tap
- [ ] Remove buttons use clear iconography (trash can, X, etc.)
- [ ] Disabled buttons are visually distinct from enabled buttons
- [ ] Confirmation dialogs are centered and clearly worded
- [ ] Empty cart state is friendly and non-alarming

### 6.2 Interaction Design
- [ ] All buttons have appropriate touch targets (minimum 44x44 points)
- [ ] Buttons provide visual feedback when tapped
- [ ] Animations are smooth and not jarring
- [ ] No lag between tap and response

### 6.3 Accessibility
- [ ] All interactive elements are keyboard accessible
- [ ] Screen reader compatible labels for all buttons
- [ ] Sufficient color contrast for text and buttons
- [ ] Focus indicators are visible

---

## 7. Non-Functional Requirements

### 7.1 Performance
- [ ] Cart modifications complete in < 100ms
- [ ] UI updates are smooth (60 fps)
- [ ] No memory leaks from repeated operations

### 7.2 Compatibility
- [ ] Works on iOS devices
- [ ] Works on Android devices  
- [ ] Works on web browsers
- [ ] Responsive design for different screen sizes

### 7.3 Maintainability
- [ ] Code is modular and reusable
- [ ] Clear separation of concerns (model, view, logic)
- [ ] Easy to extend with future features

---

## 8. Definition of Done

The Cart Item Modification feature is considered complete when:

1. ✅ All acceptance criteria are met and verified
2. ✅ All unit tests pass
3. ✅ All widget tests pass
4. ✅ Code review is completed and approved
5. ✅ Manual testing on iOS, Android, and web is successful
6. ✅ No critical or high-priority bugs remain
7. ✅ Documentation is updated (if applicable)
8. ✅ Feature is merged to main branch
9. ✅ Product owner accepts the feature

---

## 9. Out of Scope

The following are explicitly **not** part of this feature:

- ❌ Saving cart state between app sessions (persistence)
- ❌ Undo/redo functionality for cart modifications
- ❌ Animations for item removal
- ❌ Batch operations (select multiple items to remove)
- ❌ Item favoriting or save for later
- ❌ Maximum quantity limits
- ❌ Stock availability checks

These may be considered for future iterations.

---

## 10. Dependencies

- Existing Cart model (`lib/models/cart.dart`)
- Existing CartScreen widget (`lib/views/cart_screen.dart`)
- Existing Sandwich model (`lib/models/sandwich.dart`)
- Existing PricingRepository (`lib/repositories/pricing_repository.dart`)
- Flutter material design widgets
- Flutter testing framework

---

## 11. Risks and Mitigation

| Risk | Probability | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| State management issues causing UI not to update | Medium | High | Thorough testing of setState calls; consider state management solution if issues persist |
| Floating-point arithmetic errors in price calculations | Low | Medium | Use proper decimal handling; write comprehensive price calculation tests |
| Confirmation dialogs not preventing accidental deletions | Low | High | User testing to ensure dialogs are effective; clear button labeling |
| Performance issues with large carts | Low | Medium | Test with 50+ items; optimize if necessary |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-12 | Initial | Created requirements document |
| 1.1 | 2025-12-12 | Update | Added User Authentication Feature requirements |

---

# Feature Request: User Authentication (Sign-In Screen)

## Feature Prompt

**Title**: Implement User Authentication with Sign-In Screen

**Description**: Add user authentication capabilities to the sandwich shop app by creating a dedicated sign-in screen accessible from the order screen. Users should be able to sign in with email and password credentials through a secure and user-friendly interface.

**User Story**: As a customer of the sandwich shop app, I want to sign in to my account so that I can access personalized features, save my preferences, and view my order history.

**Access Point**: Add a floating action button on the bottom-left corner of the order screen with a person icon and "Sign In" label that navigates to the sign-in screen.

---

## Requirements: User Authentication Feature

### 1. Feature Overview

#### Purpose
- Enable user authentication for personalized experiences
- Provide secure credential entry for email/password login
- Create foundation for future features (order history, saved addresses, preferences)
- Improve user engagement through personalized accounts

#### Business Value
- Increased user retention through account creation
- Foundation for loyalty programs and personalized marketing
- Better user data collection for analytics
- Enhanced security for user orders and payment information

---

### 2. User Stories

#### US-6: Access Sign-In Screen
**As a** new or returning customer  
**I want to** easily access the sign-in screen from the main ordering interface  
**So that** I can log into my account without navigating through multiple menus

**Priority**: High  
**Story Points**: 2

---

#### US-7: Sign In with Email and Password
**As a** registered customer  
**I want to** sign in using my email address and password  
**So that** I can access my account and personalized features

**Priority**: High  
**Story Points**: 5

---

#### US-8: View Password While Typing
**As a** customer entering my password  
**I want to** toggle password visibility  
**So that** I can verify I've typed my password correctly

**Priority**: Medium  
**Story Points**: 2

---

#### US-9: Receive Sign-In Feedback
**As a** customer attempting to sign in  
**I want to** receive clear feedback about the sign-in status  
**So that** I know whether my sign-in was successful or if there are errors

**Priority**: High  
**Story Points**: 3

---

### 3. Acceptance Criteria

#### AC-7: Sign-In Button on Order Screen

**Given** I am on the order screen  
**When** I look at the bottom-left corner of the screen  
**Then** I see a floating action button with a person icon and "Sign In" label  
**And** the button is styled in orange to match the app theme  
**And** the button is always visible regardless of scroll position

**When** I tap the sign-in button  
**Then** I navigate to the sign-in screen  
**And** the navigation transition is smooth

**Additional Criteria**:
- [ ] Button uses `FloatingActionButton.extended` widget
- [ ] Button positioned at `FloatingActionButtonLocation.startFloat`
- [ ] Button has clear visual distinction from other UI elements
- [ ] Button remains accessible and doesn't overlap with content

---

#### AC-8: Sign-In Screen Layout

**Given** I navigate to the sign-in screen  
**Then** I see a well-structured sign-in form with:
- [ ] App logo at the top
- [ ] "Welcome Back!" heading
- [ ] "Sign in to your account" subtitle
- [ ] Email input field with email icon
- [ ] Password input field with lock icon
- [ ] Password visibility toggle button
- [ ] Sign-in button
- [ ] "Forgot Password?" link
- [ ] "Don't have an account? Sign Up" link

**And** all elements are properly styled and aligned  
**And** the screen is scrollable to accommodate different screen sizes  
**And** there is a back button in the AppBar to return to the order screen

---

#### AC-9: Email Validation

**Given** I am on the sign-in screen  
**When** I attempt to submit the form with an empty email field  
**Then** I see an error message "Please enter your email"  
**And** the form does not submit

**When** I enter an email without "@" symbol  
**Then** I see an error message "Please enter a valid email"  
**And** the form does not submit

**When** I enter a valid email format  
**Then** no email error is displayed  
**And** I can proceed with form submission (if password is valid)

**Additional Criteria**:
- [ ] Email validation occurs on form submission
- [ ] Email field has keyboard type set to `TextInputType.emailAddress`
- [ ] Error messages are clear and actionable
- [ ] Validation prevents submission with invalid emails

---

#### AC-10: Password Validation

**Given** I am on the sign-in screen  
**When** I attempt to submit the form with an empty password field  
**Then** I see an error message "Please enter your password"  
**And** the form does not submit

**When** I enter a password with fewer than 6 characters  
**Then** I see an error message "Password must be at least 6 characters"  
**And** the form does not submit

**When** I enter a valid password (6+ characters)  
**Then** no password error is displayed  
**And** I can proceed with form submission (if email is valid)

**Additional Criteria**:
- [ ] Password validation occurs on form submission
- [ ] Password field is obscured by default
- [ ] Minimum 6 character requirement enforced
- [ ] Error messages are clear and helpful

---

#### AC-11: Password Visibility Toggle

**Given** I am on the sign-in screen  
**When** the password field is in obscured mode (default)  
**Then** I see an "eye with slash" icon in the password field  
**And** the password text appears as dots/asterisks

**When** I tap the visibility toggle icon  
**Then** the password text becomes visible  
**And** the icon changes to an "eye" icon (no slash)

**When** I tap the icon again  
**Then** the password returns to obscured mode  
**And** the icon changes back to "eye with slash"

**Additional Criteria**:
- [ ] Toggle works instantly without form submission
- [ ] Icon clearly indicates current state
- [ ] Toggle state persists while on the screen
- [ ] No security issues from password visibility

---

#### AC-12: Successful Sign-In Flow

**Given** I have entered a valid email and password  
**When** I tap the "Sign In" button  
**Then** I see a success message "Signing in as [email]..."  
**And** the message appears in a green snackbar  
**And** the message displays for 2 seconds

**When** the sign-in completes (after ~1 second)  
**Then** I am automatically navigated back to the order screen  
**And** the sign-in screen is removed from the navigation stack

**Additional Criteria**:
- [ ] Success feedback is clear and positive
- [ ] Navigation happens automatically
- [ ] No errors occur during the process
- [ ] User experience is smooth and professional

---

#### AC-13: Forgot Password Link

**Given** I am on the sign-in screen  
**When** I tap the "Forgot Password?" link  
**Then** I see a snackbar message "Password reset functionality coming soon!"  
**And** I remain on the sign-in screen

**Additional Criteria**:
- [ ] Link is clearly visible below sign-in button
- [ ] Link is styled as a blue text button
- [ ] Placeholder message is user-friendly
- [ ] Functionality ready for future implementation

---

#### AC-14: Sign-Up Link

**Given** I am on the sign-in screen  
**When** I tap the "Sign Up" link  
**Then** I see a snackbar message "Sign up functionality coming soon!"  
**And** I remain on the sign-in screen

**Additional Criteria**:
- [ ] Link follows standard UX pattern ("Don't have an account? Sign Up")
- [ ] "Sign Up" portion is styled in orange to match app theme
- [ ] Link is bold and clearly clickable
- [ ] Placeholder message is user-friendly

---

### 4. Technical Requirements

#### 4.1 SignInScreen Implementation (`lib/views/sign_in_screen.dart`)
- [ ] Implement as StatefulWidget for form state management
- [ ] Use TextEditingController for email and password fields
- [ ] Use GlobalKey<FormState> for form validation
- [ ] Implement proper dispose() to prevent memory leaks
- [ ] Use TextFormField widgets with validators
- [ ] Handle password obscuring state
- [ ] Show appropriate feedback using SnackBar
- [ ] Navigate using Navigator.pop() after successful sign-in

#### 4.2 OrderScreen Updates (`lib/views/order_screen.dart`)
- [ ] Import SignInScreen
- [ ] Add `_navigateToSignIn()` navigation method
- [ ] Add FloatingActionButton.extended with:
  - Icon: Icons.person
  - Label: "Sign In"
  - Background color: Colors.orange
  - Position: FloatingActionButtonLocation.startFloat
- [ ] Ensure button doesn't interfere with existing UI

#### 4.3 Form Validation
- [ ] Email validation: check for @ symbol presence
- [ ] Password validation: minimum 6 characters
- [ ] Display inline error messages below respective fields
- [ ] Prevent form submission with invalid data
- [ ] Clear error messages when validation passes

#### 4.4 Code Quality
- [ ] Follow Flutter and Dart best practices
- [ ] Use const constructors where possible
- [ ] Proper state management with setState()
- [ ] Clean and readable code structure
- [ ] Meaningful variable and method names

---

### 5. UI/UX Requirements

#### 5.1 Visual Design
- [ ] Consistent with existing app theme and styles
- [ ] Orange accent color for primary actions (matching app theme)
- [ ] Clear visual hierarchy (logo → heading → form → actions)
- [ ] Adequate spacing between elements
- [ ] Professional and welcoming appearance
- [ ] App logo displayed prominently at top

#### 5.2 Form Design
- [ ] Input fields have clear labels
- [ ] Prefix icons for email (Icons.email) and password (Icons.lock)
- [ ] OutlineInputBorder for text fields
- [ ] Password visibility toggle as suffix icon
- [ ] Sign-in button spans full width with padding
- [ ] Sign-in button has clear call-to-action styling

#### 5.3 Interaction Design
- [ ] Smooth transitions between screens
- [ ] Immediate visual feedback on button taps
- [ ] Clear focus indicators for form fields
- [ ] Keyboard appears automatically on screen load
- [ ] Keyboard type optimized for email entry
- [ ] Form scrollable to prevent keyboard overlap

#### 5.4 Accessibility
- [ ] Sufficient touch targets (minimum 44x44 points)
- [ ] High contrast text and buttons
- [ ] Clear error messages
- [ ] Keyboard navigation support
- [ ] Screen reader compatible labels

---

### 6. Testing Requirements

#### 6.1 Widget Tests
- [ ] Test navigation from order screen to sign-in screen
- [ ] Test email validation (empty, no @, valid)
- [ ] Test password validation (empty, too short, valid)
- [ ] Test password visibility toggle
- [ ] Test form submission with invalid data
- [ ] Test form submission with valid data
- [ ] Test forgot password link interaction
- [ ] Test sign-up link interaction
- [ ] Test back button navigation

#### 6.2 Integration Tests
- [ ] Test complete sign-in flow from order screen
- [ ] Test navigation stack after sign-in
- [ ] Test form state persistence during screen lifecycle

---

### 7. Non-Functional Requirements

#### 7.1 Performance
- [ ] Sign-in screen loads in < 500ms
- [ ] Form validation is instant (< 100ms)
- [ ] No UI lag during password toggle
- [ ] Smooth 60fps animations

#### 7.2 Security
- [ ] Password field obscured by default
- [ ] No password logging in debug console
- [ ] Secure text entry flag enabled
- [ ] Ready for integration with authentication backend

#### 7.3 Compatibility
- [ ] Works on iOS (iPhone and iPad)
- [ ] Works on Android (phones and tablets)
- [ ] Works on web browsers
- [ ] Responsive to different screen sizes
- [ ] Handles both portrait and landscape orientations

---

### 8. Future Enhancements (Out of Scope)

The following are **not** included in the current implementation but planned for future iterations:

- ❌ Backend authentication integration
- ❌ Actual password reset functionality
- ❌ Sign-up screen and registration flow
- ❌ Social media authentication (Google, Facebook, Apple)
- ❌ Remember me / Keep me signed in
- ❌ Biometric authentication (Face ID, Touch ID)
- ❌ Two-factor authentication
- ❌ Session management and token handling
- ❌ Account profile management
- ❌ Order history for signed-in users

---

### 9. Dependencies

- Flutter Material Design library
- Existing OrderScreen (`lib/views/order_screen.dart`)
- Existing app_styles (`lib/views/app_styles.dart`)
- Navigator for screen transitions
- ScaffoldMessenger for feedback messages

---

### 10. Definition of Done

The User Authentication feature is considered complete when:

1. ✅ Sign-in screen is created with all required UI elements
2. ✅ Floating action button added to order screen
3. ✅ Navigation between screens works correctly
4. ✅ Email and password validation implemented
5. ✅ Password visibility toggle works
6. ✅ Success feedback displayed on sign-in
7. ✅ All acceptance criteria met and verified
8. ✅ Code follows project standards and best practices
9. ✅ No compiler warnings or errors
10. ✅ Feature is tested on multiple devices/platforms
11. ✅ Code is committed and pushed to repository

---

### 11. Implementation Notes

**Current Status**: ✅ Implemented

**Files Modified/Created**:
- Created: `lib/views/sign_in_screen.dart` - Complete sign-in screen implementation
- Modified: `lib/views/order_screen.dart` - Added floating action button and navigation

**Key Implementation Details**:
- Sign-in screen uses StatefulWidget with form validation
- Email validation checks for @ symbol
- Password validation enforces 6-character minimum
- Password visibility toggle implemented with state management
- Success feedback shown via SnackBar
- Automatic navigation back to order screen after 1 second delay
- Forgot password and sign-up links show placeholder messages
- Floating action button positioned at bottom-left using FloatingActionButtonLocation.startFloat

---
