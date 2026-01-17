import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:post_app/core/constants/app_constants.dart';
import 'package:post_app/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:post_app/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:post_app/features/posts/data/repositories/post_repository_impl.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';
import 'package:post_app/features/posts/domain/usecases/get_all_posts_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/read_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/update_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:post_app/features/posts/presentation/bloc/post_bloc.dart';
import 'dart:developer' as developer;

/// Service Locator Configuration
/// 
/// This file configures the GetIt service locator for dependency injection.
/// All dependencies are registered here in order of their dependencies.
/// 
/// Registration Order:
/// 1. External dependencies (Dio, Hive)
/// 2. Data sources (local, remote)
/// 3. Repositories (data layer)
/// 4. Use cases (domain layer)
/// 5. BLoC (presentation layer)
/// 
/// Usage:
/// ```dart
/// // Initialize in main()
/// await setupServiceLocator();
/// 
/// // Get instance of PostBloc
/// final postBloc = getIt<PostBloc>();
/// ```

final getIt = GetIt.instance;

/// Sets up all dependencies for dependency injection
/// 
/// Must be called in main() before running the app:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Hive.initFlutter();
///   await setupServiceLocator();
///   runApp(const MyApp());
/// }
/// ```
/// 
/// Architecture:
/// ```
/// External Dependencies (Dio, Hive)
///         ↓
/// Data Sources (Local, Remote)
///         ↓
/// Repositories (Data layer)
///         ↓
/// Use Cases (Domain layer)
///         ↓
/// BLoC (Presentation layer)
/// ```
/// 
/// Throws: Exception if any registration fails
/// Returns: Completes when all dependencies are registered
Future<void> setupServiceLocator() async {
  try {
    developer.log('🔧 Starting service locator setup...', name: 'ServiceLocator');
    
    // ============ External Dependencies ============
    
    /// Register Dio HTTP client with configured options
    /// 
    /// Configuration:
    /// - Base URL: https://jsonplaceholder.typicode.com
    /// - Connect timeout: 30 seconds
    /// - Send timeout: 30 seconds
    /// - Receive timeout: 30 seconds
    /// 
    /// Includes request/response logging in debug mode
    final dioClient = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(
          milliseconds: ApiConstants.connectTimeoutMs,
        ),
        sendTimeout: Duration(
          milliseconds: ApiConstants.sendTimeoutMs,
        ),
        receiveTimeout: Duration(
          milliseconds: ApiConstants.receiveTimeoutMs,
        ),
      ),
    );
    
    // Add logging interceptor in debug mode
    dioClient.interceptors.add(
      LoggingInterceptor(),
    );
    
    getIt.registerSingleton<Dio>(dioClient);
    developer.log('✅ Dio HTTP client registered', name: 'ServiceLocator');

    // ============ Data Sources ============
    
    /// Register PostLocalDataSource (Hive-based persistence)
    /// 
    /// Responsibilities:
    /// - Cache posts locally using Hive
    /// - Manage cache expiration
    /// - Handle Hive box lifecycle
    /// - Provide fallback data when offline
    /// 
    /// Initialization: Must call initialize() to open Hive boxes
    final localDataSource = PostLocalDataSourceImpl();
    await localDataSource.initialize();
    
    getIt.registerSingleton<PostLocalDataSource>(
      localDataSource,
    );
    developer.log('✅ PostLocalDataSource registered', name: 'ServiceLocator');

    /// Register PostRemoteDataSource (Dio-based API client)
    /// 
    /// Responsibilities:
    /// - Fetch posts from REST API
    /// - Handle HTTP errors and exceptions
    /// - Implement exception mapping to domain failures
    /// - Retry logic for failed requests
    /// 
    /// Dependencies: Dio instance for HTTP communication
    getIt.registerSingleton<PostRemoteDataSource>(
      PostRemoteDataSourceImpl(
        getIt<Dio>(),
      ),
    );
    developer.log('✅ PostRemoteDataSource registered', name: 'ServiceLocator');

    // ============ Repositories ============
    
    /// Register PostRepository (Data layer repository implementation)
    /// 
    /// Implements: PostRepository abstract interface
    /// 
    /// Responsibilities:
    /// - Combine local and remote data sources
    /// - Implement caching strategy (remote-first with local fallback)
    /// - Handle failure conversion (Exception → Failure)
    /// - Provide unified data access interface
    /// 
    /// Dependencies:
    /// - PostRemoteDataSource (for API calls)
    /// - PostLocalDataSource (for caching)
    /// 
    /// Caching Strategy:
    /// - Try remote first
    /// - On success, save to local cache
    /// - On failure, return cached data if available
    /// - On complete failure, return error
    getIt.registerSingleton<PostRepository>(
      PostRepositoryImpl(
        remoteDataSource: getIt<PostRemoteDataSource>(),
        localDataSource: localDataSource,
      ),
    );
    developer.log('✅ PostRepository registered', name: 'ServiceLocator');

    // ============ Use Cases ============
    
    /// Register GetAllPostsUseCase
    /// 
    /// Business Logic: Fetch all posts with caching
    /// Parameters: NoParams (no input parameters required)
    /// Returns: Either<Failure, List<Post>>
    /// 
    /// Dependencies: PostRepository
    getIt.registerSingleton<GetAllPostsUseCase>(
      GetAllPostsUseCase(
        getIt<PostRepository>(),
      ),
    );

    /// Register ReadPostUseCase
    /// 
    /// Business Logic: Fetch single post by ID
    /// Parameters: GetPostParams(id)
    /// Returns: Either<Failure, Post>
    /// 
    /// Dependencies: PostRepository
    getIt.registerSingleton<ReadPostUseCase>(
      ReadPostUseCase(
        getIt<PostRepository>(),
      ),
    );

    /// Register CreatePostUseCase
    /// 
    /// Business Logic: Create new post on server
    /// Parameters: CreatePostParams(title, body, userId)
    /// Returns: Either<Failure, Post>
    /// 
    /// Dependencies: PostRepository
    getIt.registerSingleton<CreatePostUseCase>(
      CreatePostUseCase(
        getIt<PostRepository>(),
      ),
    );

    /// Register UpdatePostUseCase
    /// 
    /// Business Logic: Update existing post on server
    /// Parameters: UpdatePostParams(id, title, body)
    /// Returns: Either<Failure, Post>
    /// 
    /// Dependencies: PostRepository
    getIt.registerSingleton<UpdatePostUseCase>(
      UpdatePostUseCase(
        getIt<PostRepository>(),
      ),
    );

    /// Register DeletePostUseCase
    /// 
    /// Business Logic: Delete post from server
    /// Parameters: DeletePostParams(id)
    /// Returns: Either<Failure, void>
    /// 
    /// Dependencies: PostRepository
    getIt.registerSingleton<DeletePostUseCase>(
      DeletePostUseCase(
        getIt<PostRepository>(),
      ),
    );
    developer.log('✅ All use cases registered', name: 'ServiceLocator');

    // ============ BLoC (Presentation Layer) ============
    
    /// Register PostBloc
    /// 
    /// Responsibilities:
    /// - Manage post-related application state
    /// - Handle user-triggered events
    /// - Coordinate between UI and use cases
    /// - Emit state changes for UI reactivity
    /// 
    /// Lifecycle: Singleton
    /// - Single instance for entire app lifetime
    /// - Persists across navigation
    /// - Maintains state between screens
    /// 
    /// Dependencies:
    /// - GetAllPostsUseCase (fetch all posts)
    /// - ReadPostUseCase (fetch single post)
    /// - CreatePostUseCase (create new post)
    /// - UpdatePostUseCase (update existing post)
    /// - DeletePostUseCase (delete post)
    /// 
    /// Event Handlers:
    /// - GetAllPostsEvent → fetches all posts
    /// - GetPostByIdEvent → fetches single post
    /// - CreatePostEvent → creates new post
    /// - UpdatePostEvent → updates existing post
    /// - DeletePostEvent → deletes post
    /// - RefreshPostsEvent → refreshes posts list
    getIt.registerSingleton<PostBloc>(
      PostBloc(
        getAllPostsUseCase: getIt<GetAllPostsUseCase>(),
        readPostUseCase: getIt<ReadPostUseCase>(),
        createPostUseCase: getIt<CreatePostUseCase>(),
        updatePostUseCase: getIt<UpdatePostUseCase>(),
        deletePostUseCase: getIt<DeletePostUseCase>(),
      ),
    );
    developer.log('✅ PostBloc registered', name: 'ServiceLocator');

    // ============ Registration Complete ============
    
    developer.log(
      '🎉 Service locator setup complete! All dependencies registered.',
      name: 'ServiceLocator',
    );
  } catch (e, stackTrace) {
    developer.log(
      '❌ Service locator setup failed: $e',
      name: 'ServiceLocator',
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

/// Cleans up all registered dependencies gracefully
/// 
/// Should be called when the app closes or when resetting state:
/// ```dart
/// void onAppExit() async {
///   await cleanupServiceLocator();
/// }
/// ```
/// 
/// Cleanup sequence:
/// 1. Close PostBloc (cancels streams, closes events)
/// 2. Close PostLocalDataSource (closes Hive boxes)
/// 3. Reset all GetIt registrations
/// 
/// Note: Errors during cleanup are logged but don't throw
Future<void> cleanupServiceLocator() async {
  try {
    developer.log('🧹 Starting service locator cleanup...', name: 'ServiceLocator');
    
    // Close BLoC streams
    try {
      await getIt<PostBloc>().close();
      developer.log('✅ PostBloc closed', name: 'ServiceLocator');
    } catch (e) {
      developer.log('⚠️ Error closing PostBloc: $e', name: 'ServiceLocator');
    }
    
    // Close local data source boxes (Hive)
    try {
      await (getIt<PostLocalDataSource>() as PostLocalDataSourceImpl).close();
      developer.log('✅ Hive boxes closed', name: 'ServiceLocator');
    } catch (e) {
      developer.log('⚠️ Error closing Hive boxes: $e', name: 'ServiceLocator');
    }
    
    // Reset all registrations
    try {
      await getIt.reset();
      developer.log('✅ Service locator reset complete', name: 'ServiceLocator');
    } catch (e) {
      developer.log('⚠️ Error resetting service locator: $e', name: 'ServiceLocator');
    }
    
    developer.log('🎉 Cleanup complete!', name: 'ServiceLocator');
  } catch (e, stackTrace) {
    developer.log(
      '❌ Cleanup error: $e',
      name: 'ServiceLocator',
      error: e,
      stackTrace: stackTrace,
    );
  }
}

// ============ Dio Interceptors ============

/// Custom logging interceptor for Dio HTTP client
/// 
/// Logs all HTTP requests and responses in debug mode
/// 
/// Logs include:
/// - Request method, path, headers
/// - Request body (if applicable)
/// - Response status code, headers
/// - Response body (if applicable)
/// - Error information (if applicable)
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '→ ${options.method} ${options.path}',
      name: 'Dio',
    );
    developer.log(
      'Headers: ${options.headers}',
      name: 'Dio',
    );
    if (options.data != null) {
      developer.log(
        'Body: ${options.data}',
        name: 'Dio',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.path}',
      name: 'Dio',
    );
    developer.log(
      'Response: ${response.data}',
      name: 'Dio',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '❌ ${err.requestOptions.method} ${err.requestOptions.path}',
      name: 'Dio',
      error: err,
    );
    handler.next(err);
  }
}
