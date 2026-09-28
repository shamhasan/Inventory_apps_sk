import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/product/data/datasources/product_local_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/usecases/filter_products.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/sort_products.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/presentation/pages/product_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final localDataSource = ProductLocalDataSourceImpl();
  final repository = ProductRepositoryImpl(localDataSource: localDataSource);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductBloc(
            getProducts: GetProducts(repository),
            sortProducts: SortProducts(),
            filterProducts: FilterProducts(),
          ),
        ),
      ],
      child: const BenchmarkApp(),
    ),
  );
}

class BenchmarkApp extends StatelessWidget {
  const BenchmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductPage(),
    );
  }
}
