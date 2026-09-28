import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'inventory_benchmark.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createTable(db);
        await _seedDatabase(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS products');
        await _createTable(db);
        await _seedDatabase(db);
      },
    );
  }

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        sku TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price INTEGER NOT NULL,
        stock INTEGER NOT NULL,
        category TEXT NOT NULL,
        image_url TEXT NOT NULL,
        weight REAL NOT NULL,
        is_active INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _seedDatabase(Database db) async {
    final batch = db.batch();
    final now = DateTime.now();

    final categories = [
      'Makanan',
      'Minuman',
      'Elektronik',
      'Pakaian',
      'Kesehatan',
    ];
    final descriptions = [
      'Produk berkualitas tinggi dengan bahan pilihan',
      'Barang terlaris kategori ini',
      'Stok terbatas, segera dapatkan',
      'Produk baru dengan kualitas terjamin',
      'Harga terjangkau dengan kualitas premium',
    ];

    for (int i = 1; i <= 10000; i++) {
      batch.insert(
        'products',
        ProductModel(
          id: i,
          sku: 'SKU-${i.toString().padLeft(5, '0')}',
          name: 'Produk Retail $i',
          description: descriptions[i % descriptions.length],
          price: (i % 5 == 0) ? 50000 : 15000,
          stock: (i % 3 == 0) ? 5 : 100,
          category: categories[i % categories.length],
          imageUrl: 'https://picsum.photos/200',
          weight: ((i % 10) + 1) * 0.5,
          isActive: i % 7 != 0,
          createdAt: now,
          updatedAt: now,
        ).toMap(),
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }
}
