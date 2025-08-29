import 'package:flutter/material.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/navigation/presentation/pages/main_navigation_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/medicines/presentation/pages/medicines_page.dart';
import '../../features/sales/presentation/pages/sales_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String main = '/main';
  static const String dashboard = '/dashboard';
  static const String medicines = '/medicines';
  static const String sales = '/sales';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case main:
        return MaterialPageRoute(builder: (_) => const MainNavigationPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case medicines:
        return MaterialPageRoute(builder: (_) => const MedicinesPage());
      case sales:
        return MaterialPageRoute(builder: (_) => const SalesPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
  }

  static void navigateToMain(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, main, (route) => false);
  }

  static void navigateBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}