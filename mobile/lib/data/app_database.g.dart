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
          ..write('position: $position')
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
          other.position == this.position);
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    activeRoutines,
    snapshots,
    tasks,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActiveRoutinesTableTableManager get activeRoutines =>
      $$ActiveRoutinesTableTableManager(_db, _db.activeRoutines);
  $$SnapshotsTableTableManager get snapshots =>
      $$SnapshotsTableTableManager(_db, _db.snapshots);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
}
