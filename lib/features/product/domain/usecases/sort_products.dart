import 'package:inventory_bloc/features/product/domain/entities/product_entity.dart';

enum SortOrder { priceAsc, priceDesc }

class SortProducts {
  List<ProductEntity> call({
    required List<ProductEntity> products,
    required SortOrder order,
  }) {
    // Gandakan list agar tidak memutasi referensi state lama secara langsung
    final sortedList = List<ProductEntity>.from(products);

    if (order == SortOrder.priceAsc) {
      sortedList.sort((a, b) => a.price.compareTo(b.price));
    } else {
      sortedList.sort((a, b) => b.price.compareTo(a.price));
    }

    return sortedList;
  }
}
