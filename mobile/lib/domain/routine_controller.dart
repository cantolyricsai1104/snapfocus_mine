import 'routine.dart';
import 'routine_ports.dart';
import 'snapshot.dart';

class RoutineController {
  RoutineController({
    required RoutineClock clock,
    required RoutineRepository repository,
    required NotificationScheduler notifications,
    SnapshotRepository? snapshots,
  }) : _clock = clock,
       _repository = repository,
       _notifications = notifications,
       _snapshots = snapshots;

  final RoutineClock _clock;
  final RoutineRepository _repository;
  final NotificationScheduler _notifications;
  final SnapshotRepository? _snapshots;

  RoutineState? _state;

  RoutineState? get state => _state;

  Future<RoutineState> start({
    required Duration focusDuration,
    required Duration breakDuration,
  }) async {
    final previous = _state;
    if (previous != null) {
      await _notifications.cancelPhaseEnd(previous);
    }

    final now = _clock.now();
    final state = RoutineState(
      id: 'routine-${now.microsecondsSinceEpoch}',
      phase: RoutinePhase.focus,
      status: RoutineStatus.running,
      focusDuration: focusDuration,
      breakDuration: breakDuration,
      startedAt: now,
      endsAt: now.add(focusDuration),
      pausedRemaining: null,
      progress: 0,
    );

    _state = state;
    await _repository.saveActive(state);
    await _notifications.schedulePhaseEnd(state);
    return state;
  }

  Future<RoutineState> pause() async {
    final current = _requireState();
    if (current.status != RoutineStatus.running || current.endsAt == null) {
      throw StateError('Only a running routine can be paused.');
    }

    final remaining = current.endsAt!.difference(_clock.now());
    final paused = current.copyWith(
      status: RoutineStatus.paused,
      endsAt: null,
      pausedRemaining: remaining.isNegative ? Duration.zero : remaining,
      progress: _progressAt(current, _clock.now()),
    );

    await _notifications.cancelPhaseEnd(current);
    _state = paused;
    await _repository.saveActive(paused);
    return paused;
  }

  Future<RoutineState> resume() async {
    final current = _requireState();
    if (current.status != RoutineStatus.paused ||
        current.pausedRemaining == null) {
      throw StateError('Only a paused routine can be resumed.');
    }

    final now = _clock.now();
    final resumed = current.copyWith(
      status: RoutineStatus.running,
      startedAt: now,
      endsAt: now.add(current.pausedRemaining!),
      pausedRemaining: null,
    );

    _state = resumed;
    await _repository.saveActive(resumed);
    await _notifications.schedulePhaseEnd(resumed);
    return resumed;
  }

  Future<void> stop() async {
    final current = _state;
    if (current != null) {
      await _notifications.cancelPhaseEnd(current);
    }
    _state = null;
    await _repository.saveActive(null);
  }

  Future<RoutineState?> restore() async {
    final restored = await _repository.loadActive();
    if (restored == null) {
      _state = null;
      return null;
    }

    if (restored.status == RoutineStatus.running &&
        restored.startedAt != null &&
        restored.endsAt != null) {
      final progress = _progressAt(restored, _clock.now());
      _state = restored.copyWith(progress: progress);
      if (progress != restored.progress) {
        await _repository.saveActive(_state);
      }
    } else {
      _state = restored;
    }
    return _state;
  }

  Future<RoutineState> refresh() async {
    final current = _requireState();
    if (current.status != RoutineStatus.running || current.endsAt == null) {
      return current;
    }

    final now = _clock.now();
    if (now.isBefore(current.endsAt!)) {
      final refreshed = current.copyWith(progress: _progressAt(current, now));
      _state = refreshed;
      if (refreshed != current) {
        await _repository.saveActive(refreshed);
      }
      return refreshed;
    }

    final phaseEndedAt = current.endsAt!;
    if (current.phase == RoutinePhase.focus) {
      final breakState = RoutineState(
        id: current.id,
        phase: RoutinePhase.breakTime,
        status: RoutineStatus.running,
        focusDuration: current.focusDuration,
        breakDuration: current.breakDuration,
        startedAt: phaseEndedAt,
        endsAt: phaseEndedAt.add(current.breakDuration),
        pausedRemaining: null,
        progress: 0,
      );
      _state = breakState;
      await _repository.saveActive(breakState);
      await _notifications.schedulePhaseEnd(breakState);
      return breakState;
    }

    final locked = current.copyWith(
      status: RoutineStatus.locked,
      endsAt: null,
      pausedRemaining: null,
      progress: 1,
    );
    _state = locked;
    await _repository.saveActive(locked);
    return locked;
  }

  Future<RoutineState> unlockWithPhoto(CapturedPhoto photo) async {
    final current = _requireState();
    if (current.status != RoutineStatus.locked ||
        current.phase != RoutinePhase.breakTime) {
      throw StateError('Only a locked break can be unlocked with a photo.');
    }

    final snapshots = _snapshots;
    if (snapshots == null) {
      throw StateError(
        'A snapshot repository is required to unlock a photo gate.',
      );
    }
    await snapshots.add(photo);

    final now = _clock.now();
    final nextFocus = RoutineState(
      id: current.id,
      phase: RoutinePhase.focus,
      status: RoutineStatus.running,
      focusDuration: current.focusDuration,
      breakDuration: current.breakDuration,
      startedAt: now,
      endsAt: now.add(current.focusDuration),
      pausedRemaining: null,
      progress: 0,
    );
    _state = nextFocus;
    await _repository.saveActive(nextFocus);
    await _notifications.schedulePhaseEnd(nextFocus);
    return nextFocus;
  }

  RoutineState _requireState() {
    final current = _state;
    if (current == null) {
      throw StateError('No active routine.');
    }
    return current;
  }

  double _progressAt(RoutineState state, DateTime now) {
    if (state.startedAt == null) return state.progress;
    final duration = state.phase == RoutinePhase.focus
        ? state.focusDuration
        : state.breakDuration;
    if (duration.inMilliseconds <= 0) return 1;
    final elapsed = now.difference(state.startedAt!).inMilliseconds;
    final progress = elapsed / duration.inMilliseconds;
    return progress.clamp(0, 1).toDouble();
  }
}
