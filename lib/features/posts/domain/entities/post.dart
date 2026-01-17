import 'package:equatable/equatable.dart';

/// Represents a Post entity in the domain layer.
///
/// This entity is independent of any external framework or UI implementation.
/// It contains the core data structure for a post without any serialization logic.
class Post extends Equatable {

  /// Creates a new [Post] instance.
  ///
  /// All parameters are required.
  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });
  /// Unique identifier for the post.
  final int id;

  /// Title of the post.
  final String title;

  /// Body/content of the post.
  final String body;

  /// ID of the user who created the post.
  final int userId;

  /// Returns a copy of this post with specified fields replaced.
  Post copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
  }) => Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
    );

  @override
  List<Object?> get props => [id, title, body, userId];

  @override
  String toString() =>
      'Post(id: $id, title: $title, body: $body, userId: $userId)';
}
