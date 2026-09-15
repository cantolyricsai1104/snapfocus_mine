import 'package:flutter/material.dart';

import 'app.dart';
import 'data/app_database.dart';
import 'data/routine_repository.dart';
import 'data/snapshot_repository.dart';
import 'domain/routine_controller.dart';
import 'domain/routine_ports.dart';
import 'services/local_notification_scheduler.dart';

class SystemRoutineClock implements RoutineClock {
  @override
  DateTime now() => DateTime.now();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final notificationPlatform = FlutterNotificationPlatform();
  await notificationPlatform.initialize();
  await notificationPlatform.requestPermissions();

  final routineRepository = DriftRoutineRepository(database);
  final snapshotRepository = DriftSnapshotRepository(database);
  final controller = RoutineController(
    clock: SystemRoutineClock(),
    repository: routineRepository,
    notifications: LocalNotificationScheduler(notificationPlatform),
    snapshots: snapshotRepository,
  );

  runApp(SnapFocusApp(controller: controller, snapshots: snapshotRepository));
}
