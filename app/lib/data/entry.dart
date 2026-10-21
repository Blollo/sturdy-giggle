import 'database.dart';

class CatEntry {
  const CatEntry(this.cat, this.sighting, this.photo);
  final CatRecord cat;
  final SightingRecord sighting;
  final PhotoRecord photo;

  String get number => '#${cat.dexNumber.toString().padLeft(3, '0')}';
  String get title => cat.name ?? 'Cat $number';
  bool get hasLocation => sighting.lat != null && sighting.lng != null;
  String get place =>
      sighting.placeName ??
      (hasLocation ? 'Saved location' : 'Location not recorded');
}

class CatDraft {
  const CatDraft({
    required this.seenAt,
    this.name,
    this.coatColor,
    this.pattern,
    this.notes,
    this.lat,
    this.lng,
    this.placeName,
    this.countryCode,
  });
  final DateTime seenAt;
  final String? name, coatColor, pattern, notes, placeName, countryCode;
  final double? lat, lng;

  void validate() {
    if ((lat == null) != (lng == null) ||
        (lat != null && (!lat!.isFinite || lat! < -90 || lat! > 90)) ||
        (lng != null && (!lng!.isFinite || lng! < -180 || lng! > 180))) {
      throw ArgumentError('Enter a valid latitude and longitude together.');
    }
    final country = clean(countryCode);
    if (country != null && !RegExp(r'^[A-Za-z]{2}$').hasMatch(country)) {
      throw ArgumentError('Use a two-letter country code, such as IT.');
    }
  }

  static String? clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
