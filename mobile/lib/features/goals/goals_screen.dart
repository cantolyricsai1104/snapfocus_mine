import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/goal.dart';
import '../../domain/goal_controller.dart';
import '../../domain/task_controller.dart';
import '../../domain/task.dart';

const _ink = Color(0xFF29313D);
const _muted = Color(0xFF756C68);
const _coral = Color(0xFFE97965);

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key, required this.controller, required this.tasks});

  final GoalController controller;
  final TaskController tasks;

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.restore();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) {
      final controller = widget.controller;
      return Scaffold(
        backgroundColor: const Color(0xFFFFF9F2),
        appBar: AppBar(
          title: const Text('Pillars & goals'),
          actions: [
            IconButton(
              tooltip: 'Add a Pillar',
              onPressed: _addPillar,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        body: controller.loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  const Text(
                    'Give the things that matter a little room to grow.',
                    style: TextStyle(color: _muted, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  if (controller.pillars.isEmpty)
                    _EmptyGoals(onAdd: _addPillar)
                  else
                    ...controller.pillars.map((pillar) {
                      final pillarGoals = controller.goals
                          .where((goal) => goal.pillarId == pillar.id)
                          .toList(growable: false);
                      return _PillarSection(
                        pillar: pillar,
                        goals: pillarGoals,
                        onAddGoal: () => _addGoal(pillar),
                        onEditPillar: () => _editPillar(pillar),
                        onDeletePillar: () => _deletePillar(pillar),
                        onEditGoal: _editGoal,
                      );
                    }),
                  if (controller.pillars.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: _addPillar,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Pillar'),
                    ),
                  ],
                ],
              ),
      );
    },
  );

  Future<void> _addPillar() => _editPillarSheet();

  Future<void> _editPillar(Pillar pillar) => _editPillarSheet(pillar);

  Future<void> _editPillarSheet([Pillar? initial]) async {
    final result = await showModalBottomSheet<Pillar>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _PillarEditor(initial: initial),
    );
    if (result != null) await widget.controller.savePillar(result);
  }

  Future<void> _deletePillar(Pillar pillar) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${pillar.name}?'),
        content: const Text('Goals in this Pillar will also be deleted.'),
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
    if (confirmed == true) {
      for (final goal in widget.controller.goals.where(
        (item) => item.pillarId == pillar.id,
      )) {
        await widget.tasks.removeGoalTask(goal.id);
      }
      await widget.controller.deletePillar(pillar.id);
    }
  }

  Future<void> _addGoal(Pillar pillar) => _editGoalSheet(pillar);

  Future<void> _editGoal(Goal goal) {
    final pillar = widget.controller.pillarFor(goal);
    if (pillar == null) return Future<void>.value();
    return _editGoalSheet(pillar, goal);
  }

  Future<void> _editGoalSheet(Pillar pillar, [Goal? initial]) async {
    final result = await showModalBottomSheet<Goal>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _GoalEditor(pillar: pillar, initial: initial),
    );
    if (result != null) {
      await widget.controller.saveGoal(result);
      await widget.tasks.syncGoalTask(
        result,
        color: widget.controller.pillarFor(result)?.color ?? '#E97965',
      );
    }
  }
}

class _PillarSection extends StatelessWidget {
  const _PillarSection({
    required this.pillar,
    required this.goals,
    required this.onAddGoal,
    required this.onEditPillar,
    required this.onDeletePillar,
    required this.onEditGoal,
  });

