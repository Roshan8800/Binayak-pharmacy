import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InteractionHandler {
  static final InteractionHandler _instance = InteractionHandler._internal();
  factory InteractionHandler() => _instance;
  InteractionHandler._internal();

  final List<UserInteraction> _interactionHistory = [];

  void handleTap(String elementId, BuildContext context, {VoidCallback? onTap}) {
    _recordInteraction(UserInteractionType.tap, elementId);
    _provideFeedback(context);
    
    if (onTap != null) {
      onTap();
    }
  }

  void handleLongPress(String elementId, BuildContext context, {VoidCallback? onLongPress}) {
    _recordInteraction(UserInteractionType.longPress, elementId);
    _provideHapticFeedback();
    
    if (onLongPress != null) {
      onLongPress();
    }
  }

  void handleFormInput(String fieldId, String value, BuildContext context) {
    _recordInteraction(UserInteractionType.input, fieldId);
    _validateInput(fieldId, value, context);
  }

  void handleNavigation(String fromScreen, String toScreen, BuildContext context) {
    _recordInteraction(UserInteractionType.navigation, '$fromScreen->$toScreen');
  }

  void handleError(String errorType, String context, BuildContext buildContext) {
    _recordInteraction(UserInteractionType.error, errorType);
    _showErrorFeedback(errorType, buildContext);
  }

  void _recordInteraction(UserInteractionType type, String elementId) {
    final interaction = UserInteraction(
      type: type,
      elementId: elementId,
      timestamp: DateTime.now(),
    );

    _interactionHistory.add(interaction);

    if (_interactionHistory.length > 1000) {
      _interactionHistory.removeAt(0);
    }

    debugPrint('User Interaction: ${type.name} on $elementId');
  }

  void _provideFeedback(BuildContext context) {
    HapticFeedback.lightImpact();
  }

  void _provideHapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  void _validateInput(String fieldId, String value, BuildContext context) {
    String? errorMessage;

    switch (fieldId) {
      case 'email':
        if (value.isNotEmpty && !_isValidEmail(value)) {
          errorMessage = 'Invalid email format';
        }
        break;
      case 'phone':
        if (value.isNotEmpty && !_isValidPhone(value)) {
          errorMessage = 'Invalid phone number';
        }
        break;
      case 'price':
        if (value.isNotEmpty && double.tryParse(value) == null) {
          errorMessage = 'Invalid price format';
        }
        break;
    }

    if (errorMessage != null) {
      _showValidationError(errorMessage, context);
    }
  }

  void _showValidationError(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorFeedback(String errorType, BuildContext context) {
    String message = 'An error occurred';
    
    switch (errorType) {
      case 'network':
        message = 'Network connection error. Please check your internet.';
        break;
      case 'validation':
        message = 'Please check your input and try again.';
        break;
      case 'permission':
        message = 'Permission required to perform this action.';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }

  Map<String, dynamic> getInteractionAnalytics() {
    return {
      'totalInteractions': _interactionHistory.length,
      'mostUsedFeatures': _getMostUsedFeatures(),
    };
  }

  List<String> _getMostUsedFeatures() {
    final featureCounts = <String, int>{};
    
    for (final interaction in _interactionHistory) {
      featureCounts[interaction.elementId] = (featureCounts[interaction.elementId] ?? 0) + 1;
    }

    final sortedFeatures = featureCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedFeatures.take(5).map((e) => e.key).toList();
  }
}

class UserInteraction {
  final UserInteractionType type;
  final String elementId;
  final DateTime timestamp;

  UserInteraction({
    required this.type,
    required this.elementId,
    required this.timestamp,
  });
}

enum UserInteractionType { tap, longPress, swipe, input, navigation, error }