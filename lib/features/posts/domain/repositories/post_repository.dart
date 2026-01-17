import 'package:dartz/dartz.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';

/// Abstract repository interface for Post data operations.
///
/// This interface defines contracts for all CRUD operations on posts.
/// Implementation details are handled in the data layer.
abstract class PostRepository {
  /// Retrieves all posts from the repository.
  ///
  /// Returns [Either<Failure, List<Post>>]:
  /// - Right: List of all posts (may be empty)
  /// - Left: Failure if retrieval fails
  ///
  /// May fetch from remote source first, then fallback to cache.
  Future<Either<Failure, List<Post>>> getAllPosts();

  /// Retrieves a single post by its ID.
  ///
  /// Parameters:
  ///   - id: The unique identifier of the post to retrieve
  ///
  /// Returns [Either<Failure, Post>]:
  /// - Right: The requested post
  /// - Left: Failure if post not found or retrieval fails
  Future<Either<Failure, Post>> getPostById(int id);

  /// Creates a new post.
  ///
  /// Parameters:
  ///   - title: The title of the post
  ///   - body: The content/body of the post
  ///   - userId: The ID of the user creating the post
  ///
  /// Returns [Either<Failure, Post>]:
  /// - Right: The newly created post with assigned ID
  /// - Left: Failure if creation fails
  ///
  /// Note: Throws ValidationException if inputs are invalid (validation should
  /// be done before calling this method).
  Future<Either<Failure, Post>> createPost({
    required String title,
    required String body,
    required int userId,
  });

  /// Updates an existing post.
  ///
  /// Parameters:
  ///   - id: The ID of the post to update
  ///   - title: The new title of the post
  ///   - body: The new content/body of the post
  ///
  /// Returns [Either<Failure, Post>]:
  /// - Right: The updated post
  /// - Left: Failure if post not found or update fails
  ///
  /// Note: Throws ValidationException if inputs are invalid (validation should
  /// be done before calling this method).
  Future<Either<Failure, Post>> updatePost({
    required int id,
    required String title,
    required String body,
  });

  /// Deletes a post by its ID.
  ///
  /// Parameters:
  ///   - id: The ID of the post to delete
  ///
  /// Returns [Either<Failure, void>]:
  /// - Right: Void (unit value) if deletion succeeds
  /// - Left: Failure if post not found or deletion fails
  Future<Either<Failure, void>> deletePost(int id);
}
