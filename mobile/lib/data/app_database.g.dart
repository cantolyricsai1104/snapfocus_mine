// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ActiveRoutinesTable extends ActiveRoutines
    with TableInfo<$ActiveRoutinesTable, ActiveRoutine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveRoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusDurationSecondsMeta =
      const VerificationMeta('focusDurationSeconds');
  @override
  late final GeneratedColumn<int> focusDurationSeconds = GeneratedColumn<int>(
    'focus_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breakDurationSecondsMeta =
      const VerificationMeta('breakDurationSeconds');
  @override
  late final GeneratedColumn<int> breakDurationSeconds = GeneratedColumn<int>(
    'break_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMicrosMeta = const VerificationMeta(
    'startedAtMicros',
  );
  @override
  late final GeneratedColumn<int> startedAtMicros = GeneratedColumn<int>(
    'started_at_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endsAtMicrosMeta = const VerificationMeta(
    'endsAtMicros',
  );
  @override
  late final GeneratedColumn<int> endsAtMicros = GeneratedColumn<int>(
    'ends_at_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pausedRemainingSecondsMeta =
      const VerificationMeta('pausedRemainingSeconds');
  @override
  late final GeneratedColumn<int> pausedRemainingSeconds = GeneratedColumn<int>(
    'paused_remaining_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phase,
    status,
    focusDurationSeconds,
    breakDurationSeconds,
    startedAtMicros,
    endsAtMicros,
    pausedRemainingSeconds,
    progress,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveRoutine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('focus_duration_seconds')) {
      context.handle(
        _focusDurationSecondsMeta,
        focusDurationSeconds.isAcceptableOrUnknown(
          data['focus_duration_seconds']!,
          _focusDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_focusDurationSecondsMeta);
    }
    if (data.containsKey('break_duration_seconds')) {
      context.handle(
        _breakDurationSecondsMeta,
        breakDurationSeconds.isAcceptableOrUnknown(
          data['break_duration_seconds']!,
          _breakDurationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_breakDurationSecondsMeta);
    }
    if (data.containsKey('started_at_micros')) {
      context.handle(
        _startedAtMicrosMeta,
        startedAtMicros.isAcceptableOrUnknown(
          data['started_at_micros']!,
          _startedAtMicrosMeta,
        ),
      );
    }
    if (data.containsKey('ends_at_micros')) {
      context.handle(
        _endsAtMicrosMeta,
        endsAtMicros.isAcceptableOrUnknown(
          data['ends_at_micros']!,
          _endsAtMicrosMeta,
        ),
      );
    }
    if (data.containsKey('paused_remaining_seconds')) {
      context.handle(
        _pausedRemainingSecondsMeta,
        pausedRemainingSeconds.isAcceptableOrUnknown(
          data['paused_remaining_seconds']!,
          _pausedRemainingSecondsMeta,
        ),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveRoutine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveRoutine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      focusDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_duration_seconds'],
      )!,
      breakDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_duration_seconds'],
      )!,
      startedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_micros'],
      ),
      endsAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ends_at_micros'],
      ),
      pausedRemainingSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paused_remaining_seconds'],
      ),
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
    );
  }

  @override
  $ActiveRoutinesTable createAlias(String alias) {
    return $ActiveRoutinesTable(attachedDatabase, alias);
  }
}

