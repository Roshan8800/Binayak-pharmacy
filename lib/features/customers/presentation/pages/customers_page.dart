import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'add_customer_page.dart';
import 'customer_details_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Customers', icon: Icon(Icons.people)),
            Tab(text: 'Regular', icon: Icon(Icons.star)),
            Tab(text: 'VIP', icon: Icon(Icons.diamond)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search customers...',
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AllCustomersTab(),
                _RegularCustomersTab(),
                _VIPCustomersTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerPage()),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Customer'),
      ),
    );
  }
}

class _AllCustomersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 50,
      itemBuilder: (context, index) {
        return _CustomerCard(
          name: 'Customer ${index + 1}',
          phone: '+91 98765 ${43210 + index}',
          email: 'customer${index + 1}@email.com',
          totalPurchases: (index + 1) * 1500.0,
          lastVisit: DateTime.now().subtract(Duration(days: index)),
          customerType: index % 10 == 0 ? 'VIP' : index % 5 == 0 ? 'Regular' : 'Normal',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDetailsPage(customerId: index + 1),
              ),
            );
          },
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}

class _RegularCustomersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 15,
      itemBuilder: (context, index) {
        return _CustomerCard(
          name: 'Regular Customer ${index + 1}',
          phone: '+91 98765 ${50000 + index}',
          email: 'regular${index + 1}@email.com',
          totalPurchases: (index + 1) * 3000.0,
          lastVisit: DateTime.now().subtract(Duration(days: index * 2)),
          customerType: 'Regular',
          onTap: () {},
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}

class _VIPCustomersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _CustomerCard(
          name: 'VIP Customer ${index + 1}',
          phone: '+91 98765 ${60000 + index}',
          email: 'vip${index + 1}@email.com',
          totalPurchases: (index + 1) * 10000.0,
          lastVisit: DateTime.now().subtract(Duration(days: index)),
          customerType: 'VIP',
          onTap: () {},
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final double totalPurchases;
  final DateTime lastVisit;
  final String customerType;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.name,
    required this.phone,
    required this.email,
    required this.totalPurchases,
    required this.lastVisit,
    required this.customerType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor = customerType == 'VIP' 
        ? Colors.purple 
        : customerType == 'Regular' 
            ? Colors.blue 
            : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: typeColor.withOpacity(0.2),
          child: Icon(
            customerType == 'VIP' 
                ? Icons.diamond 
                : customerType == 'Regular' 
                    ? Icons.star 
                    : Icons.person,
            color: typeColor,
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phone),
            Text('Total: ₹${totalPurchases.toStringAsFixed(0)}'),
            Text('Last visit: ${_formatDate(lastVisit)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(customerType),
              backgroundColor: typeColor.withOpacity(0.1),
              labelStyle: TextStyle(color: typeColor, fontSize: 10),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showCustomerOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '$difference days ago';
  }

  void _showCustomerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Call Customer'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Send Message'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Purchase History'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Customer'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}