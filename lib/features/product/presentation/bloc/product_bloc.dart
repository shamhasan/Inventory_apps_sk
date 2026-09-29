import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/filter_products.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/sort_products.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final SortProducts sortProducts;
  final FilterProducts filterProducts;

  ProductBloc({
    required this.getProducts,
    required this.sortProducts,
    required this.filterProducts,
  }) : super(const ProductState()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<SortProductsEvent>(_onSortProducts);
    on<FilterLowStockEvent>(_onFilterLowStock);
    on<ResetFilterEvent>(_onResetFilter);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final stopwatch = Stopwatch()..start();
    emit(state.copyWith(isLoading: true));
    final results = await getProducts();
    emit(
      state.copyWith(
        isLoading: false,
        rawProducts: results,
        displayedProducts: results,
      ),
    );
    stopwatch.stop();
    debugPrint(
      'METRIK Y3 (BLoC - Load): ${stopwatch.elapsedMicroseconds / 1000} ms',
    );
  }

  void _onSortProducts(SortProductsEvent event, Emitter<ProductState> emit) {
    final stopwatch = Stopwatch()..start();
    final sorted = sortProducts(
      products: state.displayedProducts,
      order: event.order,
    );
    emit(state.copyWith(displayedProducts: sorted));
    debugPrint(
      'METRIK Y3 (BLoC - Sort): ${stopwatch.elapsedMicroseconds / 1000} ms',
    );
  }

  void _onFilterLowStock(
    FilterLowStockEvent event,
    Emitter<ProductState> emit,
  ) {
    final stopwatch = Stopwatch()..start();
    final filtered = filterProducts(products: state.rawProducts, maxStock: 10);
    emit(state.copyWith(displayedProducts: filtered));
    debugPrint(
      'METRIK Y3 (BLoC - Filter): ${stopwatch.elapsedMicroseconds / 1000} ms',
    );
  }

  void _onResetFilter(ResetFilterEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(displayedProducts: state.rawProducts));
  }
}
