import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final List<PerformanceMetric> _metrics = [];
  bool _isMonitoring = false;

  void startMonitoring() {
    _isMonitoring = true;
    debugPrint('Performance monitoring started');
  }

  void stopMonitoring() {
    _isMonitoring = false;
    debugPrint('Performance monitoring stopped');
  }

  void recordMetric(String name, Duration duration, {Map<String, dynamic>? metadata}) {
    if (!_isMonitoring) return;

    final metric = PerformanceMetric(
      name: name,
      duration: duration,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _metrics.add(metric);

    // Keep only last 100 metrics to prevent memory issues
    if (_metrics.length > 100) {
      _metrics.removeAt(0);
    }

    // Log slow operations
    if (duration.inMilliseconds > 1000) {
      debugPrint('Slow operation detected: $name took ${duration.inMilliseconds}ms');
    }
  }

  List<PerformanceMetric> getMetrics() => List.unmodifiable(_metrics);

  void clearMetrics() {
    _metrics.clear();
  }

  // Measure widget build time
  static Widget measureBuildTime(Widget child, String widgetName) {
    return Builder(
      builder: (context) {
        final stopwatch = Stopwatch()..start();
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          stopwatch.stop();
          PerformanceMonitor().recordMetric(
            'Widget Build: $widgetName',
            stopwatch.elapsed,
          );
        });

        return child;
      },
    );
  }

  // Measure async operation time
  static Future<T> measureAsyncOperation<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      stopwatch.stop();
      
      PerformanceMonitor().recordMetric(
        'Async Operation: $operationName',
        stopwatch.elapsed,
      );
      
      return result;
    } catch (e) {
      stopwatch.stop();
      
      PerformanceMonitor().recordMetric(
        'Failed Operation: $operationName',
        stopwatch.elapsed,
        metadata: {'error': e.toString()},
      );
      
      rethrow;
    }
  }
}

class PerformanceMetric {
  final String name;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PerformanceMetric({
    required this.name,
    required this.duration,
    required this.timestamp,
    this.metadata,
  });

  @override
  String toString() {
    return 'PerformanceMetric(name: $name, duration: ${duration.inMilliseconds}ms, timestamp: $timestamp)';
  }
}