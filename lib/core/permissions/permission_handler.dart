import 'package:flutter/material.dart';

class PermissionHandler {
  static Future<bool> requestCameraPermission() async {
    // Simulate permission request
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // In real app, use permission_handler package
  }

  static Future<bool> requestStoragePermission() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  static Future<bool> requestMicrophonePermission() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  static Future<bool> requestNotificationPermission() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  static Future<bool> requestLocationPermission() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  static void showPermissionDialog(BuildContext context, String permission, VoidCallback onGranted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permission Permission Required'),
        content: Text('This app needs $permission permission to function properly.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onGranted();
            },
            child: const Text('Grant'),
          ),
        ],
      ),
    );
  }

  static Future<Map<String, bool>> checkAllPermissions() async {
    return {
      'camera': await requestCameraPermission(),
      'storage': await requestStoragePermission(),
      'microphone': await requestMicrophonePermission(),
      'notification': await requestNotificationPermission(),
      'location': await requestLocationPermission(),
    };
  }
}