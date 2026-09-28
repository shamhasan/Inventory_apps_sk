import 'package:flutter/foundation.dart';
import 'package:inventory_riverpod/features/product/data/datasources/product_local_data_source.dart';
import 'package:inventory_riverpod/features/product/data/repositories/product_repository_impl.dart';
import 'package:inventory_riverpod/features/product/domain/repositories/product_repository.dart';
import 'package:inventory_riverpod/features/product/domain/usecases/filter_products.dart';
import 'package:inventory_riverpod/features/product/domain/usecases/get_products.dart';
import 'package:inventory_riverpod/features/product/domain/usecases/sort_products.dart';
import 'package:inventory_riverpod/features/product/presentation/providers/product_state.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

final localDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  return ProductLocalDataSourceImpl();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    localDataSource: ref.read(localDataSourceProvider),
  );
});

final getProductsUseCaseProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.read(productRepositoryProvider));
});

final sortProductsUseCaseProvider = Provider<SortProducts>(
  (ref) => SortProducts(),
);

final filterProductsUseCaseProvider = Provider<FilterProducts>(
  (ref) => FilterProducts(),
);

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProducts _getProducts;
  final SortProducts _sortProducts;
  final FilterProducts _filterProducts;

  ProductNotifier({
    required GetProducts getProducts,
    required SortProducts sortProducts,
    required FilterProducts filterProducts,
  }) : _getProducts = getProducts,
       _sortProducts = sortProducts,
       _filterProducts = filterProducts,
       super(const ProductState());

  Future<void> loadProducts() async {
    final stopwatch = Stopwatch()..start();
    state = state.copyWith(isLoading: true);
    final results = await _getProducts();

    state = state.copyWith(
      isLoading: false,
      rawProducts: results,
      displayedProducts: results,
    );
    stopwatch.stop();
    debugPrint(
      'METRIK Y3 (Riverpod - Load): ${stopwatch.elapsedMicroseconds / 1000} ms',
    );
  }

  void sort(SortOrder order) {
    final stopwatch = Stopwatch()..start();
    final sorted = _sortProducts(
      products: state.displayedProducts,
      order: order,
    );
    state = state.copyWith(displayedProducts: sorted);
    stopwatch.stop();
    debugPrint(
      'METRIK Y3 (Riverpod - Sort): ${stopwatch.elapsedMicroseconds / 1000} ms',
    );
  }

  void filterLowStock() {
    final stopwatch = Stopwatch()..start();
    final filtered = _filterProducts(products: state.rawProducts, maxStock: 10);
    state = state.copyWith(displayedProducts: filtered);
    stopwatch.stop();
    debugPrint(
      'METRIK Y3 (Riverpod - Filter): ${stopwatch.elapsedMicroseconds / 1000} ms',
    );
  }

  void resetFilter() {
    state = state.copyWith(displayedProducts: state.rawProducts);
  }
}

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
      return ProductNotifier(
        getProducts: ref.read(getProductsUseCaseProvider),
        sortProducts: ref.read(sortProductsUseCaseProvider),
        filterProducts: ref.read(filterProductsUseCaseProvider),
      );
    });
