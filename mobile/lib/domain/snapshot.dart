class CapturedPhoto {
  const CapturedPhoto({
    required this.id,
    required this.path,
    required this.capturedAt,
    this.routineId,
    this.taskTitle,
    this.goalId,
  });

  final String id;
  final String path;
  final DateTime capturedAt;
  final String? routineId;
  final String? taskTitle;
  final String? goalId;

  @override
  bool operator ==(Object other) {
    return other is CapturedPhoto &&
        other.id == id &&
        other.path == path &&
        other.capturedAt == capturedAt &&
        other.routineId == routineId &&
        other.taskTitle == taskTitle &&
        other.goalId == goalId;
  }

  @override
  int get hashCode =>
      Object.hash(id, path, capturedAt, routineId, taskTitle, goalId);
}

class ProofDayNote {
  const ProofDayNote({required this.goalId, required this.date, this.note});

  final String goalId;
  final String date;
  final String? note;

  @override
  bool operator ==(Object other) =>
      other is ProofDayNote &&
      other.goalId == goalId &&
      other.date == date &&
      other.note == note;

  @override
  int get hashCode => Object.hash(goalId, date, note);
}
