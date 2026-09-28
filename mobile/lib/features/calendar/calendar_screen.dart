import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/task.dart';
import '../../domain/task_controller.dart';
import '../../domain/goal_controller.dart';
import '../tasks/tasks_screen.dart';

enum CalendarViewMode { day, month, year }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
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
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarViewMode _mode = CalendarViewMode.day;

  @override
  void initState() {
    super.initState();
    widget.selectedDate.addListener(_onSelectedDateChanged);
  }

  @override
  void dispose() {
    widget.selectedDate.removeListener(_onSelectedDateChanged);
    super.dispose();
  }

  void _onSelectedDateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final date = _dateString(widget.selectedDate.value);
        final tasks = widget.controller.tasks
            .where((task) => task.isScheduledOn(date))
            .toList(growable: false);
        return Scaffold(
          backgroundColor: const Color(0xFFFFF9F2),
          appBar: AppBar(
            title: const Text('Calendar'),
            actions: [
              IconButton(
                onPressed: () => widget.selectedDate.value = DateTime.now(),
                tooltip: 'Today',
                icon: const Icon(Icons.today_rounded),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _CalendarHeader(
                date: widget.selectedDate.value,
                mode: _mode,
                onModeChanged: (mode) => setState(() => _mode = mode),
                onPrevious: () => _move(-1),
                onNext: () => _move(1),
              ),
              const SizedBox(height: 16),
              if (_mode == CalendarViewMode.day)
                _DayView(
                  tasks: tasks,
                  date: date,
                  onStartTask: widget.onStartTask,
                  onAdd: () => _addTask(date),
                  onEdit: _editTask,
                  onDelete: (task) => widget.controller.delete(task.id),
                  onChanged: (task) => widget.controller.update(task),
                )
              else if (_mode == CalendarViewMode.month)
                _MonthView(
                  date: widget.selectedDate.value,
                  tasks: widget.controller.tasks,
                  onSelect: (date) => setState(() {
                    widget.selectedDate.value = date;
                    _mode = CalendarViewMode.day;
                  }),
                )
              else
                _YearView(
                  date: widget.selectedDate.value,
                  onSelect: (month) => setState(() {
                    widget.selectedDate.value = DateTime(
                      widget.selectedDate.value.year,
                      month,
                    );
                    _mode = CalendarViewMode.month;
                  }),
                ),
            ],
          ),
        );
      },
    );
  }

  void _move(int direction) {
    setState(() {
      widget.selectedDate.value = _mode == CalendarViewMode.year
          ? DateTime(
              widget.selectedDate.value.year + direction,
              widget.selectedDate.value.month,
              widget.selectedDate.value.day,
            )
          : _mode == CalendarViewMode.month
          ? DateTime(
              widget.selectedDate.value.year,
              widget.selectedDate.value.month + direction,
              widget.selectedDate.value.day,
            )
          : widget.selectedDate.value.add(Duration(days: direction));
    });
  }

  Future<void> _addTask(String date) async {
    final task = await showModalBottomSheet<TaskBlock>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskEditorSheet(date: date, goals: widget.goals.goals),
    );
    if (task != null) await widget.controller.add(task);
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
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.date,
    required this.mode,
    required this.onModeChanged,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime date;
  final CalendarViewMode mode;
  final ValueChanged<CalendarViewMode> onModeChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                mode == CalendarViewMode.year
                    ? '${date.year}'
                    : '${_month(date)} ${date.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF29313D),
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        SegmentedButton<CalendarViewMode>(
          segments: const [
            ButtonSegment(value: CalendarViewMode.day, label: Text('Day')),
            ButtonSegment(value: CalendarViewMode.month, label: Text('Month')),
            ButtonSegment(value: CalendarViewMode.year, label: Text('Year')),
          ],
          selected: {mode},
          onSelectionChanged: (value) => onModeChanged(value.first),
        ),
      ],
    );
  }
}

