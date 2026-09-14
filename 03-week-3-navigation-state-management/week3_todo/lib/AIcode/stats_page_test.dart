import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../test/stats_page.dart';

/// A fake repository we control completely: no real delay, no real
/// randomness. `shouldFail` decides deterministically whether
/// fetchStats() succeeds or throws.
class FakeStatsRepository extends StatsRepository {
  FakeStatsRepository({required this.shouldFail});

  final bool shouldFail;

  @override
  Future<List<Stat>> fetchStats() async {
    if (shouldFail) {
      throw Exception('Simulated failure');
    }
    return const [
      Stat(label: 'A', value: 1),
      Stat(label: 'B', value: 2),
      Stat(label: 'C', value: 3),
    ];
  }
}

void main() {
  group('StatsNotifier', () {
    test('resolves to AsyncData with 3 stats when the fetch succeeds', () async {
      // ProviderContainer lets us read/watch providers outside a widget
      // tree, which is all a "unit" test of a notifier needs.
      final container = ProviderContainer(
        overrides: [
          // Swap in the fake repository so the real network/delay/
          // randomness never runs during this test.
          statsRepositoryProvider.overrideWithValue(
            FakeStatsRepository(shouldFail: false),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Reading the provider triggers build(), which awaits the fake's
      // fetchStats(). container.read returns the *current* AsyncValue
      // synchronously (AsyncLoading at this point), so we wait for the
      // Future to settle before asserting.
      final future = container.read(statsProvider.notifier).future;
      final stats = await future;

      expect(stats.length, 3);
      expect(stats[0].label, 'A');

      final state = container.read(statsProvider);
      expect(state, isA<AsyncData<List<Stat>>>());
      expect(state.value, stats);
    });

    test('resolves to AsyncError when the fetch throws', () async {
      final container = ProviderContainer(
        overrides: [
          statsRepositoryProvider.overrideWithValue(
            FakeStatsRepository(shouldFail: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Trigger build() and let it fail; AsyncNotifier catches the
      // exception itself and stores it as AsyncError, so we don't
      // need to wrap this in try/catch here.
      await container.read(statsProvider.notifier).future.catchError((_) {});

      final state = container.read(statsProvider);
      expect(state, isA<AsyncError>());
      expect(state.error.toString(), contains('Simulated failure'));
    });

    test('retry() re-fetches and can recover from an error', () async {
      // Start with a repository that fails...
      final failingRepo = FakeStatsRepository(shouldFail: true);
      final container = ProviderContainer(
        overrides: [
          statsRepositoryProvider.overrideWithValue(failingRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(statsProvider.notifier).future.catchError((_) {});
      expect(container.read(statsProvider), isA<AsyncError>());

      // ...then swap the override to a succeeding repository and call
      // retry() manually to simulate the user tapping the Retry button.
      container.updateOverrides([
        statsRepositoryProvider.overrideWithValue(
          FakeStatsRepository(shouldFail: false),
        ),
      ]);

      final notifier = container.read(statsProvider.notifier);
      await notifier.retry();

      final state = container.read(statsProvider);
      expect(state, isA<AsyncData<List<Stat>>>());
      expect(state.value!.length, 3);
    });
  });
}
