import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/routine_controller.dart';
import 'domain/routine_ports.dart';
import 'features/routine/routine_screen.dart';

final routineControllerProvider = Provider<RoutineController>((ref) {
  throw UnimplementedError('The app must provide a RoutineController.');
});

final snapshotRepositoryProvider = Provider<SnapshotRepository>((ref) {
  throw UnimplementedError('The app must provide a SnapshotRepository.');
});

class SnapFocusApp extends StatelessWidget {
  const SnapFocusApp({
    super.key,
    required this.controller,
    required this.snapshots,
  });

  final RoutineController controller;
  final SnapshotRepository snapshots;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        routineControllerProvider.overrideWithValue(controller),
        snapshotRepositoryProvider.overrideWithValue(snapshots),
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
      home: RoutineScreen(
        controller: ref.watch(routineControllerProvider),
        snapshots: ref.watch(snapshotRepositoryProvider),
      ),
    );
  }
}
