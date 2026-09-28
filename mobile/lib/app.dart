import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'domain/routine_controller.dart';
import 'domain/routine_ports.dart';
import 'domain/task_controller.dart';
import 'domain/goal_controller.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/routine/routine_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/goals/goals_screen.dart';
import 'features/auth/login_screen.dart';

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
    this.authClient,
  });

  final RoutineController controller;
  final SnapshotRepository snapshots;
  final TaskController tasks;
  final GoalController goals;
  final SupabaseClient? authClient;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        routineControllerProvider.overrideWithValue(controller),
        snapshotRepositoryProvider.overrideWithValue(snapshots),
        taskControllerProvider.overrideWithValue(tasks),
        goalControllerProvider.overrideWithValue(goals),
      ],
      child: _AppView(authClient: authClient),
    );
  }
}

class _AppView extends ConsumerWidget {
  const _AppView({required this.authClient});

  final SupabaseClient? authClient;

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
      home: authClient == null
          ? const _MobileShell()
          : SupabaseAuthGate(
              client: authClient!,
              child: _MobileShell(authClient: authClient!),
            ),
    );
  }
}

class _MobileShell extends ConsumerStatefulWidget {
  const _MobileShell({this.authClient});

  final SupabaseClient? authClient;

  @override
  ConsumerState<_MobileShell> createState() => _MobileShellState();
}

class _MobileShellState extends ConsumerState<_MobileShell> {
  int _tab = 1;
  late final ValueNotifier<DateTime> _selectedDate;
  RealtimeChannel? _syncChannel;
  bool _refreshingAccountData = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier(DateTime.now());
    if (widget.authClient?.auth.currentUser != null) {
      ref.read(goalControllerProvider).reloadForAccount();
      _subscribeToCloudChanges();
    }
  }

  @override
  void dispose() {
    _selectedDate.dispose();
    final channel = _syncChannel;
    if (channel != null) unawaited(widget.authClient?.removeChannel(channel));
    super.dispose();
  }

  void _subscribeToCloudChanges() {
    final client = widget.authClient;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) return;
    _syncChannel = client.channel('snapfocus-mobile-$userId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'tasks',
        callback: (_) => _reloadCloudData(),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'pillars',
        callback: (_) => _reloadCloudData(),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'goals',
        callback: (_) => _reloadCloudData(),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'proof_photos',
        callback: (_) => _reloadCloudData(),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'proof_notes',
        callback: (_) => _reloadCloudData(),
      )
      ..subscribe((status, _) {
        if (status == RealtimeSubscribeStatus.subscribed) {
          _reloadCloudData();
        }
      });
  }

  Future<void> _reloadCloudData() async {
    if (_refreshingAccountData || !mounted) return;
    _refreshingAccountData = true;
    try {
      await ref.read(goalControllerProvider).reloadForAccount();
      await ref.read(taskControllerProvider).restore();
    } finally {
      _refreshingAccountData = false;
    }
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
            authClient: widget.authClient,
          ),
          TasksScreen(
            controller: tasks,
            goals: ref.watch(goalControllerProvider),
            selectedDate: _selectedDate,
            snapshots: snapshots,
            authClient: widget.authClient,
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
            authClient: widget.authClient,
          ),
          CalendarScreen(
            controller: tasks,
            goals: ref.watch(goalControllerProvider),
            selectedDate: _selectedDate,
            authClient: widget.authClient,
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
