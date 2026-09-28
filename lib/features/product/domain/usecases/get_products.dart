import 'package:inventory_bloc/features/product/domain/entities/product_entity.dart';
import 'package:inventory_bloc/features/product/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<ProductEntity>> call() async {
    return await repository.getProducts();
  }
}
