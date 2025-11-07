import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  int _selectedIndex = 0;

  final List<String> _sandwiches = const [
    'Footlong',
    'BLT',
    'Club',
  ];

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  void _selectIndex(int index) {
    setState(() => _selectedIndex = index % _sandwiches.length);
  }

  int _wrapIndex(int i) {
    final n = _sandwiches.length;
    return (i % n + n) % n;
  }

  @override
  Widget build(BuildContext context) {
    final prev = _wrapIndex(_selectedIndex - 1);
    final next = _wrapIndex(_selectedIndex + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display selected item and quantity
            OrderItemDisplay(
              quantity: _quantity,
              itemType: _sandwiches[_selectedIndex],
            ),
            const SizedBox(height: 24),

            // Three buttons in the center showing previous, current, next
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous
                OutlinedButton(
                  onPressed: () => _selectIndex(prev),
                  child: Text(_sandwiches[prev]),
                ),
                const SizedBox(width: 12),
                // Current (highlighted)
                ElevatedButton(
                  onPressed: () => _selectIndex(_selectedIndex),
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                  ),
                  child: Text(_sandwiches[_selectedIndex]),
                ),
                const SizedBox(width: 12),
                // Next
                OutlinedButton(
                  onPressed: () => _selectIndex(next),
                  child: Text(_sandwiches[next]),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Slider to move between sandwich options; snaps to integer values
            Slider(
              value: _selectedIndex.toDouble(),
              min: 0,
              max: (_sandwiches.length - 1).toDouble(),
              divisions: _sandwiches.length - 1,
              label: _sandwiches[_selectedIndex],
              onChanged: (v) => _selectIndex(v.round()),
            ),

            const SizedBox(height: 24),

            // Add / Remove buttons (disabled at bounds)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _quantity < widget.maxQuantity ? _increaseQuantity : null,
                  child: const Text('Add'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _quantity > 0 ? _decreaseQuantity : null,
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay({super.key, required this.quantity, required this.itemType});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          itemType,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Quantity: $quantity',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
