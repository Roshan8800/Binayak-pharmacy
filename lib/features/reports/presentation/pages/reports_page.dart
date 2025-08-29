import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> with TickerProviderStateMixin {
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
        title: const Text('Reports & Analytics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sales', icon: Icon(Icons.trending_up)),
            Tab(text: 'Inventory', icon: Icon(Icons.inventory)),
            Tab(text: 'Financial', icon: Icon(Icons.account_balance)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SalesReportsTab(),
          _InventoryReportsTab(),
          _FinancialReportsTab(),
        ],
      ),
    );
  }
}

class _SalesReportsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _ReportCard(
                  title: 'Today\'s Sales',
                  value: '₹12,450',
                  subtitle: '23 transactions',
                  icon: Icons.today,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportCard(
                  title: 'This Week',
                  value: '₹89,340',
                  subtitle: '156 transactions',
                  icon: Icons.date_range,
                  color: Colors.blue,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Selling Medicines',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(5, (index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Medicine ${index + 1}'),
                      subtitle: Text('${150 - (index * 20)} units sold'),
                      trailing: Text(
                        '₹${(15000 - (index * 2000))}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ).animate().fadeIn(delay: ((index + 4) * 100).ms);
                  }),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
        ],
      ),
    );
  }
}

class _InventoryReportsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ReportCard(
                  title: 'Total Items',
                  value: '1,234',
                  subtitle: 'in inventory',
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportCard(
                  title: 'Low Stock Items',
                  value: '23',
                  subtitle: 'need reorder',
                  icon: Icons.warning,
                  color: Colors.orange,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}

class _FinancialReportsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ReportCard(
                  title: 'Revenue',
                  value: '₹3,45,670',
                  subtitle: 'this month',
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportCard(
                  title: 'Profit',
                  value: '₹1,23,450',
                  subtitle: 'this month',
                  icon: Icons.account_balance_wallet,
                  color: Colors.blue,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.subtitle,
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}