class ActiveRoutine extends DataClass implements Insertable<ActiveRoutine> {
  final String id;
  final String phase;
  final String status;
  final int focusDurationSeconds;
  final int breakDurationSeconds;
  final int? startedAtMicros;
  final int? endsAtMicros;
  final int? pausedRemainingSeconds;
  final double progress;
  const ActiveRoutine({
    required this.id,
    required this.phase,
    required this.status,
    required this.focusDurationSeconds,
    required this.breakDurationSeconds,
    this.startedAtMicros,
    this.endsAtMicros,
    this.pausedRemainingSeconds,
    required this.progress,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phase'] = Variable<String>(phase);
    map['status'] = Variable<String>(status);
    map['focus_duration_seconds'] = Variable<int>(focusDurationSeconds);
    map['break_duration_seconds'] = Variable<int>(breakDurationSeconds);
    if (!nullToAbsent || startedAtMicros != null) {
      map['started_at_micros'] = Variable<int>(startedAtMicros);
    }
    if (!nullToAbsent || endsAtMicros != null) {
      map['ends_at_micros'] = Variable<int>(endsAtMicros);
    }
    if (!nullToAbsent || pausedRemainingSeconds != null) {
      map['paused_remaining_seconds'] = Variable<int>(pausedRemainingSeconds);
    }
    map['progress'] = Variable<double>(progress);
    return map;
  }

  ActiveRoutinesCompanion toCompanion(bool nullToAbsent) {
    return ActiveRoutinesCompanion(
      id: Value(id),
      phase: Value(phase),
      status: Value(status),
      focusDurationSeconds: Value(focusDurationSeconds),
      breakDurationSeconds: Value(breakDurationSeconds),
      startedAtMicros: startedAtMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAtMicros),
      endsAtMicros: endsAtMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(endsAtMicros),
      pausedRemainingSeconds: pausedRemainingSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedRemainingSeconds),
      progress: Value(progress),
    );
  }

  factory ActiveRoutine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveRoutine(
      id: serializer.fromJson<String>(json['id']),
      phase: serializer.fromJson<String>(json['phase']),
      status: serializer.fromJson<String>(json['status']),
      focusDurationSeconds: serializer.fromJson<int>(
        json['focusDurationSeconds'],
      ),
      breakDurationSeconds: serializer.fromJson<int>(
        json['breakDurationSeconds'],
      ),
      startedAtMicros: serializer.fromJson<int?>(json['startedAtMicros']),
      endsAtMicros: serializer.fromJson<int?>(json['endsAtMicros']),
      pausedRemainingSeconds: serializer.fromJson<int?>(
        json['pausedRemainingSeconds'],
      ),
      progress: serializer.fromJson<double>(json['progress']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phase': serializer.toJson<String>(phase),
      'status': serializer.toJson<String>(status),
      'focusDurationSeconds': serializer.toJson<int>(focusDurationSeconds),
      'breakDurationSeconds': serializer.toJson<int>(breakDurationSeconds),
      'startedAtMicros': serializer.toJson<int?>(startedAtMicros),
      'endsAtMicros': serializer.toJson<int?>(endsAtMicros),
      'pausedRemainingSeconds': serializer.toJson<int?>(pausedRemainingSeconds),
      'progress': serializer.toJson<double>(progress),
    };
  }

  ActiveRoutine copyWith({
    String? id,
    String? phase,
    String? status,
    int? focusDurationSeconds,
    int? breakDurationSeconds,
    Value<int?> startedAtMicros = const Value.absent(),
    Value<int?> endsAtMicros = const Value.absent(),
    Value<int?> pausedRemainingSeconds = const Value.absent(),
    double? progress,
  }) => ActiveRoutine(
    id: id ?? this.id,
    phase: phase ?? this.phase,
    status: status ?? this.status,
    focusDurationSeconds: focusDurationSeconds ?? this.focusDurationSeconds,
    breakDurationSeconds: breakDurationSeconds ?? this.breakDurationSeconds,
    startedAtMicros: startedAtMicros.present
        ? startedAtMicros.value
        : this.startedAtMicros,
    endsAtMicros: endsAtMicros.present ? endsAtMicros.value : this.endsAtMicros,
    pausedRemainingSeconds: pausedRemainingSeconds.present
        ? pausedRemainingSeconds.value
        : this.pausedRemainingSeconds,
    progress: progress ?? this.progress,
  );
  ActiveRoutine copyWithCompanion(ActiveRoutinesCompanion data) {
    return ActiveRoutine(
      id: data.id.present ? data.id.value : this.id,
      phase: data.phase.present ? data.phase.value : this.phase,
      status: data.status.present ? data.status.value : this.status,
      focusDurationSeconds: data.focusDurationSeconds.present
          ? data.focusDurationSeconds.value
          : this.focusDurationSeconds,
      breakDurationSeconds: data.breakDurationSeconds.present
          ? data.breakDurationSeconds.value
          : this.breakDurationSeconds,
      startedAtMicros: data.startedAtMicros.present
          ? data.startedAtMicros.value
          : this.startedAtMicros,
      endsAtMicros: data.endsAtMicros.present
          ? data.endsAtMicros.value
          : this.endsAtMicros,
      pausedRemainingSeconds: data.pausedRemainingSeconds.present
          ? data.pausedRemainingSeconds.value
          : this.pausedRemainingSeconds,
      progress: data.progress.present ? data.progress.value : this.progress,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveRoutine(')
          ..write('id: $id, ')
          ..write('phase: $phase, ')
          ..write('status: $status, ')
          ..write('focusDurationSeconds: $focusDurationSeconds, ')
          ..write('breakDurationSeconds: $breakDurationSeconds, ')
          ..write('startedAtMicros: $startedAtMicros, ')
          ..write('endsAtMicros: $endsAtMicros, ')
          ..write('pausedRemainingSeconds: $pausedRemainingSeconds, ')
          ..write('progress: $progress')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phase,
    status,
    focusDurationSeconds,
    breakDurationSeconds,
    startedAtMicros,
    endsAtMicros,
    pausedRemainingSeconds,
    progress,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveRoutine &&
          other.id == this.id &&
          other.phase == this.phase &&
          other.status == this.status &&
          other.focusDurationSeconds == this.focusDurationSeconds &&
          other.breakDurationSeconds == this.breakDurationSeconds &&
          other.startedAtMicros == this.startedAtMicros &&
          other.endsAtMicros == this.endsAtMicros &&
          other.pausedRemainingSeconds == this.pausedRemainingSeconds &&
          other.progress == this.progress);
}

class ActiveRoutinesCompanion extends UpdateCompanion<ActiveRoutine> {
  final Value<String> id;
  final Value<String> phase;
  final Value<String> status;
  final Value<int> focusDurationSeconds;
  final Value<int> breakDurationSeconds;
  final Value<int?> startedAtMicros;
  final Value<int?> endsAtMicros;
  final Value<int?> pausedRemainingSeconds;
  final Value<double> progress;
  final Value<int> rowid;
  const ActiveRoutinesCompanion({
    this.id = const Value.absent(),
    this.phase = const Value.absent(),
    this.status = const Value.absent(),
    this.focusDurationSeconds = const Value.absent(),
    this.breakDurationSeconds = const Value.absent(),
    this.startedAtMicros = const Value.absent(),
    this.endsAtMicros = const Value.absent(),
    this.pausedRemainingSeconds = const Value.absent(),
    this.progress = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveRoutinesCompanion.insert({
    required String id,
    required String phase,
    required String status,
    required int focusDurationSeconds,
    required int breakDurationSeconds,
    this.startedAtMicros = const Value.absent(),
    this.endsAtMicros = const Value.absent(),
    this.pausedRemainingSeconds = const Value.absent(),
    required double progress,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phase = Value(phase),
       status = Value(status),
       focusDurationSeconds = Value(focusDurationSeconds),
       breakDurationSeconds = Value(breakDurationSeconds),
       progress = Value(progress);
  static Insertable<ActiveRoutine> custom({
    Expression<String>? id,
    Expression<String>? phase,
    Expression<String>? status,
    Expression<int>? focusDurationSeconds,
    Expression<int>? breakDurationSeconds,
    Expression<int>? startedAtMicros,
    Expression<int>? endsAtMicros,
    Expression<int>? pausedRemainingSeconds,
    Expression<double>? progress,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phase != null) 'phase': phase,
      if (status != null) 'status': status,
      if (focusDurationSeconds != null)
        'focus_duration_seconds': focusDurationSeconds,
      if (breakDurationSeconds != null)
        'break_duration_seconds': breakDurationSeconds,
      if (startedAtMicros != null) 'started_at_micros': startedAtMicros,
      if (endsAtMicros != null) 'ends_at_micros': endsAtMicros,
      if (pausedRemainingSeconds != null)
        'paused_remaining_seconds': pausedRemainingSeconds,
      if (progress != null) 'progress': progress,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveRoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? phase,
    Value<String>? status,
    Value<int>? focusDurationSeconds,
    Value<int>? breakDurationSeconds,
    Value<int?>? startedAtMicros,
    Value<int?>? endsAtMicros,
    Value<int?>? pausedRemainingSeconds,
    Value<double>? progress,
    Value<int>? rowid,
  }) {
    return ActiveRoutinesCompanion(
      id: id ?? this.id,
      phase: phase ?? this.phase,
      status: status ?? this.status,
      focusDurationSeconds: focusDurationSeconds ?? this.focusDurationSeconds,
      breakDurationSeconds: breakDurationSeconds ?? this.breakDurationSeconds,
      startedAtMicros: startedAtMicros ?? this.startedAtMicros,
      endsAtMicros: endsAtMicros ?? this.endsAtMicros,
      pausedRemainingSeconds:
          pausedRemainingSeconds ?? this.pausedRemainingSeconds,
      progress: progress ?? this.progress,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (focusDurationSeconds.present) {
      map['focus_duration_seconds'] = Variable<int>(focusDurationSeconds.value);
    }
    if (breakDurationSeconds.present) {
      map['break_duration_seconds'] = Variable<int>(breakDurationSeconds.value);
    }
    if (startedAtMicros.present) {
      map['started_at_micros'] = Variable<int>(startedAtMicros.value);
    }
    if (endsAtMicros.present) {
      map['ends_at_micros'] = Variable<int>(endsAtMicros.value);
    }
    if (pausedRemainingSeconds.present) {
      map['paused_remaining_seconds'] = Variable<int>(
        pausedRemainingSeconds.value,
      );
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveRoutinesCompanion(')
          ..write('id: $id, ')
          ..write('phase: $phase, ')
          ..write('status: $status, ')
          ..write('focusDurationSeconds: $focusDurationSeconds, ')
          ..write('breakDurationSeconds: $breakDurationSeconds, ')
          ..write('startedAtMicros: $startedAtMicros, ')
          ..write('endsAtMicros: $endsAtMicros, ')
          ..write('pausedRemainingSeconds: $pausedRemainingSeconds, ')
          ..write('progress: $progress, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnapshotsTable extends Snapshots
    with TableInfo<$SnapshotsTable, Snapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMicrosMeta = const VerificationMeta(
    'capturedAtMicros',
  );
  @override
  late final GeneratedColumn<int> capturedAtMicros = GeneratedColumn<int>(
    'captured_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskTitleMeta = const VerificationMeta(
    'taskTitle',
  );
  @override
  late final GeneratedColumn<String> taskTitle = GeneratedColumn<String>(
    'task_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    path,
    capturedAtMicros,
    routineId,
    taskTitle,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<Snapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('captured_at_micros')) {
      context.handle(
        _capturedAtMicrosMeta,
        capturedAtMicros.isAcceptableOrUnknown(
          data['captured_at_micros']!,
          _capturedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMicrosMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    }
    if (data.containsKey('task_title')) {
      context.handle(
        _taskTitleMeta,
        taskTitle.isAcceptableOrUnknown(data['task_title']!, _taskTitleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      capturedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}captured_at_micros'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      ),
      taskTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_title'],
      ),
    );
  }

  @override
  $SnapshotsTable createAlias(String alias) {
    return $SnapshotsTable(attachedDatabase, alias);
  }
}

class Snapshot extends DataClass implements Insertable<Snapshot> {
  final String id;
  final String path;
  final int capturedAtMicros;
  final String? routineId;
  final String? taskTitle;
  const Snapshot({
    required this.id,
    required this.path,
    required this.capturedAtMicros,
    this.routineId,
    this.taskTitle,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['path'] = Variable<String>(path);
    map['captured_at_micros'] = Variable<int>(capturedAtMicros);
    if (!nullToAbsent || routineId != null) {
      map['routine_id'] = Variable<String>(routineId);
    }
    if (!nullToAbsent || taskTitle != null) {
      map['task_title'] = Variable<String>(taskTitle);
    }
    return map;
  }

  SnapshotsCompanion toCompanion(bool nullToAbsent) {
    return SnapshotsCompanion(
      id: Value(id),
      path: Value(path),
      capturedAtMicros: Value(capturedAtMicros),
      routineId: routineId == null && nullToAbsent
          ? const Value.absent()
          : Value(routineId),
      taskTitle: taskTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(taskTitle),
    );
  }

  factory Snapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snapshot(
      id: serializer.fromJson<String>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      capturedAtMicros: serializer.fromJson<int>(json['capturedAtMicros']),
      routineId: serializer.fromJson<String?>(json['routineId']),
      taskTitle: serializer.fromJson<String?>(json['taskTitle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'path': serializer.toJson<String>(path),
      'capturedAtMicros': serializer.toJson<int>(capturedAtMicros),
      'routineId': serializer.toJson<String?>(routineId),
      'taskTitle': serializer.toJson<String?>(taskTitle),
    };
  }

  Snapshot copyWith({
    String? id,
    String? path,
    int? capturedAtMicros,
    Value<String?> routineId = const Value.absent(),
    Value<String?> taskTitle = const Value.absent(),
  }) => Snapshot(
    id: id ?? this.id,
    path: path ?? this.path,
    capturedAtMicros: capturedAtMicros ?? this.capturedAtMicros,
    routineId: routineId.present ? routineId.value : this.routineId,
    taskTitle: taskTitle.present ? taskTitle.value : this.taskTitle,
  );
  Snapshot copyWithCompanion(SnapshotsCompanion data) {
    return Snapshot(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      capturedAtMicros: data.capturedAtMicros.present
          ? data.capturedAtMicros.value
          : this.capturedAtMicros,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      taskTitle: data.taskTitle.present ? data.taskTitle.value : this.taskTitle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snapshot(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('capturedAtMicros: $capturedAtMicros, ')
          ..write('routineId: $routineId, ')
          ..write('taskTitle: $taskTitle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, path, capturedAtMicros, routineId, taskTitle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snapshot &&
          other.id == this.id &&
          other.path == this.path &&
          other.capturedAtMicros == this.capturedAtMicros &&
          other.routineId == this.routineId &&
          other.taskTitle == this.taskTitle);
}

class SnapshotsCompanion extends UpdateCompanion<Snapshot> {
  final Value<String> id;
  final Value<String> path;
  final Value<int> capturedAtMicros;
  final Value<String?> routineId;
  final Value<String?> taskTitle;
  final Value<int> rowid;
  const SnapshotsCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.capturedAtMicros = const Value.absent(),
    this.routineId = const Value.absent(),
    this.taskTitle = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnapshotsCompanion.insert({
    required String id,
    required String path,
    required int capturedAtMicros,
    this.routineId = const Value.absent(),
    this.taskTitle = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       path = Value(path),
       capturedAtMicros = Value(capturedAtMicros);
  static Insertable<Snapshot> custom({
    Expression<String>? id,
    Expression<String>? path,
    Expression<int>? capturedAtMicros,
    Expression<String>? routineId,
    Expression<String>? taskTitle,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (capturedAtMicros != null) 'captured_at_micros': capturedAtMicros,
      if (routineId != null) 'routine_id': routineId,
      if (taskTitle != null) 'task_title': taskTitle,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? path,
    Value<int>? capturedAtMicros,
    Value<String?>? routineId,
    Value<String?>? taskTitle,
    Value<int>? rowid,
  }) {
    return SnapshotsCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      capturedAtMicros: capturedAtMicros ?? this.capturedAtMicros,
      routineId: routineId ?? this.routineId,
      taskTitle: taskTitle ?? this.taskTitle,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (capturedAtMicros.present) {
      map['captured_at_micros'] = Variable<int>(capturedAtMicros.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (taskTitle.present) {
      map['task_title'] = Variable<String>(taskTitle.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('capturedAtMicros: $capturedAtMicros, ')
          ..write('routineId: $routineId, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<String> scheduledTime = GeneratedColumn<String>(
    'scheduled_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<String> repeat = GeneratedColumn<String>(
    'repeat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatUntilMeta = const VerificationMeta(
    'repeatUntil',
  );
  @override
  late final GeneratedColumn<String> repeatUntil = GeneratedColumn<String>(
    'repeat_until',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedDatesMeta = const VerificationMeta(
    'completedDates',
  );
  @override
  late final GeneratedColumn<String> completedDates = GeneratedColumn<String>(
    'completed_dates',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatDaysMeta = const VerificationMeta(
    'repeatDays',
  );
  @override
  late final GeneratedColumn<String> repeatDays = GeneratedColumn<String>(
    'repeat_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _repeatMonthDayMeta = const VerificationMeta(
    'repeatMonthDay',
  );
  @override
  late final GeneratedColumn<int> repeatMonthDay = GeneratedColumn<int>(
    'repeat_month_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    durationMinutes,
    type,
    color,
    scheduledTime,
    date,
    repeat,
    repeatUntil,
    completed,
    completedDates,
    position,
    goalId,
    repeatDays,
    repeatMonthDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('repeat')) {
      context.handle(
        _repeatMeta,
        repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatMeta);
    }
    if (data.containsKey('repeat_until')) {
      context.handle(
        _repeatUntilMeta,
        repeatUntil.isAcceptableOrUnknown(
          data['repeat_until']!,
          _repeatUntilMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('completed_dates')) {
      context.handle(
        _completedDatesMeta,
        completedDates.isAcceptableOrUnknown(
          data['completed_dates']!,
          _completedDatesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedDatesMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('repeat_days')) {
      context.handle(
        _repeatDaysMeta,
        repeatDays.isAcceptableOrUnknown(data['repeat_days']!, _repeatDaysMeta),
      );
    }
    if (data.containsKey('repeat_month_day')) {
      context.handle(
        _repeatMonthDayMeta,
        repeatMonthDay.isAcceptableOrUnknown(
          data['repeat_month_day']!,
          _repeatMonthDayMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_time'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      repeat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat'],
      )!,
      repeatUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_until'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      completedDates: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_dates'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      ),
      repeatDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_days'],
      )!,
      repeatMonthDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_month_day'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String title;
  final int durationMinutes;
  final String type;
  final String color;
  final String? scheduledTime;
  final String date;
  final String repeat;
  final String? repeatUntil;
  final bool completed;
  final String completedDates;
  final int position;
  final String? goalId;
  final String repeatDays;
  final int? repeatMonthDay;
  const Task({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.type,
    required this.color,
    this.scheduledTime,
    required this.date,
    required this.repeat,
    this.repeatUntil,
    required this.completed,
    required this.completedDates,
    required this.position,
    this.goalId,
    required this.repeatDays,
    this.repeatMonthDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['type'] = Variable<String>(type);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || scheduledTime != null) {
      map['scheduled_time'] = Variable<String>(scheduledTime);
    }
    map['date'] = Variable<String>(date);
    map['repeat'] = Variable<String>(repeat);
    if (!nullToAbsent || repeatUntil != null) {
      map['repeat_until'] = Variable<String>(repeatUntil);
    }
    map['completed'] = Variable<bool>(completed);
    map['completed_dates'] = Variable<String>(completedDates);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<String>(goalId);
    }
    map['repeat_days'] = Variable<String>(repeatDays);
    if (!nullToAbsent || repeatMonthDay != null) {
      map['repeat_month_day'] = Variable<int>(repeatMonthDay);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      durationMinutes: Value(durationMinutes),
      type: Value(type),
      color: Value(color),
      scheduledTime: scheduledTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledTime),
      date: Value(date),
      repeat: Value(repeat),
      repeatUntil: repeatUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatUntil),
      completed: Value(completed),
      completedDates: Value(completedDates),
      position: Value(position),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      repeatDays: Value(repeatDays),
      repeatMonthDay: repeatMonthDay == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatMonthDay),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      type: serializer.fromJson<String>(json['type']),
      color: serializer.fromJson<String>(json['color']),
      scheduledTime: serializer.fromJson<String?>(json['scheduledTime']),
      date: serializer.fromJson<String>(json['date']),
      repeat: serializer.fromJson<String>(json['repeat']),
      repeatUntil: serializer.fromJson<String?>(json['repeatUntil']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedDates: serializer.fromJson<String>(json['completedDates']),
      position: serializer.fromJson<int>(json['position']),
      goalId: serializer.fromJson<String?>(json['goalId']),
      repeatDays: serializer.fromJson<String>(json['repeatDays']),
      repeatMonthDay: serializer.fromJson<int?>(json['repeatMonthDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'type': serializer.toJson<String>(type),
      'color': serializer.toJson<String>(color),
      'scheduledTime': serializer.toJson<String?>(scheduledTime),
      'date': serializer.toJson<String>(date),
      'repeat': serializer.toJson<String>(repeat),
      'repeatUntil': serializer.toJson<String?>(repeatUntil),
      'completed': serializer.toJson<bool>(completed),
      'completedDates': serializer.toJson<String>(completedDates),
      'position': serializer.toJson<int>(position),
      'goalId': serializer.toJson<String?>(goalId),
      'repeatDays': serializer.toJson<String>(repeatDays),
      'repeatMonthDay': serializer.toJson<int?>(repeatMonthDay),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    int? durationMinutes,
    String? type,
    String? color,
    Value<String?> scheduledTime = const Value.absent(),
    String? date,
    String? repeat,
    Value<String?> repeatUntil = const Value.absent(),
    bool? completed,
    String? completedDates,
    int? position,
    Value<String?> goalId = const Value.absent(),
    String? repeatDays,
    Value<int?> repeatMonthDay = const Value.absent(),
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    type: type ?? this.type,
    color: color ?? this.color,
    scheduledTime: scheduledTime.present
        ? scheduledTime.value
        : this.scheduledTime,
    date: date ?? this.date,
    repeat: repeat ?? this.repeat,
    repeatUntil: repeatUntil.present ? repeatUntil.value : this.repeatUntil,
    completed: completed ?? this.completed,
    completedDates: completedDates ?? this.completedDates,
    position: position ?? this.position,
    goalId: goalId.present ? goalId.value : this.goalId,
    repeatDays: repeatDays ?? this.repeatDays,
    repeatMonthDay: repeatMonthDay.present
        ? repeatMonthDay.value
        : this.repeatMonthDay,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      type: data.type.present ? data.type.value : this.type,
      color: data.color.present ? data.color.value : this.color,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      date: data.date.present ? data.date.value : this.date,
      repeat: data.repeat.present ? data.repeat.value : this.repeat,
      repeatUntil: data.repeatUntil.present
          ? data.repeatUntil.value
          : this.repeatUntil,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedDates: data.completedDates.present
          ? data.completedDates.value
          : this.completedDates,
      position: data.position.present ? data.position.value : this.position,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      repeatDays: data.repeatDays.present
          ? data.repeatDays.value
          : this.repeatDays,
      repeatMonthDay: data.repeatMonthDay.present
          ? data.repeatMonthDay.value
          : this.repeatMonthDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('type: $type, ')
          ..write('color: $color, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('date: $date, ')
          ..write('repeat: $repeat, ')
          ..write('repeatUntil: $repeatUntil, ')
          ..write('completed: $completed, ')
          ..write('completedDates: $completedDates, ')
          ..write('position: $position, ')
          ..write('goalId: $goalId, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('repeatMonthDay: $repeatMonthDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    durationMinutes,
    type,
    color,
    scheduledTime,
    date,
    repeat,
    repeatUntil,
    completed,
    completedDates,
    position,
    goalId,
    repeatDays,
    repeatMonthDay,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.durationMinutes == this.durationMinutes &&
          other.type == this.type &&
          other.color == this.color &&
          other.scheduledTime == this.scheduledTime &&
          other.date == this.date &&
          other.repeat == this.repeat &&
          other.repeatUntil == this.repeatUntil &&
          other.completed == this.completed &&
          other.completedDates == this.completedDates &&
          other.position == this.position &&
          other.goalId == this.goalId &&
          other.repeatDays == this.repeatDays &&
          other.repeatMonthDay == this.repeatMonthDay);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> durationMinutes;
  final Value<String> type;
  final Value<String> color;
  final Value<String?> scheduledTime;
  final Value<String> date;
  final Value<String> repeat;
  final Value<String?> repeatUntil;
  final Value<bool> completed;
  final Value<String> completedDates;
  final Value<int> position;
  final Value<String?> goalId;
  final Value<String> repeatDays;
  final Value<int?> repeatMonthDay;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.type = const Value.absent(),
    this.color = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.date = const Value.absent(),
    this.repeat = const Value.absent(),
    this.repeatUntil = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedDates = const Value.absent(),
    this.position = const Value.absent(),
    this.goalId = const Value.absent(),
    this.repeatDays = const Value.absent(),
    this.repeatMonthDay = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    required int durationMinutes,
    required String type,
    required String color,
    this.scheduledTime = const Value.absent(),
    required String date,
    required String repeat,
    this.repeatUntil = const Value.absent(),
    this.completed = const Value.absent(),
    required String completedDates,
    required int position,
    this.goalId = const Value.absent(),
    this.repeatDays = const Value.absent(),
    this.repeatMonthDay = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       durationMinutes = Value(durationMinutes),
       type = Value(type),
       color = Value(color),
       date = Value(date),
       repeat = Value(repeat),
       completedDates = Value(completedDates),
       position = Value(position);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? durationMinutes,
    Expression<String>? type,
    Expression<String>? color,
    Expression<String>? scheduledTime,
    Expression<String>? date,
    Expression<String>? repeat,
    Expression<String>? repeatUntil,
    Expression<bool>? completed,
    Expression<String>? completedDates,
    Expression<int>? position,
    Expression<String>? goalId,
    Expression<String>? repeatDays,
    Expression<int>? repeatMonthDay,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (type != null) 'type': type,
      if (color != null) 'color': color,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (date != null) 'date': date,
      if (repeat != null) 'repeat': repeat,
      if (repeatUntil != null) 'repeat_until': repeatUntil,
      if (completed != null) 'completed': completed,
      if (completedDates != null) 'completed_dates': completedDates,
      if (position != null) 'position': position,
      if (goalId != null) 'goal_id': goalId,
      if (repeatDays != null) 'repeat_days': repeatDays,
      if (repeatMonthDay != null) 'repeat_month_day': repeatMonthDay,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<int>? durationMinutes,
    Value<String>? type,
    Value<String>? color,
    Value<String?>? scheduledTime,
    Value<String>? date,
    Value<String>? repeat,
    Value<String?>? repeatUntil,
    Value<bool>? completed,
    Value<String>? completedDates,
    Value<int>? position,
    Value<String?>? goalId,
    Value<String>? repeatDays,
    Value<int?>? repeatMonthDay,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      type: type ?? this.type,
      color: color ?? this.color,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      date: date ?? this.date,
      repeat: repeat ?? this.repeat,
      repeatUntil: repeatUntil ?? this.repeatUntil,
      completed: completed ?? this.completed,
      completedDates: completedDates ?? this.completedDates,
      position: position ?? this.position,
      goalId: goalId ?? this.goalId,
      repeatDays: repeatDays ?? this.repeatDays,
      repeatMonthDay: repeatMonthDay ?? this.repeatMonthDay,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<String>(scheduledTime.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(repeat.value);
    }
    if (repeatUntil.present) {
      map['repeat_until'] = Variable<String>(repeatUntil.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedDates.present) {
      map['completed_dates'] = Variable<String>(completedDates.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (repeatDays.present) {
      map['repeat_days'] = Variable<String>(repeatDays.value);
    }
    if (repeatMonthDay.present) {
      map['repeat_month_day'] = Variable<int>(repeatMonthDay.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('type: $type, ')
          ..write('color: $color, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('date: $date, ')
          ..write('repeat: $repeat, ')
          ..write('repeatUntil: $repeatUntil, ')
          ..write('completed: $completed, ')
          ..write('completedDates: $completedDates, ')
          ..write('position: $position, ')
          ..write('goalId: $goalId, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('repeatMonthDay: $repeatMonthDay, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PillarsTable extends Pillars with TableInfo<$PillarsTable, Pillar> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PillarsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, emoji];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pillars';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pillar> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pillar map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pillar(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
    );
  }

  @override
  $PillarsTable createAlias(String alias) {
    return $PillarsTable(attachedDatabase, alias);
  }
}

class Pillar extends DataClass implements Insertable<Pillar> {
  final String id;
  final String name;
  final String color;
  final String emoji;
  const Pillar({
    required this.id,
    required this.name,
    required this.color,
    required this.emoji,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['emoji'] = Variable<String>(emoji);
    return map;
  }

  PillarsCompanion toCompanion(bool nullToAbsent) {
    return PillarsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      emoji: Value(emoji),
    );
  }

  factory Pillar.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pillar(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      emoji: serializer.fromJson<String>(json['emoji']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'emoji': serializer.toJson<String>(emoji),
    };
  }

  Pillar copyWith({String? id, String? name, String? color, String? emoji}) =>
      Pillar(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        emoji: emoji ?? this.emoji,
      );
  Pillar copyWithCompanion(PillarsCompanion data) {
    return Pillar(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pillar(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('emoji: $emoji')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, emoji);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pillar &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.emoji == this.emoji);
}

class PillarsCompanion extends UpdateCompanion<Pillar> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> color;
  final Value<String> emoji;
  final Value<int> rowid;
  const PillarsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.emoji = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PillarsCompanion.insert({
    required String id,
    required String name,
    required String color,
    required String emoji,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       color = Value(color),
       emoji = Value(emoji);
  static Insertable<Pillar> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? emoji,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (emoji != null) 'emoji': emoji,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PillarsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? color,
    Value<String>? emoji,
    Value<int>? rowid,
  }) {
    return PillarsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      emoji: emoji ?? this.emoji,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PillarsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('emoji: $emoji, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pillarIdMeta = const VerificationMeta(
    'pillarId',
  );
  @override
  late final GeneratedColumn<String> pillarId = GeneratedColumn<String>(
    'pillar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metricTypeMeta = const VerificationMeta(
    'metricType',
  );
  @override
  late final GeneratedColumn<String> metricType = GeneratedColumn<String>(
    'metric_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('once'),
  );
  static const VerificationMeta _periodKeyMeta = const VerificationMeta(
    'periodKey',
  );
  @override
  late final GeneratedColumn<String> periodKey = GeneratedColumn<String>(
    'period_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('all'),
  );
  static const VerificationMeta _taskTitleMeta = const VerificationMeta(
    'taskTitle',
  );
  @override
  late final GeneratedColumn<String> taskTitle = GeneratedColumn<String>(
    'task_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskWeekdaysMeta = const VerificationMeta(
    'taskWeekdays',
  );
  @override
  late final GeneratedColumn<String> taskWeekdays = GeneratedColumn<String>(
    'task_weekdays',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _taskDurationMinutesMeta =
      const VerificationMeta('taskDurationMinutes');
  @override
  late final GeneratedColumn<int> taskDurationMinutes = GeneratedColumn<int>(
    'task_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _taskTimeMeta = const VerificationMeta(
    'taskTime',
  );
  @override
  late final GeneratedColumn<String> taskTime = GeneratedColumn<String>(
    'task_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMonthsMeta = const VerificationMeta(
    'durationMonths',
  );
  @override
  late final GeneratedColumn<int> durationMonths = GeneratedColumn<int>(
    'duration_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _durationWeeksMeta = const VerificationMeta(
    'durationWeeks',
  );
  @override
  late final GeneratedColumn<int> durationWeeks = GeneratedColumn<int>(
    'duration_weeks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationValueMeta = const VerificationMeta(
    'durationValue',
  );
  @override
  late final GeneratedColumn<int> durationValue = GeneratedColumn<int>(
    'duration_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _durationUnitMeta = const VerificationMeta(
    'durationUnit',
  );
  @override
  late final GeneratedColumn<String> durationUnit = GeneratedColumn<String>(
    'duration_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('month'),
  );
  static const VerificationMeta _startedOnMeta = const VerificationMeta(
    'startedOn',
  );
  @override
  late final GeneratedColumn<String> startedOn = GeneratedColumn<String>(
    'started_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskRepeatMeta = const VerificationMeta(
    'taskRepeat',
  );
  @override
  late final GeneratedColumn<String> taskRepeat = GeneratedColumn<String>(
    'task_repeat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('weekly'),
  );
  static const VerificationMeta _taskMonthDayMeta = const VerificationMeta(
    'taskMonthDay',
  );
  @override
  late final GeneratedColumn<int> taskMonthDay = GeneratedColumn<int>(
    'task_month_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pillarId,
    name,
    metricType,
    targetValue,
    currentValue,
    unit,
    period,
    periodKey,
    taskTitle,
    taskWeekdays,
    taskDurationMinutes,
    taskTime,
    durationMonths,
    durationWeeks,
    durationValue,
    durationUnit,
    startedOn,
    taskRepeat,
    taskMonthDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pillar_id')) {
      context.handle(
        _pillarIdMeta,
        pillarId.isAcceptableOrUnknown(data['pillar_id']!, _pillarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pillarIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('metric_type')) {
      context.handle(
        _metricTypeMeta,
        metricType.isAcceptableOrUnknown(data['metric_type']!, _metricTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_metricTypeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('period_key')) {
      context.handle(
        _periodKeyMeta,
        periodKey.isAcceptableOrUnknown(data['period_key']!, _periodKeyMeta),
      );
    }
    if (data.containsKey('task_title')) {
      context.handle(
        _taskTitleMeta,
        taskTitle.isAcceptableOrUnknown(data['task_title']!, _taskTitleMeta),
      );
    }
    if (data.containsKey('task_weekdays')) {
      context.handle(
        _taskWeekdaysMeta,
        taskWeekdays.isAcceptableOrUnknown(
          data['task_weekdays']!,
          _taskWeekdaysMeta,
        ),
      );
    }
    if (data.containsKey('task_duration_minutes')) {
      context.handle(
        _taskDurationMinutesMeta,
        taskDurationMinutes.isAcceptableOrUnknown(
          data['task_duration_minutes']!,
          _taskDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('task_time')) {
      context.handle(
        _taskTimeMeta,
        taskTime.isAcceptableOrUnknown(data['task_time']!, _taskTimeMeta),
      );
    }
    if (data.containsKey('duration_months')) {
      context.handle(
        _durationMonthsMeta,
        durationMonths.isAcceptableOrUnknown(
          data['duration_months']!,
          _durationMonthsMeta,
        ),
      );
    }
    if (data.containsKey('duration_weeks')) {
      context.handle(
        _durationWeeksMeta,
        durationWeeks.isAcceptableOrUnknown(
          data['duration_weeks']!,
          _durationWeeksMeta,
        ),
      );
    }
    if (data.containsKey('duration_value')) {
      context.handle(
        _durationValueMeta,
        durationValue.isAcceptableOrUnknown(
          data['duration_value']!,
          _durationValueMeta,
        ),
      );
    }
    if (data.containsKey('duration_unit')) {
      context.handle(
        _durationUnitMeta,
        durationUnit.isAcceptableOrUnknown(
          data['duration_unit']!,
          _durationUnitMeta,
        ),
      );
    }
    if (data.containsKey('started_on')) {
      context.handle(
        _startedOnMeta,
        startedOn.isAcceptableOrUnknown(data['started_on']!, _startedOnMeta),
      );
    }
    if (data.containsKey('task_repeat')) {
      context.handle(
        _taskRepeatMeta,
        taskRepeat.isAcceptableOrUnknown(data['task_repeat']!, _taskRepeatMeta),
      );
    }
    if (data.containsKey('task_month_day')) {
      context.handle(
        _taskMonthDayMeta,
        taskMonthDay.isAcceptableOrUnknown(
          data['task_month_day']!,
          _taskMonthDayMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pillarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pillar_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      metricType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric_type'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      )!,
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      periodKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_key'],
      )!,
      taskTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_title'],
      ),
      taskWeekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_weekdays'],
      )!,
      taskDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_duration_minutes'],
      )!,
      taskTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_time'],
      ),
      durationMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_months'],
      )!,
      durationWeeks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_weeks'],
      )!,
      durationValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_value'],
      )!,
      durationUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration_unit'],
      )!,
      startedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}started_on'],
      ),
      taskRepeat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_repeat'],
      )!,
      taskMonthDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_month_day'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String pillarId;
  final String name;
  final String metricType;
  final double targetValue;
  final double currentValue;
  final String unit;
  final String period;
  final String periodKey;
  final String? taskTitle;
  final String taskWeekdays;
  final int taskDurationMinutes;
  final String? taskTime;
  final int durationMonths;
  final int durationWeeks;
  final int durationValue;
  final String durationUnit;
  final String? startedOn;
  final String taskRepeat;
  final int taskMonthDay;
  const Goal({
    required this.id,
    required this.pillarId,
    required this.name,
    required this.metricType,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.period,
    required this.periodKey,
    this.taskTitle,
    required this.taskWeekdays,
    required this.taskDurationMinutes,
    this.taskTime,
    required this.durationMonths,
    required this.durationWeeks,
    required this.durationValue,
    required this.durationUnit,
    this.startedOn,
    required this.taskRepeat,
    required this.taskMonthDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pillar_id'] = Variable<String>(pillarId);
    map['name'] = Variable<String>(name);
    map['metric_type'] = Variable<String>(metricType);
    map['target_value'] = Variable<double>(targetValue);
    map['current_value'] = Variable<double>(currentValue);
    map['unit'] = Variable<String>(unit);
    map['period'] = Variable<String>(period);
    map['period_key'] = Variable<String>(periodKey);
    if (!nullToAbsent || taskTitle != null) {
      map['task_title'] = Variable<String>(taskTitle);
    }
    map['task_weekdays'] = Variable<String>(taskWeekdays);
    map['task_duration_minutes'] = Variable<int>(taskDurationMinutes);
    if (!nullToAbsent || taskTime != null) {
      map['task_time'] = Variable<String>(taskTime);
    }
    map['duration_months'] = Variable<int>(durationMonths);
    map['duration_weeks'] = Variable<int>(durationWeeks);
    map['duration_value'] = Variable<int>(durationValue);
    map['duration_unit'] = Variable<String>(durationUnit);
    if (!nullToAbsent || startedOn != null) {
      map['started_on'] = Variable<String>(startedOn);
    }
    map['task_repeat'] = Variable<String>(taskRepeat);
    map['task_month_day'] = Variable<int>(taskMonthDay);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      pillarId: Value(pillarId),
      name: Value(name),
      metricType: Value(metricType),
      targetValue: Value(targetValue),
      currentValue: Value(currentValue),
      unit: Value(unit),
      period: Value(period),
      periodKey: Value(periodKey),
      taskTitle: taskTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(taskTitle),
      taskWeekdays: Value(taskWeekdays),
      taskDurationMinutes: Value(taskDurationMinutes),
      taskTime: taskTime == null && nullToAbsent
          ? const Value.absent()
          : Value(taskTime),
      durationMonths: Value(durationMonths),
      durationWeeks: Value(durationWeeks),
      durationValue: Value(durationValue),
      durationUnit: Value(durationUnit),
      startedOn: startedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(startedOn),
      taskRepeat: Value(taskRepeat),
      taskMonthDay: Value(taskMonthDay),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      pillarId: serializer.fromJson<String>(json['pillarId']),
      name: serializer.fromJson<String>(json['name']),
      metricType: serializer.fromJson<String>(json['metricType']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      unit: serializer.fromJson<String>(json['unit']),
      period: serializer.fromJson<String>(json['period']),
      periodKey: serializer.fromJson<String>(json['periodKey']),
      taskTitle: serializer.fromJson<String?>(json['taskTitle']),
      taskWeekdays: serializer.fromJson<String>(json['taskWeekdays']),
      taskDurationMinutes: serializer.fromJson<int>(
        json['taskDurationMinutes'],
      ),
      taskTime: serializer.fromJson<String?>(json['taskTime']),
      durationMonths: serializer.fromJson<int>(json['durationMonths']),
      durationWeeks: serializer.fromJson<int>(json['durationWeeks']),
      durationValue: serializer.fromJson<int>(json['durationValue']),
      durationUnit: serializer.fromJson<String>(json['durationUnit']),
      startedOn: serializer.fromJson<String?>(json['startedOn']),
      taskRepeat: serializer.fromJson<String>(json['taskRepeat']),
      taskMonthDay: serializer.fromJson<int>(json['taskMonthDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pillarId': serializer.toJson<String>(pillarId),
      'name': serializer.toJson<String>(name),
      'metricType': serializer.toJson<String>(metricType),
      'targetValue': serializer.toJson<double>(targetValue),
      'currentValue': serializer.toJson<double>(currentValue),
      'unit': serializer.toJson<String>(unit),
      'period': serializer.toJson<String>(period),
      'periodKey': serializer.toJson<String>(periodKey),
      'taskTitle': serializer.toJson<String?>(taskTitle),
      'taskWeekdays': serializer.toJson<String>(taskWeekdays),
      'taskDurationMinutes': serializer.toJson<int>(taskDurationMinutes),
      'taskTime': serializer.toJson<String?>(taskTime),
      'durationMonths': serializer.toJson<int>(durationMonths),
      'durationWeeks': serializer.toJson<int>(durationWeeks),
      'durationValue': serializer.toJson<int>(durationValue),
      'durationUnit': serializer.toJson<String>(durationUnit),
      'startedOn': serializer.toJson<String?>(startedOn),
      'taskRepeat': serializer.toJson<String>(taskRepeat),
      'taskMonthDay': serializer.toJson<int>(taskMonthDay),
    };
  }

  Goal copyWith({
    String? id,
    String? pillarId,
    String? name,
    String? metricType,
    double? targetValue,
    double? currentValue,
    String? unit,
    String? period,
    String? periodKey,
    Value<String?> taskTitle = const Value.absent(),
    String? taskWeekdays,
    int? taskDurationMinutes,
    Value<String?> taskTime = const Value.absent(),
    int? durationMonths,
    int? durationWeeks,
    int? durationValue,
    String? durationUnit,
    Value<String?> startedOn = const Value.absent(),
    String? taskRepeat,
    int? taskMonthDay,
  }) => Goal(
    id: id ?? this.id,
    pillarId: pillarId ?? this.pillarId,
    name: name ?? this.name,
    metricType: metricType ?? this.metricType,
    targetValue: targetValue ?? this.targetValue,
    currentValue: currentValue ?? this.currentValue,
    unit: unit ?? this.unit,
    period: period ?? this.period,
    periodKey: periodKey ?? this.periodKey,
    taskTitle: taskTitle.present ? taskTitle.value : this.taskTitle,
    taskWeekdays: taskWeekdays ?? this.taskWeekdays,
    taskDurationMinutes: taskDurationMinutes ?? this.taskDurationMinutes,
    taskTime: taskTime.present ? taskTime.value : this.taskTime,
    durationMonths: durationMonths ?? this.durationMonths,
    durationWeeks: durationWeeks ?? this.durationWeeks,
    durationValue: durationValue ?? this.durationValue,
    durationUnit: durationUnit ?? this.durationUnit,
    startedOn: startedOn.present ? startedOn.value : this.startedOn,
    taskRepeat: taskRepeat ?? this.taskRepeat,
    taskMonthDay: taskMonthDay ?? this.taskMonthDay,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      pillarId: data.pillarId.present ? data.pillarId.value : this.pillarId,
      name: data.name.present ? data.name.value : this.name,
      metricType: data.metricType.present
          ? data.metricType.value
          : this.metricType,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      period: data.period.present ? data.period.value : this.period,
      periodKey: data.periodKey.present ? data.periodKey.value : this.periodKey,
      taskTitle: data.taskTitle.present ? data.taskTitle.value : this.taskTitle,
      taskWeekdays: data.taskWeekdays.present
          ? data.taskWeekdays.value
          : this.taskWeekdays,
      taskDurationMinutes: data.taskDurationMinutes.present
          ? data.taskDurationMinutes.value
          : this.taskDurationMinutes,
      taskTime: data.taskTime.present ? data.taskTime.value : this.taskTime,
      durationMonths: data.durationMonths.present
          ? data.durationMonths.value
          : this.durationMonths,
      durationWeeks: data.durationWeeks.present
          ? data.durationWeeks.value
          : this.durationWeeks,
      durationValue: data.durationValue.present
          ? data.durationValue.value
          : this.durationValue,
      durationUnit: data.durationUnit.present
          ? data.durationUnit.value
          : this.durationUnit,
      startedOn: data.startedOn.present ? data.startedOn.value : this.startedOn,
      taskRepeat: data.taskRepeat.present
          ? data.taskRepeat.value
          : this.taskRepeat,
      taskMonthDay: data.taskMonthDay.present
          ? data.taskMonthDay.value
          : this.taskMonthDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('pillarId: $pillarId, ')
          ..write('name: $name, ')
          ..write('metricType: $metricType, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('unit: $unit, ')
          ..write('period: $period, ')
          ..write('periodKey: $periodKey, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('taskWeekdays: $taskWeekdays, ')
          ..write('taskDurationMinutes: $taskDurationMinutes, ')
          ..write('taskTime: $taskTime, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('durationWeeks: $durationWeeks, ')
          ..write('durationValue: $durationValue, ')
          ..write('durationUnit: $durationUnit, ')
          ..write('startedOn: $startedOn, ')
          ..write('taskRepeat: $taskRepeat, ')
          ..write('taskMonthDay: $taskMonthDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pillarId,
    name,
    metricType,
    targetValue,
    currentValue,
    unit,
    period,
    periodKey,
    taskTitle,
    taskWeekdays,
    taskDurationMinutes,
    taskTime,
    durationMonths,
    durationWeeks,
    durationValue,
    durationUnit,
    startedOn,
    taskRepeat,
    taskMonthDay,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.pillarId == this.pillarId &&
          other.name == this.name &&
          other.metricType == this.metricType &&
          other.targetValue == this.targetValue &&
          other.currentValue == this.currentValue &&
          other.unit == this.unit &&
          other.period == this.period &&
          other.periodKey == this.periodKey &&
          other.taskTitle == this.taskTitle &&
          other.taskWeekdays == this.taskWeekdays &&
          other.taskDurationMinutes == this.taskDurationMinutes &&
          other.taskTime == this.taskTime &&
          other.durationMonths == this.durationMonths &&
          other.durationWeeks == this.durationWeeks &&
          other.durationValue == this.durationValue &&
          other.durationUnit == this.durationUnit &&
          other.startedOn == this.startedOn &&
          other.taskRepeat == this.taskRepeat &&
          other.taskMonthDay == this.taskMonthDay);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> pillarId;
  final Value<String> name;
  final Value<String> metricType;
  final Value<double> targetValue;
  final Value<double> currentValue;
  final Value<String> unit;
  final Value<String> period;
  final Value<String> periodKey;
  final Value<String?> taskTitle;
  final Value<String> taskWeekdays;
  final Value<int> taskDurationMinutes;
  final Value<String?> taskTime;
  final Value<int> durationMonths;
  final Value<int> durationWeeks;
  final Value<int> durationValue;
  final Value<String> durationUnit;
  final Value<String?> startedOn;
  final Value<String> taskRepeat;
  final Value<int> taskMonthDay;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.pillarId = const Value.absent(),
    this.name = const Value.absent(),
    this.metricType = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.period = const Value.absent(),
    this.periodKey = const Value.absent(),
    this.taskTitle = const Value.absent(),
    this.taskWeekdays = const Value.absent(),
    this.taskDurationMinutes = const Value.absent(),
    this.taskTime = const Value.absent(),
    this.durationMonths = const Value.absent(),
    this.durationWeeks = const Value.absent(),
    this.durationValue = const Value.absent(),
    this.durationUnit = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.taskRepeat = const Value.absent(),
    this.taskMonthDay = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String pillarId,
    required String name,
    required String metricType,
    required double targetValue,
    this.currentValue = const Value.absent(),
    required String unit,
    this.period = const Value.absent(),
    this.periodKey = const Value.absent(),
    this.taskTitle = const Value.absent(),
    this.taskWeekdays = const Value.absent(),
    this.taskDurationMinutes = const Value.absent(),
    this.taskTime = const Value.absent(),
    this.durationMonths = const Value.absent(),
    this.durationWeeks = const Value.absent(),
    this.durationValue = const Value.absent(),
    this.durationUnit = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.taskRepeat = const Value.absent(),
    this.taskMonthDay = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pillarId = Value(pillarId),
       name = Value(name),
       metricType = Value(metricType),
       targetValue = Value(targetValue),
       unit = Value(unit);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? pillarId,
    Expression<String>? name,
    Expression<String>? metricType,
    Expression<double>? targetValue,
    Expression<double>? currentValue,
    Expression<String>? unit,
    Expression<String>? period,
    Expression<String>? periodKey,
    Expression<String>? taskTitle,
    Expression<String>? taskWeekdays,
    Expression<int>? taskDurationMinutes,
    Expression<String>? taskTime,
    Expression<int>? durationMonths,
    Expression<int>? durationWeeks,
    Expression<int>? durationValue,
    Expression<String>? durationUnit,
    Expression<String>? startedOn,
    Expression<String>? taskRepeat,
    Expression<int>? taskMonthDay,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pillarId != null) 'pillar_id': pillarId,
      if (name != null) 'name': name,
      if (metricType != null) 'metric_type': metricType,
      if (targetValue != null) 'target_value': targetValue,
      if (currentValue != null) 'current_value': currentValue,
      if (unit != null) 'unit': unit,
      if (period != null) 'period': period,
      if (periodKey != null) 'period_key': periodKey,
      if (taskTitle != null) 'task_title': taskTitle,
      if (taskWeekdays != null) 'task_weekdays': taskWeekdays,
      if (taskDurationMinutes != null)
        'task_duration_minutes': taskDurationMinutes,
      if (taskTime != null) 'task_time': taskTime,
      if (durationMonths != null) 'duration_months': durationMonths,
      if (durationWeeks != null) 'duration_weeks': durationWeeks,
      if (durationValue != null) 'duration_value': durationValue,
      if (durationUnit != null) 'duration_unit': durationUnit,
      if (startedOn != null) 'started_on': startedOn,
      if (taskRepeat != null) 'task_repeat': taskRepeat,
      if (taskMonthDay != null) 'task_month_day': taskMonthDay,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? pillarId,
    Value<String>? name,
    Value<String>? metricType,
    Value<double>? targetValue,
    Value<double>? currentValue,
    Value<String>? unit,
    Value<String>? period,
    Value<String>? periodKey,
    Value<String?>? taskTitle,
    Value<String>? taskWeekdays,
    Value<int>? taskDurationMinutes,
    Value<String?>? taskTime,
    Value<int>? durationMonths,
    Value<int>? durationWeeks,
    Value<int>? durationValue,
    Value<String>? durationUnit,
    Value<String?>? startedOn,
    Value<String>? taskRepeat,
    Value<int>? taskMonthDay,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      pillarId: pillarId ?? this.pillarId,
      name: name ?? this.name,
      metricType: metricType ?? this.metricType,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      period: period ?? this.period,
      periodKey: periodKey ?? this.periodKey,
      taskTitle: taskTitle ?? this.taskTitle,
      taskWeekdays: taskWeekdays ?? this.taskWeekdays,
      taskDurationMinutes: taskDurationMinutes ?? this.taskDurationMinutes,
      taskTime: taskTime ?? this.taskTime,
      durationMonths: durationMonths ?? this.durationMonths,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      durationValue: durationValue ?? this.durationValue,
      durationUnit: durationUnit ?? this.durationUnit,
      startedOn: startedOn ?? this.startedOn,
      taskRepeat: taskRepeat ?? this.taskRepeat,
      taskMonthDay: taskMonthDay ?? this.taskMonthDay,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pillarId.present) {
      map['pillar_id'] = Variable<String>(pillarId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (metricType.present) {
      map['metric_type'] = Variable<String>(metricType.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (periodKey.present) {
      map['period_key'] = Variable<String>(periodKey.value);
    }
    if (taskTitle.present) {
      map['task_title'] = Variable<String>(taskTitle.value);
    }
    if (taskWeekdays.present) {
      map['task_weekdays'] = Variable<String>(taskWeekdays.value);
    }
    if (taskDurationMinutes.present) {
      map['task_duration_minutes'] = Variable<int>(taskDurationMinutes.value);
    }
    if (taskTime.present) {
      map['task_time'] = Variable<String>(taskTime.value);
    }
    if (durationMonths.present) {
      map['duration_months'] = Variable<int>(durationMonths.value);
    }
    if (durationWeeks.present) {
      map['duration_weeks'] = Variable<int>(durationWeeks.value);
    }
    if (durationValue.present) {
      map['duration_value'] = Variable<int>(durationValue.value);
    }
    if (durationUnit.present) {
      map['duration_unit'] = Variable<String>(durationUnit.value);
    }
    if (startedOn.present) {
      map['started_on'] = Variable<String>(startedOn.value);
    }
    if (taskRepeat.present) {
      map['task_repeat'] = Variable<String>(taskRepeat.value);
    }
    if (taskMonthDay.present) {
      map['task_month_day'] = Variable<int>(taskMonthDay.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('pillarId: $pillarId, ')
          ..write('name: $name, ')
          ..write('metricType: $metricType, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('unit: $unit, ')
          ..write('period: $period, ')
          ..write('periodKey: $periodKey, ')
          ..write('taskTitle: $taskTitle, ')
          ..write('taskWeekdays: $taskWeekdays, ')
          ..write('taskDurationMinutes: $taskDurationMinutes, ')
          ..write('taskTime: $taskTime, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('durationWeeks: $durationWeeks, ')
          ..write('durationValue: $durationValue, ')
          ..write('durationUnit: $durationUnit, ')
          ..write('startedOn: $startedOn, ')
          ..write('taskRepeat: $taskRepeat, ')
          ..write('taskMonthDay: $taskMonthDay, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActiveRoutinesTable activeRoutines = $ActiveRoutinesTable(this);
  late final $SnapshotsTable snapshots = $SnapshotsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $PillarsTable pillars = $PillarsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    activeRoutines,
    snapshots,
    tasks,
    pillars,
    goals,
  ];
}

typedef $$ActiveRoutinesTableCreateCompanionBuilder =
    ActiveRoutinesCompanion Function({
      required String id,
      required String phase,
      required String status,
      required int focusDurationSeconds,
      required int breakDurationSeconds,
      Value<int?> startedAtMicros,
      Value<int?> endsAtMicros,
      Value<int?> pausedRemainingSeconds,
      required double progress,
      Value<int> rowid,
    });
typedef $$ActiveRoutinesTableUpdateCompanionBuilder =
    ActiveRoutinesCompanion Function({
      Value<String> id,
      Value<String> phase,
      Value<String> status,
      Value<int> focusDurationSeconds,
      Value<int> breakDurationSeconds,
      Value<int?> startedAtMicros,
      Value<int?> endsAtMicros,
      Value<int?> pausedRemainingSeconds,
      Value<double> progress,
      Value<int> rowid,
    });

class $$ActiveRoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveRoutinesTable> {
  $$ActiveRoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusDurationSeconds => $composableBuilder(
    column: $table.focusDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakDurationSeconds => $composableBuilder(
    column: $table.breakDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtMicros => $composableBuilder(
    column: $table.startedAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endsAtMicros => $composableBuilder(
    column: $table.endsAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pausedRemainingSeconds => $composableBuilder(
    column: $table.pausedRemainingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveRoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveRoutinesTable> {
  $$ActiveRoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusDurationSeconds => $composableBuilder(
    column: $table.focusDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakDurationSeconds => $composableBuilder(
    column: $table.breakDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtMicros => $composableBuilder(
    column: $table.startedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endsAtMicros => $composableBuilder(
    column: $table.endsAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pausedRemainingSeconds => $composableBuilder(
    column: $table.pausedRemainingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveRoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveRoutinesTable> {
  $$ActiveRoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get focusDurationSeconds => $composableBuilder(
    column: $table.focusDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breakDurationSeconds => $composableBuilder(
    column: $table.breakDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAtMicros => $composableBuilder(
    column: $table.startedAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endsAtMicros => $composableBuilder(
    column: $table.endsAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pausedRemainingSeconds => $composableBuilder(
    column: $table.pausedRemainingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);
}

class $$ActiveRoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveRoutinesTable,
          ActiveRoutine,
          $$ActiveRoutinesTableFilterComposer,
          $$ActiveRoutinesTableOrderingComposer,
          $$ActiveRoutinesTableAnnotationComposer,
          $$ActiveRoutinesTableCreateCompanionBuilder,
          $$ActiveRoutinesTableUpdateCompanionBuilder,
          (
            ActiveRoutine,
            BaseReferences<_$AppDatabase, $ActiveRoutinesTable, ActiveRoutine>,
          ),
          ActiveRoutine,
          PrefetchHooks Function()
        > {
  $$ActiveRoutinesTableTableManager(
    _$AppDatabase db,
    $ActiveRoutinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveRoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveRoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveRoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> focusDurationSeconds = const Value.absent(),
                Value<int> breakDurationSeconds = const Value.absent(),
                Value<int?> startedAtMicros = const Value.absent(),
                Value<int?> endsAtMicros = const Value.absent(),
                Value<int?> pausedRemainingSeconds = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveRoutinesCompanion(
                id: id,
                phase: phase,
                status: status,
                focusDurationSeconds: focusDurationSeconds,
                breakDurationSeconds: breakDurationSeconds,
                startedAtMicros: startedAtMicros,
                endsAtMicros: endsAtMicros,
                pausedRemainingSeconds: pausedRemainingSeconds,
                progress: progress,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phase,
                required String status,
                required int focusDurationSeconds,
                required int breakDurationSeconds,
                Value<int?> startedAtMicros = const Value.absent(),
                Value<int?> endsAtMicros = const Value.absent(),
                Value<int?> pausedRemainingSeconds = const Value.absent(),
                required double progress,
                Value<int> rowid = const Value.absent(),
              }) => ActiveRoutinesCompanion.insert(
                id: id,
                phase: phase,
                status: status,
                focusDurationSeconds: focusDurationSeconds,
                breakDurationSeconds: breakDurationSeconds,
                startedAtMicros: startedAtMicros,
                endsAtMicros: endsAtMicros,
                pausedRemainingSeconds: pausedRemainingSeconds,
                progress: progress,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveRoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveRoutinesTable,
      ActiveRoutine,
      $$ActiveRoutinesTableFilterComposer,
      $$ActiveRoutinesTableOrderingComposer,
      $$ActiveRoutinesTableAnnotationComposer,
      $$ActiveRoutinesTableCreateCompanionBuilder,
      $$ActiveRoutinesTableUpdateCompanionBuilder,
      (
        ActiveRoutine,
        BaseReferences<_$AppDatabase, $ActiveRoutinesTable, ActiveRoutine>,
      ),
      ActiveRoutine,
      PrefetchHooks Function()
    >;
typedef $$SnapshotsTableCreateCompanionBuilder =
    SnapshotsCompanion Function({
      required String id,
      required String path,
      required int capturedAtMicros,
      Value<String?> routineId,
      Value<String?> taskTitle,
      Value<int> rowid,
    });
typedef $$SnapshotsTableUpdateCompanionBuilder =
    SnapshotsCompanion Function({
      Value<String> id,
      Value<String> path,
      Value<int> capturedAtMicros,
      Value<String?> routineId,
      Value<String?> taskTitle,
      Value<int> rowid,
    });

class $$SnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capturedAtMicros => $composableBuilder(
    column: $table.capturedAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capturedAtMicros => $composableBuilder(
    column: $table.capturedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get capturedAtMicros => $composableBuilder(
    column: $table.capturedAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get routineId =>
      $composableBuilder(column: $table.routineId, builder: (column) => column);

  GeneratedColumn<String> get taskTitle =>
      $composableBuilder(column: $table.taskTitle, builder: (column) => column);
}

class $$SnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnapshotsTable,
          Snapshot,
          $$SnapshotsTableFilterComposer,
          $$SnapshotsTableOrderingComposer,
          $$SnapshotsTableAnnotationComposer,
          $$SnapshotsTableCreateCompanionBuilder,
          $$SnapshotsTableUpdateCompanionBuilder,
          (Snapshot, BaseReferences<_$AppDatabase, $SnapshotsTable, Snapshot>),
          Snapshot,
          PrefetchHooks Function()
        > {
  $$SnapshotsTableTableManager(_$AppDatabase db, $SnapshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> capturedAtMicros = const Value.absent(),
                Value<String?> routineId = const Value.absent(),
                Value<String?> taskTitle = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnapshotsCompanion(
                id: id,
                path: path,
                capturedAtMicros: capturedAtMicros,
                routineId: routineId,
                taskTitle: taskTitle,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String path,
                required int capturedAtMicros,
                Value<String?> routineId = const Value.absent(),
                Value<String?> taskTitle = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnapshotsCompanion.insert(
                id: id,
                path: path,
                capturedAtMicros: capturedAtMicros,
                routineId: routineId,
                taskTitle: taskTitle,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnapshotsTable,
      Snapshot,
      $$SnapshotsTableFilterComposer,
      $$SnapshotsTableOrderingComposer,
      $$SnapshotsTableAnnotationComposer,
      $$SnapshotsTableCreateCompanionBuilder,
      $$SnapshotsTableUpdateCompanionBuilder,
      (Snapshot, BaseReferences<_$AppDatabase, $SnapshotsTable, Snapshot>),
      Snapshot,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String title,
      required int durationMinutes,
      required String type,
      required String color,
      Value<String?> scheduledTime,
      required String date,
      required String repeat,
      Value<String?> repeatUntil,
      Value<bool> completed,
      required String completedDates,
      required int position,
      Value<String?> goalId,
      Value<String> repeatDays,
      Value<int?> repeatMonthDay,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<int> durationMinutes,
      Value<String> type,
      Value<String> color,
      Value<String?> scheduledTime,
      Value<String> date,
      Value<String> repeat,
      Value<String?> repeatUntil,
      Value<bool> completed,
      Value<String> completedDates,
      Value<int> position,
      Value<String?> goalId,
      Value<String> repeatDays,
      Value<int?> repeatMonthDay,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatUntil => $composableBuilder(
    column: $table.repeatUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedDates => $composableBuilder(
    column: $table.completedDates,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatMonthDay => $composableBuilder(
    column: $table.repeatMonthDay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatUntil => $composableBuilder(
    column: $table.repeatUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedDates => $composableBuilder(
    column: $table.completedDates,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatMonthDay => $composableBuilder(
    column: $table.repeatMonthDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get repeat =>
      $composableBuilder(column: $table.repeat, builder: (column) => column);

  GeneratedColumn<String> get repeatUntil => $composableBuilder(
    column: $table.repeatUntil,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get completedDates => $composableBuilder(
    column: $table.completedDates,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatMonthDay => $composableBuilder(
    column: $table.repeatMonthDay,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> scheduledTime = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> repeat = const Value.absent(),
                Value<String?> repeatUntil = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String> completedDates = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> goalId = const Value.absent(),
                Value<String> repeatDays = const Value.absent(),
                Value<int?> repeatMonthDay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                durationMinutes: durationMinutes,
                type: type,
                color: color,
                scheduledTime: scheduledTime,
                date: date,
                repeat: repeat,
                repeatUntil: repeatUntil,
                completed: completed,
                completedDates: completedDates,
                position: position,
                goalId: goalId,
                repeatDays: repeatDays,
                repeatMonthDay: repeatMonthDay,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required int durationMinutes,
                required String type,
                required String color,
                Value<String?> scheduledTime = const Value.absent(),
                required String date,
                required String repeat,
                Value<String?> repeatUntil = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                required String completedDates,
                required int position,
                Value<String?> goalId = const Value.absent(),
                Value<String> repeatDays = const Value.absent(),
                Value<int?> repeatMonthDay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                durationMinutes: durationMinutes,
                type: type,
                color: color,
                scheduledTime: scheduledTime,
                date: date,
                repeat: repeat,
                repeatUntil: repeatUntil,
                completed: completed,
                completedDates: completedDates,
                position: position,
                goalId: goalId,
                repeatDays: repeatDays,
                repeatMonthDay: repeatMonthDay,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$PillarsTableCreateCompanionBuilder =
    PillarsCompanion Function({
      required String id,
      required String name,
      required String color,
      required String emoji,
      Value<int> rowid,
    });
typedef $$PillarsTableUpdateCompanionBuilder =
    PillarsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> color,
      Value<String> emoji,
      Value<int> rowid,
    });

class $$PillarsTableFilterComposer
    extends Composer<_$AppDatabase, $PillarsTable> {
  $$PillarsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PillarsTableOrderingComposer
    extends Composer<_$AppDatabase, $PillarsTable> {
  $$PillarsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PillarsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PillarsTable> {
  $$PillarsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);
}

class $$PillarsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PillarsTable,
          Pillar,
          $$PillarsTableFilterComposer,
          $$PillarsTableOrderingComposer,
          $$PillarsTableAnnotationComposer,
          $$PillarsTableCreateCompanionBuilder,
          $$PillarsTableUpdateCompanionBuilder,
          (Pillar, BaseReferences<_$AppDatabase, $PillarsTable, Pillar>),
          Pillar,
          PrefetchHooks Function()
        > {
  $$PillarsTableTableManager(_$AppDatabase db, $PillarsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PillarsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PillarsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PillarsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PillarsCompanion(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String color,
                required String emoji,
                Value<int> rowid = const Value.absent(),
              }) => PillarsCompanion.insert(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PillarsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PillarsTable,
      Pillar,
      $$PillarsTableFilterComposer,
      $$PillarsTableOrderingComposer,
      $$PillarsTableAnnotationComposer,
      $$PillarsTableCreateCompanionBuilder,
      $$PillarsTableUpdateCompanionBuilder,
      (Pillar, BaseReferences<_$AppDatabase, $PillarsTable, Pillar>),
      Pillar,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      required String id,
      required String pillarId,
      required String name,
      required String metricType,
      required double targetValue,
      Value<double> currentValue,
      required String unit,
      Value<String> period,
      Value<String> periodKey,
      Value<String?> taskTitle,
      Value<String> taskWeekdays,
      Value<int> taskDurationMinutes,
      Value<String?> taskTime,
      Value<int> durationMonths,
      Value<int> durationWeeks,
      Value<int> durationValue,
      Value<String> durationUnit,
      Value<String?> startedOn,
      Value<String> taskRepeat,
      Value<int> taskMonthDay,
      Value<int> rowid,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<String> id,
      Value<String> pillarId,
      Value<String> name,
      Value<String> metricType,
      Value<double> targetValue,
      Value<double> currentValue,
      Value<String> unit,
      Value<String> period,
      Value<String> periodKey,
      Value<String?> taskTitle,
      Value<String> taskWeekdays,
      Value<int> taskDurationMinutes,
      Value<String?> taskTime,
      Value<int> durationMonths,
      Value<int> durationWeeks,
      Value<int> durationValue,
      Value<String> durationUnit,
      Value<String?> startedOn,
      Value<String> taskRepeat,
      Value<int> taskMonthDay,
      Value<int> rowid,
    });

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pillarId => $composableBuilder(
    column: $table.pillarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodKey => $composableBuilder(
    column: $table.periodKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskWeekdays => $composableBuilder(
    column: $table.taskWeekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskDurationMinutes => $composableBuilder(
    column: $table.taskDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskTime => $composableBuilder(
    column: $table.taskTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationWeeks => $composableBuilder(
    column: $table.durationWeeks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationValue => $composableBuilder(
    column: $table.durationValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskRepeat => $composableBuilder(
    column: $table.taskRepeat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskMonthDay => $composableBuilder(
    column: $table.taskMonthDay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pillarId => $composableBuilder(
    column: $table.pillarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodKey => $composableBuilder(
    column: $table.periodKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskTitle => $composableBuilder(
    column: $table.taskTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskWeekdays => $composableBuilder(
    column: $table.taskWeekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskDurationMinutes => $composableBuilder(
    column: $table.taskDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskTime => $composableBuilder(
    column: $table.taskTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationWeeks => $composableBuilder(
    column: $table.durationWeeks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationValue => $composableBuilder(
    column: $table.durationValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskRepeat => $composableBuilder(
    column: $table.taskRepeat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskMonthDay => $composableBuilder(
    column: $table.taskMonthDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pillarId =>
      $composableBuilder(column: $table.pillarId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get metricType => $composableBuilder(
    column: $table.metricType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get periodKey =>
      $composableBuilder(column: $table.periodKey, builder: (column) => column);

  GeneratedColumn<String> get taskTitle =>
      $composableBuilder(column: $table.taskTitle, builder: (column) => column);

  GeneratedColumn<String> get taskWeekdays => $composableBuilder(
    column: $table.taskWeekdays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taskDurationMinutes => $composableBuilder(
    column: $table.taskDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskTime =>
      $composableBuilder(column: $table.taskTime, builder: (column) => column);

  GeneratedColumn<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationWeeks => $composableBuilder(
    column: $table.durationWeeks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationValue => $composableBuilder(
    column: $table.durationValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get durationUnit => $composableBuilder(
    column: $table.durationUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startedOn =>
      $composableBuilder(column: $table.startedOn, builder: (column) => column);

  GeneratedColumn<String> get taskRepeat => $composableBuilder(
    column: $table.taskRepeat,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taskMonthDay => $composableBuilder(
    column: $table.taskMonthDay,
    builder: (column) => column,
  );
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pillarId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> metricType = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<double> currentValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<String> periodKey = const Value.absent(),
                Value<String?> taskTitle = const Value.absent(),
                Value<String> taskWeekdays = const Value.absent(),
                Value<int> taskDurationMinutes = const Value.absent(),
                Value<String?> taskTime = const Value.absent(),
                Value<int> durationMonths = const Value.absent(),
                Value<int> durationWeeks = const Value.absent(),
                Value<int> durationValue = const Value.absent(),
                Value<String> durationUnit = const Value.absent(),
                Value<String?> startedOn = const Value.absent(),
                Value<String> taskRepeat = const Value.absent(),
                Value<int> taskMonthDay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                pillarId: pillarId,
                name: name,
                metricType: metricType,
                targetValue: targetValue,
                currentValue: currentValue,
                unit: unit,
                period: period,
                periodKey: periodKey,
                taskTitle: taskTitle,
                taskWeekdays: taskWeekdays,
                taskDurationMinutes: taskDurationMinutes,
                taskTime: taskTime,
                durationMonths: durationMonths,
                durationWeeks: durationWeeks,
                durationValue: durationValue,
                durationUnit: durationUnit,
                startedOn: startedOn,
                taskRepeat: taskRepeat,
                taskMonthDay: taskMonthDay,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pillarId,
                required String name,
                required String metricType,
                required double targetValue,
                Value<double> currentValue = const Value.absent(),
                required String unit,
                Value<String> period = const Value.absent(),
                Value<String> periodKey = const Value.absent(),
                Value<String?> taskTitle = const Value.absent(),
                Value<String> taskWeekdays = const Value.absent(),
                Value<int> taskDurationMinutes = const Value.absent(),
                Value<String?> taskTime = const Value.absent(),
                Value<int> durationMonths = const Value.absent(),
                Value<int> durationWeeks = const Value.absent(),
                Value<int> durationValue = const Value.absent(),
                Value<String> durationUnit = const Value.absent(),
                Value<String?> startedOn = const Value.absent(),
                Value<String> taskRepeat = const Value.absent(),
                Value<int> taskMonthDay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                pillarId: pillarId,
                name: name,
                metricType: metricType,
                targetValue: targetValue,
                currentValue: currentValue,
                unit: unit,
                period: period,
                periodKey: periodKey,
                taskTitle: taskTitle,
                taskWeekdays: taskWeekdays,
                taskDurationMinutes: taskDurationMinutes,
                taskTime: taskTime,
                durationMonths: durationMonths,
                durationWeeks: durationWeeks,
                durationValue: durationValue,
                durationUnit: durationUnit,
                startedOn: startedOn,
                taskRepeat: taskRepeat,
                taskMonthDay: taskMonthDay,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
      Goal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActiveRoutinesTableTableManager get activeRoutines =>
      $$ActiveRoutinesTableTableManager(_db, _db.activeRoutines);
  $$SnapshotsTableTableManager get snapshots =>
      $$SnapshotsTableTableManager(_db, _db.snapshots);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$PillarsTableTableManager get pillars =>
      $$PillarsTableTableManager(_db, _db.pillars);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
}