class _DayView extends StatelessWidget {
  const _DayView({
    required this.tasks,
    required this.date,
    required this.onStartTask,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onChanged,
  });

  final List<TaskBlock> tasks;
  final String date;
  final ValueChanged<TaskBlock> onStartTask;
  final VoidCallback onAdd;
  final ValueChanged<TaskBlock> onEdit;
  final ValueChanged<TaskBlock> onDelete;
  final ValueChanged<TaskBlock> onChanged;

  @override
  Widget build(BuildContext context) {
    final timedTasks = tasks
        .where((task) => task.scheduledTime != null)
        .toList(growable: false);
    final anytimeTasks = tasks
        .where((task) => task.scheduledTime == null)
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Schedule',
              style: TextStyle(
                color: Color(0xFF29313D),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'No scheduled blocks for this day.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8D827B)),
            ),
          )
        else ...[
          if (anytimeTasks.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  'Anytime',
                  style: TextStyle(
                    color: Color(0xFF8D827B),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            for (final task in anytimeTasks)
              _AnytimeTaskCard(
                task: task,
                date: date,
                onStart: () => onStartTask(task),
                onEdit: () => onEdit(task),
                onDelete: () => onDelete(task),
              ),
            const SizedBox(height: 12),
          ],
          if (timedTasks.isNotEmpty)
            SizedBox(
              height: 560,
              child: _DayTimeline(
                tasks: timedTasks,
                date: date,
                onStartTask: onStartTask,
                onEdit: onEdit,
                onDelete: onDelete,
                onChanged: onChanged,
              ),
            ),
        ],
      ],
    );
  }
}

