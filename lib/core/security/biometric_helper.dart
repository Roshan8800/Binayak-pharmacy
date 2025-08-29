import 'package:flutter/services.dart';

class BiometricHelper {
  static const MethodChannel _channel = MethodChannel('biometric_auth');

  static Future<bool> isAvailable() async {
    try {
      final bool result = await _channel.invokeMethod('isAvailable');
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    try {
      final bool result = await _channel.invokeMethod('authenticate', {
        'localizedFallbackTitle': 'Use Password',
        'biometricHint': 'Verify your identity',
      });
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<List<String>> getAvailableBiometrics() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getAvailableBiometrics');
      return result.cast<String>();
    } catch (e) {
      return [];
    }
  }
}