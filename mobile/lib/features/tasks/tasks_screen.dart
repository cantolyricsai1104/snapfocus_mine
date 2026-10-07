import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/routine.dart';
import '../../domain/task.dart';
import '../../domain/task_controller.dart';
import '../../domain/goal.dart';
import '../../domain/goal_controller.dart';
import '../../domain/routine_ports.dart';
import '../goals/goals_screen.dart';
import '../goals/goal_proof_screen.dart';
import '../gallery/gallery_screen.dart';
import '../auth/login_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({
    super.key,
    required this.controller,
    required this.goals,
    required this.selectedDate,
    required this.onStartTask,
    required this.snapshots,
    this.authClient,
  });

  final TaskController controller;
  final GoalController goals;
  final ValueNotifier<DateTime> selectedDate;
  final ValueChanged<TaskBlock> onStartTask;
  final SnapshotRepository snapshots;
  final SupabaseClient? authClient;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Set<String> _dismissedBreaks = {};
  Timer? _activeTaskRefreshTimer;
  bool _showRoutine = true;

  @override
  void initState() {
    super.initState();
    widget.controller.restore();
    widget.goals.restore();
    widget.selectedDate.addListener(_onSelectedDateChanged);
    _activeTaskRefreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refreshActiveTask();
    });
  }

  @override
  void dispose() {
    widget.selectedDate.removeListener(_onSelectedDateChanged);
    _activeTaskRefreshTimer?.cancel();
    super.dispose();
  }

  void _onSelectedDateChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _refreshActiveTask() async {
    final achieved = await widget.controller.completeActiveTaskIfNeeded(
      _dateString(widget.selectedDate.value),
    );
    if (achieved != null && mounted) await showGoalAchieved(context, achieved);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (widget.controller.loading) {
          return const Scaffold(
            backgroundColor: Color(0xFFFFF9F2),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final date = _dateString(widget.selectedDate.value);
        final allTasks = widget.controller.tasks
            .where((task) => task.isScheduledOn(date))
            .toList(growable: false);
        final tasks =
            allTasks
                .where(
                  (task) => _showRoutine ? _isRoutine(task) : !_isRoutine(task),
                )
                .toList()
              ..sort(_compareTasks);
        final focusMinutes = tasks
            .where((task) => task.type == TaskType.focus)
            .fold<int>(0, (total, task) => total + task.durationMinutes);
        final breakMinutes = tasks
            .where((task) => task.type == TaskType.breakTime)
            .fold<int>(0, (total, task) => total + task.durationMinutes);
        final completed = tasks
            .where((task) => task.isCompletedOn(date))
            .length;
        final suggestion = suggestBreak(tasks, date);

        return Scaffold(
          backgroundColor: const Color(0xFFFFF9F2),
          appBar: AppBar(
            title: const Text('SnapFocus'),
            actions: [
              if (widget.authClient != null)
                SignOutAction(client: widget.authClient!),
              IconButton(
                tooltip: 'Add block',
                onPressed: () => _addTask(date),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                'Your day, one kind block at a time.',
                style: TextStyle(
                  color: Color(0xFF756C68),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _DatePickerRow(
                date: widget.selectedDate.value,
                onPrevious: () => setState(() {
                  widget.selectedDate.value = widget.selectedDate.value
                      .subtract(const Duration(days: 1));
                }),
                onNext: () => setState(() {
                  widget.selectedDate.value = widget.selectedDate.value.add(
                    const Duration(days: 1),
                  );
                }),
                onToday: () => widget.selectedDate.value = DateTime.now(),
              ),
              const SizedBox(height: 14),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text('Routine'),
                    icon: Icon(Icons.repeat_rounded),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('Daily'),
                    icon: Icon(Icons.today_rounded),
                  ),
                ],
                selected: {_showRoutine},
                onSelectionChanged: (value) =>
                    setState(() => _showRoutine = value.first),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Deep focus',
                      value: '${focusMinutes}m',
                      color: const Color(0xFFE97965),
                      icon: Icons.local_fire_department_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      label: 'Break time',
                      value: '${breakMinutes}m',
                      color: const Color(0xFF8067B7),
                      icon: Icons.coffee_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ProgressCard(
                completed: completed,
                total: tasks.length,
                focusMinutes: focusMinutes,
              ),
              const SizedBox(height: 18),
              if (suggestion != null &&
                  !_dismissedBreaks.contains(suggestion.key)) ...[
                _BreakSuggestionCard(
                  suggestion: suggestion,
                  onAdd: () => _addSuggestedBreak(suggestion, date),
                  onDismiss: () =>
                      setState(() => _dismissedBreaks.add(suggestion.key)),
                ),
                const SizedBox(height: 18),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showRoutine ? 'Routine queue' : 'Daily tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF29313D),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _addTask(date),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add block'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE97965),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (tasks.isEmpty)
                const _EmptyTasks()
              else
                ...tasks.map((task) {
                  final done = task.isCompletedOn(date);
                  final isActive =
                      widget.controller.hasActiveTimer &&
                      widget.controller.activeTaskId == task.id &&
                      !done;
                  final state = widget.controller.routineState;
                  return _TaskCard(
                    task: task,
                    date: date,
                    active: isActive,
                    progress: widget.controller.taskProgress(task),
                    activityLabel: isActive ? _activityLabel(state) : null,
                    onStart: () => widget.onStartTask(task),
                    onEdit: () => _editTask(task),
                    onDelete: () => _deleteTask(task),
                    onToggle: () => _toggleTask(task, date),
                    onMoveUp: () => _move(task, -1),
                    onMoveDown: () => _move(task, 1),
                    onProof: () => _openProof(task),
                    onIncrementCount: () =>
                        widget.controller.incrementCount(task.id, date),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  bool _isRoutine(TaskBlock task) =>
      task.goalId != null || task.repeat != TaskRepeat.none;

  int _compareTasks(TaskBlock a, TaskBlock b) {
    final priority = b.priority.compareTo(a.priority);
    if (priority != 0 && !_showRoutine) return priority;
    final aTime = _timeMinutes(a.scheduledTime);
    final bTime = _timeMinutes(b.scheduledTime);
    final time = aTime.compareTo(bTime);
    if (time != 0) return time;
    return a.title.compareTo(b.title);
  }

  int _timeMinutes(String? time) {
    if (time == null) return 24 * 60;
    final parts = time.split(':').map(int.parse).toList();
    return parts[0] * 60 + parts[1];
  }

  String _activityLabel(RoutineState? state) {
    if (state?.status == RoutineStatus.paused) return 'Paused';
    if (state?.phase == RoutinePhase.breakTime) return 'Break running';
    return 'Running now';
  }

  Future<void> _openProof(TaskBlock task) async {
    final goal = widget.goals.findGoal(task.goalId);
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => goal == null
            ? GalleryScreen(repository: widget.snapshots)
            : GoalProofScreen(goal: goal, repository: widget.snapshots),
      ),
    );
  }

  Future<void> _addTask(String date) async {
    final task = await showModalBottomSheet<TaskBlock>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskEditorSheet(
        date: date,
        goals: widget.goals.goals,
        defaultTime: widget.controller.nextAvailableTaskTime(
          date: date,
          durationMinutes: 25,
        ),
        defaultTimeIsAutomatic: true,
        suggestTime: (duration) => widget.controller.nextAvailableTaskTime(
          date: date,
          durationMinutes: duration,
        ),
        defaultRepeat: _showRoutine ? TaskRepeat.weekly : TaskRepeat.none,
      ),
    );
    if (task != null) await widget.controller.add(task);
  }

  Future<void> _addSuggestedBreak(
    BreakSuggestion suggestion,
    String date,
  ) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    await widget.controller.add(
      TaskBlock(
        id: 'break-$now',
        title: 'Reset & recharge',
        durationMinutes: suggestion.durationMinutes,
        type: TaskType.breakTime,
        color: '#8067B7',
        scheduledTime: suggestion.startTime,
        date: date,
        repeat: TaskRepeat.none,
      ),
    );
    if (mounted) setState(() => _dismissedBreaks.add(suggestion.key));
  }

  Future<void> _editTask(TaskBlock task) async {
    final updated = await showModalBottomSheet<TaskBlock>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskEditorSheet(
        date: task.date,
        initial: task,
        goals: widget.goals.goals,
      ),
    );
    if (updated != null) await widget.controller.update(updated);
  }

  Future<void> _move(TaskBlock task, int direction) async {
    final index = widget.controller.tasks.indexWhere(
      (item) => item.id == task.id,
    );
    await widget.controller.reorder(index, index + direction);
  }

  Future<void> _toggleTask(TaskBlock task, String date) async {
    final achieved = await widget.controller.toggleCompleted(task.id, date);
    if (achieved != null && mounted) await showGoalAchieved(context, achieved);
  }

  Future<void> _deleteTask(TaskBlock task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${task.title}?'),
        content: const Text('This task will be removed from your schedule.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) await widget.controller.delete(task.id);
  }
}

class _DatePickerRow extends StatelessWidget {
  const _DatePickerRow({
    required this.date,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                isToday ? 'Today' : _weekday(date),
                style: const TextStyle(
                  color: Color(0xFF29313D),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${_month(date)} ${date.day}',
                style: const TextStyle(color: Color(0xFF8D827B), fontSize: 12),
              ),
            ],
          ),
        ),
        if (!isToday)
          TextButton(onPressed: onToday, child: const Text('Today')),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1E3D7)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF8D827B), fontSize: 12),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.focusMinutes,
  });

  final int completed;
  final int total;
  final int focusMinutes;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF29313D),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                progress == 1 && total > 0
                    ? 'All tasks done! 🎉'
                    : 'Daily progress',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '$completed/$total  ${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Color(0xFFFFC5B5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFE97965)),
            ),
          ),
          if (focusMinutes > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Focus target: ${focusMinutes}m',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _BreakSuggestionCard extends StatelessWidget {
  const _BreakSuggestionCard({
    required this.suggestion,
    required this.onAdd,
    required this.onDismiss,
  });

  final BreakSuggestion suggestion;
  final VoidCallback onAdd;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1ECFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8C9F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.coffee_rounded, color: Color(0xFF8067B7)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add a reset break?',
                  style: TextStyle(
                    color: Color(0xFF29313D),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${suggestion.durationMinutes} minutes before “${suggestion.next.title}”.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF756C68),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton(
                      onPressed: onAdd,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF8067B7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Add break'),
                    ),
                    TextButton(
                      onPressed: onDismiss,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Not now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: const Color(0xFFEAD9CC),
        style: BorderStyle.solid,
      ),
    ),
    child: const Column(
      children: [
        Icon(Icons.event_available_rounded, size: 42, color: Color(0xFFE19B88)),
        SizedBox(height: 10),
        Text(
          'No tasks for this day',
          style: TextStyle(
            color: Color(0xFF29313D),
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Add a small block to give your day a shape.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF8D827B)),
        ),
      ],
    ),
  );
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.date,
    required this.active,
    required this.progress,
    required this.activityLabel,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onProof,
    required this.onIncrementCount,
  });

  final TaskBlock task;
  final String date;
  final bool active;
  final double progress;
  final String? activityLabel;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onProof;
  final VoidCallback onIncrementCount;

  @override
  Widget build(BuildContext context) {
    final done = task.isCompletedOn(date);
    final color = task.type == TaskType.focus
        ? const Color(0xFFE97965)
        : const Color(0xFF8067B7);
    final priorityColor = _priorityColor(task.priority);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: active ? const Color(0xFFFFF0EC) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: active
              ? const Color(0xFFE97965)
              : priorityColor.withValues(alpha: 0.45),
          width: active ? 1.5 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (!done && progress > 0)
            Positioned.fill(
              child: IgnorePointer(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  builder: (context, animatedProgress, child) => Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: animatedProgress,
                      heightFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withValues(alpha: 0.12),
                              color.withValues(alpha: active ? 0.24 : 0.16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 48, 12),
            child: Row(
              children: [
                Checkbox(
                  value: done,
                  onChanged: (_) => onToggle(),
                  activeColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    task.type == TaskType.focus
                        ? Icons.local_fire_department_rounded
                        : Icons.coffee_rounded,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF29313D),
                                fontWeight: FontWeight.w800,
                                decoration: done
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          if (active) ...[
                            const SizedBox(width: 6),
                            _RunningPill(label: activityLabel!),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${task.scheduledTime ?? 'Anytime'}  ·  ${task.durationMinutes}m${task.repeat != TaskRepeat.none ? '  ·  ${task.repeat.name}' : ''}',
                        style: const TextStyle(
                          color: Color(0xFF8D827B),
                          fontSize: 12,
                        ),
                      ),
                      if (task.priority > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.flag_rounded,
                                size: 13,
                                color: priorityColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _priorityLabel(task.priority),
                                style: TextStyle(
                                  color: priorityColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (task.countTarget != null && task.countUnit != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: OutlinedButton.icon(
                            onPressed: onIncrementCount,
                            icon: const Icon(Icons.add_rounded, size: 15),
                            label: Text(
                              '${task.countByDate[date] ?? 0}/${task.countTarget} ${task.countUnit}',
                            ),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              minimumSize: const Size(0, 28),
                              foregroundColor: const Color(0xFF756C68),
                              side: const BorderSide(color: Color(0xFFF1E3D7)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'View proof photos and notes',
                  onPressed: onProof,
                  icon: const Icon(Icons.photo_library_outlined),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'start':
                        onStart();
                      case 'edit':
                        onEdit();
                      case 'up':
                        onMoveUp();
                      case 'down':
                        onMoveDown();
                      case 'delete':
                        onDelete();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'start', child: Text('Start timer')),
                    PopupMenuItem(value: 'edit', child: Text('Edit block')),
                    PopupMenuItem(value: 'up', child: Text('Move up')),
                    PopupMenuItem(value: 'down', child: Text('Move down')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              tooltip: 'Delete task',
              onPressed: onDelete,
              icon: const Icon(Icons.close_rounded),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}

class _RunningPill extends StatelessWidget {
  const _RunningPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE97965),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({
    super.key,
    required this.date,
    required this.goals,
    this.defaultTime = '10:00',
    this.defaultTimeIsAutomatic = true,
    this.suggestTime,
    this.defaultRepeat = TaskRepeat.none,
    this.initial,
  });

  final String date;
  final List<Goal> goals;
  final String defaultTime;
  final bool defaultTimeIsAutomatic;
  final String Function(int durationMinutes)? suggestTime;
  final TaskRepeat defaultRepeat;
  final TaskBlock? initial;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  late final TextEditingController _title;
  late final TextEditingController _durationText;
  late final TextEditingController _countTargetText;
  late final TextEditingController _customCountUnitText;
  late int _duration;
  late bool _timeAutomatic;
  late TaskType _type;
  late TaskRepeat _repeat;
  late int _priority;
  late int _reminderMinutesBefore;
  String? _countUnit;
  String? _time;
  String? _repeatUntil;
  String? _goalId;
  late Set<int> _repeatDays;

  @override
  void initState() {
    super.initState();
    final task = widget.initial;
    _title = TextEditingController(text: task?.title ?? '');
    _durationText = TextEditingController(
      text: '${task?.durationMinutes ?? 25}',
    );
    _countTargetText = TextEditingController(
      text: task?.countTarget?.toString() ?? '',
    );
    _customCountUnitText = TextEditingController(
      text:
          task?.countUnit != null &&
              !const {'times', 'pages'}.contains(task!.countUnit)
          ? task.countUnit
          : '',
    );
    _duration = task?.durationMinutes ?? 25;
    _timeAutomatic = task == null && widget.defaultTimeIsAutomatic;
    _type = task?.type ?? TaskType.focus;
    _repeat = task?.repeat ?? widget.defaultRepeat;
    _priority = task?.priority ?? 1;
    _reminderMinutesBefore = task?.reminderMinutesBefore ?? 10;
    _countUnit = task?.countUnit;
    if (_countUnit != null && !const {'times', 'pages'}.contains(_countUnit)) {
      _countUnit = 'custom';
    }
    _time = task?.scheduledTime ?? widget.defaultTime;
    _repeatUntil = task?.repeatUntil;
    _goalId = widget.goals.any((goal) => goal.id == task?.goalId)
        ? task?.goalId
        : null;
    _repeatDays = task?.repeatDays.isNotEmpty == true
        ? {...task!.repeatDays}
        : {DateTime.parse('${task?.date ?? widget.date}T00:00:00').weekday};
  }

  @override
  void dispose() {
    _title.dispose();
    _durationText.dispose();
    _countTargetText.dispose();
    _customCountUnitText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.initial == null ? 'Configure new block' : 'Edit block',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF29313D),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              autofocus: widget.initial == null,
              decoration: InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countTargetText,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Daily count (optional)',
                      hintText: 'e.g. 10',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    initialValue: _countUnit,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('No count')),
                      DropdownMenuItem(value: 'times', child: Text('times')),
                      DropdownMenuItem(value: 'pages', child: Text('pages')),
                      DropdownMenuItem(value: 'custom', child: Text('Custom')),
                    ],
                    onChanged: (value) => setState(() {
                      _countUnit = value;
                      if (value == 'custom' &&
                          _customCountUnitText.text.isEmpty) {
                        _customCountUnitText.text = 'items';
                      }
                    }),
                  ),
                ),
              ],
            ),
            if (_countUnit == 'custom') ...[
              const SizedBox(height: 8),
              TextField(
                controller: _customCountUnitText,
                decoration: const InputDecoration(
                  labelText: 'Custom unit',
                  hintText: 'e.g. chapters or push-ups',
                ),
              ),
            ],
            const SizedBox(height: 6),
            const Text(
              'Manual count only; it does not change Goal day progress.',
              style: TextStyle(color: Color(0xFF8D827B), fontSize: 12),
            ),
            const SizedBox(height: 12),
            SegmentedButton<TaskType>(
              segments: const [
                ButtonSegment(
                  value: TaskType.focus,
                  label: Text('Focus'),
                  icon: Icon(Icons.local_fire_department_rounded),
                ),
                ButtonSegment(
                  value: TaskType.breakTime,
                  label: Text('Break'),
                  icon: Icon(Icons.coffee_rounded),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (value) => setState(() {
                _type = value.first;
                if (_type == TaskType.breakTime) _goalId = null;
              }),
            ),
            const SizedBox(height: 12),
            const Text(
              'Priority',
              style: TextStyle(
                color: Color(0xFF756C68),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('Normal')),
                ButtonSegment(value: 2, label: Text('High')),
                ButtonSegment(value: 3, label: Text('Urgent')),
              ],
              selected: {_priority},
              onSelectionChanged: (value) =>
                  setState(() => _priority = value.first),
            ),
            const SizedBox(height: 12),
            const Text(
              'Duration',
              style: TextStyle(
                color: Color(0xFF756C68),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [5, 10, 15, 25, 30, 45, 60]
                  .map(
                    (minutes) => ChoiceChip(
                      label: Text('${minutes}m'),
                      selected: _duration == minutes,
                      onSelected: (_) => _setDuration(minutes),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _durationText,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Custom minutes (1–360)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  _setDuration(parsed.clamp(1, 360).toInt());
                }
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TaskRepeat>(
                    initialValue: _repeat,
                    decoration: InputDecoration(
                      labelText: 'Repeat',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: TaskRepeat.values
                        .map(
                          (repeat) => DropdownMenuItem(
                            value: repeat,
                            child: Text(
                              repeat == TaskRepeat.none
                                  ? 'One day'
                                  : repeat.name,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _repeat = value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.schedule_rounded),
                    label: Text(
                      _timeAutomatic
                          ? '${_time ?? 'No time'} (auto)'
                          : (_time ?? 'No time'),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.initial == null &&
                widget.defaultRepeat != TaskRepeat.none)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Routine blocks repeat automatically. You can change the schedule below.',
                  style: TextStyle(color: Color(0xFF8D827B), fontSize: 12),
                ),
              ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _reminderMinutesBefore,
              decoration: const InputDecoration(
                labelText: 'Calendar reminder',
                helperText: 'Reminder before this task starts',
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Off')),
                DropdownMenuItem(value: 1, child: Text('1 minute before')),
                DropdownMenuItem(value: 5, child: Text('5 minutes before')),
                DropdownMenuItem(value: 10, child: Text('10 minutes before')),
                DropdownMenuItem(value: 15, child: Text('15 minutes before')),
                DropdownMenuItem(value: 30, child: Text('30 minutes before')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _reminderMinutesBefore = value);
                }
              },
            ),
            if (widget.initial == null)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Start time is placed in the next available calendar slot. You can change it.',
                  style: TextStyle(color: Color(0xFF8D827B), fontSize: 12),
                ),
              ),
            if (_repeat == TaskRepeat.weekly) ...[
              const SizedBox(height: 12),
              const Text(
                'Repeat on',
                style: TextStyle(
                  color: Color(0xFF756C68),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: List.generate(7, (index) {
                  final weekday = index + 1;
                  const shortDays = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  const fullDays = [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                    'Sunday',
                  ];
                  return Semantics(
                    label: fullDays[index],
                    child: FilterChip(
                      label: Text(shortDays[index]),
                      selected: _repeatDays.contains(weekday),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _repeatDays.add(weekday);
                        } else if (_repeatDays.length > 1) {
                          _repeatDays.remove(weekday);
                        }
                      }),
                    ),
                  );
                }),
              ),
            ],
            if (_repeat != TaskRepeat.none) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _repeatUntil == null
                          ? 'Repeats forever'
                          : 'Until $_repeatUntil',
                      style: const TextStyle(color: Color(0xFF756C68)),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _pickRepeatUntil,
                    child: Text(
                      _repeatUntil == null ? 'Set end date' : 'Change date',
                    ),
                  ),
                  if (_repeatUntil != null)
                    IconButton(
                      onPressed: () => setState(() => _repeatUntil = null),
                      tooltip: 'Repeat forever',
                      icon: const Icon(Icons.clear_rounded),
                    ),
                ],
              ),
            ],
            if (_type == TaskType.focus && widget.goals.isNotEmpty) ...[
              const SizedBox(height: 14),
              DropdownButtonFormField<String?>(
                initialValue: _goalId,
                decoration: InputDecoration(
                  labelText: 'Linked goal (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('No linked goal'),
                  ),
                  ...widget.goals.map(
                    (goal) => DropdownMenuItem<String?>(
                      value: goal.id,
                      child: Text(
                        '${goal.name} · ${goal.durationValue} ${goal.durationUnit.label}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _goalId = value),
              ),
              const SizedBox(height: 6),
              const Text(
                'Completing this linked task counts one completed day for the goal.',
                style: TextStyle(color: Color(0xFF8D827B), fontSize: 12),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE97965),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  widget.initial == null ? 'Confirm block' : 'Save changes',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final parts = (_time ?? '10:00').split(':').map(int.parse).toList();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: parts[0], minute: parts[1]),
    );
    if (picked != null) {
      setState(() {
        _timeAutomatic = false;
        _time =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _setDuration(int duration) {
    setState(() {
      _duration = duration;
      if (_timeAutomatic) {
        _time = widget.suggestTime?.call(duration) ?? _time;
      }
    });
  }

  Future<void> _pickRepeatUntil() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDate: _repeatUntil == null
          ? DateTime.now().add(const Duration(days: 30))
          : DateTime.parse(_repeatUntil!),
    );
    if (picked != null) {
      setState(() => _repeatUntil = _dateString(picked));
    }
  }

  void _save() {
    if (_title.text.trim().isEmpty) return;
    final now = DateTime.now().microsecondsSinceEpoch;
    Navigator.of(context).pop(
      TaskBlock(
        id: widget.initial?.id ?? 'task-$now',
        title: _title.text.trim(),
        durationMinutes: _duration,
        type: _type,
        color: _type == TaskType.focus ? '#E97965' : '#8067B7',
        scheduledTime: _time,
        date: widget.initial?.date ?? widget.date,
        repeat: _repeat,
        priority: _priority,
        reminderMinutesBefore: _reminderMinutesBefore,
        countTarget: int.tryParse(_countTargetText.text.trim()),
        countUnit: _countUnit == 'custom'
            ? _customCountUnitText.text.trim()
            : _countUnit,
        countByDate: widget.initial?.countByDate ?? const {},
        repeatUntil: _repeatUntil,
        completed: widget.initial?.completed ?? false,
        completedDates: widget.initial?.completedDates ?? const [],
        goalId: _goalId,
        repeatDays: _repeat == TaskRepeat.weekly
            ? (_repeatDays.toList()..sort())
            : const [],
      ),
    );
  }
}

String _dateString(DateTime value) =>
    '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
String _weekday(DateTime value) => const [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
][value.weekday - 1];
String _month(DateTime value) => const [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][value.month - 1];

Color _priorityColor(int priority) => switch (priority) {
  3 => const Color(0xFFD64545),
  2 => const Color(0xFFE28A2B),
  _ => const Color(0xFF7B8794),
};

String _priorityLabel(int priority) => switch (priority) {
  3 => 'Urgent',
  2 => 'High priority',
  _ => 'Normal',
};