  final Pillar pillar;
  final List<Goal> goals;
  final VoidCallback onAddGoal;
  final VoidCallback onEditPillar;
  final VoidCallback onDeletePillar;
  final ValueChanged<Goal> onEditGoal;

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(pillar.color);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.14),
                child: Text(pillar.emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pillar.name,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Pillar options',
                onSelected: (value) =>
                    value == 'edit' ? onEditPillar() : onDeletePillar(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit Pillar')),
                  PopupMenuItem(value: 'delete', child: Text('Delete Pillar')),
                ],
              ),
            ],
          ),
          if (goals.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'No goals yet',
                      style: TextStyle(color: _muted),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onAddGoal,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add goal'),
                  ),
                ],
              ),
            )
          else ...[
            const SizedBox(height: 8),
            ...goals.map(
              (goal) => _GoalCard(
                goal: goal,
                color: color,
                onTap: () => onEditGoal(goal),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onAddGoal,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add goal'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.color,
    required this.onTap,
  });
  final Goal goal;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Color(0xFFF1E3D7)),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (goal.expired)
                  const Chip(
                    avatar: Icon(Icons.event_busy_rounded, size: 18),
                    label: Text('Ended'),
                    visualDensity: VisualDensity.compact,
                  )
                else if (goal.achieved)
                  const Chip(
                    avatar: Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF4A946A),
                      size: 18,
                    ),
                    label: Text('Achieved'),
                    visualDensity: VisualDensity.compact,
                  )
                else
                  Text(
                    '${(goal.progress * 100).round()}%',
                    style: TextStyle(color: color, fontWeight: FontWeight.w800),
                  ),
              ],
            ),
            const SizedBox(height: 9),
            Semantics(
              label: '${goal.name}: ${(goal.progress * 100).round()}% of duration elapsed',
              child: LinearProgressIndicator(
                value: goal.progress,
                minHeight: 9,
                borderRadius: BorderRadius.circular(8),
                color: goal.achieved ? const Color(0xFF4A946A) : color,
                backgroundColor: color.withValues(alpha: 0.14),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '${_goalDurationLabel(goal)} · ${goal.currentValue.toStringAsFixed(0)} min focused',
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}

class _EmptyGoals extends StatelessWidget {
  const _EmptyGoals({required this.onAdd});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFF1E3D7)),
    ),
    child: Column(
      children: [
        const Icon(Icons.flag_outlined, color: _coral, size: 42),
        const SizedBox(height: 10),
        const Text(
          'Start with a Pillar',
          style: TextStyle(
            color: _ink,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Group your goals around an area that matters to you.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Create a Pillar'),
        ),
      ],
    ),
  );
}

class _PillarEditor extends StatefulWidget {
  const _PillarEditor({this.initial});
  final Pillar? initial;
  @override
  State<_PillarEditor> createState() => _PillarEditorState();
}

