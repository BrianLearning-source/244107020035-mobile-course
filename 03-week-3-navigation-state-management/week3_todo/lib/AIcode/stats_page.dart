import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single statistic entry that will be shown as one row in the list.
class Stat {
  final String label;
  final double value;

  const Stat({required this.label, required this.value});
}

/// -----------------------------------------------------------------------
/// REPOSITORY
/// -----------------------------------------------------------------------
/// We pull the "fetch" logic out of the Notifier and into its own class.
/// This is the trick that makes the notifier easy to unit test: in tests
/// we can swap this class for a Fake that returns instantly and
/// deterministically, instead of the real 2-second/30%-failure version.
class StatsRepository {
  /// Simulates a network call:
  /// - waits 2 seconds (pretend latency)
  /// - has a ~30% chance of throwing, to simulate a flaky backend
  Future<List<Stat>> fetchStats() async {
    await Future.delayed(const Duration(seconds: 2));

    final failed = Random().nextDouble() < 0.3; // ~30% chance
    if (failed) {
      throw Exception('Failed to load statistics. Please try again.');
    }

    // Always exactly 3 items, per the requirement.
    return const [
      Stat(label: 'Active Users', value: 1523),
      Stat(label: 'Daily Sign-ups', value: 87),
      Stat(label: 'Conversion Rate', value: 4.2),
    ];
  }
}

/// Exposes the repository to the rest of the app via Riverpod.
/// Overriding this single provider in tests is what lets us fake the
/// network call without touching the notifier's code at all.
final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository();
});

/// -----------------------------------------------------------------------
/// NOTIFIER
/// -----------------------------------------------------------------------
/// AsyncNotifier<List<Stat>> gives us an AsyncValue<List<Stat>> state
/// (AsyncLoading / AsyncData / AsyncError) for free, which maps directly
/// onto the three UI states we need to handle.
class StatsNotifier extends AsyncNotifier<List<Stat>> {
  @override
  FutureOr<List<Stat>> build() {
    // build() runs the first time the provider is read (and again if
    // ref.invalidateSelf()/ref.refresh() is called). Returning the
    // Future here means Riverpod automatically shows AsyncLoading while
    // it's pending, then AsyncData or AsyncError depending on outcome.
    final repository = ref.watch(statsRepositoryProvider);
    return repository.fetchStats();
  }

  /// Called by the UI's Retry button.
  Future<void> retry() async {
    // Show the spinner again immediately instead of leaving the old
    // error on screen while the new fetch is in flight.
    state = const AsyncLoading();

    // AsyncValue.guard() runs the given future and automatically wraps
    // the outcome as AsyncData (on success) or AsyncError (on thrown
    // exception) — no manual try/catch needed.
    final repository = ref.read(statsRepositoryProvider);
    state = await AsyncValue.guard(repository.fetchStats);
  }
}

/// The provider the UI actually watches/reads.
final statsProvider = AsyncNotifierProvider<StatsNotifier, List<Stat>>(
  StatsNotifier.new,
);

/// -----------------------------------------------------------------------
/// UI
/// -----------------------------------------------------------------------
/// ConsumerWidget (instead of StatelessWidget) gives build() a WidgetRef,
/// which is what lets us watch/read providers.
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch subscribes this widget to statsProvider: whenever the
    // state changes (loading -> data/error, etc.) build() re-runs.
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: statsAsync.when(
        // 1) LOADING — shown while the Future in build()/retry() is pending.
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        // 2) ERROR — shown if the fetch throws. We display the message
        //    and a button that calls the notifier's retry() method.
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  // ref.read (not watch) here: we only need the notifier
                  // once, to call a method on it — we're not rebuilding
                  // based on it.
                  onPressed: () => ref.read(statsProvider.notifier).retry(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),

        // 3) DATA — the happy path. Render the 3 stats in a ListView.
        data: (stats) => ListView.builder(
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return ListTile(
              title: Text(stat.label),
              trailing: Text(stat.value.toString()),
            );
          },
        ),
      ),
    );
  }
}
