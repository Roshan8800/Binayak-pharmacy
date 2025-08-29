import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> with TickerProviderStateMixin {
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
        title: const Text('Inventory Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Stock Levels', icon: Icon(Icons.inventory)),
            Tab(text: 'Low Stock', icon: Icon(Icons.warning)),
            Tab(text: 'Expiring', icon: Icon(Icons.schedule)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StockLevelsTab(),
          _LowStockTab(),
          _ExpiringTab(),
        ],
      ),
    );
  }
}

class _StockLevelsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _InventoryCard(
                  title: 'Total Items',
                  value: '1,234',
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InventoryCard(
                  title: 'Total Value',
                  value: '₹5,67,890',
                  icon: Icons.currency_rupee,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(Icons.medication, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text('Medicine ${index + 1}'),
                  subtitle: Text('Batch: B${1000 + index} | Exp: 12/2025'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${100 - index} units',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      LinearProgressIndicator(
                        value: (100 - index) / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(
                          (100 - index) > 20 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 50).ms);
            },
          ),
        ),
      ],
    );
  }
}

class _LowStockTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[800], size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '23 items are running low',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                        Text(
                          'Reorder these items to avoid stockouts',
                          style: TextStyle(color: Colors.orange[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 23,
            itemBuilder: (context, index) {
              final stock = 5 + (index % 10);
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange[100],
                    child: Icon(Icons.warning, color: Colors.orange[800]),
                  ),
                  title: Text('Medicine ${index + 1}'),
                  subtitle: Text('Min level: 20 | Current: $stock'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(
                        label: Text('$stock left'),
                        backgroundColor: Colors.orange[100],
                        labelStyle: TextStyle(color: Colors.orange[800]),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Reorder'),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 50).ms);
            },
          ),
        ),
      ],
    );
  }
}

class _ExpiringTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: Colors.red[800], size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '12 items expiring soon',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                        Text(
                          'Items expiring within 30 days',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 12,
            itemBuilder: (context, index) {
              final daysLeft = 30 - (index * 2);
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[100],
                    child: Icon(Icons.schedule, color: Colors.red[800]),
                  ),
                  title: Text('Medicine ${index + 1}'),
                  subtitle: Text('Batch: B${2000 + index} | Stock: ${50 + index}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(
                        label: Text('$daysLeft days'),
                        backgroundColor: daysLeft <= 7 ? Colors.red[100] : Colors.orange[100],
                        labelStyle: TextStyle(
                          color: daysLeft <= 7 ? Colors.red[800] : Colors.orange[800],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Mark Sale'),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 50).ms);
            },
          ),
        ),
      ],
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _InventoryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Live',
                    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}