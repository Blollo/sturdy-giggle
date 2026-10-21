import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'data/database.dart';
import 'data/repository.dart';
import 'providers.dart';
import 'services/photo_store.dart';
import 'ui/detail.dart';
import 'ui/editor.dart';
import 'ui/home.dart';
import 'ui/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _Startup());
}

class _Startup extends StatefulWidget {
  const _Startup();
  @override
  State<_Startup> createState() => _StartupState();
}

class _StartupState extends State<_Startup> {
  late Future<CatRepository> _future;
  CatRepository? _repository;
  @override
  void initState() {
    super.initState();
    _future = _open();
  }

  Future<CatRepository> _open() async {
    final root = await getApplicationDocumentsDirectory();
    await Directory(root.path).create(recursive: true);
    final db = AppDatabase();
    final repository = CatRepository(db, DiskPhotoStore(root));
    try {
      await repository.initialize();
      _repository = repository;
      return repository;
    } catch (_) {
      await db.close();
      rethrow;
    }
  }

  @override
  void dispose() {
    _repository?.db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<CatRepository>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ProviderScope(
          overrides: [repositoryProvider.overrideWithValue(snapshot.data!)],
          child: const CatDexApp(),
        );
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: fieldGuideTheme(),
        home: Scaffold(
          body: Center(
            child: snapshot.hasError
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pets, size: 48, color: forest),
                        const SizedBox(height: 24),
                        const Text(
                          'Your collection couldn’t be opened. Check available storage and try again.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => setState(() => _future = _open()),
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}

class CatDexApp extends StatefulWidget {
  const CatDexApp({super.key});
  @override
  State<CatDexApp> createState() => _CatDexAppState();
}

class _CatDexAppState extends State<CatDexApp> {
  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const HomeScreen(),
        routes: [
          GoRoute(path: 'add', builder: (_, _) => const EditorScreen()),
          GoRoute(
            path: 'cats/:id',
            builder: (_, state) =>
                DetailScreen(id: state.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (_, state) =>
                    EditorScreen(id: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Cat-dex',
    debugShowCheckedModeBanner: false,
    theme: fieldGuideTheme(),
    routerConfig: _router,
  );
}
