import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/routine.dart';
import '../../domain/task.dart';
import '../../domain/task_controller.dart';
import '../../domain/goal.dart';
import '../../domain/goal_controller.dart';
import '../goals/goals_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({
    super.key,
    required this.controller,
    required this.goals,
    required this.selectedDate,
    required this.onStartTask,
  });

  final TaskController controller;
  final GoalController goals;
  final ValueNotifier<DateTime> selectedDate;
  final ValueChanged<TaskBlock> onStartTask;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Set<String> _dismissedBreaks = {};
  Timer? _activeTaskRefreshTimer;

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
        final tasks = widget.controller.tasks
            .where((task) => task.isScheduledOn(date))
            .toList(growable: false);
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
                  const Text(
                    'Tasks queue',
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
                    onDelete: () => widget.controller.delete(task.id),
                    onToggle: () => _toggleTask(task, date),
                    onMoveUp: () => _move(task, -1),
                    onMoveDown: () => _move(task, 1),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  String _activityLabel(RoutineState? state) {
    if (state?.status == RoutineStatus.paused) return 'Paused';
    if (state?.phase == RoutinePhase.breakTime) return 'Break running';
    return 'Running now';
  }

  Future<void> _addTask(String date) async {
    final task = await showModalBottomSheet<TaskBlock>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskEditorSheet(date: date, goals: widget.goals.goals),
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
    final achieved = await widget.controller.toggleCompleted(
      task.id,
      date,
    );
    if (achieved != null && mounted) await showGoalAchieved(context, achieved);
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

  @override
  Widget build(BuildContext context) {
    final done = task.isCompletedOn(date);
    final color = task.type == TaskType.focus
        ? const Color(0xFFE97965)
        : const Color(0xFF8067B7);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: active ? const Color(0xFFFFF0EC) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: active ? const Color(0xFFE97965) : const Color(0xFFF1E3D7),
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
            padding: const EdgeInsets.all(12),
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
                    ],
                  ),
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
    this.initial,
  });

  final String date;
  final List<Goal> goals;
  final TaskBlock? initial;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  late final TextEditingController _title;
  late final TextEditingController _durationText;
  late int _duration;
  late TaskType _type;
  late TaskRepeat _repeat;
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
    _duration = task?.durationMinutes ?? 25;
    _type = task?.type ?? TaskType.focus;
    _repeat = task?.repeat ?? TaskRepeat.none;
    _time = task?.scheduledTime ?? '10:00';
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
                      onSelected: (_) => setState(() => _duration = minutes),
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
                  setState(() => _duration = parsed.clamp(1, 360).toInt());
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
                    label: Text(_time ?? 'No time'),
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
                'Tracked timer minutes add to the linked goal’s focused time.',
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
      setState(
        () => _time =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
      );
    }
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
