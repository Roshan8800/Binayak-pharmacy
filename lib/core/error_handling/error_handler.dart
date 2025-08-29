import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleError(dynamic error, BuildContext context, {String? customMessage}) {
    String message = customMessage ?? _getErrorMessage(error);
    
    // Log error for debugging
    debugPrint('Error: $error');
    
    // Show user-friendly error message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  static String _getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return 'Network error. Please check your connection.';
    } else if (error is AuthenticationException) {
      return 'Authentication failed. Please try again.';
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is DatabaseException) {
      return 'Database error. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Custom Exception Classes
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}