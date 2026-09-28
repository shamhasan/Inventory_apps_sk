import 'package:inventory_riverpod/features/product/domain/entities/product_entity.dart';

class FilterProducts {
  List<ProductEntity> call({
    required List<ProductEntity> products,
    int maxStock = 10,
  }) {
    return products.where((item) => item.stock < maxStock).toList();
  }
}
