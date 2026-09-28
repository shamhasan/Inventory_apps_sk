import 'package:inventory_bloc/features/product/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.sku,
    required super.name,
    required super.description,
    required super.price,
    required super.stock,
    required super.category,
    required super.imageUrl,
    required super.weight,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      sku: map['sku'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as int,
      stock: map['stock'] as int,
      category: map['category'] as String,
      imageUrl: map['image_url'] as String,
      weight: (map['weight'] as num).toDouble(),
      isActive: (map['is_active'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "sku": sku,
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "category": category,
      "image_url": imageUrl,
      "weight": weight,
      "is_active": isActive ? 1 : 0,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
