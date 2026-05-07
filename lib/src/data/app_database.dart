import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:snorvy/src/domain/sleep_models.dart';

part 'app_database.g.dart';

@DataClassName('SleepNightRow')
class SleepNightRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get snoreScore => integer().withDefault(const Constant(0))();
  BoolColumn get isManual => boolean().withDefault(const Constant(false))();
  TextColumn get recordingPath => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('SleepEventRow')
class SleepEventRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nightId =>
      integer().references(SleepNightRows, #id, onDelete: KeyAction.cascade)();
  IntColumn get kind => intEnum<SleepEventKind>()();
  DateTimeColumn get startsAt => dateTime()();
  IntColumn get durationSeconds => integer()();
  IntColumn get intensity => integer()();
  TextColumn get filePath => text().nullable()();
  BoolColumn get userExcluded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [SleepNightRows, SleepEventRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'snorvy',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  Stream<List<SleepNightRow>> watchRecentNights({int limit = 30}) {
    final query = select(sleepNightRows)
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.date, mode: OrderingMode.desc),
      ])
      ..limit(limit);

    return query.watch();
  }

  Future<List<SleepNight>> fetchRecentSleepNights({int limit = 30}) async {
    final query = select(sleepNightRows)
      ..orderBy([
        (table) =>
            OrderingTerm(expression: table.date, mode: OrderingMode.desc),
      ])
      ..limit(limit);

    final nightRows = await query.get();
    final nights = <SleepNight>[];

    for (final nightRow in nightRows) {
      final eventRows =
          await (select(sleepEventRows)
                ..where((table) => table.nightId.equals(nightRow.id))
                ..orderBy([
                  (table) => OrderingTerm(expression: table.startsAt),
                ]))
              .get();

      nights.add(_mapNight(nightRow, eventRows));
    }

    return nights;
  }

  Future<int> countRecordedNightsForMonth(DateTime month) async {
    final monthStart = DateTime(month.year, month.month);
    final nextMonthStart = DateTime(month.year, month.month + 1);
    final countExpression = sleepNightRows.id.count();
    final query = selectOnly(sleepNightRows)
      ..addColumns([countExpression])
      ..where(sleepNightRows.isManual.equals(false))
      ..where(sleepNightRows.recordingPath.isNotNull())
      ..where(sleepNightRows.date.isBiggerOrEqualValue(monthStart))
      ..where(sleepNightRows.date.isSmallerThanValue(nextMonthStart));

    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  Future<int> createManualNight({
    required DateTime startedAt,
    required DateTime endedAt,
    String? notes,
  }) {
    final date = DateTime(endedAt.year, endedAt.month, endedAt.day);

    return into(sleepNightRows).insert(
      SleepNightRowsCompanion.insert(
        date: date,
        startedAt: startedAt,
        endedAt: endedAt,
        isManual: const Value(true),
        notes: Value(notes),
      ),
    );
  }

  Future<int> createRecordedNight({
    required DateTime startedAt,
    required DateTime endedAt,
    required String recordingPath,
  }) {
    final date = DateTime(endedAt.year, endedAt.month, endedAt.day);

    return into(sleepNightRows).insert(
      SleepNightRowsCompanion.insert(
        date: date,
        startedAt: startedAt,
        endedAt: endedAt,
        recordingPath: Value(recordingPath),
      ),
    );
  }

  Future<int> addDetectedEvent({
    required int nightId,
    required SleepEventKind kind,
    required DateTime startsAt,
    required Duration duration,
    required int intensity,
    required String filePath,
  }) {
    return into(sleepEventRows).insert(
      SleepEventRowsCompanion.insert(
        nightId: nightId,
        kind: kind,
        startsAt: startsAt,
        durationSeconds: duration.inSeconds,
        intensity: intensity.clamp(0, 100),
        filePath: Value(filePath),
      ),
    );
  }

  Future<List<String>> deleteNight(int nightId) async {
    return transaction(() async {
      final nightRow = await (select(
        sleepNightRows,
      )..where((table) => table.id.equals(nightId))).getSingleOrNull();
      if (nightRow == null) {
        return const <String>[];
      }

      final eventRows = await (select(
        sleepEventRows,
      )..where((table) => table.nightId.equals(nightId))).get();
      final filePaths = _filePathsFor(nightRow, eventRows);

      await (delete(
        sleepNightRows,
      )..where((table) => table.id.equals(nightId))).go();

      return filePaths;
    });
  }

  Future<List<String>> deleteAllNights() async {
    return transaction(() async {
      final nightRows = await select(sleepNightRows).get();
      final eventRows = await select(sleepEventRows).get();
      final filePaths = <String>{};

      for (final nightRow in nightRows) {
        filePaths.addAll(
          _filePathsFor(
            nightRow,
            eventRows.where((eventRow) => eventRow.nightId == nightRow.id),
          ),
        );
      }

      await delete(sleepNightRows).go();
      return filePaths.toList(growable: false);
    });
  }

  List<String> _filePathsFor(
    SleepNightRow nightRow,
    Iterable<SleepEventRow> eventRows,
  ) {
    return {
      ?nightRow.recordingPath,
      for (final eventRow in eventRows) ?eventRow.filePath,
    }.toList(growable: false);
  }

  SleepNight _mapNight(SleepNightRow nightRow, List<SleepEventRow> eventRows) {
    return SleepNight(
      id: nightRow.id,
      date: nightRow.date,
      startedAt: nightRow.startedAt,
      endedAt: nightRow.endedAt,
      snoreScore: nightRow.snoreScore,
      isManual: nightRow.isManual,
      recordingPath: nightRow.recordingPath,
      events: [
        for (final eventRow in eventRows)
          SleepEvent(
            id: eventRow.id,
            kind: eventRow.kind,
            startsAt: eventRow.startsAt,
            duration: Duration(seconds: eventRow.durationSeconds),
            intensity: eventRow.intensity,
            filePath: eventRow.filePath,
          ),
      ],
    );
  }
}
