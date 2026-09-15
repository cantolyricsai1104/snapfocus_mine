import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/routine.dart';
import 'package:mobile/domain/routine_controller.dart';
import 'package:mobile/domain/routine_ports.dart';

void main() {
  group('RoutineController', () {
    test('starts a focus and schedules one phase-end notification', () async {
      final clock = FakeClock(DateTime(2026, 9, 16, 9));
      final repository = MemoryRoutineRepository();
      final notifications = RecordingNotificationScheduler();
      final controller = RoutineController(
        clock: clock,
        repository: repository,
        notifications: notifications,
      );

      final state = await controller.start(
        focusDuration: const Duration(minutes: 25),
        breakDuration: const Duration(minutes: 5),
      );

      expect(state.phase, RoutinePhase.focus);
      expect(state.status, RoutineStatus.running);
      expect(state.startedAt, clock.current);
      expect(state.endsAt, DateTime(2026, 9, 16, 9, 25));
      expect(state.progress, 0);
      expect(repository.active, state);
      expect(notifications.scheduled, [state]);
    });

    test('pauses a focus and cancels its pending notification', () async {
      final clock = FakeClock(DateTime(2026, 9, 16, 9));
      final repository = MemoryRoutineRepository();
      final notifications = RecordingNotificationScheduler();
      final controller = RoutineController(
        clock: clock,
        repository: repository,
        notifications: notifications,
      );
      final running = await controller.start(
        focusDuration: const Duration(minutes: 25),
        breakDuration: const Duration(minutes: 5),
      );

      clock.current = DateTime(2026, 9, 16, 9, 10);
      final paused = await controller.pause();

      expect(paused.status, RoutineStatus.paused);
      expect(paused.endsAt, isNull);
      expect(paused.pausedRemaining, const Duration(minutes: 15));
      expect(notifications.cancelled, [running]);
      expect(repository.active, paused);
    });

    test('resumes a paused focus from its saved remaining duration', () async {
      final clock = FakeClock(DateTime(2026, 9, 16, 9));
      final repository = MemoryRoutineRepository();
      final notifications = RecordingNotificationScheduler();
      final controller = RoutineController(
        clock: clock,
        repository: repository,
        notifications: notifications,
      );
      await controller.start(
        focusDuration: const Duration(minutes: 25),
        breakDuration: const Duration(minutes: 5),
      );
      clock.current = DateTime(2026, 9, 16, 9, 10);
      await controller.pause();
      clock.current = DateTime(2026, 9, 16, 9, 12);

      final resumed = await controller.resume();

      expect(resumed.status, RoutineStatus.running);
      expect(resumed.startedAt, clock.current);
      expect(resumed.endsAt, DateTime(2026, 9, 16, 9, 27));
      expect(resumed.pausedRemaining, isNull);
      expect(notifications.scheduled, hasLength(2));
    });

    test('stops a routine and clears its pending notification', () async {
      final clock = FakeClock(DateTime(2026, 9, 16, 9));
      final repository = MemoryRoutineRepository();
      final notifications = RecordingNotificationScheduler();
      final controller = RoutineController(
        clock: clock,
        repository: repository,
        notifications: notifications,
      );
      final running = await controller.start(
        focusDuration: const Duration(minutes: 25),
        breakDuration: const Duration(minutes: 5),
      );

      await controller.stop();

      expect(controller.state, isNull);
      expect(repository.active, isNull);
      expect(notifications.cancelled, [running]);
    });

    test(
      'restores a running routine without duplicating its notification',
      () async {
        final clock = FakeClock(DateTime(2026, 9, 16, 9, 10));
        final repository = MemoryRoutineRepository();
        final notifications = RecordingNotificationScheduler();
        final saved = RoutineState(
          id: 'routine-saved',
          phase: RoutinePhase.focus,
          status: RoutineStatus.running,
          focusDuration: const Duration(minutes: 25),
          breakDuration: const Duration(minutes: 5),
          startedAt: DateTime(2026, 9, 16, 9),
          endsAt: DateTime(2026, 9, 16, 9, 25),
          pausedRemaining: null,
          progress: 0.4,
        );
        repository.active = saved;
        final controller = RoutineController(
          clock: clock,
          repository: repository,
          notifications: notifications,
        );

        final restored = await controller.restore();

        expect(restored, saved);
        expect(controller.state, saved);
        expect(notifications.scheduled, isEmpty);
      },
    );

    test(
      'moves from focus to break when the focus end time is reached',
      () async {
        final clock = FakeClock(DateTime(2026, 9, 16, 9));
        final repository = MemoryRoutineRepository();
        final notifications = RecordingNotificationScheduler();
        final controller = RoutineController(
          clock: clock,
          repository: repository,
          notifications: notifications,
        );
        await controller.start(
          focusDuration: const Duration(minutes: 25),
          breakDuration: const Duration(minutes: 5),
        );
        clock.current = DateTime(2026, 9, 16, 9, 25);

        final breakState = await controller.refresh();

        expect(breakState.phase, RoutinePhase.breakTime);
        expect(breakState.status, RoutineStatus.running);
        expect(breakState.startedAt, clock.current);
        expect(breakState.endsAt, DateTime(2026, 9, 16, 9, 30));
        expect(breakState.progress, 0);
        expect(notifications.scheduled, hasLength(2));
      },
    );

    test('locks the transition when the break end time is reached', () async {
      final clock = FakeClock(DateTime(2026, 9, 16, 9));
      final repository = MemoryRoutineRepository();
      final notifications = RecordingNotificationScheduler();
      final controller = RoutineController(
        clock: clock,
        repository: repository,
        notifications: notifications,
      );
      await controller.start(
        focusDuration: const Duration(minutes: 25),
        breakDuration: const Duration(minutes: 5),
      );
      clock.current = DateTime(2026, 9, 16, 9, 25);
      await controller.refresh();
      clock.current = DateTime(2026, 9, 16, 9, 30);

      final locked = await controller.refresh();

      expect(locked.phase, RoutinePhase.breakTime);
      expect(locked.status, RoutineStatus.locked);
      expect(locked.endsAt, isNull);
      expect(locked.progress, 1);
    });

    test('unlocks the next focus after a successful photo gate', () async {
      final clock = FakeClock(DateTime(2026, 9, 16, 9));
      final repository = MemoryRoutineRepository();
      final notifications = RecordingNotificationScheduler();
      final controller = RoutineController(
        clock: clock,
        repository: repository,
        notifications: notifications,
      );
      await controller.start(
        focusDuration: const Duration(minutes: 25),
        breakDuration: const Duration(minutes: 5),
      );
      clock.current = DateTime(2026, 9, 16, 9, 25);
      await controller.refresh();
      clock.current = DateTime(2026, 9, 16, 9, 30);
      await controller.refresh();

      final nextFocus = await controller.unlockWithPhoto();

      expect(nextFocus.phase, RoutinePhase.focus);
      expect(nextFocus.status, RoutineStatus.running);
      expect(nextFocus.startedAt, clock.current);
      expect(nextFocus.endsAt, DateTime(2026, 9, 16, 9, 55));
      expect(nextFocus.progress, 0);
      expect(notifications.scheduled, hasLength(3));
    });
  });
}

class FakeClock implements RoutineClock {
  FakeClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

class MemoryRoutineRepository implements RoutineRepository {
  RoutineState? active;

  @override
  Future<RoutineState?> loadActive() async => active;

  @override
  Future<void> saveActive(RoutineState? state) async {
    active = state;
  }
}

class RecordingNotificationScheduler implements NotificationScheduler {
  final scheduled = <RoutineState>[];
  final cancelled = <RoutineState>[];

  @override
  Future<void> cancelPhaseEnd(RoutineState state) async {
    cancelled.add(state);
  }

  @override
  Future<void> schedulePhaseEnd(RoutineState state) async {
    scheduled.add(state);
  }
}
