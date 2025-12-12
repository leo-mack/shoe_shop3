# Feature Request: Cart Item Modification

I have a Flutter sandwich shop app with an order screen and a cart screen. I need to implement cart modification features so users can update items after adding them to the cart.

## Current Implementation
- **Order Screen**: Users select sandwiches (type, size, bread type, quantity) and add them to cart
- **Cart Screen**: Displays cart items with details and total price
- **Cart Model**: Located in `lib/models/cart.dart`
- **Cart Screen UI**: Located in `lib/views/cart_screen.dart`

## Features to Implement

### 1. Change Item Quantity
**Description**: Allow users to increment or decrement the quantity of an item already in the cart.

**UI Requirements**:
- Display current quantity for each cart item
- Add "+" button to increase quantity
- Add "-" button to decrease quantity
- Disable "-" button when quantity is 1 (minimum)
- Update total price immediately when quantity changes

**Behavior**:
- When user taps "+": Increase quantity by 1, recalculate item price and total
- When user taps "-": Decrease quantity by 1 (minimum 1), recalculate item price and total
- Price updates should be reflected in real-time without page refresh

### 2. Remove Item from Cart
**Description**: Allow users to completely remove an item from the cart.

**UI Requirements**:
- Add a "Remove" or delete icon button for each cart item
- Show confirmation dialog before removing item
- Update cart display and total price after removal

**Behavior**:
- When user taps remove button: Show confirmation dialog ("Remove this item from cart?")
- If user confirms: Remove item from cart, update total price, refresh cart display
- If cart becomes empty: Show appropriate empty cart message
- If user cancels: Keep item in cart, no changes

### 3. Clear Entire Cart
**Description**: Allow users to remove all items from the cart at once.

**UI Requirements**:
- Add a "Clear Cart" button in the cart screen (e.g., in AppBar or at bottom)
- Show confirmation dialog before clearing
- Only show button when cart has items

**Behavior**:
- When user taps "Clear Cart": Show confirmation dialog ("Remove all items from cart?")
- If user confirms: Empty the cart completely, show empty cart state
- If user cancels: Keep all items, no changes

## Technical Requirements
- Update the Cart model in `lib/models/cart.dart` with necessary methods
- Modify CartScreen widget in `lib/views/cart_screen.dart` to include UI controls
- Ensure state updates properly trigger UI rebuilds
- Maintain existing cart functionality (adding items, calculating prices)
- Write widget tests for all new interactions

## Expected Deliverables
1. Updated Cart model with methods: `updateQuantity()`, `removeAt()`, `clear()`
2. Updated CartScreen UI with quantity controls, remove buttons, and clear cart button
3. Confirmation dialogs for destructive actions (remove item, clear cart)
4. Widget tests verifying the new functionality works correctly
5. All changes should follow the existing code style and patterns in the app
