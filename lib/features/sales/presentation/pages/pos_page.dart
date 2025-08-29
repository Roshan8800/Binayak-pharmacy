import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class POSPage extends StatefulWidget {
  const POSPage({super.key});

  @override
  State<POSPage> createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {
  final List<CartItem> _cartItems = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  double _discount = 0;

  @override
  Widget build(BuildContext context) {
    final total = _cartItems.fold(0.0, (sum, item) => sum + item.total);
    final finalAmount = total - _discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Panel - Product Selection
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Search medicines...',
                    leading: const Icon(Icons.search),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return _ProductCard(
                        name: 'Medicine ${index + 1}',
                        price: 50.0 + (index * 10),
                        stock: 100 - index,
                        onTap: () => _addToCart('Medicine ${index + 1}', 50.0 + (index * 10)),
                      ).animate().fadeIn(delay: (index * 50).ms);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Right Panel - Cart & Checkout
          Container(
            width: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                left: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _customerController,
                        decoration: const InputDecoration(
                          labelText: 'Customer Name',
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Cart (${_cartItems.length} items)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (_cartItems.isNotEmpty)
                            TextButton(
                              onPressed: () => setState(() => _cartItems.clear()),
                              child: const Text('Clear All'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text('Cart is empty', style: Theme.of(context).textTheme.titleLarge),
                              Text('Add medicines to start billing', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            return _CartItemTile(
                              item: item,
                              onQuantityChanged: (quantity) {
                                setState(() {
                                  if (quantity > 0) {
                                    item.quantity = quantity;
                                  } else {
                                    _cartItems.removeAt(index);
                                  }
                                });
                              },
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    border: Border(
                      top: BorderSide(color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Discount:'),
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: const InputDecoration(
                                prefixText: '₹',
                                isDense: true,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _discount = double.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Subtotal:'),
                          const Spacer(),
                          Text('₹${total.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '₹${finalAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _cartItems.isEmpty ? null : _processPayment,
                          icon: const Icon(Icons.payment),
                          label: const Text('Process Payment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(String name, double price) {
    final existingIndex = _cartItems.indexWhere((item) => item.name == name);
    setState(() {
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(name: name, price: price, quantity: 1));
      }
    });
  }

  void _processPayment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Sale has been processed successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final int stock;
  final VoidCallback onTap;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.stock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.medication,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                '₹${price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                'Stock: $stock',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;

  const _CartItemTile({
    required this.item,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('₹${item.price.toStringAsFixed(2)} each'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onQuantityChanged(item.quantity - 1),
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () => onQuantityChanged(item.quantity + 1),
            icon: const Icon(Icons.add_circle_outline),
          ),
          const SizedBox(width: 8),
          Text('₹${item.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});

  double get total => price * quantity;
}