class _PillarEditorState extends State<_PillarEditor> {
  late final TextEditingController _name;
  late String _emoji;
  late Color _color;
  static const _emojis = [
    '🌱',
    '💼',
    '📚',
    '💪',
    '🧠',
    '🏡',
    '💰',
    '🎨',
    '❤️',
    '✨',
  ];
  static const _colors = [
    Color(0xFFE97965),
    Color(0xFF8067B7),
    Color(0xFF438C78),
    Color(0xFF4681A8),
    Color(0xFFCB8A38),
    Color(0xFFD05B83),
  ];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial?.name ?? '');
    _emoji = widget.initial?.emoji ?? _emojis.first;
    _color = _parseColor(widget.initial?.color ?? '#E97965');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _EditorSheet(
    title: widget.initial == null ? 'Create a Pillar' : 'Edit Pillar',
    actionLabel: widget.initial == null ? 'Create Pillar' : 'Save Pillar',
    onSave: () {
      if (_name.text.trim().isEmpty) return;
      final id =
          widget.initial?.id ??
          'pillar-${DateTime.now().microsecondsSinceEpoch}';
      Navigator.pop(
        context,
        Pillar(
          id: id,
          name: _name.text.trim(),
          color: _color.toHex(),
          emoji: _emoji,
        ),
      );
    },
    children: [
      TextField(
        controller: _name,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Pillar name',
          hintText: 'e.g. Career, Health, Learning',
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'Choose an emoji',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 6,
        children: _emojis
            .map(
              (emoji) => ChoiceChip(
                label: Text(emoji, style: const TextStyle(fontSize: 20)),
                selected: emoji == _emoji,
                onSelected: (_) => setState(() => _emoji = emoji),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 14),
      const Text('Color', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 12,
        children: _colors
            .map(
              (color) => IconButton(
                onPressed: () => setState(() => _color = color),
                tooltip: 'Choose color',
                icon: Icon(
                  color == _color ? Icons.check_circle : Icons.circle,
                  color: color,
                  size: 32,
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}

class _GoalEditor extends StatefulWidget {
  const _GoalEditor({required this.pillar, this.initial});
  final Pillar pillar;
  final Goal? initial;
  @override
  State<_GoalEditor> createState() => _GoalEditorState();
}

class _GoalEditorState extends State<_GoalEditor> {
  late final TextEditingController _name;
  late final TextEditingController _durationValue;
  late GoalDurationUnit _durationUnit;
  late final TextEditingController _taskTitle;
  late final TextEditingController _taskDuration;
  late bool _scheduleTask;
  late Set<int> _weekdays;
  late TaskRepeat _taskRepeat;
  late int _taskMonthDay;
  String? _taskTime;
  static const _weekdayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    final goal = widget.initial;
    _name = TextEditingController(text: goal?.name ?? '');
    _durationValue = TextEditingController(
      text: '${goal?.durationValue ?? 3}',
    );
    _durationUnit = goal?.durationUnit ?? GoalDurationUnit.month;
    _taskTitle = TextEditingController(text: goal?.taskTitle ?? '');
    _scheduleTask = goal?.taskTitle != null;
    _weekdays = {...?goal?.taskWeekdays};
    if (_weekdays.isEmpty) _weekdays = {1, 2, 3, 4, 5};
    _taskRepeat = goal?.taskRepeat ?? TaskRepeat.weekly;
    _taskMonthDay = goal?.taskMonthDay ?? DateTime.now().day;
    _taskDuration = TextEditingController(
      text: '${goal?.taskDurationMinutes ?? 25}',
    );
    _taskTime = goal?.taskTime ?? '09:00';
  }

  @override
  void dispose() {
    _name.dispose();
    _durationValue.dispose();
    _taskTitle.dispose();
    _taskDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _EditorSheet(
    title: widget.initial == null ? 'Create a goal' : 'Edit goal',
    actionLabel: widget.initial == null ? 'Create goal' : 'Save goal',
    onSave: () {
      final name = _name.text.trim();
      final duration = int.tryParse(_durationValue.text.trim());
      if (name.isEmpty) return;
      if (duration == null || duration < 1 || duration > 1000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter a duration from 1 to 1000.'),
          ),
        );
        return;
      }
      final taskDuration = int.tryParse(_taskDuration.text.trim());
      if (_scheduleTask && _taskTitle.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a name for the recurring task.')),
        );
        return;
      }
      if (_scheduleTask &&
          ((_taskRepeat == TaskRepeat.weekly && _weekdays.isEmpty) ||
              taskDuration == null ||
              taskDuration < 1 ||
              taskDuration > 360)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Choose repeat days and a task duration from 1 to 360 minutes.',
            ),
          ),
        );
        return;
      }
      final old = widget.initial;
      Navigator.pop(
        context,
        Goal(
          id: old?.id ?? 'goal-${DateTime.now().microsecondsSinceEpoch}',
          pillarId: widget.pillar.id,
          name: name,
          metricType: GoalMetricType.time,
          targetValue: 0,
          currentValue: old?.currentValue ?? 0,
          unit: 'minutes',
          durationValue: duration,
          durationUnit: _durationUnit,
          durationMonths: _durationUnit == GoalDurationUnit.month ? duration : 0,
          durationWeeks: _durationUnit == GoalDurationUnit.week ? duration : 0,
          startedOn: old == null || old.expired
              ? _dateKey(DateTime.now())
              : old.startedOn ?? _dateKey(DateTime.now()),
          taskTitle: _scheduleTask ? _taskTitle.text.trim() : null,
          taskWeekdays: _scheduleTask && _taskRepeat == TaskRepeat.weekly
              ? (_weekdays.toList()..sort())
              : const [],
          taskDurationMinutes: taskDuration ?? 25,
          taskTime: _scheduleTask ? _taskTime : null,
          taskRepeat: _taskRepeat,
          taskMonthDay: _taskMonthDay,
        ),
      );
    },
    children: [
      TextField(
        controller: _name,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          labelText: 'Goal name',
          hintText: 'e.g. Learn guitar, read more',
        ),
      ),
      const SizedBox(height: 14),
      const Text(
        'Goal duration',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _durationValue,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<GoalDurationUnit>(
              initialValue: _durationUnit,
              decoration: const InputDecoration(labelText: 'Unit'),
              items: GoalDurationUnit.values
                  .map((unit) => DropdownMenuItem(value: unit, child: Text(unit.label)))
                  .toList(),
              onChanged: (unit) {
                if (unit != null) setState(() => _durationUnit = unit);
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      const Text(
        'The progress bar tracks time elapsed. Focus time is recorded separately.',
        style: TextStyle(color: _muted, fontSize: 12),
      ),
      const SizedBox(height: 12),
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: const Text('Schedule a recurring task'),
        subtitle: const Text(
          'Repeat a timed focus task while this goal lasts.',
        ),
        value: _scheduleTask,
        onChanged: (enabled) => setState(() {
          _scheduleTask = enabled;
        }),
      ),
      if (_scheduleTask) ...[
        const SizedBox(height: 8),
        TextField(
          controller: _taskTitle,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Task name',
            hintText: 'Name this recurring task',
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<TaskRepeat>(
          initialValue: _taskRepeat,
          decoration: const InputDecoration(labelText: 'Repeat'),
          items: const [
            DropdownMenuItem(value: TaskRepeat.daily, child: Text('Every day')),
            DropdownMenuItem(
              value: TaskRepeat.weekly,
              child: Text('Every week'),
            ),
            DropdownMenuItem(
              value: TaskRepeat.monthly,
              child: Text('Every month'),
            ),
          ],
          onChanged: (value) =>
              setState(() => _taskRepeat = value ?? _taskRepeat),
        ),
        if (_taskRepeat == TaskRepeat.weekly) ...[
          const SizedBox(height: 14),
          const Text(
            'Repeat on',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(7, (index) {
              final day = index + 1;
              return Semantics(
                label: _weekdayNames[index],
                child: ChoiceChip(
                  label: Text(_weekdayLabels[index]),
                  selected: _weekdays.contains(day),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _weekdays.add(day);
                    } else {
                      _weekdays.remove(day);
                    }
                  }),
                ),
              );
            }),
          ),
        ],
        if (_taskRepeat == TaskRepeat.monthly) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _taskMonthDay,
            decoration: const InputDecoration(
              labelText: 'Day of month',
              helperText:
                  'If a month is shorter, it uses that month’s last day.',
            ),
            items: [
              for (var day = 1; day <= 31; day++)
                DropdownMenuItem(
                  value: day,
                  child: Text(day == 31 ? '31st / last day' : _ordinal(day)),
                ),
            ],
            onChanged: (value) =>
                setState(() => _taskMonthDay = value ?? _taskMonthDay),
          ),
        ],
        const SizedBox(height: 14),
        TextField(
          controller: _taskDuration,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Session duration (minutes)',
            hintText: '25',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [15, 25, 30, 45, 60]
              .map(
                (minutes) => ActionChip(
                  label: Text('${minutes}m'),
                  onPressed: () =>
                      setState(() => _taskDuration.text = '$minutes'),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _pickTaskTime,
          icon: const Icon(Icons.schedule_rounded),
          label: Text(
            'Starts at ${TimeOfDay(hour: int.parse(_taskTime!.split(':')[0]), minute: int.parse(_taskTime!.split(':')[1])).format(context)}',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Scheduled at 9:00 AM by default. Tracked timer minutes add to your goal.',
          style: TextStyle(color: _muted, fontSize: 12),
        ),
      ],
    ],
  );

  Future<void> _pickTaskTime() async {
    final parts = (_taskTime ?? '09:00').split(':').map(int.parse).toList();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: parts[0], minute: parts[1]),
    );
    if (picked != null) {
      setState(
        () => _taskTime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
      );
    }
  }

  String _ordinal(int day) {
    final suffix = day % 100 >= 11 && day % 100 <= 13
        ? 'th'
        : switch (day % 10) {
            1 => 'st',
            2 => 'nd',
            3 => 'rd',
            _ => 'th',
          };
    return '$day$suffix';
  }
}

