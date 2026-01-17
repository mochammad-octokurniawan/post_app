import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/core/constants/error_messages.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/usecases/get_all_posts_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/read_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/update_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/delete_post_usecase.dart';
import 'post_event.dart';
import 'post_state.dart';

/// PostBloc manages all Post-related state and business logic
/// Coordinates between domain use cases and presentation layer
/// 
/// Responsibilities:
/// - Handle user events (fetch, create, update, delete posts)
/// - Call appropriate use cases
/// - Convert Either<Failure, T> to appropriate states
/// - Emit states for UI consumption
/// 
/// Architecture:
/// ```
/// UI Layer (Pages/Widgets)
///       ↓
///   PostBloc (this)
///       ↓
/// Domain Use Cases
///       ↓
/// Data Repository
/// ```
/// 
/// Usage:
/// ```dart
/// BlocProvider(
///   create: (_) => PostBloc(
///     getAllPostsUseCase: getIt(),
///     readPostUseCase: getIt(),
///     createPostUseCase: getIt(),
///     updatePostUseCase: getIt(),
///     deletePostUseCase: getIt(),
///   ),
///   child: MyApp(),
/// )
/// ```
class PostBloc extends Bloc<PostEvent, PostState> {
  final GetAllPostsUseCase _getAllPostsUseCase;
  final ReadPostUseCase _readPostUseCase;
  final CreatePostUseCase _createPostUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  /// Constructor
  /// 
  /// Parameters:
  /// - [getAllPostsUseCase]: UseCase to fetch all posts
  /// - [readPostUseCase]: UseCase to fetch single post
  /// - [createPostUseCase]: UseCase to create new post
  /// - [updatePostUseCase]: UseCase to update post
  /// - [deletePostUseCase]: UseCase to delete post
  /// 
  /// Initializes:
  /// - State to PostInitial
  /// - Event handlers for each event type
  PostBloc({
    required GetAllPostsUseCase getAllPostsUseCase,
    required ReadPostUseCase readPostUseCase,
    required CreatePostUseCase createPostUseCase,
    required UpdatePostUseCase updatePostUseCase,
    required DeletePostUseCase deletePostUseCase,
  })  : _getAllPostsUseCase = getAllPostsUseCase,
        _readPostUseCase = readPostUseCase,
        _createPostUseCase = createPostUseCase,
        _updatePostUseCase = updatePostUseCase,
        _deletePostUseCase = deletePostUseCase,
        super(const PostInitial()) {
    // Register event handlers
    on<GetAllPostsEvent>(_onGetAllPostsEvent);
    on<GetPostByIdEvent>(_onGetPostByIdEvent);
    on<CreatePostEvent>(_onCreatePostEvent);
    on<UpdatePostEvent>(_onUpdatePostEvent);
    on<DeletePostEvent>(_onDeletePostEvent);
    on<RefreshPostsEvent>(_onRefreshPostsEvent);
  }

  /// Handle GetAllPostsEvent
  /// 
  /// Flow:
  /// 1. Emit PostLoading state
  /// 2. Call GetAllPostsUseCase
  /// 3. Handle Either<Failure, List<Post>>:
  ///    - Success: Emit PostLoaded with posts
  ///    - Failure: Emit PostError with failure details
  /// 
  /// Event may have previous posts stored to maintain UI context
  Future<void> _onGetAllPostsEvent(
    GetAllPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());

    final result = await _getAllPostsUseCase(const NoParams());

