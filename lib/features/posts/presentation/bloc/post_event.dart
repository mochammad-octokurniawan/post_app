import 'package:equatable/equatable.dart';

/// Base class for all Post-related events
/// Extends Equatable for testing and comparison
abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch all posts from the repository
/// Triggered when user navigates to posts list or requests refresh
/// 
/// Example:
/// ```dart
/// context.read<PostBloc>().add(GetAllPostsEvent());
/// ```
class GetAllPostsEvent extends PostEvent {
  const GetAllPostsEvent();

  @override
  List<Object?> get props => [];
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
  final String id;

  const GetPostByIdEvent({required this.id});

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
  final String title;
  final String body;
  final int userId;

  const CreatePostEvent({
    required this.title,
    required this.body,
    required this.userId,
  });

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
  final String id;
  final String title;
  final String body;

  const UpdatePostEvent({
    required this.id,
    required this.title,
    required this.body,
  });

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
  final String id;

  const DeletePostEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to refresh posts list
/// Similar to GetAllPostsEvent but indicates explicit user refresh
/// Can be used to clear cache and force API call
/// 
/// Example:
/// ```dart
/// context.read<PostBloc>().add(RefreshPostsEvent());
/// ```
class RefreshPostsEvent extends PostEvent {
  const RefreshPostsEvent();

  @override
  List<Object?> get props => [];
}
