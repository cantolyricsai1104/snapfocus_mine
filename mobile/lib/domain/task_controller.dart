import 'package:flutter/foundation.dart';

import 'routine.dart';
import 'routine_controller.dart';
import 'goal.dart';
import 'goal_controller.dart';
import 'task.dart';
import 'task_ports.dart';

class TaskController extends ChangeNotifier {
  TaskController({
    required TaskRepository repository,
    required RoutineController routine,
    required GoalController goals,
  }) : _repository = repository,
       _routine = routine,
       _goals = goals;

  final TaskRepository _repository;
  final RoutineController _routine;
  final GoalController _goals;

  List<TaskBlock> _tasks = const [];
  String? _selectedTaskId;
  String? _activeRoutineId;
  final Map<String, int> _elapsedSecondsByTask = {};
  bool _loading = true;

  List<TaskBlock> get tasks => List.unmodifiable(_tasks);
  bool get loading => _loading;
  TaskBlock? get selectedTask => _find(_selectedTaskId);
  String? get activeTaskId => _selectedTaskId;
  RoutineState? get routineState => _routine.state;

  bool get hasActiveTimer {
    final status = _routine.state?.status;
    return _selectedTaskId != null &&
        (status == RoutineStatus.running || status == RoutineStatus.paused);
  }

  double taskProgress(TaskBlock task) {
    final totalSeconds = task.durationMinutes * 60;
    if (totalSeconds <= 0) return 0;

    var elapsed = _elapsedSecondsByTask[task.id] ?? 0;
    final state = _routine.state;
    if (_selectedTaskId == task.id &&
        state != null &&
        state.id == _activeRoutineId &&
        state.phase == RoutinePhase.focus) {
      elapsed = _elapsedForState(task, state);
    }
    return (elapsed / totalSeconds).clamp(0.0, 1.0).toDouble();
  }

  Future<void> restore() async {
    _loading = true;
    notifyListeners();
    await _goals.restore();
    final stored = await _repository.list();
    final source = stored.where((task) => !_isUntouchedStarterTask(task));
    _tasks = [
      for (final task in source)
        if (task.id.startsWith('goal-task-') && task.scheduledTime == null)
          task.copyWith(scheduledTime: '09:00')
        else
          task,
    ];
    if (stored.isEmpty || !_sameTasks(stored, _tasks)) {
      await _repository.replaceAll(_tasks);
    }
    await _backfillCompletedGoalTasks();
    _loading = false;
    notifyListeners();
  }

  Future<void> _backfillCompletedGoalTasks() async {
    for (final goal in _goals.goals) {
      // Progress already present may include timer sessions recorded by older
      // versions. Only seed legacy completed tasks for untouched goals.
      if (goal.currentValue > 0) continue;

      var minutes = 0.0;
      final start = goal.startedOn;
      final end = goal.endDate == null ? null : _dateString(goal.endDate!);
      for (final task in _tasks.where((item) => item.goalId == goal.id)) {
        final completedDates = task.completedDates.toSet();
        if (task.repeat == TaskRepeat.none &&
            task.completed &&
            completedDates.isEmpty) {
          completedDates.add(task.date);
        }
        for (final date in completedDates) {
          if ((start == null || date.compareTo(start) >= 0) &&
              (end == null || date.compareTo(end) <= 0) &&
              task.isScheduledOn(date)) {
            minutes += task.durationMinutes;
          }
        }
      }
      if (minutes > 0) await _goals.addProgress(goal.id, minutes);
    }
  }

  Future<void> add(TaskBlock task) async {
    _tasks = [..._tasks, task];
    await _save();
  }

  Future<void> update(TaskBlock task) async {
    _tasks = [
      for (final item in _tasks)
        if (item.id == task.id) task else item,
    ];
    await _save();
  }

  Future<void> delete(String id) async {
    _tasks = _tasks.where((task) => task.id != id).toList(growable: false);
    if (_selectedTaskId == id) _selectedTaskId = null;
    await _save();
  }

