import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../medicines/presentation/pages/medicines_page.dart';
import '../../../sales/presentation/pages/sales_page.dart';
import '../../../inventory/presentation/pages/inventory_page.dart';
import '../../../customers/presentation/pages/customers_page.dart';
import '../../../suppliers/presentation/pages/suppliers_page.dart';
import '../../../prescriptions/presentation/pages/prescriptions_page.dart';
import '../../../reports/presentation/pages/reports_page.dart';
import '../../../ai_assistant/presentation/pages/ai_assistant_page.dart';
import '../../../smart_analytics/presentation/pages/smart_analytics_page.dart';
import '../../../voice_assistant/presentation/pages/voice_assistant_page.dart';
import '../../../barcode/presentation/pages/barcode_scanner_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../backup/presentation/pages/backup_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Features'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: 'Core Features', icon: Icons.star),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _FeatureCard(
                  title: 'Medicines',
                  subtitle: 'Manage inventory',
                  icon: Icons.medication,
                  color: Colors.green,
                  onTap: () => _navigateTo(context, const MedicinesPage()),
                ),
                _FeatureCard(
                  title: 'Sales',
                  subtitle: 'Process orders',
                  icon: Icons.point_of_sale,
                  color: Colors.blue,
                  onTap: () => _navigateTo(context, const SalesPage()),
                ),
                _FeatureCard(
                  title: 'Inventory',
                  subtitle: 'Stock management',
                  icon: Icons.inventory,
                  color: Colors.orange,
                  onTap: () => _navigateTo(context, const InventoryPage()),
                ),
                _FeatureCard(
                  title: 'Customers',
                  subtitle: 'Customer management',
                  icon: Icons.people,
                  color: Colors.purple,
                  onTap: () => _navigateTo(context, const CustomersPage()),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 24),

            _SectionHeader(title: 'AI Features', icon: Icons.psychology),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _FeatureCard(
                  title: 'AI Assistant',
                  subtitle: 'Smart chatbot',
                  icon: Icons.smart_toy,
                  color: Colors.deepPurple,
                  onTap: () => _navigateTo(context, const AIAssistantPage()),
                ),
                _FeatureCard(
                  title: 'Smart Analytics',
                  subtitle: 'AI insights',
                  icon: Icons.analytics,
                  color: Colors.indigo,
                  onTap: () => _navigateTo(context, const SmartAnalyticsPage()),
                ),
                _FeatureCard(
                  title: 'Voice Assistant',
                  subtitle: 'Voice commands',
                  icon: Icons.mic,
                  color: Colors.teal,
                  onTap: () => _navigateTo(context, const VoiceAssistantPage()),
                ),
                _FeatureCard(
                  title: 'Barcode Scanner',
                  subtitle: 'AI scanning',
                  icon: Icons.qr_code_scanner,
                  color: Colors.cyan,
                  onTap: () => _navigateTo(context, const BarcodeScannerPage()),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.purple[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  const Text(
                    '50+ Features',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Complete Pharmacy Management Solution',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showSearch(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search feature coming soon!')),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shimmer(delay: 2000.ms, duration: 1800.ms);
  }
}