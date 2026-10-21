import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/entry.dart';
import 'data/repository.dart';
import 'services/device_services.dart';

final repositoryProvider = Provider<CatRepository>(
  (ref) => throw UnimplementedError('Override at startup'),
);
final captureProvider = Provider<CaptureService>(
  (ref) => DeviceCaptureService(),
);
final locationProvider = Provider<LocationService>(
  (ref) => DeviceLocationService(),
);
final entriesProvider = StreamProvider<List<CatEntry>>(
  (ref) => ref.watch(repositoryProvider).watchEntries(),
);

// Recovered Android picker data is offered to the user instead of silently saved.
final recoveredPhotoProvider = NotifierProvider<RecoveredPhoto, String?>(
  RecoveredPhoto.new,
);

class RecoveredPhoto extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? path) => state = path;
}

final mapTileProvider = Provider<TileProvider?>((ref) => null);

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
