import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/database/database_helper.dart';
import 'core/theme/app_theme.dart';
import 'core/app_state/app_state_manager.dart';
import 'core/navigation/app_router.dart';
import 'core/notifications/notification_service.dart';
import 'core/performance/performance_monitor.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/medicines/presentation/bloc/medicine_bloc.dart';
import 'features/inventory/presentation/bloc/inventory_bloc.dart';
import 'features/sales/presentation/bloc/sales_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core services
  await DatabaseHelper.instance.database;
  await AppStateManager().initialize();
  await NotificationService().initialize();
  PerformanceMonitor().startMonitoring();
  
  runApp(const BinayakPharmacyApp());
}

class BinayakPharmacyApp extends StatelessWidget {
  const BinayakPharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateManager()),
        BlocProvider(create: (context) => MedicineBloc()),
        BlocProvider(create: (context) => InventoryBloc()),
        BlocProvider(create: (context) => SalesBloc()),
      ],
      child: Consumer<AppStateManager>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Binayak Pharmacy',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.splash,
          );
        },
      ),
    );
  }
}