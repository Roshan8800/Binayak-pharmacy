class PharmacyRules {
  // Medicine validation rules
  static bool validateMedicineStock(int currentStock, int minStock) {
    return currentStock >= minStock;
  }

  static bool validateExpiryDate(DateTime expiryDate) {
    return expiryDate.isAfter(DateTime.now());
  }

  static bool validatePrice(double purchasePrice, double sellingPrice) {
    return sellingPrice > purchasePrice;
  }

  // Sales validation rules
  static bool validateSaleQuantity(int requestedQty, int availableStock) {
    return requestedQty <= availableStock && requestedQty > 0;
  }

  static bool validateDiscount(double discount, double totalAmount) {
    return discount >= 0 && discount <= totalAmount * 0.5; // Max 50% discount
  }

  // Customer validation rules
  static bool validateCustomerAge(int age) {
    return age >= 0 && age <= 150;
  }

  static bool validatePhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone);
  }

  // Business logic rules
  static double calculateTax(double amount, double taxRate) {
    return amount * (taxRate / 100);
  }

  static double calculateDiscount(double amount, double discountPercent) {
    return amount * (discountPercent / 100);
  }

  static bool shouldReorder(int currentStock, int minStock, int avgDailySales) {
    final daysOfStock = currentStock / (avgDailySales > 0 ? avgDailySales : 1);
    return daysOfStock <= 7; // Reorder if less than 7 days of stock
  }

  // AI-driven business rules
  static bool isHighValueCustomer(double totalPurchases, int visitCount) {
    return totalPurchases > 10000 || visitCount > 50;
  }

  static String getCustomerTier(double totalPurchases) {
    if (totalPurchases > 50000) return 'VIP';
    if (totalPurchases > 20000) return 'Premium';
    if (totalPurchases > 5000) return 'Regular';
    return 'Basic';
  }

  static bool requiresPrescription(String medicineCategory) {
    final prescriptionRequired = ['Antibiotics', 'Controlled Substances', 'Narcotics'];
    return prescriptionRequired.contains(medicineCategory);
  }

  // Inventory management rules
  static bool isExpiringSoon(DateTime expiryDate, {int warningDays = 30}) {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= warningDays && daysUntilExpiry > 0;
  }

  static bool isExpired(DateTime expiryDate) {
    return expiryDate.isBefore(DateTime.now());
  }

  static double calculateProfitMargin(double purchasePrice, double sellingPrice) {
    if (purchasePrice == 0) return 0;
    return ((sellingPrice - purchasePrice) / purchasePrice) * 100;
  }

  // Security rules
  static bool validateUserAccess(String userRole, String action) {
    final adminActions = ['delete_medicine', 'modify_prices', 'view_reports'];
    final pharmacistActions = ['add_medicine', 'process_sale', 'view_inventory'];
    final cashierActions = ['process_sale', 'view_medicines'];

    switch (userRole.toLowerCase()) {
      case 'admin':
        return true; // Admin can do everything
      case 'pharmacist':
        return pharmacistActions.contains(action) || adminActions.contains(action);
      case 'cashier':
        return cashierActions.contains(action);
      default:
        return false;
    }
  }

  // Notification rules
  static bool shouldSendLowStockAlert(int currentStock, int minStock) {
    return currentStock <= minStock;
  }

  static bool shouldSendExpiryAlert(DateTime expiryDate) {
    return isExpiringSoon(expiryDate, warningDays: 7);
  }
}