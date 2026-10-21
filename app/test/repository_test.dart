import 'dart:io';

import 'package:cat_dex/data/database.dart';
import 'package:cat_dex/data/entry.dart';
import 'package:cat_dex/data/repository.dart';
import 'package:cat_dex/services/photo_store.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  // Restart tests deliberately open distinct in-memory and disk databases.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late FakePhotos photos;
  late CatRepository repository;
  final now = DateTime.utc(2026, 10, 21, 12);
  CatDraft draft({String? name, double? lat, double? lng, String? country}) =>
      CatDraft(
        seenAt: now,
        name: name,
        lat: lat,
        lng: lng,
        countryCode: country,
      );
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    photos = FakePhotos();
    repository = CatRepository(db, photos, clock: () => now);
    await repository.initialize();
  });
  tearDown(() async => db.close());

  test('creates one atomic catch with UUIDv7 IDs, nullable location and dirty flags', () async {
    final id = await repository.save(draft(name: '  '), sourcePhoto: 'cat.jpg');
    final entry = (await repository.watchEntries().first).single;
    expect(id[14], '7');
    expect(entry.sighting.id[14], '7');
    expect(entry.photo.id[14], '7');
    expect(entry.title, 'Cat #001');
    expect(entry.hasLocation, false);
    expect(entry.cat.dirty && entry.sighting.dirty && entry.photo.dirty, true);
    expect(entry.cat.updatedAt.toUtc(), now);
    expect(entry.photo.storageKey, isNull);
    expect(photos.stored, contains(entry.photo.localPath));
  });

  test('numbers are unique across concurrent saves and are not reused after deletion', () async {
    final ids = await Future.wait(
      List.generate(4, (_) => repository.save(draft(), sourcePhoto: 'cat.jpg')),
    );
    await repository.deleteCat(ids[1]);
    await repository.save(draft(), sourcePhoto: 'cat.jpg');
    expect(
      (await repository.watchEntries().first).map((e) => e.cat.dexNumber),
      [1, 3, 4, 5],
    );
  });

  test('photo failure creates no rows and consumes no dex number', () async {
    photos.failImport = true;
    await expectLater(
      repository.save(draft(), sourcePhoto: 'cat.jpg'),
      throwsStateError,
    );
    expect(await db.select(db.cats).get(), isEmpty);
    expect((await db.select(db.localOwners).getSingle()).nextDexNumber, 1);
  });

  test(
    'database failure rolls back all metadata, allocation and imported file',
    () async {
      await db.customStatement(
        "CREATE TRIGGER reject_photos BEFORE INSERT ON photos BEGIN SELECT RAISE(ABORT, 'full'); END",
      );
      await expectLater(
        repository.save(draft(), sourcePhoto: 'cat.jpg'),
        throwsA(anything),
      );
      expect(await db.select(db.cats).get(), isEmpty);
      expect(await db.select(db.sightings).get(), isEmpty);
      expect(photos.stored, isEmpty);
      expect((await db.select(db.localOwners).getSingle()).nextDexNumber, 1);
    },
  );

  test('edit preserves IDs and number, normalizes country, permits clearing location', () async {
    final id = await repository.save(
      draft(name: '  Miso  ', lat: 41.9, lng: 12.5, country: 'it'),
      sourcePhoto: 'cat.jpg',
    );
    final before = (await repository.watchEntries().first).single;
    expect(before.cat.name, 'Miso');
    expect(before.sighting.countryCode, 'IT');
    await repository.save(draft(name: 'Miso II'), catId: id);
    final after = (await repository.watchEntries().first).single;
    expect(after.cat.dexNumber, before.cat.dexNumber);
    expect(after.sighting.id, before.sighting.id);
    expect(after.photo.id, before.photo.id);
    expect(after.sighting.lat, isNull);
    expect(after.sighting.lng, isNull);
    expect(after.sighting.countryCode, isNull);
  });

  test('replacement tombstones old photo and shows only the new one', () async {
    final id = await repository.save(draft(), sourcePhoto: 'cat.jpg');
    final oldPhoto = (await repository.watchEntries().first).single.photo;
    await repository.save(draft(), catId: id, sourcePhoto: 'replacement.jpg');
    final visible = await repository.watchEntries().first;
    expect(visible, hasLength(1));
    expect(visible.single.photo.id, isNot(oldPhoto.id));
    final all = await db.select(db.photos).get();
    expect(all, hasLength(2));
    expect(all.where((p) => p.deletedAt != null), hasLength(1));
    expect(photos.stored, hasLength(2));
  });

  test('delete cascades tombstones and keeps referenced photo files on startup cleanup', () async {
    final id = await repository.save(draft(), sourcePhoto: 'cat.jpg');
    await repository.deleteCat(id);
    expect(await repository.watchEntries().first, isEmpty);
    expect((await db.select(db.cats).getSingle()).deletedAt, isNotNull);
    expect((await db.select(db.sightings).getSingle()).deletedAt, isNotNull);
    expect((await db.select(db.photos).getSingle()).deletedAt, isNotNull);
    photos.stored.add('photos/orphan.jpg');
    await repository.initialize();
    expect(photos.stored, hasLength(1));
    expect(photos.stored, isNot(contains('photos/orphan.jpg')));
    await expectLater(repository.save(draft(), catId: id), throwsStateError);
  });

  test(
    'photo is required only for new cats; invalid coordinates never import',
    () async {
      await expectLater(repository.save(draft()), throwsArgumentError);
      for (final invalid in [
        draft(lat: 1),
        draft(lng: 1),
        draft(lat: 91, lng: 0),
        draft(lat: 0, lng: 181),
        draft(lat: double.nan, lng: 0),
        draft(country: 'Italy'),
      ]) {
        await expectLater(
          repository.save(invalid, sourcePhoto: 'cat.jpg'),
          throwsArgumentError,
        );
      }
      expect(photos.imports, 0);
    },
  );

  test(
    'SQLite enforces paired valid coordinates even outside the repository',
    () async {
      await repository.save(draft(), sourcePhoto: 'cat.jpg');
      await expectLater(
        db.update(db.sightings).write(const SightingsCompanion(lat: Value(12))),
        throwsA(anything),
      );
    },
  );

  test(
    'collection, owner identity and number sequence survive database restart',
    () async {
      final directory = await Directory.systemTemp.createTemp('cat-dex-db-');
      final file = File('${directory.path}/db.sqlite');
      var disk = AppDatabase(NativeDatabase(file));
      try {
        var repo = CatRepository(disk, photos);
        await repo.initialize();
        final owner = (await disk.select(disk.localOwners).getSingle()).id;
        await repo.save(draft(name: 'Miso'), sourcePhoto: 'cat.jpg');
        await disk.close();
        disk = AppDatabase(NativeDatabase(file));
        repo = CatRepository(disk, photos);
        await repo.initialize();
        expect((await disk.select(disk.localOwners).getSingle()).id, owner);
        await repo.save(draft(), sourcePhoto: 'cat2.jpg');
        expect((await repo.watchEntries().first).map((e) => e.number), [
          '#001',
          '#002',
        ]);
      } finally {
        await disk.close();
        await directory.delete(recursive: true);
      }
    },
  );

  test('disk cleanup removes interrupted staging files but retains referenced tombstones', () async {
    final directory = await Directory.systemTemp.createTemp('cat-dex-photos-');
    try {
      final folder = await Directory('${directory.path}/photos').create();
      await File('${folder.path}/kept.jpg').writeAsString('keep');
      await File('${folder.path}/orphan.jpg').writeAsString('remove');
      await File('${folder.path}/unfinished.jpg.part').writeAsString('remove');
      final store = DiskPhotoStore(directory);
      await store.cleanOrphans({'photos/kept.jpg'});
      expect(await folder.list().length, 1);
      expect(
        await File(store.absolutePath('photos/kept.jpg')).readAsString(),
        'keep',
      );
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
