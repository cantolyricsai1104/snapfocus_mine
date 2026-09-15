import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/routine.dart';
import 'package:mobile/domain/routine_controller.dart';
import 'package:mobile/domain/routine_ports.dart';
import 'package:mobile/domain/snapshot.dart';
import 'package:mobile/features/routine/routine_screen.dart';

void main() {
  testWidgets('starts a focus from the idle routine screen', (tester) async {
    final clock = TestClock(DateTime(2026, 9, 16, 9));
    final controller = RoutineController(
      clock: clock,
      repository: TestRoutineRepository(),
      notifications: TestNotificationScheduler(),
      snapshots: TestSnapshotRepository(),
    );

    await tester.pumpWidget(
      MaterialApp(home: RoutineScreen(controller: controller)),
    );

    expect(find.text('Start focus'), findsOneWidget);
    expect(find.text('Your focus buddy is ready'), findsOneWidget);

    await tester.tap(find.text('Start focus'));
    await tester.pump();

    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Growing with your focus'), findsOneWidget);
  });
}

class TestClock implements RoutineClock {
  TestClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

class TestRoutineRepository implements RoutineRepository {
  RoutineState? active;

  @override
  Future<RoutineState?> loadActive() async => active;

  @override
  Future<void> saveActive(RoutineState? state) async {
    active = state;
  }
}

class TestNotificationScheduler implements NotificationScheduler {
  @override
  Future<void> cancelPhaseEnd(RoutineState state) async {}

  @override
  Future<void> schedulePhaseEnd(RoutineState state) async {}
}

class TestSnapshotRepository implements SnapshotRepository {
  final photos = <CapturedPhoto>[];

  @override
  Future<void> add(CapturedPhoto photo) async => photos.add(photo);

  @override
  Future<void> clearAll() async => photos.clear();

  @override
  Future<void> delete(String id) async {
    photos.removeWhere((photo) => photo.id == id);
  }

  @override
  Future<List<CapturedPhoto>> list() async => List.unmodifiable(photos);
}
