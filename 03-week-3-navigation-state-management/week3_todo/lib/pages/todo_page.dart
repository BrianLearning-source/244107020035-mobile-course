import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo Riverpod')),
      body: todos.isEmpty
        ? const Center(
          child: Text('No tasks yet')
        )
        : ListView.builder(
          itemCount: todos.length,
          itemBuilder: (Context, index) => 
            ListTile( 
              leading: Checkbox(
                value: todos[index].done,
                onChanged: (_) =>
                  ref.read(todoListProvider.notifier).toggle(index),
              ),
              title: Text(
                todos[index].title,
                style: TextStyle(
                  decoration: todos[index].done
                    ? TextDecoration.lineThrough
                    : null),
                ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed:() =>
                  ref.read(todoListProvider.notifier).remove(index),
                ),
              ),
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(context, ref),
            child: const Icon(Icons.add),
          ),
        );
      }

void _showAddDialog(BuildContext context,WidgetRef ref) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('New Task'),
      content: TextField(
        controller: controller, autofocus: true
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              ref 
                .read(todoListProvider.notifier)
                .add(controller.text.trim());
            }
              Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
}

// ProductPage widget to display the list of products using ProductsNotifier

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Failed to load: $err'),
              FilledButton(
                onPressed: () => ref.invalidate(productsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) =>
              ListTile(title: Text(products[index])),
        ),
      ),
    );
  }
}