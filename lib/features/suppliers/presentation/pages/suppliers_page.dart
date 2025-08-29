import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Suppliers', icon: Icon(Icons.business)),
            Tab(text: 'Active', icon: Icon(Icons.verified)),
            Tab(text: 'Orders', icon: Icon(Icons.shopping_cart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AllSuppliersTab(),
          _ActiveSuppliersTab(),
          _OrdersTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_business),
        label: const Text('Add Supplier'),
      ),
    );
  }
}

class _AllSuppliersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.2),
              child: const Icon(Icons.business, color: Colors.blue),
            ),
            title: Text('Supplier ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact: +91 98765 ${43210 + index}'),
                Text('Medicines: ${20 + index * 5}'),
                Text('Rating: ${4.0 + (index % 10) * 0.1}/5.0'),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'view', child: Text('View Details')),
                const PopupMenuItem(value: 'order', child: Text('Place Order')),
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}

class _ActiveSuppliersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.2),
              child: const Icon(Icons.verified, color: Colors.green),
            ),
            title: Text('Active Supplier ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last Order: ${index + 1} days ago'),
                Text('Total Orders: ${50 + index * 10}'),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' ${4.5 + (index % 5) * 0.1}'),
                  ],
                ),
              ],
            ),
            trailing: Chip(
              label: const Text('Active'),
              backgroundColor: Colors.green.withOpacity(0.1),
              labelStyle: const TextStyle(color: Colors.green),
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}

class _OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (context, index) {
        final statuses = ['Pending', 'Shipped', 'Delivered', 'Cancelled'];
        final status = statuses[index % 4];
        Color statusColor = status == 'Delivered' ? Colors.green :
                           status == 'Shipped' ? Colors.blue :
                           status == 'Pending' ? Colors.orange : Colors.red;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.2),
              child: Text('${index + 1}'),
            ),
            title: Text('Order #PO${1000 + index}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Supplier: Supplier ${(index % 5) + 1}'),
                Text('Amount: ₹${(5000 + index * 500)}'),
                Text('Date: ${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().month}'),
              ],
            ),
            trailing: Chip(
              label: Text(status),
              backgroundColor: statusColor.withOpacity(0.1),
              labelStyle: TextStyle(color: statusColor, fontSize: 10),
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}