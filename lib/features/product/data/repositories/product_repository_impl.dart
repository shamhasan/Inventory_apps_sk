import 'package:inventory_bloc/features/product/data/datasources/product_local_data_source.dart';
import 'package:inventory_bloc/features/product/domain/entities/product_entity.dart';
import 'package:inventory_bloc/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    return await localDataSource.getProducts();
  }
}
