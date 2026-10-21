import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/entry.dart';
import '../providers.dart';
import 'maps.dart';
import 'shared.dart';
import 'theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tab = 0;
  bool _list = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recover());
  }

  Future<void> _recover() async {
    try {
      final path = await ref.read(captureProvider).recover();
      if (mounted && path != null) {
        ref.read(recoveredPhotoProvider.notifier).set(path);
      }
    } catch (_) {
      if (mounted) {
        showMessage(
          context,
          'The interrupted photo could not be recovered. Please choose it again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(entriesProvider);
    final recovered = ref.watch(recoveredPhotoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets, size: 23),
            SizedBox(width: 10),
            Text(
              'cat-dex',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'About your collection',
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Cat-dex',
              applicationVersion: '0.1.0',
              children: [
                const Text(
                  'A field guide to the cats you meet.\n\nYour collection is stored on this device. Cloud backup and friends are coming in a later version. Removing the app may remove your collection.',
                ),
              ],
            ),
            icon: const Icon(Icons.info_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => EmptyState(
          title: 'Couldn’t open your dex',
          message: 'Your collection could not be loaded. Try again.',
          action: OutlinedButton(
            onPressed: () => ref.invalidate(entriesProvider),
            child: const Text('Retry'),
          ),
        ),
        data: (cats) => Column(
          children: [
            if (recovered != null)
              MaterialBanner(
                content: const Text(
                  'A photo from an interrupted capture is ready.',
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        ref.read(recoveredPhotoProvider.notifier).set(null),
                    child: const Text('Dismiss'),
                  ),
                  TextButton(
                    onPressed: () => context.push('/add'),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            Expanded(child: _tab == 0 ? _dex(cats) : _map(cats)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () => context.push('/add'),
        backgroundColor: forest,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Add cat'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'My dex',
          ),
          NavigationDestination(
            icon: Icon(Icons.public_outlined),
            selectedIcon: Icon(Icons.public),
            label: 'World map',
          ),
        ],
      ),
    );
  }

  Widget _dex(List<CatEntry> cats) {
    final countries = cats
        .map((e) => e.sighting.countryCode)
        .whereType<String>()
        .toSet()
        .length;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Little encounters. Lasting memories.'),
                const SizedBox(height: 10),
                Text(
                  'Your feline\nfield guide.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _stat(
                        '${cats.length}',
                        cats.length == 1 ? 'cat collected' : 'cats collected',
                      ),
                    ),
                    Container(
                      height: 34,
                      width: 1,
                      color: line,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    Expanded(
                      child: _stat(
                        '$countries',
                        countries == 1 ? 'country' : 'countries',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (cats.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: 90),
              child: EmptyState(
                title: 'Every cat has a story.',
                message: 'Meet a cat. Take a photo.\nYour first discovery starts here.',
              ),
            ),
          )
        else ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
              child: Row(
                children: [
                  const Expanded(child: SectionLabel('The collection')),
                  Text(
                    'In discovery order',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: muted),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.crossAxisExtent >= 700 ? 3 : 2;
                return SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 270,
                  ),
                  itemCount: cats.length,
                  itemBuilder: (context, index) => _CatCard(cats[index]),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _stat(String count, String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(count, style: Theme.of(context).textTheme.headlineMedium),
      Text(label, style: const TextStyle(fontSize: 12, color: muted)),
    ],
  );

  Widget _map(List<CatEntry> cats) {
    final located = cats.where((c) => c.hasLocation).length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Out in the world',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '$located mapped · ${cats.length - located} without location',
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: _list ? 'Show map' : 'Show encounter list',
                onPressed: () => setState(() => _list = !_list),
                icon: Icon(_list ? Icons.map_outlined : Icons.list_alt),
              ),
            ],
          ),
        ),
        Expanded(
          child: _list
              ? cats.isEmpty
                    ? const EmptyState(
                        title: 'No encounters yet',
                        message:
                            'Your saved cats will appear here, even offline.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: cats.length,
                        separatorBuilder: (_, _) =>
                            const Divider(indent: 24, endIndent: 24),
                        itemBuilder: (_, index) {
                          final cat = cats[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            leading: SizedBox.square(
                              dimension: 56,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CatPhoto(path: cat.photo.localPath),
                              ),
                            ),
                            title: Text('${cat.number} · ${cat.title}'),
                            subtitle: Text(cat.place),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/cats/${cat.cat.id}'),
                          );
                        },
                      )
              : EncounterMap(
                  key: ValueKey(
                    cats
                        .map(
                          (e) =>
                              '${e.cat.id}:${e.sighting.lat}:${e.sighting.lng}',
                        )
                        .join(','),
                  ),
                  entries: cats,
                  onSelect: (cat) => context.push('/cats/${cat.cat.id}'),
                ),
        ),
      ],
    );
  }
}

class _CatCard extends StatelessWidget {
  const _CatCard(this.entry);
  final CatEntry entry;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => context.push('/cats/${entry.cat.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CatPhoto(path: entry.photo.localPath, cacheWidth: 600),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: paper,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.number,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: forest,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 13, color: muted),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        entry.place,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: muted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
