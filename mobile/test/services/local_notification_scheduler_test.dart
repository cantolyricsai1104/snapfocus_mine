import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/routine.dart';
import 'package:mobile/services/local_notification_scheduler.dart';

void main() {
  test('schedules a focus completion notification at the phase end', () async {
    final platform = RecordingNotificationPlatform();
    final scheduler = LocalNotificationScheduler(platform);
    final state = _state(RoutinePhase.focus);

    await scheduler.schedulePhaseEnd(state);

    expect(platform.scheduled, hasLength(1));
    expect(platform.scheduled.single.title, 'Focus complete');
    expect(
      platform.scheduled.single.body,
      'Take a break and reset your space.',
    );
    expect(platform.scheduled.single.scheduledAt, state.endsAt);
  });

  test('uses a different message for break completion', () async {
    final platform = RecordingNotificationPlatform();
    final scheduler = LocalNotificationScheduler(platform);

    await scheduler.schedulePhaseEnd(_state(RoutinePhase.breakTime));

    expect(platform.scheduled.single.title, 'Break complete');
    expect(
      platform.scheduled.single.body,
      'Capture your workspace to unlock Focus.',
    );
  });

  test('cancels the same phase notification when requested', () async {
    final platform = RecordingNotificationPlatform();
    final scheduler = LocalNotificationScheduler(platform);
    final state = _state(RoutinePhase.focus);

    await scheduler.schedulePhaseEnd(state);
    await scheduler.cancelPhaseEnd(state);

    expect(platform.cancelled, [platform.scheduled.single.id]);
  });
}

RoutineState _state(RoutinePhase phase) {
  return RoutineState(
    id: 'routine-notification',
    phase: phase,
    status: RoutineStatus.running,
    focusDuration: const Duration(minutes: 25),
    breakDuration: const Duration(minutes: 5),
    startedAt: DateTime(2026, 9, 16, 9),
    endsAt: phase == RoutinePhase.focus
        ? DateTime(2026, 9, 16, 9, 25)
        : DateTime(2026, 9, 16, 9, 30),
    pausedRemaining: null,
    progress: 0,
  );
}

class RecordingNotificationPlatform implements NotificationPlatform {
  final scheduled = <NotificationRequest>[];
  final cancelled = <int>[];

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }

  @override
  Future<void> schedule(NotificationRequest request) async {
    scheduled.add(request);
  }
}
