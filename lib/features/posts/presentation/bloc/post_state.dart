import 'package:equatable/equatable.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
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

/// Loading state while fetching data from repository
/// Used for:
/// - Fetching all posts
/// - Fetching single post
/// - Creating new post
/// - Updating post
/// - Deleting post
/// 
/// Typical UI: Shows loading spinner/skeleton
class PostLoading extends PostState {
  const PostLoading();

  @override
  List<Object?> get props => [];
}

/// Success state when posts are loaded and displayed
/// Contains the list of posts to display
/// 
/// Parameters:
/// - [posts]: List of Post entities to display
/// - [message]: Optional success message to show to user
/// 
/// Typical UI: Shows list of posts, hides loading indicator
/// 
/// Example:
/// ```dart
/// if (state is PostLoaded) {
///   return ListView(
///     children: state.posts.map((post) => PostTile(post)).toList(),
///   );
/// }
/// ```
class PostLoaded extends PostState {
  final List<Post> posts;
  final String? message;

  const PostLoaded({
    required this.posts,
    this.message,
  });

  @override
  List<Object?> get props => [posts, message];
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
  final Failure failure;
  final String message;
  final List<Post>? previousPosts;

  const PostError({
    required this.failure,
    required this.message,
    this.previousPosts,
  });

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
  final Post post;
  final String message;

  const PostCreated({
    required this.post,
    required this.message,
  });

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
  final Post post;
  final String message;

  const PostUpdated({
    required this.post,
    required this.message,
  });

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
  final String message;

  const PostDeleted({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
