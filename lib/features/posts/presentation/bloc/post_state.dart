import 'package:equatable/equatable.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/entities/post_sort_type.dart';
import 'package:post_app/core/error/failures.dart';

/// Base class for all Post-related states
/// Extends Equatable for testing and comparison
abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

/// Initial state when BLoC is first created
/// No data has been loaded yet
/// 
/// Typical UI: Shows empty/loading placeholder
class PostInitial extends PostState {
  const PostInitial();

  @override
  List<Object?> get props => [];
}

/// ============================================================================
/// POST LIST STATES
/// ============================================================================

/// Loading state for fetching list of all posts
/// 
/// Typical UI: Shows loading spinner/skeleton
class PostListLoading extends PostState {
  const PostListLoading();

  @override
  List<Object?> get props => [];
}

/// Success state when list of posts is loaded and displayed
/// Contains the list of posts to display with current sorting
/// 
/// Parameters:
/// - [posts]: List of Post entities to display
/// - [sortType]: Current sorting type applied to the list
/// - [message]: Optional success message to show to user
/// 
/// Typical UI: Shows list of posts in ListView with sort indicator
/// 
/// Example:
/// ```dart
/// if (state is PostListLoaded) {
///   return ListView(
///     children: state.posts.map((post) => PostTile(post)).toList(),
///   );
/// }
/// ```
class PostListLoaded extends PostState {

  const PostListLoaded({
    required this.posts,
    this.sortType = PostSortType.idAscending,
    this.message,
  });
  final List<Post> posts;
  final PostSortType sortType;
  final String? message;

  @override
  List<Object?> get props => [posts, sortType, message];
}

/// ============================================================================
/// POST DETAIL STATES
/// ============================================================================

/// Loading state for fetching a single post by ID
/// 
/// Parameters:
/// - [postId]: The ID of the post being fetched
/// 
/// Typical UI: Shows loading spinner/skeleton for detail view
class PostDetailLoading extends PostState {
  const PostDetailLoading({
    required this.postId,
  });
  
  final String postId;

  @override
  List<Object?> get props => [postId];
}

/// Success state when a single post is loaded for detail view
/// Contains the specific post to display in detail
/// 
/// Parameters:
/// - [post]: The Post entity to display in detail
/// - [message]: Optional success message to show to user
/// 
/// Typical UI: Shows full post content (title, body, metadata)
/// 
/// Example:
/// ```dart
/// if (state is PostDetailLoaded) {
///   return PostCard(post: state.post);
/// }
/// ```
class PostDetailLoaded extends PostState {

  const PostDetailLoaded({
    required this.post,
    this.message,
  });
  final Post post;
  final String? message;

  @override
  List<Object?> get props => [post, message];
}

/// Backwards compatibility - maps to list loaded
@Deprecated('Use PostListLoaded or PostDetailLoaded instead')
class PostLoaded extends PostState {

  const PostLoaded({
    required this.posts,
    this.message,
  });
  final List<Post> posts;
  final String? message;

  @override
  List<Object?> get props => [posts, message];
}

/// Loading state that covers both list and detail loading
/// 
/// Typical UI: Shows loading spinner/skeleton
@Deprecated('Use PostListLoading or PostDetailLoading instead')
class PostLoading extends PostState {
  const PostLoading();

  @override
  List<Object?> get props => [];
}

/// Error state when an operation fails
/// Contains failure information for error display
/// 
/// Parameters:
/// - [failure]: Failure object containing error details
/// - [message]: User-friendly error message
/// - [previousPosts]: Optional list of previously loaded posts (for context)
/// 
/// Typical UI: Shows error message, snackbar, or error dialog
/// 
/// Error Types:
/// - ServerFailure: API returned error
/// - NetworkFailure: No network connection
/// - CacheFailure: Local cache error
/// - ValidationFailure: Input validation error
/// - UnexpectedFailure: Unexpected error
/// 
/// Example:
/// ```dart
/// if (state is PostError) {
///   ScaffoldMessenger.of(context).showSnackBar(
///     SnackBar(text: state.message),
///   );
/// }
/// ```
class PostError extends PostState {

  const PostError({
    required this.failure,
    required this.message,
    this.previousPosts,
  });
  final Failure failure;
  final String message;
  final List<Post>? previousPosts;

  @override
  List<Object?> get props => [failure, message, previousPosts];
}

/// Success state after creating a new post
/// Indicates the post was successfully created
/// 
/// Parameters:
/// - [post]: The newly created Post entity
/// - [message]: Success message to show to user
/// 
/// Typical UI: Show toast notification, navigate away, or add to list
/// 
/// Example:
/// ```dart
/// if (state is PostCreated) {
///   Navigator.pop(context); // Navigate back
///   ScaffoldMessenger.of(context).showSnackBar(
///     SnackBar(text: 'Post created successfully'),
///   );
/// }
/// ```
class PostCreated extends PostState {

  const PostCreated({
    required this.post,
    required this.message,
  });
  final Post post;
  final String message;

  @override
  List<Object?> get props => [post, message];
}

/// Success state after updating a post
/// Indicates the post was successfully updated
/// 
/// Parameters:
/// - [post]: The updated Post entity
/// - [message]: Success message to show to user
/// 
/// Typical UI: Show toast notification, refresh list, update detail view
/// 
/// Example:
/// ```dart
/// if (state is PostUpdated) {
///   ScaffoldMessenger.of(context).showSnackBar(
///     SnackBar(text: 'Post updated successfully'),
///   );
/// }
/// ```
class PostUpdated extends PostState {

  const PostUpdated({
    required this.post,
    required this.message,
  });
  final Post post;
  final String message;

  @override
  List<Object?> get props => [post, message];
}

/// Success state after deleting a post
/// Indicates the post was successfully deleted
/// 
/// Parameters:
/// - [message]: Success message to show to user
/// 
/// Typical UI: Show toast notification, navigate away, remove from list
/// 
/// Example:
/// ```dart
/// if (state is PostDeleted) {
///   Navigator.pop(context); // Navigate back to list
///   ScaffoldMessenger.of(context).showSnackBar(
///     SnackBar(text: 'Post deleted successfully'),
///   );
/// }
/// ```
class PostDeleted extends PostState {

  const PostDeleted({
    required this.message,
  });
  final String message;

  @override
  List<Object?> get props => [message];
}
