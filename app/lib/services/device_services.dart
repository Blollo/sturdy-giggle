import 'dart:async';
import 'dart:io';

import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

abstract interface class CaptureService {
  Future<String?> pick({required bool camera});
  Future<String?> recover();
}

class DeviceCaptureService implements CaptureService {
  final _picker = ImagePicker();
  @override
  Future<String?> pick({required bool camera}) async =>
      (await _picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        requestFullMetadata: false,
      ))?.path;

  @override
  Future<String?> recover() async {
    if (!Platform.isAndroid) return null;
    final response = await _picker.retrieveLostData();
    if (response.exception != null) throw response.exception!;
    return response.files?.firstOrNull?.path;
  }
}

class LocationFix {
  const LocationFix(this.lat, this.lng);
  final double lat, lng;
}

class PlaceLabel {
  const PlaceLabel(this.name, this.country);
  final String? name, country;
}

class LocationFailure implements Exception {
  const LocationFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

abstract interface class LocationService {
  Future<LocationFix> current();
  Future<PlaceLabel?> describe(double lat, double lng);
}

class DeviceLocationService implements LocationService {
  @override
  Future<LocationFix> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationFailure(
        'Location services are off. You can still save your cat.',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationFailure(
        'Location access is off in Settings. Enter a location manually or save without it.',
      );
    }
    if (permission == LocationPermission.denied) {
      throw const LocationFailure(
        'Location permission was declined. You can still save your cat.',
      );
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      ).timeout(const Duration(seconds: 15));
      return LocationFix(position.latitude, position.longitude);
    } on TimeoutException {
      throw const LocationFailure(
        'GPS took too long. Try again or save without a location.',
      );
    }
  }

  @override
  Future<PlaceLabel?> describe(double lat, double lng) async {
    try {
      final places = await geo.Geocoding()
          .placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 5));
      if (places.isEmpty) return null;
      final place = places.first;
      final parts = [
        place.locality,
        place.administrativeArea,
        place.country,
      ].whereType<String>().where((p) => p.isNotEmpty).toSet();
      return PlaceLabel(
        parts.isEmpty ? null : parts.join(', '),
        place.isoCountryCode,
      );
    } catch (_) {
      return null; // Coordinates remain usable without a network/geocoder.
    }
  }
}
