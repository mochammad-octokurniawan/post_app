import 'package:equatable/equatable.dart';
import 'package:post_app/features/posts/domain/entities/post_sort_type.dart';

/// Base class for all Post-related events
/// Extends Equatable for testing and comparison
abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch all posts from the repository with optional sorting
/// Triggered when user navigates to posts list or requests refresh
/// 
/// Parameters:
/// - [sortType]: Type of sorting to apply (defaults to ID ascending)
/// 
/// Example:
/// ```dart
/// context.read<PostBloc>().add(
///   GetAllPostsEvent(sortType: PostSortType.titleAscending),
/// );
/// ```
class GetAllPostsEvent extends PostEvent {
  const GetAllPostsEvent({
    this.sortType = PostSortType.idAscending,
  });

  /// The sorting type to apply when fetching posts
  final PostSortType sortType;

  @override
  List<Object?> get props => [sortType];
}

/// Event to fetch a single post by ID
/// Used when navigating to post detail page
/// 
/// Parameters:
/// - [id]: The post ID to fetch
/// 
/// Example:
/// ```dart
/// context.read<PostBloc>().add(GetPostByIdEvent(id: '1'));
/// ```
class GetPostByIdEvent extends PostEvent {

  const GetPostByIdEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to create a new post
/// Triggered when user submits the create post form
/// 
/// Parameters:
/// - [title]: Post title (1-100 characters)
/// - [body]: Post content (1-5000 characters)
/// - [userId]: ID of the user creating the post
/// 
/// Example:
/// ```dart
/// context.read<PostBloc>().add(
///   CreatePostEvent(
///     title: 'My First Post',
///     body: 'This is the content',
///     userId: 1,
///   ),
/// );
/// ```
class CreatePostEvent extends PostEvent {

  const CreatePostEvent({
    required this.title,
    required this.body,
    required this.userId,
  });
  final String title;
  final String body;
  final int userId;

  @override
  List<Object?> get props => [title, body, userId];
}

/// Event to update an existing post
/// Triggered when user submits the edit post form
/// 
/// Parameters:
/// - [id]: ID of the post to update
/// - [title]: Updated post title (1-100 characters)
/// - [body]: Updated post content (1-5000 characters)
/// 
/// Example:
/// ```dart
/// context.read<PostBloc>().add(
///   UpdatePostEvent(
///     id: '1',
///     title: 'Updated Title',
///     body: 'Updated content',
///   ),
/// );
/// ```
class UpdatePostEvent extends PostEvent {

  const UpdatePostEvent({
    required this.id,
    required this.title,
    required this.body,
  });
  final String id;
  final String title;
  final String body;

  @override
  List<Object?> get props => [id, title, body];
}

/// Event to delete a post
/// Triggered when user clicks delete button
/// 
/// Parameters:
/// - [id]: ID of the post to delete
/// 
/// Example:
/// ```dart
/// context.read<PostBloc>().add(DeletePostEvent(id: '1'));
/// ```
class DeletePostEvent extends PostEvent {

  const DeletePostEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to refresh posts list with optional sorting
/// Similar to GetAllPostsEvent but indicates explicit user refresh
/// Can be used to clear cache and force API call
/// 
/// Parameters:
/// - [sortType]: Type of sorting to apply (defaults to ID ascending)
/// 
/// Example:
/// ```dart
/// context.read<PostBloc>().add(
///   RefreshPostsEvent(sortType: PostSortType.titleAscending),
/// );
/// ```
class RefreshPostsEvent extends PostEvent {
  const RefreshPostsEvent({
    this.sortType = PostSortType.idAscending,
  });

  /// The sorting type to apply when refreshing posts
  final PostSortType sortType;

  @override
  List<Object?> get props => [sortType];
}
