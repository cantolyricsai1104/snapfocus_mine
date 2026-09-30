import 'package:flutter/foundation.dart';

import 'goal.dart';
import 'goal_ports.dart';

class GoalController extends ChangeNotifier {
  GoalController({required GoalRepository repository})
    : _repository = repository;

  final GoalRepository _repository;
  List<Pillar> _pillars = const [];
  List<Goal> _goals = const [];
  bool _loading = true;
  Future<void>? _restoreFuture;

  List<Pillar> get pillars => List.unmodifiable(_pillars);
  List<Goal> get goals => List.unmodifiable(_goals);
  bool get loading => _loading;
  List<Goal> get activeGoals => _goals.where((goal) => !goal.expired).toList();

  Pillar? pillarFor(Goal goal) {
    for (final pillar in _pillars) {
      if (pillar.id == goal.pillarId) return pillar;
    }
    return null;
  }

  Goal? findGoal(String? id) {
    if (id == null) return null;
    for (final goal in _goals) {
      if (goal.id == id) return goal;
    }
    return null;
  }

  Future<void> restore() => _restoreFuture ??= _restore();

  Future<void> reloadForAccount() {
    _restoreFuture = null;
    _loading = true;
    notifyListeners();
    return restore();
  }

  Future<void> _restore() async {
    _pillars = await _repository.listPillars();
    final stored = await _repository.listGoals();
    final today = _dateKey(DateTime.now());
    _goals = stored
        .map((goal) {
          final legacyCount = goal.metricType == GoalMetricType.numeric;
          final expectedUnit = goal.metricType == GoalMetricType.days
              ? 'days'
              : 'minutes';
          final needsNormalization =
              legacyCount ||
              goal.startedOn == null ||
              (goal.metricType != GoalMetricType.time &&
                  goal.metricType != GoalMetricType.days) ||
              goal.targetValue != 0 ||
              goal.unit != expectedUnit;
          if (!needsNormalization) return goal;
          return goal.copyWith(
            startedOn: goal.startedOn ?? today,
            currentValue: legacyCount ? 0 : goal.currentValue,
            metricType: legacyCount ? GoalMetricType.time : goal.metricType,
            targetValue: 0,
            unit: expectedUnit,
          );
        })
        .toList(growable: false);
    if (_goals.indexed.any((entry) => entry.$2 != stored[entry.$1])) {
      await _repository.replaceGoals(_goals);
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> savePillar(Pillar pillar) async {
    _pillars = [
      for (final item in _pillars)
        if (item.id != pillar.id) item,
      pillar,
    ];
    await _repository.replacePillars(_pillars);
    notifyListeners();
  }

  Future<void> deletePillar(String id) async {
    _pillars = _pillars.where((item) => item.id != id).toList();
    _goals = _goals.where((item) => item.pillarId != id).toList();
    await _repository.replacePillars(_pillars);
    await _repository.replaceGoals(_goals);
    notifyListeners();
  }

  Future<void> saveGoal(Goal goal) async {
    final normalized = goal;
    _goals = [
      for (final item in _goals)
        if (item.id != normalized.id) item,
      normalized,
    ];
    await _repository.replaceGoals(_goals);
    notifyListeners();
  }

  Future<void> deleteGoal(String id) async {
    _goals = _goals.where((goal) => goal.id != id).toList();
    await _repository.replaceGoals(_goals);
    notifyListeners();
  }

  Future<bool> addProgress(String id, double amount) async {
    final existing = findGoal(id);
    if (existing == null || amount <= 0) return false;
    final wasAchieved = existing.achieved;
    final updated = existing.copyWith(
      currentValue: existing.currentValue + amount,
    );
    await saveGoal(updated);
    return !wasAchieved && updated.achieved;
  }
}

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
