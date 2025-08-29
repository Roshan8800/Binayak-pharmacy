import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with TickerProviderStateMixin {
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
        title: const Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.notifications)),
            Tab(text: 'Alerts', icon: Icon(Icons.warning)),
            Tab(text: 'AI Insights', icon: Icon(Icons.psychology)),
            Tab(text: 'Settings', icon: Icon(Icons.settings)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () => _markAllAsRead(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AllNotificationsTab(),
          _AlertsTab(),
          _AIInsightsTab(),
          _SettingsTab(),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }
}

class _AllNotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationItem(
        title: 'Low Stock Alert',
        message: 'Paracetamol stock is running low (5 units left)',
        type: NotificationType.warning,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationItem(
        title: 'AI Recommendation',
        message: 'Consider increasing Crocin stock by 25% for better sales',
        type: NotificationType.aiInsight,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      NotificationItem(
        title: 'Expiry Alert',
        message: 'Amoxicillin batch B2024 expires in 7 days',
        type: NotificationType.error,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      NotificationItem(
        title: 'Sales Milestone',
        message: 'Congratulations! You\'ve reached ₹50,000 in sales this month',
        type: NotificationType.success,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      NotificationItem(
        title: 'New Customer',
        message: 'John Doe has been added as a VIP customer',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _NotificationCard(notification: notifications[index])
            .animate().fadeIn(delay: (index * 100).ms);
      },
    );
  }
}

class _AlertsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alerts = [
      AlertItem(
        title: 'Critical Stock Level',
        message: 'Paracetamol: Only 5 units remaining',
        severity: AlertSeverity.critical,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        action: 'Reorder Now',
      ),
      AlertItem(
        title: 'Expiry Warning',
        message: '3 medicines expiring within 7 days',
        severity: AlertSeverity.high,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        action: 'View Details',
      ),
      AlertItem(
        title: 'Payment Overdue',
        message: 'Supplier payment of ₹15,000 is overdue',
        severity: AlertSeverity.medium,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        action: 'Pay Now',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        return _AlertCard(alert: alerts[index])
            .animate().fadeIn(delay: (index * 100).ms);
      },
    );
  }
}

class _AIInsightsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final insights = [
      AIInsight(
        title: 'Revenue Optimization',
        insight: 'Increase Paracetamol stock by 25% to capture additional ₹15,000 revenue',
        confidence: 92,
        category: 'Sales',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      AIInsight(
        title: 'Customer Behavior',
        insight: 'Peak sales hours are 10 AM - 12 PM. Consider promotional offers during 2-4 PM',
        confidence: 87,
        category: 'Analytics',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AIInsight(
        title: 'Seasonal Trend',
        insight: 'Cough syrup demand increases by 40% during monsoon season',
        confidence: 95,
        category: 'Inventory',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: insights.length,
      itemBuilder: (context, index) {
        return _AIInsightCard(insight: insights[index])
            .animate().fadeIn(delay: (index * 100).ms);
      },
    );
  }
}

class _SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title: const Text('Push Notifications'),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Stock Alerts'),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Expiry Notifications'),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.psychology),
                title: const Text('AI Insights'),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Notification Time'),
                subtitle: const Text('9:00 AM - 6:00 PM'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.volume_up),
                title: const Text('Sound'),
                subtitle: const Text('Default'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.vibration),
                title: const Text('Vibration'),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTypeColor().withOpacity(0.2),
          child: Icon(_getTypeIcon(), color: _getTypeColor()),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: notification.isRead 
            ? null 
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (notification.type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.aiInsight:
        return Colors.purple;
      case NotificationType.info:
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.aiInsight:
        return Icons.psychology;
      case NotificationType.info:
      default:
        return Icons.info;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _AlertCard extends StatelessWidget {
  final AlertItem alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getSeverityColor().withOpacity(0.3)),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getSeverityColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_getSeverityIcon(), color: _getSeverityColor()),
          ),
          title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(alert.message),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getSeverityColor(),
                  foregroundColor: Colors.white,
                ),
                child: Text(alert.action),
              ),
            ],
          ),
          trailing: Chip(
            label: Text(_getSeverityText()),
            backgroundColor: _getSeverityColor().withOpacity(0.1),
            labelStyle: TextStyle(color: _getSeverityColor(), fontSize: 10),
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor() {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Colors.red;
      case AlertSeverity.high:
        return Colors.orange;
      case AlertSeverity.medium:
        return Colors.yellow[700]!;
      case AlertSeverity.low:
        return Colors.blue;
    }
  }

  IconData _getSeverityIcon() {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Icons.dangerous;
      case AlertSeverity.high:
        return Icons.warning;
      case AlertSeverity.medium:
        return Icons.info;
      case AlertSeverity.low:
        return Icons.notifications;
    }
  }

  String _getSeverityText() {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return 'Critical';
      case AlertSeverity.high:
        return 'High';
      case AlertSeverity.medium:
        return 'Medium';
      case AlertSeverity.low:
        return 'Low';
    }
  }
}

class _AIInsightCard extends StatelessWidget {
  final AIInsight insight;

  const _AIInsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.purple.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.psychology, color: Colors.purple, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    insight.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${insight.confidence}%',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(insight.insight),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text(insight.category),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    labelStyle: const TextStyle(color: Colors.blue, fontSize: 10),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(insight.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}

enum NotificationType { info, success, warning, error, aiInsight }
enum AlertSeverity { low, medium, high, critical }

class NotificationItem {
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });
}

class AlertItem {
  final String title;
  final String message;
  final AlertSeverity severity;
  final DateTime timestamp;
  final String action;

  AlertItem({
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    required this.action,
  });
}

class AIInsight {
  final String title;
  final String insight;
  final int confidence;
  final String category;
  final DateTime timestamp;

  AIInsight({
    required this.title,
    required this.insight,
    required this.confidence,
    required this.category,
    required this.timestamp,
  });
}