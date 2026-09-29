import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:inventory_bloc/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Benchmark Skenario 1 Repetisi (Load, Sort, Filter)', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    print('====================================================');
    print('⏳ APLIKASI TERBUKA. JEDA PERSIAPAN 1 MENIT DIMULAI.');
    print('🚨 BUKA DEVTOOLS DAN ANDROID PROFILER SEKARANG!');
    print('====================================================');

    await Future.delayed(const Duration(minutes: 2));

    print('🚀 JEDA SELESAI, ROBOT MULAI MENGEKLIK LOAD!');

    final btnLoad = find.byKey(const Key('btn_load'));
    await tester.tap(btnLoad);
    await tester.pumpAndSettle();

    print('Tunggu 15 detik');
    await Future.delayed(const Duration(seconds: 15));

    final btnSort = find.byKey(const Key('btn_sort'));
    await tester.tap(btnSort);
    await tester.pumpAndSettle();

    print('Tunggu 15 detik');
    await Future.delayed(const Duration(seconds: 15));

    final btnFilter = find.byKey(const Key('btn_filter'));
    await tester.tap(btnFilter);
    await tester.pumpAndSettle();

    print('--- 1 REPETISI SELESAI. SILAKAN CATAT METRIK DEVTOOLS ---');
  });
}
