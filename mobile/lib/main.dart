import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'data/app_database.dart';
import 'data/routine_repository.dart';
import 'data/snapshot_repository.dart';
import 'data/task_repository.dart';
import 'data/goal_repository.dart';
import 'data/supabase_repositories.dart';
import 'domain/routine_controller.dart';
import 'domain/routine_ports.dart';
import 'domain/task_controller.dart';
import 'domain/goal_controller.dart';
import 'domain/task_ports.dart';
import 'domain/goal_ports.dart';
import 'services/local_notification_scheduler.dart';

class SystemRoutineClock implements RoutineClock {
  @override
  DateTime now() => DateTime.now();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
  SupabaseClient? authClient;
  if (supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
    authClient = Supabase.instance.client;
  }

  final database = AppDatabase();
  final localTaskRepository = DriftTaskRepository(database);
  final localGoalRepository = DriftGoalRepository(database);
  final localSnapshotRepository = DriftSnapshotRepository(database);
  final sync = authClient == null
      ? null
      : SupabaseSyncBridge(client: authClient, database: database);
  final TaskRepository taskRepository = sync == null
      ? localTaskRepository
      : SupabaseTaskRepository(local: localTaskRepository, sync: sync);
  final GoalRepository goalRepository = sync == null
      ? localGoalRepository
      : SupabaseGoalRepository(local: localGoalRepository, sync: sync);
  final SnapshotRepository snapshotRepository = sync == null
      ? localSnapshotRepository
      : SupabaseSnapshotRepository(local: localSnapshotRepository, sync: sync);
  final notificationPlatform = FlutterNotificationPlatform();
  await notificationPlatform.initialize();
  await notificationPlatform.requestPermissions();

  final routineRepository = DriftRoutineRepository(database);
  final controller = RoutineController(
    clock: SystemRoutineClock(),
    repository: routineRepository,
    notifications: LocalNotificationScheduler(notificationPlatform),
    snapshots: snapshotRepository,
  );
  final goalController = GoalController(repository: goalRepository);
  final taskController = TaskController(
    repository: taskRepository,
    routine: controller,
    goals: goalController,
    onTasksChanged: notificationPlatform.scheduleTaskReminders,
  );

  runApp(
    SnapFocusApp(
      controller: controller,
      snapshots: snapshotRepository,
      tasks: taskController,
      goals: goalController,
      authClient: authClient,
    ),
  );
}