    result.fold(
      // Failure case
      (failure) {
        final message = _getFailureMessage(failure);
        emit(
          PostError(
            failure: failure,
            message: message,
          ),
        );
      },
      // Success case
      (posts) {
        emit(
          PostLoaded(
            posts: posts,
            message: ErrorMessages.createPostSuccess,
          ),
        );
      },
    );
  }

  /// Handle GetPostByIdEvent
  /// 
  /// Flow:
  /// 1. Emit PostLoading state
  /// 2. Call ReadPostUseCase with post ID
  /// 3. Handle Either<Failure, Post>:
  ///    - Success: Emit PostLoaded with single post in list
  ///    - Failure: Emit PostError with failure details
  /// 
  /// Note: Returns single post wrapped in list for UI consistency
  Future<void> _onGetPostByIdEvent(
    GetPostByIdEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());

    final result = await _readPostUseCase(
      GetPostParams(id: int.parse(event.id)),
    );

    result.fold(
      // Failure case
      (failure) {
        final message = _getFailureMessage(failure);
        emit(
          PostError(
            failure: failure,
            message: message,
          ),
        );
      },
      // Success case
      (post) {
        emit(
          PostLoaded(
            posts: [post],
            message: ErrorMessages.createPostSuccess,
          ),
        );
      },
    );
  }

  /// Handle CreatePostEvent
  /// 
  /// Flow:
  /// 1. Emit PostLoading state
  /// 2. Call CreatePostUseCase with post data
  /// 3. Handle Either<Failure, Post>:
  ///    - Success: Emit PostCreated with new post
  ///    - Failure: Emit PostError with failure details
  /// 
  /// UI typically:
  /// - Shows success toast
  /// - Navigates back to list
  /// - Refreshes list with new post
  Future<void> _onCreatePostEvent(
    CreatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());

    final result = await _createPostUseCase(
      CreatePostParams(
        title: event.title,
        body: event.body,
        userId: event.userId,
      ),
    );

    result.fold(
      // Failure case
      (failure) {
        final message = _getFailureMessage(failure);
        emit(
          PostError(
            failure: failure,
            message: message,
          ),
        );
      },
      // Success case
      (post) {
        emit(
          PostCreated(
            post: post,
            message: ErrorMessages.createPostSuccess,
          ),
        );
      },
    );
  }

  /// Handle UpdatePostEvent
  /// 
  /// Flow:
  /// 1. Emit PostLoading state
  /// 2. Call UpdatePostUseCase with updated post data
  /// 3. Handle Either<Failure, Post>:
  ///    - Success: Emit PostUpdated with updated post
  ///    - Failure: Emit PostError with failure details
  /// 
  /// UI typically:
  /// - Shows success toast
  /// - Navigates back to detail or list
  /// - Refreshes affected views
  Future<void> _onUpdatePostEvent(
    UpdatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());

    final result = await _updatePostUseCase(
      UpdatePostParams(
        id: int.parse(event.id),
        title: event.title,
        body: event.body,
      ),
    );

    result.fold(
      // Failure case
      (failure) {
        final message = _getFailureMessage(failure);
        emit(
          PostError(
            failure: failure,
            message: message,
          ),
        );
      },
      // Success case
      (post) {
        emit(
          PostUpdated(
            post: post,
            message: ErrorMessages.updatePostSuccess,
          ),
        );
      },
    );
  }

  /// Handle DeletePostEvent
  /// 
  /// Flow:
  /// 1. Emit PostLoading state
  /// 2. Call DeletePostUseCase with post ID
  /// 3. Handle Either<Failure, void>:
  ///    - Success: Emit PostDeleted with success message
  ///    - Failure: Emit PostError with failure details
  /// 
  /// UI typically:
  /// - Shows success toast
  /// - Removes post from list
  /// - Navigates back if on detail page
  Future<void> _onDeletePostEvent(
    DeletePostEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());

    final result = await _deletePostUseCase(
      DeletePostParams(id: int.parse(event.id)),
    );

    result.fold(
      // Failure case
      (failure) {
        final message = _getFailureMessage(failure);
        emit(
          PostError(
            failure: failure,
            message: message,
          ),
        );
      },
      // Success case
      (_) {
        emit(
          PostDeleted(
            message: ErrorMessages.deletePostSuccess,
          ),
        );
      },
    );
  }

  /// Handle RefreshPostsEvent
  /// 
  /// Similar to GetAllPostsEvent but indicates explicit user refresh
  /// Can be used to:
  /// - Clear cache and force fresh API call
  /// - Trigger pull-to-refresh UI action
  /// - Update posts list after modifications
  /// 
  /// Implementation same as GetAllPostsEvent
  Future<void> _onRefreshPostsEvent(
    RefreshPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());

    final result = await _getAllPostsUseCase(const NoParams());

    result.fold(
      // Failure case
      (failure) {
        final message = _getFailureMessage(failure);
        emit(
          PostError(
            failure: failure,
            message: message,
          ),
        );
      },
      // Success case
      (posts) {
        emit(
          PostLoaded(
            posts: posts,
            message: ErrorMessages.createPostSuccess,
          ),
        );
      },
    );
  }

  /// Maps failure types to user-friendly error messages
  /// 
  /// Failure Types:
  /// - ServerFailure: "Server error. Please try again later."
  /// - NetworkFailure: "Network error. Please check your connection."
  /// - CacheFailure: "Cache error. Please try again."
  /// - ValidationFailure: "Invalid input. Please check your data."
  /// - UnexpectedFailure: "An unexpected error occurred."
  /// 
  /// Parameters:
  /// - [failure]: Failure object to convert
  /// 
  /// Returns: User-friendly error message
  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return ErrorMessages.serverError;
    } else if (failure is NetworkFailure) {
      return ErrorMessages.networkError;
    } else if (failure is CacheFailure) {
      return ErrorMessages.cacheError;
    } else if (failure is ValidationFailure) {
      return ErrorMessages.validationError;
    } else {
      return ErrorMessages.unexpectedError;
    }
  }
}
