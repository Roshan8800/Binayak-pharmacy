import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final int? id;
  final String name;
  final String? genericName;
  final String? manufacturer;
  final String? batchNumber;
  final DateTime? expiryDate;
  final double purchasePrice;
  final double sellingPrice;
  final int stockQuantity;
  final int minStockLevel;
  final String? category;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Medicine({
    this.id,
    required this.name,
    this.genericName,
    this.manufacturer,
    this.batchNumber,
    this.expiryDate,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stockQuantity,
    required this.minStockLevel,
    this.category,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'generic_name': genericName,
      'manufacturer': manufacturer,
      'batch_number': batchNumber,
      'expiry_date': expiryDate?.toIso8601String(),
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'stock_quantity': stockQuantity,
      'min_stock_level': minStockLevel,
      'category': category,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      genericName: map['generic_name'],
      manufacturer: map['manufacturer'],
      batchNumber: map['batch_number'],
      expiryDate: map['expiry_date'] != null ? DateTime.parse(map['expiry_date']) : null,
      purchasePrice: map['purchase_price']?.toDouble() ?? 0.0,
      sellingPrice: map['selling_price']?.toDouble() ?? 0.0,
      stockQuantity: map['stock_quantity'] ?? 0,
      minStockLevel: map['min_stock_level'] ?? 0,
      category: map['category'],
      description: map['description'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Medicine copyWith({
    int? id,
    String? name,
    String? genericName,
    String? manufacturer,
    String? batchNumber,
    DateTime? expiryDate,
    double? purchasePrice,
    double? sellingPrice,
    int? stockQuantity,
    int? minStockLevel,
    String? category,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      manufacturer: manufacturer ?? this.manufacturer,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      category: category ?? this.category,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        genericName,
        manufacturer,
        batchNumber,
        expiryDate,
        purchasePrice,
        sellingPrice,
        stockQuantity,
        minStockLevel,
        category,
        description,
        createdAt,
        updatedAt,
      ];
}