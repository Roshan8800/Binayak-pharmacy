import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateManager extends ChangeNotifier {
  static final AppStateManager _instance = AppStateManager._internal();
  factory AppStateManager() => _instance;
  AppStateManager._internal();

  bool _isFirstLaunch = true;
  bool _isLoggedIn = false;
  String _currentUser = '';
  ThemeMode _themeMode = ThemeMode.light;
  String _language = 'en';
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;

  // Getters
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isLoggedIn => _isLoggedIn;
  String get currentUser => _currentUser;
  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;

  // Initialize app state
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('first_launch') ?? true;
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _currentUser = prefs.getString('current_user') ?? '';
    _themeMode = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
    _language = prefs.getString('language') ?? 'en';
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    notifyListeners();
  }

  Future<void> setLoggedIn(bool value, [String user = '']) async {
    _isLoggedIn = value;
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', value);
    await prefs.setString('current_user', user);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> logout() async {
    await setLoggedIn(false);
    _currentUser = '';
    notifyListeners();
  }
}