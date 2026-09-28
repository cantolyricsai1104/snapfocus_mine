import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/goal.dart';
import '../../domain/routine_ports.dart';
import '../../domain/snapshot.dart';
import '../../domain/task.dart';

class GoalProofScreen extends StatefulWidget {
  const GoalProofScreen({
    super.key,
    required this.goal,
    required this.repository,
  });

  final Goal goal;
  final SnapshotRepository repository;

  @override
  State<GoalProofScreen> createState() => _GoalProofScreenState();
}

class _GoalProofScreenState extends State<GoalProofScreen> {
  List<CapturedPhoto> _photos = const [];
  Map<String, ProofDayNote> _notes = const {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final allPhotos = await widget.repository.list();
      final notes = await widget.repository.listNotes(widget.goal.id);
      if (!mounted) return;
      setState(() {
        _photos = allPhotos
            .where(
              (photo) =>
                  photo.goalId == widget.goal.id ||
                  (widget.goal.taskTitle != null &&
                      photo.goalId == null &&
                      photo.taskTitle == widget.goal.taskTitle),
            )
            .toList(growable: false);
        _notes = {for (final note in notes) note.date: note};
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = '$error';
        _loading = false;
      });
    }
  }

  Future<void> _editNote(String date, CapturedPhoto? photo) async {
    final controller = TextEditingController(text: _notes[date]?.note ?? '');
    final note = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_longDate(DateTime.parse(date))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (photo != null && !kIsWeb) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(photo.path),
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              maxLength: 240,
              decoration: const InputDecoration(
                labelText: 'A note for this day',
                hintText: 'What did you focus on?',
                border: OutlineInputBorder(),
              ),
            ),
            if (photo == null)
              const Text(
                'No proof photo saved for this day.',
                style: TextStyle(color: Color(0xFF8D827B), fontSize: 12),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save note'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (note == null) return;
    await widget.repository.saveNote(
      ProofDayNote(
        goalId: widget.goal.id,
        date: date,
        note: note.isEmpty ? null : note,
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final dates = _scheduledDates(widget.goal);
    final grouped = <String, List<DateTime>>{};
    for (final date in dates) {
      grouped.putIfAbsent('${date.year}-${date.month}', () => []).add(date);
    }
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      appBar: AppBar(title: Text('${widget.goal.name} proof')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Proof history could not load. Try again.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            )
          : dates.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Add a scheduled task to create daily proof blocks.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF756C68)),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
              children: [
                Text(
                  '${dates.length} scheduled ${dates.length == 1 ? 'day' : 'days'} · tap a block to add a note',
                  style: const TextStyle(
                    color: Color(0xFF756C68),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                for (final month in grouped.entries) ...[
                  Text(
                    _monthLabel(month.value.first),
                    style: const TextStyle(
                      color: Color(0xFF29313D),
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final date in month.value)
                        _dayBlock(date, _photosForDay(date)),
                    ],
                  ),
                  const SizedBox(height: 22),
                ],
              ],
            ),
    );
  }

  Widget _dayBlock(DateTime date, List<CapturedPhoto> photos) {
    final dateKey = _dateKey(date);
    final photo = photos.isEmpty ? null : photos.first;
    final note = _notes[dateKey]?.note;
    final hasNote = note != null && note.trim().isNotEmpty;
    final hasProof = photo != null || hasNote;
    final proofStatus = hasProof ? 'proof complete' : 'proof missing';
    final photoStatus = photo != null ? 'photo saved' : 'no photo';
    final noteStatus = hasNote ? 'note saved' : 'no note';
    final color = hasProof ? const Color(0xFF4E946B) : const Color(0xFFD86F62);
    return Semantics(
      button: true,
      label: '${_longDate(date)}, $photoStatus, $noteStatus, $proofStatus',
      child: SizedBox(
        width: 64,
        child: Material(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _editNote(dateKey, photo),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: color,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (photo != null && !kIsWeb)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.file(
                        File(photo.path),
                        width: 52,
                        height: 34,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.broken_image_outlined,
                          color: color,
                          size: 22,
                        ),
                      ),
                    )
                  else
                    Icon(
                      hasProof ? Icons.check_circle_rounded : Icons.camera_alt,
                      color: color,
                      size: 20,
                    ),
                  if (note != null && note.isNotEmpty)
                    const Icon(
                      Icons.notes_rounded,
                      color: Color(0xFF756C68),
                      size: 14,
                    )
                  else
                    const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<CapturedPhoto> _photosForDay(DateTime date) => _photos
      .where((photo) => _dateKey(photo.capturedAt) == _dateKey(date))
      .toList(growable: false);
}

List<DateTime> _scheduledDates(Goal goal) {
  final startText = goal.startedOn;
  final end = goal.endDate;
  if (startText == null || end == null || goal.taskTitle == null) {
    return const [];
  }
  final start = DateTime.parse(startText);
  final lastDay = DateTime(end.year, end.month, end.day);
  final scheduledTask = TaskBlock(
    id: 'goal-proof-${goal.id}',
    title: goal.taskTitle!,
    durationMinutes: goal.taskDurationMinutes,
    type: TaskType.focus,
    color: '#E97965',
    scheduledTime: goal.taskTime ?? '09:00',
    date: startText,
    repeat: goal.taskRepeat,
    repeatUntil: _dateKey(lastDay),
    goalId: goal.id,
    repeatDays: goal.taskWeekdays,
    repeatMonthDay: goal.taskMonthDay,
  );
  final dates = <DateTime>[];
  for (
    var date = DateTime(start.year, start.month, start.day);
    !date.isAfter(lastDay);
    date = date.add(const Duration(days: 1))
  ) {
    if (scheduledTask.isScheduledOn(_dateKey(date))) {
      dates.add(date);
    }
  }
  return dates;
}

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

const _monthNames = [
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
];

String _longDate(DateTime date) =>
    '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';

String _monthLabel(DateTime date) =>
    '${_monthNames[date.month - 1]} ${date.year}';