class _AnytimeTaskCard extends StatelessWidget {
  const _AnytimeTaskCard({
    required this.task,
    required this.date,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskBlock task;
  final String date;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final done = task.isCompletedOn(date);
    final color = done
        ? const Color(0xFF9AA0A6)
        : task.type == TaskType.focus
        ? const Color(0xFFE97965)
        : const Color(0xFF8067B7);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onStart,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: const Color(0xFF29313D),
                        fontWeight: FontWeight.w700,
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${task.durationMinutes}m${task.repeat != TaskRepeat.none ? ' · ${task.repeat.name}' : ''}',
                      style: const TextStyle(
                        color: Color(0xFF8D827B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Start timer',
            onPressed: onStart,
            icon: Icon(Icons.play_circle_fill_rounded, color: color),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit block')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayTimeline extends StatelessWidget {
  const _DayTimeline({
    required this.tasks,
    required this.date,
    required this.onStartTask,
    required this.onEdit,
    required this.onDelete,
    required this.onChanged,
  });

  static const double _hourHeight = 72;
  static const double _labelWidth = 52;

  final List<TaskBlock> tasks;
  final String date;
  final ValueChanged<TaskBlock> onStartTask;
  final ValueChanged<TaskBlock> onEdit;
  final ValueChanged<TaskBlock> onDelete;
  final ValueChanged<TaskBlock> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1E3D7)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SingleChildScrollView(
          controller: ScrollController(initialScrollOffset: 6 * _hourHeight),
          padding: const EdgeInsets.only(bottom: 24),
          child: SizedBox(
            height: _hourHeight * 24,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final timelineWidth = constraints.maxWidth - _labelWidth;
                return Stack(
                  children: [
                    for (var hour = 0; hour < 24; hour++)
                      Positioned(
                        top: hour * _hourHeight,
                        left: 0,
                        right: 0,
                        height: _hourHeight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: _labelWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 7,
                                  right: 10,
                                ),
                                child: Text(
                                  _formatHour(hour),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Color(0xFF8D827B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                margin: const EdgeInsets.only(top: 15),
                                color: const Color(0xFFF1E3D7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    for (final task in tasks)
                      if (task.scheduledTime != null)
                        _TimelineTask(
                          key: ValueKey(task.id),
                          task: task,
                          date: date,
                          left: _labelWidth + 8,
                          width: timelineWidth - 16,
                          top: _minutes(task.scheduledTime!) / 60 * _hourHeight,
                          onStart: () => onStartTask(task),
                          onEdit: () => onEdit(task),
                          onDelete: () => onDelete(task),
                          onChanged: onChanged,
                        ),
                    if (_isToday(date))
                      _CurrentTimeIndicator(
                        date: date,
                        hourHeight: _hourHeight,
                        labelWidth: _labelWidth,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrentTimeIndicator extends StatefulWidget {
  const _CurrentTimeIndicator({
    required this.date,
    required this.hourHeight,
    required this.labelWidth,
  });

  final String date;
  final double hourHeight;
  final double labelWidth;

  @override
  State<_CurrentTimeIndicator> createState() => _CurrentTimeIndicatorState();
}

class _CurrentTimeIndicatorState extends State<_CurrentTimeIndicator> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dateString(_now) != widget.date) return const SizedBox.shrink();

    final minutes = _now.hour * 60 + _now.minute + _now.second / 60;
    final top = minutes / 60 * widget.hourHeight;
    final label =
        '${_now.hour == 0 || _now.hour == 12 ? 12 : _now.hour % 12}:${_now.minute.toString().padLeft(2, '0')} ${_now.hour < 12 ? 'AM' : 'PM'}';
    return Positioned(
      top: top - 6,
      left: widget.labelWidth - 4,
      right: 0,
      height: 18,
      child: IgnorePointer(
        child: Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Color(0xFFE97965),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(height: 2, color: const Color(0xFFE97965)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE97965),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineTask extends StatefulWidget {
  const _TimelineTask({
    super.key,
    required this.task,
    required this.date,
    required this.left,
    required this.width,
    required this.top,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
    required this.onChanged,
  });

  final TaskBlock task;
  final String date;
  final double left;
  final double width;
  final double top;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<TaskBlock> onChanged;

  @override
  State<_TimelineTask> createState() => _TimelineTaskState();
}

class _TimelineTaskState extends State<_TimelineTask> {
  static const double _hourHeight = _DayTimeline._hourHeight;
  double? _dragStartGlobalY;
  int? _baseMinutes;
  int? _baseDuration;
  TaskBlock? _preview;

  TaskBlock get _task => _preview ?? widget.task;

  void _beginDrag(DragStartDetails details) {
    // Keep the pointer origin in screen coordinates. The resize handle moves
    // as the block grows, so localPosition would shift underneath the finger.
    _dragStartGlobalY = details.globalPosition.dy;
    _baseMinutes = _minutes(widget.task.scheduledTime ?? '09:00');
    _baseDuration = widget.task.durationMinutes;
  }

  void _drag(DragUpdateDetails details) {
    if (_dragStartGlobalY == null || _baseMinutes == null) return;
    final delta = details.globalPosition.dy - _dragStartGlobalY!;
    final minutes = (_baseMinutes! + _snap(delta / _hourHeight * 60))
        .clamp(0, 24 * 60 - 15)
        .toInt();
    setState(() => _preview = _task.copyWith(scheduledTime: _time(minutes)));
  }

  void _resize(DragUpdateDetails details) {
    if (_dragStartGlobalY == null || _baseDuration == null) return;
    final delta = details.globalPosition.dy - _dragStartGlobalY!;
    final duration = (_baseDuration! + _snap(delta / _hourHeight * 60))
        .clamp(15, 12 * 60)
        .toInt();
    setState(() => _preview = _task.copyWith(durationMinutes: duration));
  }

  void _commit() {
    if (_preview != null) widget.onChanged(_preview!);
    setState(() {
      _preview = null;
      _dragStartGlobalY = null;
      _baseMinutes = null;
      _baseDuration = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final task = _task;
    final isCompleted = task.isCompletedOn(widget.date);
    final taskColor = task.type == TaskType.focus
        ? const Color(0xFFE97965)
        : const Color(0xFF8067B7);
    final color = isCompleted ? const Color(0xFF9AA0A6) : taskColor;
    final height = (task.durationMinutes / 60 * _hourHeight)
        // Keep a short event large enough to show and grab its resize edge.
        .clamp(44.0, 12 * _hourHeight)
        .toDouble();
    return Positioned(
      top:
          widget.top +
          (_minutes(widget.task.scheduledTime ?? '09:00') ==
                  _minutes(task.scheduledTime ?? '09:00')
              ? 0
              : (_minutes(task.scheduledTime ?? '09:00') -
                        _minutes(widget.task.scheduledTime ?? '09:00')) /
                    60 *
                    _hourHeight),
      left: widget.left,
      width: widget.width,
      height: height,
      child: GestureDetector(
        onPanStart: _beginDrag,
        onPanUpdate: _drag,
        onPanEnd: (_) => _commit(),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.fromLTRB(
                  8,
                  height < 36 ? 2 : 8,
                  4,
                  height < 36 ? 2 : 8,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.55)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: height > 64 ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCompleted
                              ? const Color(0xFF6F757B)
                              : const Color(0xFF29313D),
                          fontSize: height < 36 ? 11 : 12,
                          fontWeight: FontWeight.w800,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    if (height >= 36)
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        iconSize: 17,
                        onSelected: (value) {
                          if (value == 'start') widget.onStart();
                          if (value == 'edit') widget.onEdit();
                          if (value == 'delete') widget.onDelete();
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'start',
                            child: Text('Start timer'),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit block'),
                          ),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: height.clamp(20.0, 28.0).toDouble(),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: _beginDrag,
                onPanUpdate: _resize,
                onPanEnd: (_) => _commit(),
                onPanCancel: _commit,
                child: Semantics(
                  label: 'Resize ${task.title}',
                  hint: 'Drag up or down to change the task duration',
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      border: Border(
                        top: BorderSide(color: color.withValues(alpha: 0.38)),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int _minutes(String time) {
  final parts = time.split(':').map(int.parse).toList();
  return parts[0] * 60 + parts[1];
}

int _snap(double minutes) => (minutes / 15).round() * 15;

String _time(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

String _formatHour(int hour) =>
    '${(hour % 12 == 0 ? 12 : hour % 12).toString()} ${hour < 12 ? 'AM' : 'PM'}';

class _MonthView extends StatelessWidget {
  const _MonthView({
    required this.date,
    required this.tasks,
    required this.onSelect,
  });

  final DateTime date;
  final List<TaskBlock> tasks;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(date.year, date.month, 1);
    final days = DateTime(date.year, date.month + 1, 0).day;
    final offset = first.weekday - 1;
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
            Text('S'),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offset + days,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            if (index < offset) return const SizedBox.shrink();
            final day = index - offset + 1;
            final current = DateTime(date.year, date.month, day);
            final count = tasks
                .where((task) => task.isScheduledOn(_dateString(current)))
                .length;
            return InkWell(
              onTap: () => onSelect(current),
              borderRadius: BorderRadius.circular(14),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF1E3D7)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: const TextStyle(
                        color: Color(0xFF29313D),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (count > 0)
                      Text(
                        '•' * (count > 3 ? 3 : count),
                        style: const TextStyle(
                          color: Color(0xFFE97965),
                          fontSize: 16,
                          height: 0.8,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _YearView extends StatelessWidget {
  const _YearView({required this.date, required this.onSelect});

  final DateTime date;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => onSelect(index + 1),
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1E3D7)),
            ),
            child: Center(
              child: Text(
                _monthName(index + 1),
                style: const TextStyle(
                  color: Color(0xFF29313D),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

String _dateString(DateTime value) =>
    '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
bool _isToday(String value) => _dateString(DateTime.now()) == value;
String _month(DateTime value) => _monthName(value.month);
String _monthName(int month) => const [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
][month - 1];
