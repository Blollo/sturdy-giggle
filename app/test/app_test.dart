import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cat_dex/data/database.dart';
import 'package:cat_dex/data/entry.dart';
import 'package:cat_dex/data/repository.dart';
import 'package:cat_dex/main.dart';
import 'package:cat_dex/providers.dart';
import 'package:cat_dex/services/device_services.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

final pixel = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
);

class TestTiles extends TileProvider {
  TestTiles({this.fail = false});
  final bool fail;
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      MemoryImage(fail ? Uint8List(0) : pixel);
}

void appTest(String name, WidgetTesterCallback body) {
  testWidgets(name, (tester) async {
    try {
      await body(tester);
    } finally {
      // Drain Drift's deferred stream cancellation before invariant checks.
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    }
  });
}

void main() {
  late AppDatabase db;
  late CatRepository repository;
  late FakePhotos photos;
  late FakeCapture capture;
  late FakeLocation location;
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    photos = FakePhotos();
    repository = CatRepository(db, photos);
    capture = FakeCapture();
    location = FakeLocation();
    await repository.initialize();
  });
  tearDown(() => db.close());

  Future<void> start(
    WidgetTester tester, {
    bool failedTiles = false,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repository),
          captureProvider.overrideWithValue(capture),
          locationProvider.overrideWithValue(location),
          mapTileProvider.overrideWith((ref) => TestTiles(fail: failedTiles)),
        ],
        child: const CatDexApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> add(WidgetTester tester, {bool camera = false}) async {
    await tester.tap(find.text('Add cat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(camera ? 'Camera' : 'Gallery'));
    await tester.pumpAndSettle();
  }

  Future<void> save(
    WidgetTester tester, {
    String label = 'Add to my dex',
  }) async {
    await tester.scrollUntilVisible(
      find.text(label),
      350,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  appTest('empty dex and editor render at a small phone size', (tester) async {
    await start(tester, size: const Size(320, 568));
    expect(find.text('Every cat has a story.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Add cat'));
    await tester.pumpAndSettle();
    expect(find.text('A photo starts their story'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  appTest('gallery → save without GPS → detail → edit → delete', (
    tester,
  ) async {
    await start(tester);
    await add(tester);
    expect(location.calls, 0);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name (optional)'),
      'Miso',
    );
    await save(tester);
    expect(find.text('Miso'), findsOneWidget);
    expect(find.text('The first encounter'.toUpperCase()), findsOneWidget);
    expect(
      ((await tester.runAsync(() => repository.watchEntries().first))!)
          .single
          .hasLocation,
      false,
    );
    await tester.tap(find.byTooltip('Edit cat'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name (optional)'),
      'Miso II',
    );
    await save(tester, label: 'Save changes');
    expect(find.text('Miso II'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete cat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete cat'));
    await tester.pumpAndSettle();
    expect(find.text('Every cat has a story.'), findsOneWidget);
    expect(
      (await tester.runAsync(() => repository.watchEntries().first))!,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
  });

  appTest('cancelled picker cannot create a cat', (tester) async {
    capture.nextPhoto = null;
    await start(tester);
    await add(tester);
    await save(tester);
    expect(find.text('Choose a photo first.'), findsOneWidget);
    expect(
      (await tester.runAsync(() => repository.watchEntries().first))!,
      isEmpty,
    );
  });

  appTest('camera permission failure leaves the gallery available', (
    tester,
  ) async {
    capture.fail = true;
    await start(tester);
    await add(tester, camera: true);
    expect(
      find.textContaining('Couldn’t open the photo picker'),
      findsOneWidget,
    );
    expect(find.text('Gallery'), findsOneWidget);
    expect(
      (await tester.runAsync(() => repository.watchEntries().first))!,
      isEmpty,
    );
  });

  appTest('GPS denial does not block saving a camera capture', (tester) async {
    location.failure = const LocationFailure(
      'Permission declined. Save without a location.',
    );
    await start(tester);
    await add(tester, camera: true);
    await save(tester);
    expect(
      ((await tester.runAsync(() => repository.watchEntries().first))!)
          .single
          .hasLocation,
      false,
    );
  });

  appTest('GPS timeout keeps photo and allows saving', (tester) async {
    location.failure = const LocationFailure(
      'GPS took too long. Try again or save without a location.',
    );
    await start(tester);
    await add(tester, camera: true);
    await save(tester);
    expect(
      ((await tester.runAsync(() => repository.watchEntries().first))!)
          .single
          .hasLocation,
      false,
    );
  });

  appTest('failed reverse geocoding preserves coordinates', (tester) async {
    location.label = null;
    await start(tester);
    await add(tester, camera: true);
    await save(tester);
    final entry = ((await tester.runAsync(
      () => repository.watchEntries().first,
    ))!).single;
    expect(entry.sighting.lat, 41.9);
    expect(entry.sighting.lng, 12.5);
    expect(entry.sighting.placeName, isNull);
  });

  appTest(
    'saving does not wait for GPS and late location cannot modify saved entry',
    (tester) async {
      location.gate = Completer<LocationFix>();
      await start(tester);
      await add(tester, camera: true);
      await save(tester);
      expect(
        ((await tester.runAsync(() => repository.watchEntries().first))!)
            .single
            .hasLocation,
        false,
      );
      location.gate!.complete(const LocationFix(10, 10));
      await tester.pumpAndSettle();
      expect(
        ((await tester.runAsync(() => repository.watchEntries().first))!)
            .single
            .hasLocation,
        false,
      );
      expect(tester.takeException(), isNull);
    },
  );

  appTest('repeated save taps import one photo and create one entry', (
    tester,
  ) async {
    photos.importGate = Completer<void>();
    await start(tester);
    await add(tester);
    await tester.scrollUntilVisible(
      find.text('Add to my dex'),
      350,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Add to my dex'));
    await tester.tap(find.text('Add to my dex'));
    await tester.pump();
    expect(photos.imports, 1);
    photos.importGate!.complete();
    await tester.pumpAndSettle();
    expect(
      (await tester.runAsync(() => repository.watchEntries().first))!,
      hasLength(1),
    );
  });

  appTest('save failure keeps the form and supports retry', (tester) async {
    photos.failImport = true;
    await start(tester);
    await add(tester);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name (optional)'),
      'Miso',
    );
    await save(tester);
    expect(find.textContaining('Couldn’t save your cat.'), findsOneWidget);
    expect(
      (await tester.runAsync(() => repository.watchEntries().first))!,
      isEmpty,
    );
    photos.failImport = false;
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await save(tester);
    expect(
      ((await tester.runAsync(() => repository.watchEntries().first))!)
          .single
          .title,
      'Miso',
    );
  });

  appTest('recovered Android photo is offered and explicitly saved', (
    tester,
  ) async {
    capture.recovered = '/recovered.jpg';
    await start(tester);
    expect(
      find.text('A photo from an interrupted capture is ready.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await save(tester);
    expect(
      (await tester.runAsync(() => repository.watchEntries().first))!,
      hasLength(1),
    );
  });

  appTest('map list includes entries without locations when map tiles fail', (
    tester,
  ) async {
    await repository.save(
      CatDraft(seenAt: DateTime.now(), name: 'Miso'),
      sourcePhoto: 'cat.jpg',
    );
    await start(tester, failedTiles: true);
    await tester.tap(find.text('World map'));
    await tester.pumpAndSettle();
    expect(find.text('0 mapped · 1 without location'), findsOneWidget);
    expect(find.textContaining('Map tiles unavailable'), findsOneWidget);
    await tester.tap(find.byTooltip('Show encounter list'));
    await tester.pumpAndSettle();
    expect(find.text('#001 · Miso'), findsOneWidget);
    expect(find.text('Location not recorded'), findsOneWidget);
  });

  appTest('nearby encounters cluster on the map', (tester) async {
    for (var i = 0; i < 3; i++) {
      await repository.save(
        CatDraft(seenAt: DateTime.now(), lat: 41.9, lng: 12.5),
        sourcePhoto: 'cat.jpg',
      );
    }
    await start(tester);
    await tester.tap(find.text('World map'));
    await tester.pumpAndSettle();
    expect(find.text('3 mapped · 0 without location'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
