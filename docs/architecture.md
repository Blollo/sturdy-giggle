# Local app architecture

## Flow

Screens watch Riverpod providers, which observe `CatRepository` streams backed by Drift. SQLite is the source of truth. `CaptureService`, `LocationService`, and `PhotoStore` isolate device operations from state and persistence. UI tests replace these services and map tiles; production uses the native plugins.

The native database runs in Drift's background isolate. Foreign keys and WAL are enabled. Times are written in UTC and converted to local time for display. The schema snapshot is in `app/drift_schemas/app_database/`.

## Records

- `local_owners`: one persistent client UUID and the next available dex number. This is a local collection identity, not an authenticated user.
- `cats`: UUIDv7 ID, local owner, dex number, optional name/coat/pattern/notes, creation/update/deletion times, dirty flag. Owner and dex number are unique together.
- `sightings`: UUIDv7 ID, cat, encounter time, optional coordinate pair/place/country/note, update/deletion times, dirty flag. The first version creates exactly one initial sighting per cat; the relationship supports later re-encounters.
- `photos`: UUIDv7 ID, sighting, relative local path, dimensions, optional server storage key and blurhash, update/deletion times, dirty flag. Replacing a photo tombstones the old metadata and creates a new photo ID.

Latitude/longitude must be both absent or both present and within bounds. Country codes are optional two-letter codes, normalized to uppercase. Names and labels are optional trimmed text. Unknown countries are excluded from the country count.

## Save lifecycle

1. Validate the draft; a new cat requires a photo.
2. Decode/process the selected file, normalize orientation, strip EXIF, and compress to JPEG with a target maximum 1600-pixel long edge and no intentional upscaling.
3. Flush to a staging file inside persistent app storage and rename it to its final unique path.
4. In one SQLite transaction, allocate the dex number and insert/update the cat, first sighting, and photo metadata. Edits preserve cat/sighting identity and dex number.
5. If the transaction fails, remove the newly imported file. On startup, remove leftover unreferenced images and staging files, including those from a process interruption between steps 3 and 4.

Old referenced photos—including tombstones—are retained. A future sync/purge policy will decide when they can be reclaimed. Startup cleanup finishes before the app accepts saves. Duplicate Save taps are blocked while the operation is in flight. A late GPS result cannot change a saved draft.

Camera picker files are temporary; persistent copies are required. Android lost-picker data is offered for review, never automatically saved. Gallery imports do not assume the phone's current coordinates are the photo location. Date/location corrections are explicit.

## Offline and privacy

The catalog and original compressed images remain usable without internet. GPS may work offline; reverse geocoding is best effort and never blocks saving. Map tiles are requested only for interactive viewing, with the library's cache and visible OpenStreetMap attribution. Unavailable tiles leave local records accessible through the encounter list. No offline-region download feature is included.

Coordinates stay local in this milestone. EXIF is not retained in the stored image. No background location access, analytics SDK, authentication, or HTTP sync client is included.

## Next milestones (not implemented)

Retain the proposed Go `net/http` + `modernc.org/sqlite` server, `sqlc`, `goose`, local storage interface, and later Apple/Google authentication. Do not treat this device schema as a finalized wire contract.

Before synchronization, specify account attachment/migration, multi-device dex-number allocation, clock skew and equal-timestamp conflicts, per-row acknowledgement/version behavior, paginated monotonic cursors, photo retry state, and tombstone retention. A dirty boolean alone must not acknowledge an edit made while a push is in flight.

Before friends, implement server-side relationship checks and a documented coarse-coordinate transformation for every shared response. Rounded coordinates alone do not protect location clues in images or text. Do not share full-resolution location metadata or raw photos containing EXIF.
