import 'package:flutter/material.dart';

import '../../domain/task.dart';
import '../../domain/task_controller.dart';
import '../tasks/tasks_screen.dart';

enum CalendarViewMode { day, month, year }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.controller,
    required this.onStartTask,
  });

  final TaskController controller;
  final ValueChanged<TaskBlock> onStartTask;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  CalendarViewMode _mode = CalendarViewMode.day;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final date = _dateString(_selectedDate);
        final tasks = widget.controller.tasks
            .where((task) => task.isScheduledOn(date))
            .toList(growable: false);
        return Scaffold(
          backgroundColor: const Color(0xFFFFF9F2),
          appBar: AppBar(
            title: const Text('Calendar'),
            actions: [
              IconButton(
                onPressed: () => setState(() => _selectedDate = DateTime.now()),
                tooltip: 'Today',
                icon: const Icon(Icons.today_rounded),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _CalendarHeader(
                date: _selectedDate,
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
                  onShift: (task, amount) => _shiftTask(task, amount),
                )
              else if (_mode == CalendarViewMode.month)
                _MonthView(
                  date: _selectedDate,
                  tasks: widget.controller.tasks,
                  onSelect: (date) => setState(() {
                    _selectedDate = date;
                    _mode = CalendarViewMode.day;
                  }),
                )
              else
                _YearView(
                  date: _selectedDate,
                  onSelect: (month) => setState(() {
                    _selectedDate = DateTime(_selectedDate.year, month);
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
      _selectedDate = _mode == CalendarViewMode.year
          ? DateTime(
              _selectedDate.year + direction,
              _selectedDate.month,
              _selectedDate.day,
            )
          : _mode == CalendarViewMode.month
          ? DateTime(
              _selectedDate.year,
              _selectedDate.month + direction,
              _selectedDate.day,
            )
          : _selectedDate.add(Duration(days: direction));
    });
  }

  Future<void> _addTask(String date) async {
    final task = await showModalBottomSheet<TaskBlock>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskEditorSheet(date: date),
    );
    if (task != null) await widget.controller.add(task);
  }

  Future<void> _editTask(TaskBlock task) async {
    final updated = await showModalBottomSheet<TaskBlock>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TaskEditorSheet(date: task.date, initial: task),
    );
    if (updated != null) await widget.controller.update(updated);
  }

  Future<void> _shiftTask(TaskBlock task, int amount) async {
    final parts = (task.scheduledTime ?? '09:00')
        .split(':')
        .map(int.parse)
        .toList();
    final minutes = (parts[0] * 60 + parts[1] + amount)
        .clamp(0, 23 * 60 + 45)
        .toInt();
    final time =
        '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
    await widget.controller.schedule(
      task.id,
      time,
      date: _dateString(_selectedDate),
    );
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
    required this.onShift,
  });

  final List<TaskBlock> tasks;
  final String date;
  final ValueChanged<TaskBlock> onStartTask;
  final VoidCallback onAdd;
  final ValueChanged<TaskBlock> onEdit;
  final ValueChanged<TaskBlock> onDelete;
  final void Function(TaskBlock, int) onShift;

  @override
  Widget build(BuildContext context) {
    final sorted = [...tasks]
      ..sort(
        (a, b) =>
            (a.scheduledTime ?? '99:99').compareTo(b.scheduledTime ?? '99:99'),
      );
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
        if (sorted.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'No scheduled blocks for this day.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8D827B)),
            ),
          )
        else
          ...sorted.map(
            (task) => _CalendarTask(
              task: task,
              date: date,
              onStart: () => onStartTask(task),
              onEdit: () => onEdit(task),
              onDelete: () => onDelete(task),
              onShift: (amount) => onShift(task, amount),
            ),
          ),
      ],
    );
  }
}

class _CalendarTask extends StatelessWidget {
  const _CalendarTask({
    required this.task,
    required this.date,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
    required this.onShift,
  });

  final TaskBlock task;
  final String date;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<int> onShift;

  @override
  Widget build(BuildContext context) {
    final color = task.type == TaskType.focus
        ? const Color(0xFFE97965)
        : const Color(0xFF8067B7);
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFF1E3D7)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(
            task.type == TaskType.focus
                ? Icons.local_fire_department_rounded
                : Icons.coffee_rounded,
            color: color,
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(
            color: Color(0xFF29313D),
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          '${task.scheduledTime ?? 'Unscheduled'} · ${task.durationMinutes}m · ${task.isCompletedOn(date) ? 'Done' : 'Open'}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onStart,
              tooltip: 'Start timer',
              icon: Icon(Icons.play_circle_fill_rounded, color: color),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                  case 'earlier':
                    onShift(-15);
                  case 'later':
                    onShift(15);
                  case 'delete':
                    onDelete();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit block')),
                PopupMenuItem(
                  value: 'earlier',
                  child: Text('Move 15 min earlier'),
                ),
                PopupMenuItem(value: 'later', child: Text('Move 15 min later')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
