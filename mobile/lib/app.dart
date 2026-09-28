import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/routine_controller.dart';
import 'domain/routine_ports.dart';
import 'domain/task_controller.dart';
import 'domain/goal_controller.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/routine/routine_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/goals/goals_screen.dart';

final routineControllerProvider = Provider<RoutineController>((ref) {
  throw UnimplementedError('The app must provide a RoutineController.');
});

final snapshotRepositoryProvider = Provider<SnapshotRepository>((ref) {
  throw UnimplementedError('The app must provide a SnapshotRepository.');
});

final taskControllerProvider = Provider<TaskController>((ref) {
  throw UnimplementedError('The app must provide a TaskController.');
});

final goalControllerProvider = Provider<GoalController>((ref) {
  throw UnimplementedError('The app must provide a GoalController.');
});

class SnapFocusApp extends StatelessWidget {
  const SnapFocusApp({
    super.key,
    required this.controller,
    required this.snapshots,
    required this.tasks,
    required this.goals,
  });

  final RoutineController controller;
  final SnapshotRepository snapshots;
  final TaskController tasks;
  final GoalController goals;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        routineControllerProvider.overrideWithValue(controller),
        snapshotRepositoryProvider.overrideWithValue(snapshots),
        taskControllerProvider.overrideWithValue(tasks),
        goalControllerProvider.overrideWithValue(goals),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends ConsumerWidget {
  const _AppView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'SnapFocus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE97965),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF9F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF9F2),
          foregroundColor: Color(0xFF29313D),
          elevation: 0,
        ),
      ),
      home: const _MobileShell(),
    );
  }
}

class _MobileShell extends ConsumerStatefulWidget {
  const _MobileShell();

  @override
  ConsumerState<_MobileShell> createState() => _MobileShellState();
}

class _MobileShellState extends ConsumerState<_MobileShell> {
  int _tab = 1;
  late final ValueNotifier<DateTime> _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier(DateTime.now());
  }

  @override
  void dispose() {
    _selectedDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskControllerProvider);
    final routine = ref.watch(routineControllerProvider);
    final snapshots = ref.watch(snapshotRepositoryProvider);

    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          GoalsScreen(
            controller: ref.watch(goalControllerProvider),
            tasks: tasks,
            snapshots: snapshots,
          ),
          TasksScreen(
            controller: tasks,
            goals: ref.watch(goalControllerProvider),
            selectedDate: _selectedDate,
            snapshots: snapshots,
            onStartTask: (task) async {
              await tasks.startTask(task);
              if (mounted) setState(() => _tab = 2);
            },
          ),
          RoutineScreen(
            controller: routine,
            snapshots: snapshots,
            taskTitle: tasks.selectedTask?.title,
            goalId: tasks.selectedTask?.goalId,
            taskDurationMinutes: tasks.selectedTask?.durationMinutes,
            onStop: tasks.saveActiveTaskProgress,
            onEndWithoutPhoto: tasks.completeActiveTaskWithoutPhoto,
          ),
          CalendarScreen(
            controller: tasks,
            goals: ref.watch(goalControllerProvider),
            selectedDate: _selectedDate,
            onStartTask: (task) async {
              await tasks.startTask(task);
              if (mounted) setState(() => _tab = 2);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.flag_rounded), label: 'Goals'),
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_rounded),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}
