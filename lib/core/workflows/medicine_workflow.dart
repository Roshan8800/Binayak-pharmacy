import '../business_logic/pharmacy_rules.dart';
import '../notifications/notification_service.dart';
import '../../features/medicines/data/models/medicine_model.dart';
import '../../features/medicines/data/repositories/medicine_repository.dart';

class MedicineWorkflow {
  final MedicineRepository _repository = MedicineRepository();
  final NotificationService _notificationService = NotificationService();

  Future<WorkflowResult> addMedicine(Medicine medicine) async {
    try {
      final validationResult = _validateMedicineData(medicine);
      if (!validationResult.isSuccess) {
        return validationResult;
      }

      final duplicateCheck = await _checkForDuplicates(medicine.name);
      if (!duplicateCheck.isSuccess) {
        return duplicateCheck;
      }

      final medicineId = await _repository.insertMedicine(medicine);
      await _postAddProcessing(medicine.copyWith(id: medicineId));

      return WorkflowResult.success('Medicine added successfully', data: medicineId);
    } catch (e) {
      return WorkflowResult.error('Failed to add medicine: ${e.toString()}');
    }
  }

  Future<WorkflowResult> updateMedicine(Medicine medicine) async {
    try {
      final existingMedicine = await _repository.getMedicineById(medicine.id!);
      if (existingMedicine == null) {
        return WorkflowResult.error('Medicine not found');
      }

      final validationResult = _validateMedicineData(medicine);
      if (!validationResult.isSuccess) {
        return validationResult;
      }

      await _repository.updateMedicine(medicine);
      await _postUpdateProcessing(existingMedicine, medicine);

      return WorkflowResult.success('Medicine updated successfully');
    } catch (e) {
      return WorkflowResult.error('Failed to update medicine: ${e.toString()}');
    }
  }

  Future<WorkflowResult> processMedicineSale(int medicineId, int quantity) async {
    try {
      final medicine = await _repository.getMedicineById(medicineId);
      if (medicine == null) {
        return WorkflowResult.error('Medicine not found');
      }

      if (!PharmacyRules.validateSaleQuantity(quantity, medicine.stockQuantity)) {
        return WorkflowResult.error('Insufficient stock or invalid quantity');
      }

      final updatedMedicine = medicine.copyWith(
        stockQuantity: medicine.stockQuantity - quantity,
      );
      await _repository.updateMedicine(updatedMedicine);

      if (PharmacyRules.shouldSendLowStockAlert(
        updatedMedicine.stockQuantity, 
        updatedMedicine.minStockLevel
      )) {
        _notificationService.sendLowStockAlert(
          updatedMedicine.name, 
          updatedMedicine.stockQuantity
        );
      }

      return WorkflowResult.success('Sale processed successfully', 
        data: {'newStock': updatedMedicine.stockQuantity});
    } catch (e) {
      return WorkflowResult.error('Failed to process sale: ${e.toString()}');
    }
  }

  WorkflowResult _validateMedicineData(Medicine medicine) {
    if (medicine.name.trim().isEmpty) {
      return WorkflowResult.error('Medicine name is required');
    }

    if (!PharmacyRules.validatePrice(medicine.purchasePrice, medicine.sellingPrice)) {
      return WorkflowResult.error('Selling price must be greater than purchase price');
    }

    if (medicine.expiryDate != null && !PharmacyRules.validateExpiryDate(medicine.expiryDate!)) {
      return WorkflowResult.error('Expiry date cannot be in the past');
    }

    return WorkflowResult.success('Validation passed');
  }

  Future<WorkflowResult> _checkForDuplicates(String medicineName) async {
    final existingMedicines = await _repository.searchMedicines(medicineName);
    final exactMatch = existingMedicines.where(
      (m) => m.name.toLowerCase() == medicineName.toLowerCase()
    ).toList();

    if (exactMatch.isNotEmpty) {
      return WorkflowResult.error('Medicine with this name already exists');
    }

    return WorkflowResult.success('No duplicates found');
  }

  Future<void> _postAddProcessing(Medicine medicine) async {
    _notificationService.sendNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Medicine Added',
      message: '${medicine.name} has been added to inventory',
      type: NotificationType.info,
      timestamp: DateTime.now(),
    ));

    if (PharmacyRules.shouldSendLowStockAlert(medicine.stockQuantity, medicine.minStockLevel)) {
      _notificationService.sendLowStockAlert(medicine.name, medicine.stockQuantity);
    }
  }

  Future<void> _postUpdateProcessing(Medicine oldMedicine, Medicine newMedicine) async {
    if (newMedicine.expiryDate != null && 
        PharmacyRules.shouldSendExpiryAlert(newMedicine.expiryDate!)) {
      final daysLeft = newMedicine.expiryDate!.difference(DateTime.now()).inDays;
      _notificationService.sendNotification(AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Expiry Alert',
        message: '${newMedicine.name} expires in $daysLeft days',
        type: NotificationType.warning,
        timestamp: DateTime.now(),
      ));
    }
  }
}

class WorkflowResult {
  final bool isSuccess;
  final String message;
  final dynamic data;

  WorkflowResult._(this.isSuccess, this.message, this.data);

  factory WorkflowResult.success(String message, {dynamic data}) {
    return WorkflowResult._(true, message, data);
  }

  factory WorkflowResult.error(String message, {dynamic data}) {
    return WorkflowResult._(false, message, data);
  }
}