  Future<void> syncGoalTask(Goal goal, {required String color}) async {
    final id = 'goal-task-${goal.id}';
    final previous = _find(id);
    if (goal.taskTitle == null) {
      if (previous != null) {
        _tasks = _tasks.where((task) => task.id != id).toList();
        await _save();
      }
      return;
    }
    final task = TaskBlock(
      id: id,
      title: goal.taskTitle!,
      durationMinutes: goal.taskDurationMinutes,
      type: TaskType.focus,
      color: color,
      scheduledTime: goal.taskTime ?? '09:00',
      date: goal.startedOn ?? previous?.date ?? _dateString(DateTime.now()),
      repeat: goal.taskRepeat,
      repeatUntil: goal.endDate == null ? null : _dateString(goal.endDate!),
      completed: previous?.completed ?? false,
      completedDates: previous?.completedDates ?? const [],
      goalId: goal.id,
      repeatDays: goal.taskRepeat == TaskRepeat.weekly
          ? ([...goal.taskWeekdays]..sort())
          : const [],
      repeatMonthDay: goal.taskRepeat == TaskRepeat.monthly
          ? goal.taskMonthDay
          : null,
    );
    if (previous == null) {
      _tasks = [..._tasks, task];
    } else {
      _tasks = [
        for (final item in _tasks)
          if (item.id == id) task else item,
      ];
    }
    await _save();
  }

  Future<void> removeGoalTask(String goalId) async {
    final id = 'goal-task-$goalId';
    if (!_tasks.any((task) => task.id == id)) return;
    _tasks = _tasks.where((task) => task.id != id).toList();
    await _save();
  }

  Future<void> reorder(int from, int to) async {
    if (from == to ||
        from < 0 ||
        to < 0 ||
        from >= _tasks.length ||
        to >= _tasks.length) {
      return;
    }
    final next = [..._tasks];
    final item = next.removeAt(from);
    next.insert(to, item);
    _tasks = next;
    await _save();
  }

  Future<Goal?> toggleCompleted(String id, String date) async {
    final task = _find(id);
    if (task == null) return null;
    final completed = task.isCompletedOn(date);
    Goal? achievedGoal;
    if (!completed && task.goalId != null) {
      final goal = _goals.findGoal(task.goalId);
      if (goal != null) {
        final seconds = task.id == _selectedTaskId
            ? taskProgress(task) * task.durationMinutes * 60
            : (_elapsedSecondsByTask[task.id] ?? 0).toDouble();
        achievedGoal = await _recordGoalProgress(
          task,
          timeMinutes: seconds / 60,
        );
      }
    }
    final dates = [...task.completedDates]..remove(date);
    if (!completed) dates.add(date);
    await update(task.copyWith(completed: !completed, completedDates: dates));
    return achievedGoal;
  }

  Future<void> schedule(String id, String time, {String? date}) async {
    final task = _find(id);
    if (task == null) return;
    await update(task.copyWith(scheduledTime: time, date: date ?? task.date));
  }

  Future<void> startTask(TaskBlock task) async {
    await saveActiveTaskProgress();
    if (_routine.state != null) await _routine.stop();

    _selectedTaskId = task.id;
    final totalSeconds = task.durationMinutes * 60;
    final elapsed = _elapsedSecondsByTask[task.id] ?? 0;
    final remainingSeconds = (totalSeconds - elapsed).clamp(1, totalSeconds);
    final state = await _routine.start(
      focusDuration: Duration(seconds: remainingSeconds),
      breakDuration: const Duration(minutes: 5),
    );
    _activeRoutineId = state.id;
    notifyListeners();
  }

  Future<void> saveActiveTaskProgress() async {
    final state = _routine.state;
    final task = selectedTask;
    if (_activeRoutineId == null ||
        state == null ||
        task == null ||
        state.id != _activeRoutineId) {
      return;
    }

    if (state.phase == RoutinePhase.breakTime) {
      _elapsedSecondsByTask[task.id] = task.durationMinutes * 60;
      return;
    }

    final totalSeconds = task.durationMinutes * 60;
    final elapsed = _elapsedForState(task, state);
    _elapsedSecondsByTask[task.id] = elapsed.clamp(0, totalSeconds);
  }

