import 'task.dart';

abstract interface class TaskRepository {
  Future<List<TaskBlock>> list();

  Future<void> replaceAll(List<TaskBlock> tasks);
}
