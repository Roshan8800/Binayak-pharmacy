import 'package:intl/intl.dart';

class CurrencyUtils {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  
  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }
  
  static String formatCurrencyCompact(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }
  
  static double parseAmount(String text) {
    final cleanText = text.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanText) ?? 0.0;
  }
}