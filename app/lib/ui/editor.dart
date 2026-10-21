import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../data/entry.dart';
import '../providers.dart';
import '../services/device_services.dart';
import 'maps.dart';
import 'shared.dart';
import 'theme.dart';

class EditorScreen extends ConsumerWidget {
  const EditorScreen({this.id, super.key});
  final String? id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null) return const _EditorForm();
    return ref
        .watch(entriesProvider)
        .when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (_, _) => Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Couldn’t load this cat.')),
          ),
          data: (entries) {
            final entry = entries.where((e) => e.cat.id == id).firstOrNull;
            if (entry == null) {
              return Scaffold(
                appBar: AppBar(),
                body: const Center(child: Text('Cat not found.')),
              );
            }
            return _EditorForm(key: ValueKey(id), existing: entry);
          },
        );
  }
}

class _EditorForm extends ConsumerStatefulWidget {
  const _EditorForm({this.existing, super.key});
  final CatEntry? existing;
  @override
  ConsumerState<_EditorForm> createState() => _EditorFormState();
}

class _EditorFormState extends ConsumerState<_EditorForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(),
      _coat = TextEditingController(),
      _pattern = TextEditingController(),
      _notes = TextEditingController();
  final _lat = TextEditingController(),
      _lng = TextEditingController(),
      _place = TextEditingController(),
      _country = TextEditingController();
  late DateTime _seenAt;
  String? _photo;
  String? _locationStatus;
  bool _saving = false,
      _picking = false,
      _locating = false,
      _changed = false,
      _saved = false;
  int _locationRequest = 0;

  @override
  void initState() {
    super.initState();
    final entry = widget.existing;
    _seenAt =
        entry?.sighting.seenAt.toLocal() ?? ref.read(clockProvider)().toLocal();
    _name.text = entry?.cat.name ?? '';
    _coat.text = entry?.cat.coatColor ?? '';
    _pattern.text = entry?.cat.pattern ?? '';
    _notes.text = entry?.cat.notes ?? '';
    _lat.text = entry?.sighting.lat?.toString() ?? '';
    _lng.text = entry?.sighting.lng?.toString() ?? '';
    _place.text = entry?.sighting.placeName ?? '';
    _country.text = entry?.sighting.countryCode ?? '';
    if (entry == null) {
      _photo = ref.read(recoveredPhotoProvider);
      _changed = _photo != null;
    }
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _coat,
      _pattern,
      _notes,
      _lat,
      _lng,
      _place,
      _country,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pick(bool camera) async {
    if (_picking || _saving) return;
    setState(() => _picking = true);
    try {
      final path = await ref.read(captureProvider).pick(camera: camera);
      if (!mounted || path == null) return;
      setState(() {
        _photo = path;
        _changed = true;
      });
      if (camera &&
          widget.existing == null &&
          _lat.text.isEmpty &&
          _lng.text.isEmpty) {
        unawaited(_currentLocation());
      }
    } catch (_) {
      if (mounted) {
        showMessage(
          context,
          'Couldn’t open the photo picker. Check camera/photo access in Settings, or try the gallery.',
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _currentLocation() async {
    final request = ++_locationRequest;
    setState(() {
      _locating = true;
      _locationStatus = 'Finding your location… You can save without waiting.';
    });
    try {
      final fix = await ref.read(locationProvider).current();
      if (!mounted || request != _locationRequest || _saving) return;
      await _applyLocation(LatLng(fix.lat, fix.lng), request);
    } catch (error) {
      if (mounted && request == _locationRequest) {
        setState(() {
          _locationStatus = error is LocationFailure
              ? error.message
              : 'Location unavailable. Enter it manually or save without it.';
        });
      }
    } finally {
      if (mounted && request == _locationRequest) {
        setState(() => _locating = false);
      }
    }
  }

  Future<void> _applyLocation(LatLng point, int request) async {
    setState(() {
      _locating = false;
      _lat.text = point.latitude.toStringAsFixed(6);
      _lng.text = point.longitude.toStringAsFixed(6);
      _place.clear();
      _country.clear();
      _changed = true;
      _locationStatus = 'Coordinates saved. Looking up the place name…';
    });
    final place = await ref
        .read(locationProvider)
        .describe(point.latitude, point.longitude);
    if (!mounted || request != _locationRequest || _saving) return;
    setState(() {
      if (_place.text.isEmpty) _place.text = place?.name ?? '';
      if (_country.text.isEmpty) _country.text = place?.country ?? '';
      _locationStatus = place == null
          ? 'Coordinates saved. You can add the place name yourself.'
          : null;
    });
  }

  Future<void> _chooseMap() async {
    final lat = double.tryParse(_lat.text), lng = double.tryParse(_lng.text);
    final point = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => LocationPicker(
          initial:
              lat != null &&
                  lng != null &&
                  lat.isFinite &&
                  lng.isFinite &&
                  lat.abs() <= 90 &&
                  lng.abs() <= 180
              ? LatLng(lat, lng)
              : null,
        ),
      ),
    );
    if (!mounted || point == null) return;
    await _applyLocation(point, ++_locationRequest);
  }

  void _clearLocation() {
    ++_locationRequest;
    setState(() {
      _lat.clear();
      _lng.clear();
      _place.clear();
      _country.clear();
      _locationStatus = null;
      _locating = false;
      _changed = true;
    });
  }

  Future<void> _date() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _seenAt,
      firstDate: DateTime(1900),
      lastDate: ref.read(clockProvider)(),
    );
    if (!mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_seenAt),
    );
    if (!mounted) return;
    setState(() {
      _seenAt = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? _seenAt.hour,
        time?.minute ?? _seenAt.minute,
      );
      _changed = true;
    });
  }

  Future<void> _save() async {
    if (_saving || _picking) return;
    if (!_form.currentState!.validate()) return;
    if (_photo == null && widget.existing == null) {
      showMessage(context, 'Choose a photo first.');
      return;
    }
    setState(() => _saving = true);
    ++_locationRequest;
    try {
      final id = await ref
          .read(repositoryProvider)
          .save(
            CatDraft(
              seenAt: _seenAt,
              name: _name.text,
              coatColor: _coat.text,
              pattern: _pattern.text,
              notes: _notes.text,
              lat: double.tryParse(_lat.text.trim()),
              lng: double.tryParse(_lng.text.trim()),
              placeName: _place.text,
              countryCode: _country.text,
            ),
            catId: widget.existing?.cat.id,
            sourcePhoto: _photo,
          );
      if (!mounted) return;
      if (widget.existing == null) {
        ref.read(recoveredPhotoProvider.notifier).set(null);
      }
      setState(() {
        _saved = true;
        _saving = false;
      });
      if (widget.existing != null) {
        context.pop();
      } else {
        context.replace('/cats/$id');
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _locating = false;
        });
        showMessage(
          context,
          'Couldn’t save your cat. Your form is still here—check available storage and try again.',
        );
      }
    }
  }

  Future<void> _leave() async {
    if (_saving) return;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your unsaved changes will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (discard == true && mounted) {
      setState(() => _changed = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    }
  }

  String? _coordinate(String? text, bool latitude) {
    final value = text?.trim() ?? '';
    final other = latitude ? _lng.text.trim() : _lat.text.trim();
    if (value.isEmpty) {
      return other.isEmpty ? null : 'Both coordinates are needed';
    }
    final number = double.tryParse(value);
    final limit = latitude ? 90 : 180;
    if (number == null || !number.isFinite || number.abs() > limit) {
      return 'Use −$limit to $limit';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final photo = _photo ?? widget.existing?.photo.localPath;
    return PopScope(
      canPop: !_saving && (!_changed || _saved),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.existing == null ? 'A new discovery' : 'Edit discovery',
          ),
        ),
        body: AbsorbPointer(
          absorbing: _saving,
          child: Form(
            key: _form,
            onChanged: () {
              if (!_changed) setState(() => _changed = true);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              children: [
                const SectionLabel('One photo. One new friend.'),
                const SizedBox(height: 16),
                if (photo != null)
                  AspectRatio(
                    aspectRatio: 1.25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CatPhoto(path: photo, absolute: _photo != null),
                    ),
                  ),
                if (photo == null)
                  Container(
                    height: 190,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EBE0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CatSilhouette(size: 95),
                        SizedBox(height: 12),
                        Text(
                          'A photo starts their story',
                          style: TextStyle(color: forest),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _picking ? null : () => _pick(true),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _picking ? null : () => _pick(false),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
                if (_picking)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(),
                  ),
                const SizedBox(height: 26),
                const SectionLabel('Get to know them'),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Name (optional)',
                    hintText: 'A name, a nickname, a feeling…',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _coat,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 80,
                  decoration: const InputDecoration(
                    labelText: 'Coat color',
                    hintText: 'Ginger, black & white…',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _pattern,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 80,
                  decoration: const InputDecoration(
                    labelText: 'Pattern',
                    hintText: 'Tabby, calico, solid…',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _notes,
                  minLines: 3,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Field notes',
                    hintText: 'Sleepy café regular. Very good company.',
                  ),
                ),
                const SizedBox(height: 22),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('First encounter'),
                  subtitle: Text(
                    '${displayDate(_seenAt)} · ${TimeOfDay.fromDateTime(_seenAt).format(context)}',
                  ),
                  trailing: const Icon(Icons.edit_outlined, size: 20),
                  onTap: _date,
                ),
                const SizedBox(height: 20),
                const SectionLabel('Where your paths crossed'),
                const SizedBox(height: 8),
                const Text(
                  'Optional. Save now and add a location later.',
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _locating ? null : _currentLocation,
                  icon: const Icon(Icons.my_location),
                  label: Text(
                    _locating ? 'Finding location…' : 'Use my current location',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _chooseMap,
                  icon: const Icon(Icons.pin_drop_outlined),
                  label: const Text('Choose on map'),
                ),
                if (_locationStatus != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _locationStatus!,
                      style: const TextStyle(color: muted, fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _lat,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                        ),
                        validator: (v) => _coordinate(v, true),
                        onChanged: (_) {
                          ++_locationRequest;
                          setState(() {
                            _locating = false;
                            _locationStatus = null;
                            _place.clear();
                            _country.clear();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lng,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                        ),
                        validator: (v) => _coordinate(v, false),
                        onChanged: (_) {
                          ++_locationRequest;
                          setState(() {
                            _locating = false;
                            _locationStatus = null;
                            _place.clear();
                            _country.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _place,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Place name',
                    hintText: 'Trastevere, Rome',
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _country,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 2,
                  decoration: const InputDecoration(
                    labelText: 'Country code',
                    hintText: 'IT',
                    counterText: '',
                  ),
                  validator: (value) =>
                      value == null ||
                          value.trim().isEmpty ||
                          RegExp(r'^[A-Za-z]{2}$').hasMatch(value.trim())
                      ? null
                      : 'Use two letters, such as IT',
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _clearLocation,
                    icon: const Icon(Icons.location_off_outlined, size: 18),
                    label: const Text('Clear location'),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _saving || _picking ? null : _save,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(
                    _saving
                        ? 'Saving discovery…'
                        : widget.existing == null
                        ? 'Add to my dex'
                        : 'Save changes',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Saved on this device. No connection needed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
