import 'goal.dart';

abstract interface class GoalRepository {
  Future<List<Pillar>> listPillars();
  Future<List<Goal>> listGoals();
  Future<void> replacePillars(List<Pillar> pillars);
  Future<void> replaceGoals(List<Goal> goals);
}
