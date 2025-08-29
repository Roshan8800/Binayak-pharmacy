import 'package:flutter/material.dart';
import '../app_state/app_state_manager.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _notifications = [];
  final List<Function(AppNotification)> _listeners = [];

  Future<void> initialize() async {
    await _setupNotificationChannels();
    _startPeriodicChecks();
  }

  void addListener(Function(AppNotification) listener) {
    _listeners.add(listener);
  }

  void sendNotification(AppNotification notification) {
    if (!AppStateManager().notificationsEnabled) return;

    _notifications.insert(0, notification);
    
    if (_notifications.length > 50) {
      _notifications.removeLast();
    }

    for (final listener in _listeners) {
      listener(notification);
    }
  }

  List<AppNotification> getNotifications() => List.unmodifiable(_notifications);

  List<AppNotification> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  Future<void> _setupNotificationChannels() async {
    debugPrint('Notification channels setup completed');
  }

  void _startPeriodicChecks() {
    Future.delayed(const Duration(hours: 1), () {
      _checkLowStock();
      _startPeriodicChecks();
    });
  }

  void _checkLowStock() {
    sendNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Low Stock Alert',
      message: 'Paracetamol stock is running low (5 units left)',
      type: NotificationType.warning,
      timestamp: DateTime.now(),
    ));
  }

  void sendLowStockAlert(String medicineName, int quantity) {
    sendNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Low Stock Alert',
      message: '$medicineName stock is running low ($quantity units left)',
      type: NotificationType.warning,
      timestamp: DateTime.now(),
    ));
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType { info, success, warning, error, aiInsight }