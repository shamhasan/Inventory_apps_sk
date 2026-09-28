import '../../domain/usecases/sort_products.dart';

abstract class ProductEvent {
  const ProductEvent();
}

class LoadProductsEvent extends ProductEvent {}

class SortProductsEvent extends ProductEvent {
  final SortOrder order;
  const SortProductsEvent(this.order);
}

class FilterLowStockEvent extends ProductEvent {}

class ResetFilterEvent extends ProductEvent {}
