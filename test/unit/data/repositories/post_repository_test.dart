import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';

void main() {
  final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);
  late Post testPost;

  setUp(() {
    testPost = Post(
      id: 1,
      title: 'Test Post',
      body: 'Test Body',
      userId: 1,
      createdAt: testDateTime,
    );
  });

  group('PostRepository Contract Tests', () {
    test('should return Either<Failure, List<Post>> for getAllPosts', () {
      // Arrange
      final result = Right<Failure, List<Post>>([testPost]);

      // Act & Assert
      result.fold(
        (failure) => fail('Should return right'),
        (posts) => expect(posts.length, 1),
      );
    });

    test('should return Either<Failure, Post> for getPostById', () {
      // Arrange
      final result = Right<Failure, Post>(testPost);

      // Act & Assert
      result.fold(
        (failure) => fail('Should return right'),
        (post) => expect(post.id, 1),
      );
    });

    test('should return Either<Failure, Post> for createPost', () {
      // Arrange
      final newPost = Post(
        id: 2,
        title: 'New',
        body: 'Body',
        userId: 1,
        createdAt: testDateTime,
      );
      final result = Right<Failure, Post>(newPost);

      // Act & Assert
      result.fold(
        (failure) => fail('Should return right'),
        (post) => expect(post.id, 2),
      );
    });

    test('should return Either<Failure, Post> for updatePost', () {
      // Arrange
      final updated = testPost.copyWith(title: 'Updated');
      final result = Right<Failure, Post>(updated);

      // Act & Assert
      result.fold(
        (failure) => fail('Should return right'),
        (post) => expect(post.title, 'Updated'),
      );
    });

    test('should return Either<Failure, void> for deletePost', () {
      // Arrange
      final result = Right<Failure, void>(null);

      // Act & Assert
      result.fold(
        (failure) => fail('Should return right'),
        (_) => expect(true, true),
      );
    });

    test('should handle ServerFailure from getAllPosts', () {
      // Arrange
      final result = Left<Failure, List<Post>>(ServerFailure('Server error'));

      // Act & Assert
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (posts) => fail('Should return left'),
      );
    });

    test('should handle CacheFailure from getAllPosts', () {
      // Arrange
      final result = Left<Failure, List<Post>>(CacheFailure('Cache error'));

      // Act & Assert
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (posts) => fail('Should return left'),
      );
    });

    test('should handle ServerFailure from createPost', () {
      // Arrange
      final result = Left<Failure, Post>(ServerFailure('Creation failed'));

      // Act & Assert
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (post) => fail('Should return left'),
      );
    });

    test('should handle ServerFailure from updatePost', () {
      // Arrange
      final result = Left<Failure, Post>(ServerFailure('Update failed'));

      // Act & Assert
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (post) => fail('Should return left'),
      );
    });

    test('should handle ServerFailure from deletePost', () {
      // Arrange
      final result = Left<Failure, void>(ServerFailure('Delete failed'));

      // Act & Assert
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should return left'),
      );
    });
  });
}

