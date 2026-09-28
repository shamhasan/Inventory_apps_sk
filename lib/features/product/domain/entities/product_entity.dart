class ProductEntity {
  final int id;
  final String sku;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String category;

  final String imageUrl;
  final double weight;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,

    required this.imageUrl,
    required this.weight,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
