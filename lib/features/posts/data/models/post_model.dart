import 'package:post_app/features/posts/domain/entities/post.dart';

/// Data model for Post that extends the domain entity.
///
/// This model is responsible for:
/// - JSON serialization/deserialization
/// - Mapping between API responses and domain entities
/// - Data layer representation of posts
class PostModel extends Post {
  /// Creates a [PostModel] instance.
  ///
  /// All parameters are required. This constructor is typically called
  /// by the fromJson factory method.
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.userId,
  });

  /// Creates a [PostModel] from a [Post] entity.
  ///
  /// Useful for converting domain entities to models for caching or API calls.
  factory PostModel.fromEntity(Post post) => PostModel(
      id: post.id,
      title: post.title,
      body: post.body,
      userId: post.userId,
    );

  /// Creates a [PostModel] from a JSON map.
  ///
  /// Typically used when deserializing API responses from JSONPlaceholder API.
  /// The API response includes: id, userId, title, body
  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'] as int,
        userId: json['userId'] is int
          ? json['userId'] as int
          : (json['userId'] != null ? int.tryParse(json['userId'].toString()) ?? 1 : 1),
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
      );

  /// Converts this [PostModel] to a JSON map.
  ///
  /// Used when:
  /// - Sending data to API (POST/PUT requests)
  /// - Caching in local storage
  /// - Serializing for temporary storage
  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };

  /// Creates a copy of this model with specified fields replaced.
  ///
  /// Overrides the domain entity's copyWith to maintain type.
  @override
  PostModel copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
  }) => PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
    );
}
