import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/usecases/sort_products.dart';
import '../providers/product_notifier.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productNotifierProvider);
    final notifier = ref.read(productNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riverpod Benchmark (${state.displayedProducts.length} SKU)',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                ElevatedButton(
                  key: const Key('btn_load'),
                  onPressed: () => notifier.loadProducts(),
                  child: const Text('Load 10k'),
                ),
                ElevatedButton(
                  key: const Key('btn_sort'),
                  onPressed: () => notifier.sort(SortOrder.priceAsc),
                  child: const Text('Sort Harga Termurah'),
                ),
                ElevatedButton(
                  key: const Key('btn_filter'),
                  onPressed: () => notifier.filterLowStock(),
                  child: const Text('Filter Stok < 10'),
                ),
                ElevatedButton(
                  onPressed: () => notifier.resetFilter(),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.displayedProducts.length,
                itemBuilder: (context, index) {
                  final item = state.displayedProducts[index];
                  final dateFormat = DateFormat('dd MMM yyyy');

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              width: 64,
                              height: 64,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons
                                    .inventory_2, // Ikon statis dari material design
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name + Active badge
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item.isActive
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.isActive ? 'Aktif' : 'Nonaktif',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: item.isActive
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                // SKU + Category
                                Text(
                                  '${item.sku} · ${item.category}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Description
                                Text(
                                  item.description,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Price, Stock, Weight, Date
                                Wrap(
                                  spacing: 12,
                                  children: [
                                    Text(
                                      'Rp ${item.price}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      'Stok: ${item.stock}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${item.weight} kg',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      dateFormat.format(item.createdAt),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
