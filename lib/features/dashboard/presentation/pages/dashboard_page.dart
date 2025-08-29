import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/quick_stats.dart';
import '../widgets/recent_activities.dart';
import '../../../medicines/presentation/pages/medicines_page.dart';
import '../../../sales/presentation/pages/sales_page.dart';
import '../../../inventory/presentation/pages/inventory_page.dart';
import '../../../reports/presentation/pages/reports_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../main_menu/presentation/pages/main_menu_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Binayak Pharmacy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, Suman Sahu',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pharmacy Owner',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Today: ${DateTime.now().toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Quick Stats
            const QuickStats().animate().fadeIn(delay: 200.ms, duration: 600.ms),
            
            const SizedBox(height: 24),
            
            // Main Actions Grid
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                DashboardCard(
                  title: 'Medicines',
                  subtitle: 'Manage inventory',
                  icon: Icons.medication_outlined,
                  color: AppTheme.primaryColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicinesPage())),
                ),
                DashboardCard(
                  title: 'Sales',
                  subtitle: 'Process orders',
                  icon: Icons.point_of_sale_outlined,
                  color: AppTheme.successColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesPage())),
                ),
                DashboardCard(
                  title: 'Inventory',
                  subtitle: 'Stock management',
                  icon: Icons.inventory_2_outlined,
                  color: AppTheme.warningColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryPage())),
                ),
                DashboardCard(
                  title: 'Reports',
                  subtitle: 'Analytics & insights',
                  icon: Icons.analytics_outlined,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsPage())),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            
            const SizedBox(height: 24),
            
            // Recent Activities
            const RecentActivities().animate().fadeIn(delay: 600.ms, duration: 600.ms),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'menu',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MainMenuPage())),
            child: const Icon(Icons.apps),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'sale',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesPage())),
            icon: const Icon(Icons.add),
            label: const Text('Quick Sale'),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
        ],
      ).animate().scale(delay: 800.ms, duration: 400.ms),
    );
  }
}