import 'package:flutter/foundation.dart';

import 'routine_controller.dart';
import 'task.dart';
import 'task_ports.dart';

class TaskController extends ChangeNotifier {
  TaskController({
    required TaskRepository repository,
    required RoutineController routine,
  }) : _repository = repository,
       _routine = routine;

  final TaskRepository _repository;
  final RoutineController _routine;

  List<TaskBlock> _tasks = const [];
  String? _selectedTaskId;
  bool _loading = true;

  List<TaskBlock> get tasks => List.unmodifiable(_tasks);
  bool get loading => _loading;
  TaskBlock? get selectedTask => _find(_selectedTaskId);

  Future<void> restore() async {
    final stored = await _repository.list();
    _tasks = stored.isEmpty ? defaultTasks(DateTime.now()) : stored;
    if (stored.isEmpty) await _repository.replaceAll(_tasks);
    _loading = false;
    notifyListeners();
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
    if (_tasks.length == 1) return;
    _tasks = _tasks.where((task) => task.id != id).toList(growable: false);
    if (_selectedTaskId == id) _selectedTaskId = null;
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

  Future<void> toggleCompleted(String id, String date) async {
    final task = _find(id);
    if (task == null) return;
    final completed = task.isCompletedOn(date);
    final dates = [...task.completedDates]..remove(date);
    if (!completed) dates.add(date);
    await update(task.copyWith(completed: !completed, completedDates: dates));
  }

  Future<void> schedule(String id, String time, {String? date}) async {
    final task = _find(id);
    if (task == null) return;
    await update(task.copyWith(scheduledTime: time, date: date ?? task.date));
  }

  Future<void> startTask(TaskBlock task) async {
    _selectedTaskId = task.id;
    await _routine.start(
      focusDuration: task.type == TaskType.focus
          ? Duration(minutes: task.durationMinutes)
          : const Duration(minutes: 5),
      breakDuration: task.type == TaskType.breakTime
          ? Duration(minutes: task.durationMinutes)
          : const Duration(minutes: 5),
    );
    notifyListeners();
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

List<TaskBlock> defaultTasks(DateTime now) {
  final date = _dateString(now);
  return [
    TaskBlock(
      id: 'task-1',
      title: 'Scroll Phone & Twitter',
      durationMinutes: 15,
      type: TaskType.breakTime,
      color: '#8B5CF6',
      scheduledTime: '09:00',
      date: date,
      repeat: TaskRepeat.none,
    ),
    TaskBlock(
      id: 'task-2',
      title: 'Learn Python Backend',
      durationMinutes: 45,
      type: TaskType.focus,
      color: '#FF6B00',
      scheduledTime: '09:30',
      date: date,
      repeat: TaskRepeat.none,
    ),
    TaskBlock(
      id: 'task-3',
      title: 'Coffee & Stretch Break',
      durationMinutes: 15,
      type: TaskType.breakTime,
      color: '#3B82F6',
      scheduledTime: '10:30',
      date: date,
      repeat: TaskRepeat.none,
    ),
    TaskBlock(
      id: 'task-4',
      title: 'Code SnapFocus Architecture',
      durationMinutes: 60,
      type: TaskType.focus,
      color: '#CCFF00',
      scheduledTime: '11:00',
      date: date,
      repeat: TaskRepeat.none,
    ),
    TaskBlock(
      id: 'task-5',
      title: 'Lunch & Fresh Air Walk',
      durationMinutes: 30,
      type: TaskType.breakTime,
      color: '#10B981',
      scheduledTime: '12:30',
      date: date,
      repeat: TaskRepeat.none,
    ),
  ];
}

String _dateString(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
