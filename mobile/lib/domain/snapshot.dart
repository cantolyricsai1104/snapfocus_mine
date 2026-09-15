class CapturedPhoto {
  const CapturedPhoto({
    required this.id,
    required this.path,
    required this.capturedAt,
    this.routineId,
    this.taskTitle,
  });

  final String id;
  final String path;
  final DateTime capturedAt;
  final String? routineId;
  final String? taskTitle;

  @override
  bool operator ==(Object other) {
    return other is CapturedPhoto &&
        other.id == id &&
        other.path == path &&
        other.capturedAt == capturedAt &&
        other.routineId == routineId &&
        other.taskTitle == taskTitle;
  }

  @override
  int get hashCode => Object.hash(id, path, capturedAt, routineId, taskTitle);
}
