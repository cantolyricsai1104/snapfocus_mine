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
}

CapturedPhoto _photo(String id, DateTime capturedAt) {
  return CapturedPhoto(
    id: id,
    path: '/private/$id.jpg',
    capturedAt: capturedAt,
  );
}
