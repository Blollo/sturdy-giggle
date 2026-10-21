import 'dart:async';

import 'package:cat_dex/services/device_services.dart';
import 'package:cat_dex/services/photo_store.dart';

class FakePhotos implements PhotoStore {
  final stored = <String>{};
  bool failImport = false;
  Completer<void>? importGate;
  int imports = 0;
  @override
  Future<StoredPhoto> importPhoto(String sourcePath, String id) async {
    imports++;
    await importGate?.future;
    if (failImport) throw StateError('Disk full');
    final path = 'photos/$id.jpg';
    stored.add(path);
    return StoredPhoto(path, 1200, 1600);
  }

  @override
  String absolutePath(String path) => '/private/tmp/cat-dex-test-missing/$path';
  @override
  Future<void> cleanOrphans(Set<String> paths) async =>
      stored.removeWhere((path) => !paths.contains(path));
  @override
  Future<void> remove(String path) async {
    stored.remove(path);
  }
}

class FakeCapture implements CaptureService {
  String? nextPhoto = '/fake/cat.jpg';
  String? recovered;
  bool fail = false;
  int calls = 0;
  @override
  Future<String?> pick({required bool camera}) async {
    calls++;
    if (fail) throw StateError('Permission denied');
    return nextPhoto;
  }

  @override
  Future<String?> recover() async => recovered;
}

class FakeLocation implements LocationService {
  Object? failure;
  PlaceLabel? label = const PlaceLabel('Rome', 'IT');
  Completer<LocationFix>? gate;
  int calls = 0;
  @override
  Future<LocationFix> current() async {
    calls++;
    if (failure != null) throw failure!;
    return gate != null ? gate!.future : const LocationFix(41.9, 12.5);
  }

  @override
  Future<PlaceLabel?> describe(double lat, double lng) async => label;
}
