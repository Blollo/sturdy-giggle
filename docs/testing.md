# Verification

## Automated checks

Verified during implementation: Dart analysis reports no issues; all 25 tests pass, including the three visual snapshots. The ARM64 Android debug build succeeds.

Run `./scripts/check.sh` from the repository root. It resolves dependencies, checks Dart formatting, runs the analyzer, and executes all unit/widget/visual tests.

The test suite covers:

- Atomic creation and rollback, including imported-file cleanup and dex-number allocation on failure.
- UUIDv7 identity, concurrent numbering, nullable coordinates, country normalization, dirty flags, updates, photo replacement, and cascading tombstones.
- Persistent database reopening and local-owner/number-sequence survival.
- SQLite coordinate constraints and cleanup of unreferenced/staging image files while retaining referenced tombstones.
- Small-screen layout, add → detail → edit → delete, picker cancellation/permission failure, GPS denial/timeout, failed geocoding, and saving while GPS is pending.
- Duplicate Save taps, failed-save retry, Android recovered-photo review, failed map tiles, encounter-list fallback, and marker clustering.
- Three deterministic visual snapshots: empty dex, add-cat form, and a populated dex using an illustrative test fixture. Fixture cats are never inserted into the production app.

Golden tests load Roboto and Material Icons from the pinned Flutter SDK. Review changed images before updating baselines:

```sh
./scripts/flutter.sh test test/visual_test.dart --update-goldens
```

The current database schema snapshot is committed under `app/drift_schemas/`. No migration is needed before the first release; later schema changes must include upgrade tests against prior snapshots.

## Native builds and environment

Flutter 3.47.7 / Dart 3.13.5 are pinned. Development uses iOS 15+ and Android API 24+; Android compiles against SDK 36.

```sh
./scripts/flutter.sh build ios --simulator --debug
./scripts/flutter.sh build apk --debug --target-platform android-arm64
```

On the implementation machine, Xcode 26.6 reports that iOS 26.5 is not installed. Its platform download failed with “Insufficient space available. Requires 8.49 GB.” Older installed simulator runtimes did not satisfy Xcode's build destination requirements. Free sufficient disk space and install the platform in Xcode → Settings → Components, then rerun the iOS build.

The existing Android emulator also refused startup because of insufficient disk space. Native simulator interaction and physical-phone verification are therefore not claimed as completed. The initial Android compilation ran out of disk space. After reclaiming unused downloads created by this task and reducing Gradle to a 2 GB heap/two workers, the ARM64 Android debug APK built successfully at `app/build/app/outputs/flutter-apk/app-debug.apk`.

## Real-device acceptance checklist

- [ ] Launch on an iPhone with the intended development team and confirm permission descriptions.
- [ ] Capture portrait and landscape camera photos; confirm correct orientation, JPEG output, and long edge at most 1600 pixels.
- [ ] Import JPEG, PNG, and a real-device HEIC photo. Confirm small images are not enlarged and stored output does not contain GPS EXIF.
- [ ] Deny camera access, then choose a gallery photo. Cancel either picker without creating a record.
- [ ] Deny location access or disable location services; save a photo-only cat successfully.
- [ ] Capture in airplane mode, force-close, reopen, and confirm the photo/entry/coordinates persist.
- [ ] Correct coordinates using the map and manual fields; clear location; verify detail and counts update.
- [ ] Reconnect, view clustered encounters, select a cat, and verify the attribution link.
- [ ] Disable networking with uncached map tiles; use the encounter list and open saved photos.
- [ ] Replace a photo, edit notes, delete a cat, and confirm the next dex number is not reused.
- [ ] On Android, test interrupted image picking with activity recreation and explicitly review the recovered photo.
- [ ] Repeat the basic flow on Android and check larger text sizes and landscape layouts.

Physical camera/GPS and native image compression require this checklist even though widget tests use fake platform services.
