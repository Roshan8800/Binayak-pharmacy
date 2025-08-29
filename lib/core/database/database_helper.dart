import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'binayak_pharmacy.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Medicines table
    await db.execute('''
      CREATE TABLE medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        generic_name TEXT,
        manufacturer TEXT,
        batch_number TEXT,
        expiry_date TEXT,
        purchase_price REAL,
        selling_price REAL,
        stock_quantity INTEGER,
        min_stock_level INTEGER,
        category TEXT,
        description TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // Sales table
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_name TEXT,
        customer_phone TEXT,
        total_amount REAL,
        discount REAL,
        final_amount REAL,
        payment_method TEXT,
        sale_date TEXT,
        created_at TEXT
      )
    ''');

    // Sale items table
    await db.execute('''
      CREATE TABLE sale_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER,
        medicine_id INTEGER,
        quantity INTEGER,
        unit_price REAL,
        total_price REAL,
        FOREIGN KEY (sale_id) REFERENCES sales (id),
        FOREIGN KEY (medicine_id) REFERENCES medicines (id)
      )
    ''');

    // Inventory transactions table
    await db.execute('''
      CREATE TABLE inventory_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicine_id INTEGER,
        transaction_type TEXT,
        quantity INTEGER,
        reference_id INTEGER,
        notes TEXT,
        created_at TEXT,
        FOREIGN KEY (medicine_id) REFERENCES medicines (id)
      )
    ''');
  }
}