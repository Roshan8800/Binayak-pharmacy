import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SmartAnalyticsPage extends StatefulWidget {
  const SmartAnalyticsPage({super.key});

  @override
  State<SmartAnalyticsPage> createState() => _SmartAnalyticsPageState();
}

class _SmartAnalyticsPageState extends State<SmartAnalyticsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Analytics'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'AI Insights', icon: Icon(Icons.psychology)),
            Tab(text: 'Predictions', icon: Icon(Icons.trending_up)),
            Tab(text: 'Patterns', icon: Icon(Icons.pattern)),
            Tab(text: 'Recommendations', icon: Icon(Icons.lightbulb)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AIInsightsTab(),
          _PredictionsTab(),
          _PatternsTab(),
          _RecommendationsTab(),
        ],
      ),
    );
  }
}

class _AIInsightsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.psychology, color: Colors.purple),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'AI Business Insights',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InsightCard(
                    title: 'Revenue Optimization',
                    insight: 'AI suggests increasing Paracetamol stock by 25% to capture ₹15,000 additional revenue this month.',
                    confidence: 92,
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _InsightCard(
                    title: 'Customer Behavior',
                    insight: 'Peak sales hours are 10 AM - 12 PM. Consider promotional offers during 2-4 PM to boost sales.',
                    confidence: 87,
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _InsightCard(
                    title: 'Inventory Alert',
                    insight: 'Cough syrup demand increases by 40% during monsoon. Stock up before next month.',
                    confidence: 95,
                    icon: Icons.warning,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Performance Metrics',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          title: 'Prediction Accuracy',
                          value: '94.2%',
                          icon: Icons.verified,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          title: 'Cost Savings',
                          value: '₹23,450',
                          icon: Icons.savings,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
        ],
      ),
    );
  }
}

class _PredictionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Predictions (Next 7 Days)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('AI Sales Prediction Chart'),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Predicted Revenue: ₹87,500 (±5%)', 
                  style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 16),
        ...List.generate(5, (index) {
          final medicines = ['Paracetamol', 'Crocin', 'Aspirin', 'Amoxicillin', 'Ibuprofen'];
          final predictions = [145, 120, 98, 87, 76];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Icon(Icons.trending_up, color: Colors.blue),
              ),
              title: Text(medicines[index]),
              subtitle: Text('Predicted demand: ${predictions[index]} units'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${85 + index * 2}%', 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('Confidence', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 100).ms);
        }),
      ],
    );
  }
}

class _PatternsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Purchase Patterns',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _PatternCard(
                  pattern: 'Customers buying fever medicines also purchase pain relievers 78% of the time',
                  actionable: 'Bundle these items for cross-selling',
                  impact: 'Potential 15% revenue increase',
                ),
                const SizedBox(height: 12),
                _PatternCard(
                  pattern: 'Elderly customers prefer morning visits (9-11 AM)',
                  actionable: 'Staff senior pharmacist during these hours',
                  impact: 'Improved customer satisfaction',
                ),
                const SizedBox(height: 12),
                _PatternCard(
                  pattern: 'Prescription refills peak on weekends',
                  actionable: 'Ensure adequate stock on Fridays',
                  impact: 'Reduced stockouts by 25%',
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 600.ms),
      ],
    );
  }
}

class _RecommendationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'AI Recommendations',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _RecommendationCard(
                  title: 'Inventory Optimization',
                  recommendation: 'Reduce Vitamin C stock by 20% and increase Zinc tablets by 35%',
                  reason: 'Based on seasonal demand patterns and current stock levels',
                  priority: 'High',
                  savings: '₹8,500',
                ),
                const SizedBox(height: 12),
                _RecommendationCard(
                  title: 'Pricing Strategy',
                  recommendation: 'Implement dynamic pricing for generic medicines',
                  reason: 'Competitor analysis shows 12% price advantage opportunity',
                  priority: 'Medium',
                  savings: '₹12,000',
                ),
                const SizedBox(height: 12),
                _RecommendationCard(
                  title: 'Customer Retention',
                  recommendation: 'Launch loyalty program for customers spending >₹500/month',
                  reason: '23% of customers show high churn risk',
                  priority: 'High',
                  savings: '₹25,000',
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 600.ms),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String insight;
  final int confidence;
  final IconData icon;
  final Color color;

  const _InsightCard({
    required this.title,
    required this.insight,
    required this.confidence,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$confidence%',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(insight, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final String pattern;
  final String actionable;
  final String impact;

  const _PatternCard({
    required this.pattern,
    required this.actionable,
    required this.impact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📊 $pattern', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('💡 $actionable', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text('📈 $impact', 
            style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String recommendation;
  final String reason;
  final String priority;
  final String savings;

  const _RecommendationCard({
    required this.title,
    required this.recommendation,
    required this.reason,
    required this.priority,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor = priority == 'High' ? Colors.red : Colors.orange;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(recommendation, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(reason, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.savings, color: Colors.green, size: 16),
              const SizedBox(width: 4),
              Text('Potential savings: $savings', 
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}