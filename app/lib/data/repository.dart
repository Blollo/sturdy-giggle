import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../services/photo_store.dart';
import 'database.dart';
import 'entry.dart';

class CatRepository {
  CatRepository(this.db, this.photos, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final AppDatabase db;
  final PhotoStore photos;
  final DateTime Function() clock;
  static const _uuid = Uuid();
  String? _ownerId;

  Future<void> initialize() async {
    await db.transaction(() async {
      final owner = await db.select(db.localOwners).getSingleOrNull();
      if (owner != null) {
        _ownerId = owner.id;
      } else {
        _ownerId = _uuid.v7();
        await db
            .into(db.localOwners)
            .insert(LocalOwnersCompanion.insert(id: _ownerId!));
      }
    });
    // Tombstones retain their photos for future synchronization.
    final referenced = (await db.select(db.photos).get())
        .map((p) => p.localPath)
        .toSet();
    await photos.cleanOrphans(referenced);
  }

  Stream<List<CatEntry>> watchEntries() {
    final query =
        db.select(db.cats).join([
            innerJoin(db.sightings, db.sightings.catId.equalsExp(db.cats.id)),
            innerJoin(
              db.photos,
              db.photos.sightingId.equalsExp(db.sightings.id),
            ),
          ])
          ..where(
            db.cats.deletedAt.isNull() &
                db.sightings.deletedAt.isNull() &
                db.photos.deletedAt.isNull(),
          )
          ..orderBy([OrderingTerm.asc(db.cats.dexNumber)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => CatEntry(
              row.readTable(db.cats),
              row.readTable(db.sightings),
              row.readTable(db.photos),
            ),
          )
          .toList(),
    );
  }

  Future<String> save(
    CatDraft draft, {
    String? catId,
    String? sourcePhoto,
  }) async {
    draft.validate();
    if (_ownerId == null) throw StateError('The collection is not ready yet.');
    if (catId == null && sourcePhoto == null) {
      throw ArgumentError('Choose a photo first.');
    }
    final photoId = _uuid.v7();
    StoredPhoto? imported;
    try {
      if (sourcePhoto != null) {
        imported = await photos.importPhoto(sourcePhoto, photoId);
      }
      return await db.transaction(() async {
        final now = clock().toUtc();
        final id = catId ?? _uuid.v7();
        String sightingId;
        final values = CatsCompanion(
          name: Value(CatDraft.clean(draft.name)),
          coatColor: Value(CatDraft.clean(draft.coatColor)),
          pattern: Value(CatDraft.clean(draft.pattern)),
          notes: Value(CatDraft.clean(draft.notes)),
          updatedAt: Value(now),
          dirty: const Value(true),
        );
        if (catId == null) {
          final owner = await (db.select(
            db.localOwners,
          )..where((o) => o.id.equals(_ownerId!))).getSingle();
          await db
              .into(db.cats)
              .insert(
                values.copyWith(
                  id: Value(id),
                  ownerId: Value(_ownerId!),
                  dexNumber: Value(owner.nextDexNumber),
                  createdAt: Value(now),
                ),
              );
          await (db.update(
            db.localOwners,
          )..where((o) => o.id.equals(_ownerId!))).write(
            LocalOwnersCompanion(nextDexNumber: Value(owner.nextDexNumber + 1)),
          );
          sightingId = _uuid.v7();
          await db
              .into(db.sightings)
              .insert(
                SightingsCompanion.insert(
                  id: sightingId,
                  catId: id,
                  seenAt: draft.seenAt.toUtc(),
                  updatedAt: now,
                ),
              );
        } else {
          final updated =
              await (db.update(db.cats)
                    ..where((c) => c.id.equals(id) & c.deletedAt.isNull()))
                  .write(values);
          if (updated != 1) {
            throw StateError('This cat is no longer in your collection.');
          }
          sightingId =
              (await (db.select(db.sightings)..where(
                        (s) => s.catId.equals(id) & s.deletedAt.isNull(),
                      ))
                      .getSingle())
                  .id;
        }
        await (db.update(
          db.sightings,
        )..where((s) => s.id.equals(sightingId))).write(
          SightingsCompanion(
            seenAt: Value(draft.seenAt.toUtc()),
            lat: Value(draft.lat),
            lng: Value(draft.lng),
            placeName: Value(CatDraft.clean(draft.placeName)),
            countryCode: Value(
              CatDraft.clean(draft.countryCode)?.toUpperCase(),
            ),
            updatedAt: Value(now),
            dirty: const Value(true),
          ),
        );
        if (imported != null) {
          await (db.update(db.photos)..where(
                (p) => p.sightingId.equals(sightingId) & p.deletedAt.isNull(),
              ))
              .write(
                PhotosCompanion(
                  deletedAt: Value(now),
                  updatedAt: Value(now),
                  dirty: const Value(true),
                ),
              );
          await db
              .into(db.photos)
              .insert(
                PhotosCompanion.insert(
                  id: photoId,
                  sightingId: sightingId,
                  localPath: imported!.path,
                  width: imported.width,
                  height: imported.height,
                  updatedAt: now,
                ),
              );
        }
        return id;
      });
    } catch (_) {
      if (imported != null) {
        try {
          await photos.remove(imported.path);
        } catch (_) {
          /* Startup cleanup retries. */
        }
      }
      rethrow;
    }
  }

  Future<void> deleteCat(String id) => db.transaction(() async {
    final now = clock().toUtc();
    final sightings = await (db.select(
      db.sightings,
    )..where((s) => s.catId.equals(id))).get();
    for (final sighting in sightings) {
      await (db.update(db.photos)..where(
            (p) => p.sightingId.equals(sighting.id) & p.deletedAt.isNull(),
          ))
          .write(
            PhotosCompanion(
              deletedAt: Value(now),
              updatedAt: Value(now),
              dirty: const Value(true),
            ),
          );
    }
    await (db.update(
      db.sightings,
    )..where((s) => s.catId.equals(id) & s.deletedAt.isNull())).write(
      SightingsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        dirty: const Value(true),
      ),
    );
    await (db.update(
      db.cats,
    )..where((c) => c.id.equals(id) & c.deletedAt.isNull())).write(
      CatsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        dirty: const Value(true),
      ),
    );
  });
}
