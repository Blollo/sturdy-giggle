# Cat-dex

A field guide to the real-world cats you meet. Photograph a cat, give it a numbered dex entry, and keep the encounter on your map.

Milestone 1 is a **local-only Flutter app**, built for iPhone first with Android support. No account, API key, or server is required. Cats, photos, edits, and coordinates work offline; new map tiles and place-name lookup need a connection.

## Run it

1. Install Flutter **3.47.7** (Dart 3.13.5). `.fvmrc` pins the SDK if you use FVM: `fvm install`.
2. Install Xcode and its iOS simulator runtime. Open Xcode once to complete setup. For Android, install Android Studio, Android SDK 36 and Java 17+.
3. From this directory:

```sh
./scripts/flutter.sh doctor -v
./scripts/flutter.sh pub get
./scripts/flutter.sh devices
./scripts/flutter.sh run -d <device-id>
```

The helper uses `FLUTTER_BIN` if set, then FVM if installed, then `flutter` on PATH. It sets the foreground-only location build flag used by the iOS plugin.

For the SDK installed during development in this workspace:

```sh
export FLUTTER_BIN=/private/tmp/cat-dex-flutter/bin/flutter
export PUB_CACHE=/private/tmp/cat-dex-pub
export GRADLE_USER_HOME=/private/tmp/cat-dex-gradle
./scripts/flutter.sh run -d <device-id>
```

That SDK is temporary: install a persistent SDK or use FVM for ongoing development.

### Your iPhone

Connect and trust the iPhone, enable Developer Mode, then select your Apple development team in the Runner target in `app/ios/Runner.xcodeproj`. Change the development bundle identifier if signing requires a unique one. Run with the helper above. A Personal Team supports basic personal-device testing; TestFlight and production distribution come later.

Camera capture needs a real device. The simulator supports gallery imports and simulated locations. Denying location access never prevents saving a cat.

## Development checks

```sh
./scripts/check.sh
./scripts/flutter.sh build ios --simulator --debug
./scripts/flutter.sh build apk --debug
```

After changing Drift tables:

```sh
./scripts/flutter.sh pub run build_runner build
./scripts/flutter.sh pub run drift_dev make-migrations
```

Commit generated database code, schema snapshots, and the dependency lockfile. For a released schema, increase `schemaVersion` and implement/test a migration before generating the next snapshot.

## Project layout

- `app/`: Flutter screens, Riverpod providers, Drift database, platform services, tests, and native targets.
- `server/`: reserved for the next milestone's Go API.
- `docs/architecture.md`: data lifecycle and future sync boundaries.
- `docs/testing.md`: automated coverage and device acceptance checklist.

## What works

- Camera/gallery capture with one photo per cat; compressed JPEG in persistent app storage.
- Dex grid with permanent per-collection numbers and known-country counts.
- Cat detail, first encounter, notes, editing, photo replacement, and confirmed deletion.
- Foreground GPS, best-effort reverse geocoding, manual coordinates, and map-pin correction.
- Clustered encounter map, local encounter list, and unavailable-tile fallback.
- Recovery prompt for interrupted Android image picking.

Development identifiers are `com.catdex.cat_dex` on Android and `com.catdex.catDex` on iOS. The interface is English. Re-encounters, accounts, export/backup, synchronization, and friends are not implemented yet. Data remains on this device; uninstalling the app can remove it.

Map tiles use OpenStreetMap with attribution and the map library's HTTP-aware cache. There are no region downloads or prefetch jobs. To use a different compatible raster endpoint, pass `--dart-define=MAP_TILE_URL=https://…/{z}/{x}/{y}.png`; attribution must also be adapted before shipping another provider.
