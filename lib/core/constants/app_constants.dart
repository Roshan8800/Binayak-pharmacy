class AppConstants {
  static const String appName = 'Binayak Pharmacy';
  static const String packageName = 'com.roshan.binayakstore';
  static const String ownerName = 'Suman Sahu';
  static const String createdBy = 'Roshan';
  static const String version = '1.0.0';
  
  // Database
  static const String databaseName = 'binayak_pharmacy.db';
  static const int databaseVersion = 1;
  
  // Preferences Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  
  // Categories
  static const List<String> medicineCategories = [
    'Tablet',
    'Capsule', 
    'Syrup',
    'Injection',
    'Ointment',
    'Drops',
    'Powder',
    'Other'
  ];
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'Cash',
    'Card',
    'UPI',
    'Net Banking',
    'Credit'
  ];
}