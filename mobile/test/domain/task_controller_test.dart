import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/goal.dart';
import 'package:mobile/domain/goal_controller.dart';
import 'package:mobile/domain/goal_ports.dart';
import 'package:mobile/domain/routine.dart';
import 'package:mobile/domain/routine_controller.dart';
import 'package:mobile/domain/routine_ports.dart';
import 'package:mobile/domain/task.dart';
import 'package:mobile/domain/task_controller.dart';
import 'package:mobile/domain/task_ports.dart';

void main() {
  test(
    'checking an untimed goal task credits its planned focus minutes',
    () async {
      const date = '2026-09-28';
      final goalRepository = _MemoryGoalRepository([
        const Goal(
          id: 'goal-dance',
          pillarId: 'health',
          name: 'dance',
          metricType: GoalMetricType.time,
          targetValue: 0,
          currentValue: 0,
          unit: 'minutes',
          startedOn: date,
        ),
      ]);
      final goals = GoalController(repository: goalRepository);
      await goals.restore();

      final task = TaskBlock(
        id: 'goal-task-dance',
        title: 'dance',
        durationMinutes: 30,
        type: TaskType.focus,
        color: '#E97965',
        scheduledTime: '08:15',
        date: date,
        repeat: TaskRepeat.daily,
        goalId: 'goal-dance',
      );
      final taskRepository = _MemoryTaskRepository([task]);
      final controller = TaskController(
        repository: taskRepository,
        routine: RoutineController(
          clock: _FakeClock(DateTime(2026, 9, 28, 8)),
          repository: _MemoryRoutineRepository(),
          notifications: _NoopNotifications(),
        ),
        goals: goals,
      );
      await controller.restore();

      await controller.toggleCompleted(task.id, date);

      expect(goals.findGoal('goal-dance')?.currentValue, 30);
      expect(controller.tasks.single.isCompletedOn(date), isTrue);
    },
  );

  test(
    'backfills completed goal tasks once when restoring an empty goal',
    () async {
      const date = '2026-09-28';
      final goals = GoalController(
        repository: _MemoryGoalRepository([
          const Goal(
            id: 'goal-dance',
            pillarId: 'health',
            name: 'dance',
            metricType: GoalMetricType.time,
            targetValue: 0,
            currentValue: 0,
            unit: 'minutes',
            startedOn: date,
          ),
        ]),
      );
      final task = TaskBlock(
        id: 'goal-task-dance',
        title: 'dance',
        durationMinutes: 30,
        type: TaskType.focus,
        color: '#E97965',
        scheduledTime: '08:15',
        date: date,
        repeat: TaskRepeat.daily,
        completedDates: const [date],
        goalId: 'goal-dance',
      );
      final controller = TaskController(
        repository: _MemoryTaskRepository([task]),
        routine: RoutineController(
          clock: _FakeClock(DateTime(2026, 9, 28, 8)),
          repository: _MemoryRoutineRepository(),
          notifications: _NoopNotifications(),
        ),
        goals: goals,
      );

      await controller.restore();
      await controller.restore();

      expect(goals.findGoal('goal-dance')?.currentValue, 30);
    },
  );
}

class _MemoryTaskRepository implements TaskRepository {
  _MemoryTaskRepository(this.tasks);

  List<TaskBlock> tasks;

  @override
  Future<List<TaskBlock>> list() async => tasks;

  @override
  Future<void> replaceAll(List<TaskBlock> tasks) async {
    this.tasks = List.of(tasks);
  }
}

class _MemoryGoalRepository implements GoalRepository {
  _MemoryGoalRepository(this.goals);

  List<Goal> goals;

  @override
  Future<List<Pillar>> listPillars() async => const [];

  @override
  Future<List<Goal>> listGoals() async => goals;

  @override
  Future<void> replacePillars(List<Pillar> pillars) async {}

  @override
  Future<void> replaceGoals(List<Goal> goals) async {
    this.goals = List.of(goals);
  }
}

class _FakeClock implements RoutineClock {
  _FakeClock(this.value);

  final DateTime value;

  @override
  DateTime now() => value;
}

class _MemoryRoutineRepository implements RoutineRepository {
  @override
  Future<RoutineState?> loadActive() async => null;

  @override
  Future<void> saveActive(RoutineState? state) async {}
}

class _NoopNotifications implements NotificationScheduler {
  @override
  Future<void> cancelPhaseEnd(RoutineState state) async {}

  @override
  Future<void> schedulePhaseEnd(RoutineState state) async {}
}
