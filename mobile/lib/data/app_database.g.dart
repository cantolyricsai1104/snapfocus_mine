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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActiveRoutinesTable activeRoutines = $ActiveRoutinesTable(this);
  late final $SnapshotsTable snapshots = $SnapshotsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    activeRoutines,
    snapshots,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActiveRoutinesTableTableManager get activeRoutines =>
      $$ActiveRoutinesTableTableManager(_db, _db.activeRoutines);
  $$SnapshotsTableTableManager get snapshots =>
      $$SnapshotsTableTableManager(_db, _db.snapshots);
}
