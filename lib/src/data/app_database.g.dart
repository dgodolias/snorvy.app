// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SleepNightRowsTable extends SleepNightRows
    with TableInfo<$SleepNightRowsTable, SleepNightRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepNightRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snoreScoreMeta = const VerificationMeta(
    'snoreScore',
  );
  @override
  late final GeneratedColumn<int> snoreScore = GeneratedColumn<int>(
    'snore_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isManualMeta = const VerificationMeta(
    'isManual',
  );
  @override
  late final GeneratedColumn<bool> isManual = GeneratedColumn<bool>(
    'is_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    startedAt,
    endedAt,
    snoreScore,
    isManual,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_night_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepNightRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('snore_score')) {
      context.handle(
        _snoreScoreMeta,
        snoreScore.isAcceptableOrUnknown(data['snore_score']!, _snoreScoreMeta),
      );
    }
    if (data.containsKey('is_manual')) {
      context.handle(
        _isManualMeta,
        isManual.isAcceptableOrUnknown(data['is_manual']!, _isManualMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepNightRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepNightRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      snoreScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snore_score'],
      )!,
      isManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_manual'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SleepNightRowsTable createAlias(String alias) {
    return $SleepNightRowsTable(attachedDatabase, alias);
  }
}

class SleepNightRow extends DataClass implements Insertable<SleepNightRow> {
  final int id;
  final DateTime date;
  final DateTime startedAt;
  final DateTime endedAt;
  final int snoreScore;
  final bool isManual;
  final String? notes;
  final DateTime createdAt;
  const SleepNightRow({
    required this.id,
    required this.date,
    required this.startedAt,
    required this.endedAt,
    required this.snoreScore,
    required this.isManual,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['snore_score'] = Variable<int>(snoreScore);
    map['is_manual'] = Variable<bool>(isManual);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SleepNightRowsCompanion toCompanion(bool nullToAbsent) {
    return SleepNightRowsCompanion(
      id: Value(id),
      date: Value(date),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      snoreScore: Value(snoreScore),
      isManual: Value(isManual),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory SleepNightRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepNightRow(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      snoreScore: serializer.fromJson<int>(json['snoreScore']),
      isManual: serializer.fromJson<bool>(json['isManual']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'snoreScore': serializer.toJson<int>(snoreScore),
      'isManual': serializer.toJson<bool>(isManual),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SleepNightRow copyWith({
    int? id,
    DateTime? date,
    DateTime? startedAt,
    DateTime? endedAt,
    int? snoreScore,
    bool? isManual,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => SleepNightRow(
    id: id ?? this.id,
    date: date ?? this.date,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    snoreScore: snoreScore ?? this.snoreScore,
    isManual: isManual ?? this.isManual,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  SleepNightRow copyWithCompanion(SleepNightRowsCompanion data) {
    return SleepNightRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      snoreScore: data.snoreScore.present
          ? data.snoreScore.value
          : this.snoreScore,
      isManual: data.isManual.present ? data.isManual.value : this.isManual,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepNightRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('snoreScore: $snoreScore, ')
          ..write('isManual: $isManual, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    startedAt,
    endedAt,
    snoreScore,
    isManual,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepNightRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.snoreScore == this.snoreScore &&
          other.isManual == this.isManual &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SleepNightRowsCompanion extends UpdateCompanion<SleepNightRow> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> snoreScore;
  final Value<bool> isManual;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const SleepNightRowsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.snoreScore = const Value.absent(),
    this.isManual = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SleepNightRowsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required DateTime startedAt,
    required DateTime endedAt,
    this.snoreScore = const Value.absent(),
    this.isManual = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt);
  static Insertable<SleepNightRow> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? snoreScore,
    Expression<bool>? isManual,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (snoreScore != null) 'snore_score': snoreScore,
      if (isManual != null) 'is_manual': isManual,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SleepNightRowsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? snoreScore,
    Value<bool>? isManual,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return SleepNightRowsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      snoreScore: snoreScore ?? this.snoreScore,
      isManual: isManual ?? this.isManual,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (snoreScore.present) {
      map['snore_score'] = Variable<int>(snoreScore.value);
    }
    if (isManual.present) {
      map['is_manual'] = Variable<bool>(isManual.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepNightRowsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('snoreScore: $snoreScore, ')
          ..write('isManual: $isManual, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SleepEventRowsTable extends SleepEventRows
    with TableInfo<$SleepEventRowsTable, SleepEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepEventRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nightIdMeta = const VerificationMeta(
    'nightId',
  );
  @override
  late final GeneratedColumn<int> nightId = GeneratedColumn<int>(
    'night_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sleep_night_rows (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SleepEventKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SleepEventKind>($SleepEventRowsTable.$converterkind);
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userExcludedMeta = const VerificationMeta(
    'userExcluded',
  );
  @override
  late final GeneratedColumn<bool> userExcluded = GeneratedColumn<bool>(
    'user_excluded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_excluded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nightId,
    kind,
    startsAt,
    durationSeconds,
    intensity,
    filePath,
    userExcluded,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_event_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('night_id')) {
      context.handle(
        _nightIdMeta,
        nightId.isAcceptableOrUnknown(data['night_id']!, _nightIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nightIdMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('user_excluded')) {
      context.handle(
        _userExcludedMeta,
        userExcluded.isAcceptableOrUnknown(
          data['user_excluded']!,
          _userExcludedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nightId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}night_id'],
      )!,
      kind: $SleepEventRowsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      userExcluded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_excluded'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SleepEventRowsTable createAlias(String alias) {
    return $SleepEventRowsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SleepEventKind, int, int> $converterkind =
      const EnumIndexConverter<SleepEventKind>(SleepEventKind.values);
}

class SleepEventRow extends DataClass implements Insertable<SleepEventRow> {
  final int id;
  final int nightId;
  final SleepEventKind kind;
  final DateTime startsAt;
  final int durationSeconds;
  final int intensity;
  final String? filePath;
  final bool userExcluded;
  final DateTime createdAt;
  const SleepEventRow({
    required this.id,
    required this.nightId,
    required this.kind,
    required this.startsAt,
    required this.durationSeconds,
    required this.intensity,
    this.filePath,
    required this.userExcluded,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['night_id'] = Variable<int>(nightId);
    {
      map['kind'] = Variable<int>(
        $SleepEventRowsTable.$converterkind.toSql(kind),
      );
    }
    map['starts_at'] = Variable<DateTime>(startsAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['intensity'] = Variable<int>(intensity);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['user_excluded'] = Variable<bool>(userExcluded);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SleepEventRowsCompanion toCompanion(bool nullToAbsent) {
    return SleepEventRowsCompanion(
      id: Value(id),
      nightId: Value(nightId),
      kind: Value(kind),
      startsAt: Value(startsAt),
      durationSeconds: Value(durationSeconds),
      intensity: Value(intensity),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      userExcluded: Value(userExcluded),
      createdAt: Value(createdAt),
    );
  }

  factory SleepEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepEventRow(
      id: serializer.fromJson<int>(json['id']),
      nightId: serializer.fromJson<int>(json['nightId']),
      kind: $SleepEventRowsTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      intensity: serializer.fromJson<int>(json['intensity']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      userExcluded: serializer.fromJson<bool>(json['userExcluded']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nightId': serializer.toJson<int>(nightId),
      'kind': serializer.toJson<int>(
        $SleepEventRowsTable.$converterkind.toJson(kind),
      ),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'intensity': serializer.toJson<int>(intensity),
      'filePath': serializer.toJson<String?>(filePath),
      'userExcluded': serializer.toJson<bool>(userExcluded),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SleepEventRow copyWith({
    int? id,
    int? nightId,
    SleepEventKind? kind,
    DateTime? startsAt,
    int? durationSeconds,
    int? intensity,
    Value<String?> filePath = const Value.absent(),
    bool? userExcluded,
    DateTime? createdAt,
  }) => SleepEventRow(
    id: id ?? this.id,
    nightId: nightId ?? this.nightId,
    kind: kind ?? this.kind,
    startsAt: startsAt ?? this.startsAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    intensity: intensity ?? this.intensity,
    filePath: filePath.present ? filePath.value : this.filePath,
    userExcluded: userExcluded ?? this.userExcluded,
    createdAt: createdAt ?? this.createdAt,
  );
  SleepEventRow copyWithCompanion(SleepEventRowsCompanion data) {
    return SleepEventRow(
      id: data.id.present ? data.id.value : this.id,
      nightId: data.nightId.present ? data.nightId.value : this.nightId,
      kind: data.kind.present ? data.kind.value : this.kind,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      userExcluded: data.userExcluded.present
          ? data.userExcluded.value
          : this.userExcluded,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepEventRow(')
          ..write('id: $id, ')
          ..write('nightId: $nightId, ')
          ..write('kind: $kind, ')
          ..write('startsAt: $startsAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('intensity: $intensity, ')
          ..write('filePath: $filePath, ')
          ..write('userExcluded: $userExcluded, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nightId,
    kind,
    startsAt,
    durationSeconds,
    intensity,
    filePath,
    userExcluded,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepEventRow &&
          other.id == this.id &&
          other.nightId == this.nightId &&
          other.kind == this.kind &&
          other.startsAt == this.startsAt &&
          other.durationSeconds == this.durationSeconds &&
          other.intensity == this.intensity &&
          other.filePath == this.filePath &&
          other.userExcluded == this.userExcluded &&
          other.createdAt == this.createdAt);
}

class SleepEventRowsCompanion extends UpdateCompanion<SleepEventRow> {
  final Value<int> id;
  final Value<int> nightId;
  final Value<SleepEventKind> kind;
  final Value<DateTime> startsAt;
  final Value<int> durationSeconds;
  final Value<int> intensity;
  final Value<String?> filePath;
  final Value<bool> userExcluded;
  final Value<DateTime> createdAt;
  const SleepEventRowsCompanion({
    this.id = const Value.absent(),
    this.nightId = const Value.absent(),
    this.kind = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.intensity = const Value.absent(),
    this.filePath = const Value.absent(),
    this.userExcluded = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SleepEventRowsCompanion.insert({
    this.id = const Value.absent(),
    required int nightId,
    required SleepEventKind kind,
    required DateTime startsAt,
    required int durationSeconds,
    required int intensity,
    this.filePath = const Value.absent(),
    this.userExcluded = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : nightId = Value(nightId),
       kind = Value(kind),
       startsAt = Value(startsAt),
       durationSeconds = Value(durationSeconds),
       intensity = Value(intensity);
  static Insertable<SleepEventRow> custom({
    Expression<int>? id,
    Expression<int>? nightId,
    Expression<int>? kind,
    Expression<DateTime>? startsAt,
    Expression<int>? durationSeconds,
    Expression<int>? intensity,
    Expression<String>? filePath,
    Expression<bool>? userExcluded,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nightId != null) 'night_id': nightId,
      if (kind != null) 'kind': kind,
      if (startsAt != null) 'starts_at': startsAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (intensity != null) 'intensity': intensity,
      if (filePath != null) 'file_path': filePath,
      if (userExcluded != null) 'user_excluded': userExcluded,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SleepEventRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? nightId,
    Value<SleepEventKind>? kind,
    Value<DateTime>? startsAt,
    Value<int>? durationSeconds,
    Value<int>? intensity,
    Value<String?>? filePath,
    Value<bool>? userExcluded,
    Value<DateTime>? createdAt,
  }) {
    return SleepEventRowsCompanion(
      id: id ?? this.id,
      nightId: nightId ?? this.nightId,
      kind: kind ?? this.kind,
      startsAt: startsAt ?? this.startsAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      intensity: intensity ?? this.intensity,
      filePath: filePath ?? this.filePath,
      userExcluded: userExcluded ?? this.userExcluded,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nightId.present) {
      map['night_id'] = Variable<int>(nightId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(
        $SleepEventRowsTable.$converterkind.toSql(kind.value),
      );
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (userExcluded.present) {
      map['user_excluded'] = Variable<bool>(userExcluded.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepEventRowsCompanion(')
          ..write('id: $id, ')
          ..write('nightId: $nightId, ')
          ..write('kind: $kind, ')
          ..write('startsAt: $startsAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('intensity: $intensity, ')
          ..write('filePath: $filePath, ')
          ..write('userExcluded: $userExcluded, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SleepNightRowsTable sleepNightRows = $SleepNightRowsTable(this);
  late final $SleepEventRowsTable sleepEventRows = $SleepEventRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sleepNightRows,
    sleepEventRows,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sleep_night_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sleep_event_rows', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SleepNightRowsTableCreateCompanionBuilder =
    SleepNightRowsCompanion Function({
      Value<int> id,
      required DateTime date,
      required DateTime startedAt,
      required DateTime endedAt,
      Value<int> snoreScore,
      Value<bool> isManual,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$SleepNightRowsTableUpdateCompanionBuilder =
    SleepNightRowsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> snoreScore,
      Value<bool> isManual,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$SleepNightRowsTableReferences
    extends BaseReferences<_$AppDatabase, $SleepNightRowsTable, SleepNightRow> {
  $$SleepNightRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SleepEventRowsTable, List<SleepEventRow>>
  _sleepEventRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sleepEventRows,
    aliasName: $_aliasNameGenerator(
      db.sleepNightRows.id,
      db.sleepEventRows.nightId,
    ),
  );

  $$SleepEventRowsTableProcessedTableManager get sleepEventRowsRefs {
    final manager = $$SleepEventRowsTableTableManager(
      $_db,
      $_db.sleepEventRows,
    ).filter((f) => f.nightId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sleepEventRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SleepNightRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SleepNightRowsTable> {
  $$SleepNightRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snoreScore => $composableBuilder(
    column: $table.snoreScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManual => $composableBuilder(
    column: $table.isManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sleepEventRowsRefs(
    Expression<bool> Function($$SleepEventRowsTableFilterComposer f) f,
  ) {
    final $$SleepEventRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sleepEventRows,
      getReferencedColumn: (t) => t.nightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SleepEventRowsTableFilterComposer(
            $db: $db,
            $table: $db.sleepEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SleepNightRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepNightRowsTable> {
  $$SleepNightRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoreScore => $composableBuilder(
    column: $table.snoreScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManual => $composableBuilder(
    column: $table.isManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepNightRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepNightRowsTable> {
  $$SleepNightRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get snoreScore => $composableBuilder(
    column: $table.snoreScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isManual =>
      $composableBuilder(column: $table.isManual, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> sleepEventRowsRefs<T extends Object>(
    Expression<T> Function($$SleepEventRowsTableAnnotationComposer a) f,
  ) {
    final $$SleepEventRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sleepEventRows,
      getReferencedColumn: (t) => t.nightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SleepEventRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.sleepEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SleepNightRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepNightRowsTable,
          SleepNightRow,
          $$SleepNightRowsTableFilterComposer,
          $$SleepNightRowsTableOrderingComposer,
          $$SleepNightRowsTableAnnotationComposer,
          $$SleepNightRowsTableCreateCompanionBuilder,
          $$SleepNightRowsTableUpdateCompanionBuilder,
          (SleepNightRow, $$SleepNightRowsTableReferences),
          SleepNightRow,
          PrefetchHooks Function({bool sleepEventRowsRefs})
        > {
  $$SleepNightRowsTableTableManager(
    _$AppDatabase db,
    $SleepNightRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepNightRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepNightRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepNightRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> snoreScore = const Value.absent(),
                Value<bool> isManual = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SleepNightRowsCompanion(
                id: id,
                date: date,
                startedAt: startedAt,
                endedAt: endedAt,
                snoreScore: snoreScore,
                isManual: isManual,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required DateTime startedAt,
                required DateTime endedAt,
                Value<int> snoreScore = const Value.absent(),
                Value<bool> isManual = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SleepNightRowsCompanion.insert(
                id: id,
                date: date,
                startedAt: startedAt,
                endedAt: endedAt,
                snoreScore: snoreScore,
                isManual: isManual,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SleepNightRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sleepEventRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sleepEventRowsRefs) db.sleepEventRows,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sleepEventRowsRefs)
                    await $_getPrefetchedData<
                      SleepNightRow,
                      $SleepNightRowsTable,
                      SleepEventRow
                    >(
                      currentTable: table,
                      referencedTable: $$SleepNightRowsTableReferences
                          ._sleepEventRowsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SleepNightRowsTableReferences(
                            db,
                            table,
                            p0,
                          ).sleepEventRowsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.nightId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SleepNightRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepNightRowsTable,
      SleepNightRow,
      $$SleepNightRowsTableFilterComposer,
      $$SleepNightRowsTableOrderingComposer,
      $$SleepNightRowsTableAnnotationComposer,
      $$SleepNightRowsTableCreateCompanionBuilder,
      $$SleepNightRowsTableUpdateCompanionBuilder,
      (SleepNightRow, $$SleepNightRowsTableReferences),
      SleepNightRow,
      PrefetchHooks Function({bool sleepEventRowsRefs})
    >;
typedef $$SleepEventRowsTableCreateCompanionBuilder =
    SleepEventRowsCompanion Function({
      Value<int> id,
      required int nightId,
      required SleepEventKind kind,
      required DateTime startsAt,
      required int durationSeconds,
      required int intensity,
      Value<String?> filePath,
      Value<bool> userExcluded,
      Value<DateTime> createdAt,
    });
typedef $$SleepEventRowsTableUpdateCompanionBuilder =
    SleepEventRowsCompanion Function({
      Value<int> id,
      Value<int> nightId,
      Value<SleepEventKind> kind,
      Value<DateTime> startsAt,
      Value<int> durationSeconds,
      Value<int> intensity,
      Value<String?> filePath,
      Value<bool> userExcluded,
      Value<DateTime> createdAt,
    });

final class $$SleepEventRowsTableReferences
    extends BaseReferences<_$AppDatabase, $SleepEventRowsTable, SleepEventRow> {
  $$SleepEventRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SleepNightRowsTable _nightIdTable(_$AppDatabase db) =>
      db.sleepNightRows.createAlias(
        $_aliasNameGenerator(db.sleepEventRows.nightId, db.sleepNightRows.id),
      );

  $$SleepNightRowsTableProcessedTableManager get nightId {
    final $_column = $_itemColumn<int>('night_id')!;

    final manager = $$SleepNightRowsTableTableManager(
      $_db,
      $_db.sleepNightRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nightIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SleepEventRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SleepEventRowsTable> {
  $$SleepEventRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SleepEventKind, SleepEventKind, int>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userExcluded => $composableBuilder(
    column: $table.userExcluded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SleepNightRowsTableFilterComposer get nightId {
    final $$SleepNightRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nightId,
      referencedTable: $db.sleepNightRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SleepNightRowsTableFilterComposer(
            $db: $db,
            $table: $db.sleepNightRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SleepEventRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepEventRowsTable> {
  $$SleepEventRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userExcluded => $composableBuilder(
    column: $table.userExcluded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SleepNightRowsTableOrderingComposer get nightId {
    final $$SleepNightRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nightId,
      referencedTable: $db.sleepNightRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SleepNightRowsTableOrderingComposer(
            $db: $db,
            $table: $db.sleepNightRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SleepEventRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepEventRowsTable> {
  $$SleepEventRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SleepEventKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<bool> get userExcluded => $composableBuilder(
    column: $table.userExcluded,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SleepNightRowsTableAnnotationComposer get nightId {
    final $$SleepNightRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.nightId,
      referencedTable: $db.sleepNightRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SleepNightRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.sleepNightRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SleepEventRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepEventRowsTable,
          SleepEventRow,
          $$SleepEventRowsTableFilterComposer,
          $$SleepEventRowsTableOrderingComposer,
          $$SleepEventRowsTableAnnotationComposer,
          $$SleepEventRowsTableCreateCompanionBuilder,
          $$SleepEventRowsTableUpdateCompanionBuilder,
          (SleepEventRow, $$SleepEventRowsTableReferences),
          SleepEventRow,
          PrefetchHooks Function({bool nightId})
        > {
  $$SleepEventRowsTableTableManager(
    _$AppDatabase db,
    $SleepEventRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepEventRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepEventRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepEventRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nightId = const Value.absent(),
                Value<SleepEventKind> kind = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<bool> userExcluded = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SleepEventRowsCompanion(
                id: id,
                nightId: nightId,
                kind: kind,
                startsAt: startsAt,
                durationSeconds: durationSeconds,
                intensity: intensity,
                filePath: filePath,
                userExcluded: userExcluded,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nightId,
                required SleepEventKind kind,
                required DateTime startsAt,
                required int durationSeconds,
                required int intensity,
                Value<String?> filePath = const Value.absent(),
                Value<bool> userExcluded = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SleepEventRowsCompanion.insert(
                id: id,
                nightId: nightId,
                kind: kind,
                startsAt: startsAt,
                durationSeconds: durationSeconds,
                intensity: intensity,
                filePath: filePath,
                userExcluded: userExcluded,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SleepEventRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({nightId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (nightId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.nightId,
                                referencedTable: $$SleepEventRowsTableReferences
                                    ._nightIdTable(db),
                                referencedColumn:
                                    $$SleepEventRowsTableReferences
                                        ._nightIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SleepEventRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepEventRowsTable,
      SleepEventRow,
      $$SleepEventRowsTableFilterComposer,
      $$SleepEventRowsTableOrderingComposer,
      $$SleepEventRowsTableAnnotationComposer,
      $$SleepEventRowsTableCreateCompanionBuilder,
      $$SleepEventRowsTableUpdateCompanionBuilder,
      (SleepEventRow, $$SleepEventRowsTableReferences),
      SleepEventRow,
      PrefetchHooks Function({bool nightId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SleepNightRowsTableTableManager get sleepNightRows =>
      $$SleepNightRowsTableTableManager(_db, _db.sleepNightRows);
  $$SleepEventRowsTableTableManager get sleepEventRows =>
      $$SleepEventRowsTableTableManager(_db, _db.sleepEventRows);
}
