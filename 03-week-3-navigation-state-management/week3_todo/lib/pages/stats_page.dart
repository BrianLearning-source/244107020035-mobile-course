import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final completedCount = todos.where((t) => t.done).length;
    final activeCount = todos.length - completedCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatCard(
                title: 'Total Tasks',
                count: todos.length,
                icon: Icons.list_alt,
                color: Colors.teal,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Completed Tasks',
                count: completedCount,
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Active Tasks',
                count: activeCount,
                icon: Icons.pending_actions,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color, size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}