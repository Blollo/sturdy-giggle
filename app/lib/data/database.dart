import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class LocalOwners extends Table {
  TextColumn get id => text()();
  IntColumn get nextDexNumber => integer().withDefault(const Constant(1))();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CatRecord')
class Cats extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(LocalOwners, #id)();
  IntColumn get dexNumber => integer()();
  TextColumn get name => text().nullable()();
  TextColumn get coatColor => text().nullable()();
  TextColumn get pattern => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {ownerId, dexNumber},
  ];
}

@DataClassName('SightingRecord')
class Sightings extends Table {
  TextColumn get id => text()();
  TextColumn get catId => text().references(Cats, #id)();
  DateTimeColumn get seenAt => dateTime()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get placeName => text().nullable()();
  TextColumn get countryCode => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK ((lat IS NULL AND lng IS NULL) OR '
        '(lat IS NOT NULL AND lng IS NOT NULL AND lat BETWEEN -90 AND 90 AND lng BETWEEN -180 AND 180))',
  ];
}

@DataClassName('PhotoRecord')
class Photos extends Table {
  TextColumn get id => text()();
  TextColumn get sightingId => text().references(Sightings, #id)();
  TextColumn get localPath => text()();
  TextColumn get storageKey => text().nullable()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  TextColumn get blurhash => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [LocalOwners, Cats, Sightings, Photos])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'cat_dex'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );
}
