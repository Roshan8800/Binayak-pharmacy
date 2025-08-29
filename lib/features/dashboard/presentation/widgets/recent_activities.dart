import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activities',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _ActivityItem(
                title: _getActivityTitle(index),
                subtitle: _getActivitySubtitle(index),
                time: _getActivityTime(index),
                icon: _getActivityIcon(index),
                color: _getActivityColor(index),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getActivityTitle(int index) {
    const titles = [
      'Medicine Added',
      'Sale Completed',
      'Stock Updated',
      'Low Stock Alert',
      'Expiry Warning',
    ];
    return titles[index];
  }

  String _getActivitySubtitle(int index) {
    const subtitles = [
      'Paracetamol 500mg added to inventory',
      'Sale #1234 - ₹450 completed',
      'Crocin stock updated to 100 units',
      'Aspirin running low (5 units left)',
      'Amoxicillin expires in 7 days',
    ];
    return subtitles[index];
  }

  String _getActivityTime(int index) {
    const times = [
      '2 min ago',
      '5 min ago',
      '10 min ago',
      '15 min ago',
      '1 hour ago',
    ];
    return times[index];
  }

  IconData _getActivityIcon(int index) {
    const icons = [
      Icons.add_circle_outline,
      Icons.point_of_sale,
      Icons.update,
      Icons.warning_amber,
      Icons.schedule,
    ];
    return icons[index];
  }

  Color _getActivityColor(int index) {
    const colors = [
      AppTheme.successColor,
      AppTheme.primaryColor,
      Colors.blue,
      AppTheme.warningColor,
      AppTheme.errorColor,
    ];
    return colors[index];
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
        ),
      ),
    );
  }
}