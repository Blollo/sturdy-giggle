import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/entry.dart';
import '../providers.dart';
import 'maps.dart';
import 'shared.dart';
import 'theme.dart';

class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({required this.id, super.key});
  final String id;
  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _deleting = false;
  Future<void> _delete(CatEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${entry.title}?'),
        content: Text(
          'This removes ${entry.number} from your collection and map. Its dex number won’t be reused.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep cat'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete cat'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      await ref.read(repositoryProvider).deleteCat(widget.id);
      if (mounted) context.go('/');
    } catch (_) {
      if (mounted) {
        setState(() => _deleting = false);
        showMessage(context, 'Couldn’t delete this cat. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) => ref
      .watch(entriesProvider)
      .when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, _) => Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Couldn’t load this cat.')),
        ),
        data: (entries) {
          final entry = entries.where((c) => c.cat.id == widget.id).firstOrNull;
          if (entry == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                title: 'Cat not found',
                message: 'This entry is no longer in your collection.',
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(entry.number),
              actions: [
                IconButton(
                  tooltip: 'Edit cat',
                  onPressed: _deleting
                      ? null
                      : () => context.push('/cats/${widget.id}/edit'),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Delete cat',
                  onPressed: _deleting ? null : () => _delete(entry),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            body: _deleting
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: CatPhoto(
                            path: entry.photo.localPath,
                            cacheWidth: 1600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const SectionLabel('A familiar face'),
                      const SizedBox(height: 8),
                      Text(
                        entry.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 10),
                      if (entry.cat.coatColor != null ||
                          entry.cat.pattern != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (entry.cat.coatColor != null)
                              Chip(
                                avatar: const Icon(
                                  Icons.palette_outlined,
                                  size: 17,
                                ),
                                label: Text(entry.cat.coatColor!),
                              ),
                            if (entry.cat.pattern != null)
                              Chip(label: Text(entry.cat.pattern!)),
                          ],
                        ),
                      if (entry.cat.notes != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          entry.cat.notes!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Divider(),
                      ),
                      const SectionLabel('The first encounter'),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFE1EBDF),
                            child: Icon(Icons.pets, color: forest, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayDate(entry.sighting.seenAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.place,
                                  style: const TextStyle(color: muted),
                                ),
                                if (entry.hasLocation)
                                  Text(
                                    '${entry.sighting.lat!.toStringAsFixed(5)}, ${entry.sighting.lng!.toStringAsFixed(5)}',
                                    style: const TextStyle(
                                      color: muted,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (entry.hasLocation)
                        SizedBox(
                          height: 220,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: EncounterMap(
                              key: ValueKey(
                                '${entry.sighting.lat}:${entry.sighting.lng}',
                              ),
                              entries: [entry],
                              interactive: false,
                            ),
                          ),
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: () =>
                              context.push('/cats/${widget.id}/edit'),
                          icon: const Icon(Icons.add_location_alt_outlined),
                          label: const Text('Add a location'),
                        ),
                    ],
                  ),
          );
        },
      );
}
