import 'routine.dart';

abstract interface class RoutineClock {
  DateTime now();
}

abstract interface class RoutineRepository {
  Future<RoutineState?> loadActive();

  Future<void> saveActive(RoutineState? state);
}

abstract interface class NotificationScheduler {
  Future<void> schedulePhaseEnd(RoutineState state);

  Future<void> cancelPhaseEnd(RoutineState state);
}