class _EditorSheet extends StatelessWidget {
  const _EditorSheet({
    required this.title,
    required this.children,
    required this.actionLabel,
    required this.onSave,
  });
  final String title;
  final List<Widget> children;
  final String actionLabel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      22,
      20,
      MediaQuery.viewInsetsOf(context).bottom + 20,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          ...children,
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onSave, child: Text(actionLabel)),
          ),
        ],
      ),
    ),
  );
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(9);
    final colors = [
      const Color(0xFFE97965),
      const Color(0xFF8067B7),
      const Color(0xFF438C78),
      const Color(0xFFCB8A38),
    ];
    for (var i = 0; i < 48; i++) {
      final x = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height * 0.3;
      final y =
          startY +
          progress * (size.height * (0.65 + random.nextDouble() * 0.7));
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(
          alpha: (1 - progress * 0.55).clamp(0, 1),
        );
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * 7 + i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 6, height: 10),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

Future<void> showGoalAchieved(BuildContext context, Goal goal) =>
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1400),
                    curve: Curves.easeOut,
                    builder: (_, value, _) =>
                        CustomPaint(painter: _ConfettiPainter(value)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.celebration_rounded,
                      size: 54,
                      color: _coral,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Goal achieved!',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      goal.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _muted),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Lovely'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

Color _parseColor(String value) {
  final hex = value.replaceFirst('#', '');
  final parsed = int.tryParse(hex, radix: 16) ?? 0xFFE97965;
  return Color(hex.length == 6 ? 0xFF000000 | parsed : parsed);
}

String _goalDurationLabel(Goal goal) {
  final duration = '${goal.durationValue} ${goal.durationUnit.label}${goal.durationValue == 1 ? '' : 's'}';
  final end = goal.endDate;
  if (end == null) return duration;
  return '$duration · ends ${end.month}/${end.day}/${end.year}';
}

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

extension on Color {
  String toHex() =>
      '#${(toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
