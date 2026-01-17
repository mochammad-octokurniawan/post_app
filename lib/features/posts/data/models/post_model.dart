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
    required int id,
    required String title,
    required String body,
    required int userId,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
    id: id,
    title: title,
    body: body,
    userId: userId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Creates a [PostModel] from a [Post] entity.
  ///
  /// Useful for converting domain entities to models for caching or API calls.
  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      title: post.title,
      body: post.body,
      userId: post.userId,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
    );
  }

  /// Creates a [PostModel] from a JSON map.
  ///
  /// Typically used when deserializing API responses from JSONPlaceholder API.
  /// The API response includes: id, userId, title, body
  /// Additional fields like createdAt may be generated locally.
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts this [PostModel] to a JSON map.
  ///
  /// Used when:
  /// - Sending data to API (POST/PUT requests)
  /// - Caching in local storage
  /// - Serializing for temporary storage
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Creates a copy of this model with specified fields replaced.
  ///
  /// Overrides the domain entity's copyWith to maintain type.
  @override
  PostModel copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
