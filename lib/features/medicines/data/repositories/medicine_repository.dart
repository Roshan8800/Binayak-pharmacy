import '../../../../core/database/database_helper.dart';
import '../models/medicine_model.dart';

class MedicineRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Medicine>> getAllMedicines() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('medicines');
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  Future<Medicine?> getMedicineById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Medicine.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertMedicine(Medicine medicine) async {
    final db = await _databaseHelper.database;
    final medicineWithTimestamp = medicine.copyWith(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return await db.insert('medicines', medicineWithTimestamp.toMap());
  }

  Future<int> updateMedicine(Medicine medicine) async {
    final db = await _databaseHelper.database;
    final medicineWithTimestamp = medicine.copyWith(
      updatedAt: DateTime.now(),
    );
    return await db.update(
      'medicines',
      medicineWithTimestamp.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> deleteMedicine(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Medicine>> searchMedicines(String query) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      where: 'name LIKE ? OR generic_name LIKE ? OR manufacturer LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  Future<List<Medicine>> getLowStockMedicines() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM medicines WHERE stock_quantity <= min_stock_level',
    );
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  Future<List<Medicine>> getExpiringMedicines(int days) async {
    final db = await _databaseHelper.database;
    final futureDate = DateTime.now().add(Duration(days: days));
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      where: 'expiry_date <= ?',
      whereArgs: [futureDate.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }
}