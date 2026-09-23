import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Sesuaikan path import dengan nama project di pubspec.yaml kamu:
import 'package:week3_todo/providers/todo_provider.dart';
import 'package:week3_todo/providers/products_provider.dart';
// import '../lib/AIcode/providers/todo_provider.dart';
// import '../lib/AIcode/providers/products_provider.dart';

void main() {
  group('TodoListNotifier Tests', () {
    test('Nilai awal todoListProvider harus berupa list kosong', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(todoListProvider), isEmpty);
    });

    test('add() menambahkan item baru secara immutable', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoListProvider.notifier).add('Belajar Riverpod');

      final todos = container.read(todoListProvider);
      expect(todos.length, 1);
      expect(todos.first.title, 'Belajar Riverpod');
      expect(todos.first.done, isFalse);
    });

    test('toggle() mengubah status done', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(todoListProvider.notifier);
      notifier.add('Tugas 1');
      notifier.toggle(0);

      expect(container.read(todoListProvider)[0].done, isTrue);

      notifier.toggle(0);
      expect(container.read(todoListProvider)[0].done, isFalse);
    });

    test('remove() menghapus item berdasarkan indeks', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(todoListProvider.notifier);
      notifier.add('Item A');
      notifier.add('Item B');

      notifier.remove(0);

      final todos = container.read(todoListProvider);
      expect(todos.length, 1);
      expect(todos.first.title, 'Item B');
    });
  });

  group('ProductsNotifier Tests', () {
    test('build() menghasilkan data awal setelah loading selesai', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Status awal adalah AsyncLoading
      expect(container.read(productsProvider), isA<AsyncLoading>());

      // Tunggu hingga Future dari build() selesai
      final data = await container.read(productsProvider.future);

      expect(data, ['Keyboard', 'Mouse', 'Monitor']);
      expect(container.read(productsProvider).value, ['Keyboard', 'Mouse', 'Monitor']);
    });
  });
}