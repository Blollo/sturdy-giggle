import 'dart:io';
import 'dart:convert';

import 'package:cat_dex/data/database.dart';
import 'package:cat_dex/data/entry.dart';
import 'package:cat_dex/data/repository.dart';
import 'package:cat_dex/main.dart';
import 'package:cat_dex/providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'fakes.dart';

class _FixturePhotos extends FakePhotos {
  @override
  String absolutePath(String path) => p.absolute('test/fixtures/cat.png');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final configFile = File('.dart_tool/package_config.json').absolute;
    final config =
        jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
    final flutter = (config['packages'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((package) => package['name'] == 'flutter');
    final packageRoot = configFile.uri
        .resolve(flutter['rootUri'] as String)
        .toFilePath();
    final sdk = p.normalize(p.join(packageRoot, '../..'));
    final font = FontLoader('Roboto');
    for (final weight in ['Regular', 'Bold', 'Medium']) {
      font.addFont(
        File(
          p.join(sdk, 'bin/cache/artifacts/material_fonts/Roboto-$weight.ttf'),
        ).readAsBytes().then((bytes) => bytes.buffer.asByteData()),
      );
    }
    await font.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(
        File(
          p.join(
            sdk,
            'bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
          ),
        ).readAsBytes().then((bytes) => bytes.buffer.asByteData()),
      );
    await icons.load();
  });

  testWidgets('field guide screens at phone size', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final db = AppDatabase(NativeDatabase.memory());
    final repository = CatRepository(db, _FixturePhotos());
    await repository.initialize();
    try {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            repositoryProvider.overrideWithValue(repository),
            clockProvider.overrideWithValue(
              () => DateTime(2026, 10, 21, 14, 30),
            ),
            captureProvider.overrideWithValue(FakeCapture()),
          ],
          child: const CatDexApp(),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CatDexApp),
        matchesGoldenFile('goldens/dex_empty.png'),
      );
      await tester.tap(find.text('Add cat'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CatDexApp),
        matchesGoldenFile('goldens/add_cat.png'),
      );
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await repository.save(
        CatDraft(
          seenAt: DateTime(2026, 10, 20),
          name: 'Paprika',
          coatColor: 'Ginger',
          placeName: 'Rome, Italy',
          countryCode: 'IT',
        ),
        sourcePhoto: 'fixture',
      );
      await repository.save(
        CatDraft(
          seenAt: DateTime(2026, 10, 21),
          name: 'Mochi',
          coatColor: 'Black & white',
          placeName: 'Kyoto, Japan',
          countryCode: 'JP',
        ),
        sourcePhoto: 'fixture',
      );
      await tester.pumpAndSettle();
      // File IO and codec completion need real time plus rendered frames.
      var loaded = false;
      final image = ResizeImage(
        FileImage(File(p.absolute('test/fixtures/cat.png'))),
        width: 600,
      ).resolve(ImageConfiguration.empty);
      final listener = ImageStreamListener((_, _) => loaded = true);
      image.addListener(listener);
      for (var frame = 0; frame < 30 && !loaded; frame++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump(const Duration(milliseconds: 16));
      }
      image.removeListener(listener);
      expect(
        loaded,
        isTrue,
        reason: 'The fixture photo must be decoded before the screenshot.',
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(CatDexApp),
        matchesGoldenFile('goldens/dex_populated.png'),
      );
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await db.close();
    }
  });
}
