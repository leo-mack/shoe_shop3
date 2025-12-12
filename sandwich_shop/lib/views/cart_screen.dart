import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      widget.cart.updateQuantity(index, newQuantity);
    });
  }

  void _removeItem(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text(
              'Are you sure you want to remove this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        widget.cart.removeAt(index);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from cart'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _clearCart() async {
    if (widget.cart.isEmpty) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
              'Are you sure you want to remove all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        widget.cart.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cart cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _navigateToCheckout() async {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: widget.cart),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        widget.cart.clear();
      });

      final String orderId = result['orderId'] as String;
      final String estimatedTime = result['estimatedTime'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              if (widget.cart.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Your cart is empty',
                    style: heading2,
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                for (int i = 0; i < widget.cart.itemsList.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.cart.itemsList[i].key.name,
                                style: heading2),
                            Text(
                              '${_getSizeText(widget.cart.itemsList[i].key.isFootlong)} on ${widget.cart.itemsList[i].key.breadType.name} bread',
                              style: normalText,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      onPressed:
                                          widget.cart.itemsList[i].value > 1
                                              ? () => _updateQuantity(
                                                  i,
                                                  widget.cart.itemsList[i]
                                                          .value -
                                                      1)
                                              : null,
                                    ),
                                    Text(
                                      'Qty: ${widget.cart.itemsList[i].value}',
                                      style: normalText,
                                    ),
                                    IconButton(
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      onPressed: () => _updateQuantity(i,
                                          widget.cart.itemsList[i].value + 1),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '£${_getItemPrice(widget.cart.itemsList[i].key, widget.cart.itemsList[i].value).toStringAsFixed(2)}',
                                      style: heading2,
                                    ),
                                    TextButton.icon(
                                      icon: const Icon(Icons.delete_outline,
                                          size: 18),
                                      label: const Text('Remove'),
                                      onPressed: () => _removeItem(i),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: £${widget.cart.totalPrice.toStringAsFixed(2)}',
                    style: heading1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: StyledButton(
                    onPressed: _clearCart,
                    icon: Icons.delete_sweep,
                    label: 'Clear Cart',
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Builder(
                builder: (BuildContext context) {
                  final bool cartHasItems = widget.cart.items.isNotEmpty;
                  if (cartHasItems) {
                    return StyledButton(
                      onPressed: _navigateToCheckout,
                      icon: Icons.payment,
                      label: 'Checkout',
                      backgroundColor: Colors.orange,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _goBack,
                icon: Icons.arrow_back,
                label: 'Back to Order',
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
