import 'package:equatable/equatable.dart';

/// Represents a Post entity in the domain layer.
///
/// This entity is independent of any external framework or UI implementation.
/// It contains the core data structure for a post without any serialization logic.
class Post extends Equatable {

  /// Creates a new [Post] instance.
  ///
  /// All parameters are required except [updatedAt].
  /// [createdAt] defaults to current time if not provided.
  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });
  /// Unique identifier for the post.
  final int id;

  /// Title of the post.
  final String title;

  /// Body/content of the post.
  final String body;

  /// ID of the user who created the post.
  final int userId;

  /// Timestamp when the post was created.
  final DateTime createdAt;

  /// Timestamp when the post was last updated.
  final DateTime? updatedAt;

  /// Returns a copy of this post with specified fields replaced.
  Post copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );

  @override
  List<Object?> get props => [id, title, body, userId, createdAt, updatedAt];

  @override
  String toString() =>
      'Post(id: $id, title: $title, body: $body, userId: $userId, '
      'createdAt: $createdAt, updatedAt: $updatedAt)';
}
