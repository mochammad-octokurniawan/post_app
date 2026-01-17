import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:post_app/config/routes/router.dart';
import 'package:post_app/service_locator/service_locator.dart';
import 'package:post_app/features/posts/presentation/bloc/bloc.dart';
import 'dart:developer' as developer;

void main() async {
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();
    developer.log('✅ Flutter bindings initialized', name: 'Main');

    // Initialize Hive for local storage
    await Hive.initFlutter();
    developer.log('✅ Hive initialized', name: 'Main');

    // Initialize dependency injection
    await setupServiceLocator();
    developer.log('✅ Service locator setup complete', name: 'Main');

    runApp(const PostApp());
  } catch (e, stackTrace) {
    developer.log(
      '❌ App initialization error: $e',
      name: 'Main',
      error: e,
      stackTrace: stackTrace,
    );

    // Show error in debug mode
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Initialization Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostApp extends StatelessWidget {
  const PostApp({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<PostBloc>(
    // Create BLoC from service locator
    // The BLoC is a singleton, so it's the same instance throughout the app
    create: (_) {
      developer.log(
        '🔵 PostBloc created from service locator',
        name: 'PostApp',
      );
      return getIt<PostBloc>();
    },
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Post CRUD',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: appRouter,
    ),
  );
}
