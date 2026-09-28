import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/app_database.dart';
import 'package:mobile/data/snapshot_repository.dart';
import 'package:mobile/domain/snapshot.dart';

void main() {
  late AppDatabase database;
  late DriftSnapshotRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftSnapshotRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('saves and lists snapshots in newest-first order', () async {
    final first = _photo('photo-1', DateTime(2026, 9, 16, 9));
    final second = _photo('photo-2', DateTime(2026, 9, 16, 10));

    await repository.add(first);
    await repository.add(second);

    expect(await repository.list(), [second, first]);
  });

  test('deletes one snapshot without deleting the others', () async {
    final first = _photo('photo-1', DateTime(2026, 9, 16, 9));
    final second = _photo('photo-2', DateTime(2026, 9, 16, 10));
    await repository.add(first);
    await repository.add(second);

    await repository.delete(first.id);

    expect(await repository.list(), [second]);
  });

  test('clears all snapshots', () async {
    await repository.add(_photo('photo-1', DateTime(2026, 9, 16, 9)));

    await repository.clearAll();

    expect(await repository.list(), isEmpty);
  });

  test('stores goal links on proof photos', () async {
    final photo = _photo(
      'photo-goal',
      DateTime(2026, 9, 16, 9),
      goalId: 'goal-1',
    );

    await repository.add(photo);

    expect(await repository.list(), [photo]);
  });

  test('saves a note for a goal proof day', () async {
    const note = ProofDayNote(
      goalId: 'goal-1',
      date: '2026-09-16',
      note: 'Practiced the new chord changes.',
    );

    await repository.saveNote(note);

    expect(await repository.listNotes('goal-1'), [note]);
  });

  test('deletes only notes belonging to the deleted goal', () async {
    await repository.saveNote(
      const ProofDayNote(goalId: 'goal-1', date: '2026-09-16', note: 'One'),
    );
    await repository.saveNote(
      const ProofDayNote(goalId: 'goal-2', date: '2026-09-16', note: 'Two'),
    );

    await repository.deleteNotes('goal-1');

    expect(await repository.listNotes('goal-1'), isEmpty);
    expect((await repository.listNotes('goal-2')).single.note, 'Two');
  });
}

CapturedPhoto _photo(String id, DateTime capturedAt, {String? goalId}) {
  return CapturedPhoto(
    id: id,
    path: '/private/$id.jpg',
    capturedAt: capturedAt,
    goalId: goalId,
  );
}