  int _elapsedForState(TaskBlock task, RoutineState state) {
    final totalSeconds = task.durationMinutes * 60;
    final savedSeconds = _elapsedSecondsByTask[task.id] ?? 0;
    final remainingSeconds = totalSeconds - savedSeconds;
    final phaseElapsed = state.status == RoutineStatus.paused
        ? remainingSeconds -
              (state.pausedRemaining?.inSeconds ?? remainingSeconds)
        : (state.progress * remainingSeconds).round();
    return (savedSeconds + phaseElapsed).clamp(0, totalSeconds);
  }

  Future<Goal?> completeActiveTaskIfNeeded(String date) async {
    final state = _routine.state;
    if (_activeRoutineId == null ||
        state == null ||
        state.id != _activeRoutineId ||
        state.phase != RoutinePhase.breakTime) {
      return null;
    }

    final task = selectedTask;
    if (task == null || task.isCompletedOn(date)) return null;

    final achievedGoal = await _recordGoalProgress(
      task,
      timeMinutes: task.durationMinutes.toDouble(),
    );

    final dates = [...task.completedDates, date];
    await update(
      task.copyWith(
        completed: task.repeat == TaskRepeat.none ? true : task.completed,
        completedDates: dates,
      ),
    );
    return achievedGoal;
  }

  Future<Goal?> completeActiveTaskWithoutPhoto() async {
    final task = selectedTask;
    if (_activeRoutineId == null || task == null) return null;

    await saveActiveTaskProgress();
    final date = _dateString(DateTime.now());
    if (task.isCompletedOn(date)) return null;

    final elapsed = _elapsedSecondsByTask[task.id] ?? 0;
    final achievedGoal = await _recordGoalProgress(
      task,
      timeMinutes: elapsed / 60,
    );
    final dates = [...task.completedDates, date];
    await update(
      task.copyWith(
        completed: task.repeat == TaskRepeat.none ? true : task.completed,
        completedDates: dates,
      ),
    );
    return achievedGoal;
  }

  Future<Goal?> _recordGoalProgress(
    TaskBlock task, {
    required double timeMinutes,
  }) async {
    final goal = _goals.findGoal(task.goalId);
    if (goal == null) return null;
    final contribution = timeMinutes > 0
        ? timeMinutes
        : task.durationMinutes.toDouble();
    if (contribution <= 0) return null;
    return await _goals.addProgress(goal.id, contribution) ? goal : null;
  }

  TaskBlock? _find(String? id) {
    if (id == null) return null;
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  Future<void> _save() async {
    await _repository.replaceAll(_tasks);
    notifyListeners();
  }
}

bool _sameTasks(List<TaskBlock> left, List<TaskBlock> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}

bool _isUntouchedStarterTask(TaskBlock task) {
  final expected = switch (task.id) {
    'task-1' => (
      'Scroll Phone & Twitter',
      15,
      TaskType.breakTime,
      '#8B5CF6',
      '09:00',
    ),
    'task-2' => (
      'Learn Python Backend',
      45,
      TaskType.focus,
      '#FF6B00',
      '09:30',
    ),
    'task-3' => (
      'Coffee & Stretch Break',
      15,
      TaskType.breakTime,
      '#3B82F6',
      '10:30',
    ),
    'task-4' => (
      'Code SnapFocus Architecture',
      60,
      TaskType.focus,
      '#CCFF00',
      '11:00',
    ),
    'task-5' => (
      'Lunch & Fresh Air Walk',
      30,
      TaskType.breakTime,
      '#10B981',
      '12:30',
    ),
    _ => null,
  };
  if (expected == null) return false;
  return task.title == expected.$1 &&
      task.durationMinutes == expected.$2 &&
      task.type == expected.$3 &&
      task.color == expected.$4 &&
      task.scheduledTime == expected.$5 &&
      task.repeat == TaskRepeat.none &&
      task.repeatUntil == null &&
      !task.completed &&
      task.completedDates.isEmpty &&
      task.goalId == null &&
      task.repeatDays.isEmpty &&
      task.repeatMonthDay == null;
}

String _dateString(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
