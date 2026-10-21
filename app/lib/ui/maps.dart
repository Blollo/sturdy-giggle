import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/entry.dart';
import 'theme.dart';

const tileUrl = String.fromEnvironment(
  'MAP_TILE_URL',
  defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
);

class EncounterMap extends ConsumerStatefulWidget {
  const EncounterMap({
    this.entries = const [],
    this.onSelect,
    this.onTap,
    this.selected,
    this.interactive = true,
    super.key,
  });
  final List<CatEntry> entries;
  final ValueChanged<CatEntry>? onSelect;
  final ValueChanged<LatLng>? onTap;
  final LatLng? selected;
  final bool interactive;
  @override
  ConsumerState<EncounterMap> createState() => _EncounterMapState();
}

class _EncounterMapState extends ConsumerState<EncounterMap> {
  bool _tileError = false;
  final _controller = MapController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final located = widget.entries.where((e) => e.hasLocation).toList();
    final points = located
        .map((e) => LatLng(e.sighting.lat!, e.sighting.lng!))
        .toList();
    final selected = widget.selected;
    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter:
                selected ??
                (points.isEmpty ? const LatLng(25, 10) : points.first),
            initialZoom: selected != null || points.length == 1 ? 13 : 2,
            initialCameraFit: selected == null && points.length > 1
                ? CameraFit.bounds(
                    bounds: LatLngBounds.fromPoints(points),
                    padding: const EdgeInsets.all(55),
                    maxZoom: 15,
                  )
                : null,
            interactionOptions: InteractionOptions(
              flags: widget.interactive
                  ? InteractiveFlag.all & ~InteractiveFlag.rotate
                  : InteractiveFlag.none,
            ),
            onTap: (_, point) => widget.onTap?.call(point),
            backgroundColor: const Color(0xFFE7EBDD),
          ),
          children: [
            TileLayer(
              urlTemplate: tileUrl,
              tileProvider: ref.watch(mapTileProvider),
              userAgentPackageName: 'com.catdex.app',
              errorTileCallback: (_, _, _) {
                if (!_tileError && mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _tileError = true);
                  });
                }
              },
            ),
            if (located.isNotEmpty)
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(46, 46),
                  markers: located
                      .map(
                        (e) => Marker(
                          point: LatLng(e.sighting.lat!, e.sighting.lng!),
                          width: 48,
                          height: 48,
                          child: IconButton.filled(
                            tooltip: '${e.number} ${e.title}',
                            onPressed: () => widget.onSelect?.call(e),
                            icon: const Icon(Icons.pets, size: 22),
                          ),
                        ),
                      )
                      .toList(),
                  builder: (_, markers) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: forest,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        '${markers.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (selected != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: selected,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.location_on,
                      color: forest,
                      size: 46,
                    ),
                  ),
                ],
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: Material(
                color: Colors.white.withValues(alpha: 0.94),
                child: InkWell(
                  onTap: () async {
                    await launchUrl(
                      Uri.parse('https://www.openstreetmap.org/copyright'),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Text(
                      '© OpenStreetMap contributors',
                      style: TextStyle(fontSize: 11, color: forest),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_tileError)
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Material(
              color: paper,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Map tiles unavailable. Your saved encounters are still here.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class LocationPicker extends StatefulWidget {
  const LocationPicker({this.initial, super.key});
  final LatLng? initial;
  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _point;
  @override
  void initState() {
    super.initState();
    _point = widget.initial;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Choose a location')),
    body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Tap the map where you met this cat.'),
        ),
        Expanded(
          child: EncounterMap(
            selected: _point,
            onTap: (point) => setState(() => _point = point),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _point == null
                    ? null
                    : () => Navigator.pop(context, _point),
                child: const Text('Use this location'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
