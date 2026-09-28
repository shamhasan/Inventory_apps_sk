import 'package:inventory_riverpod/features/product/domain/entities/product_entity.dart';

class ProductState {
  final bool isLoading;
  final List<ProductEntity> rawProducts;
  final List<ProductEntity> displayedProducts;

  const ProductState({
    this.isLoading = false,
    this.rawProducts = const [],
    this.displayedProducts = const [],
  });

  ProductState copyWith({
    bool? isLoading,
    List<ProductEntity>? rawProducts,
    List<ProductEntity>? displayedProducts,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      rawProducts: rawProducts ?? this.rawProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
    );
  }
}
