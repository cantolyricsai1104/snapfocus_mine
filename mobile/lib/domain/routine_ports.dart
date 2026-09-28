import 'routine.dart';
import 'snapshot.dart';

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

abstract interface class SnapshotRepository {
  Future<void> add(CapturedPhoto photo);

  Future<void> saveNote(ProofDayNote note);

  Future<List<ProofDayNote>> listNotes(String goalId);

  Future<void> deleteNotes(String goalId);

  Future<List<CapturedPhoto>> list();

  Future<void> delete(String id);

  Future<void> clearAll();
}
