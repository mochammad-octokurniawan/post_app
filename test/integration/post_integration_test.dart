import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

// Mock repository for integration testing
class MockPostRepository implements PostRepository {
  final List<Post> _posts = [];

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (_posts.isEmpty) {
      return Left(CacheFailure('No posts cached'));
    }
    return Right(_posts);
  }

  @override
  Future<Either<Failure, Post>> getPostById(int id) async {
    try {
      final post = _posts.firstWhere((p) => p.id == id);
      return Right(post);
    } catch (e) {
      return Left(ServerFailure('Post not found'));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    final post = Post(
      id: _posts.length + 1,
      title: title,
      body: body,
      userId: userId,
      createdAt: DateTime.now(),
    );
    _posts.add(post);
    return Right(post);
  }

  @override
  Future<Either<Failure, Post>> updatePost({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      final index = _posts.indexWhere((p) => p.id == id);
      final updated = _posts[index].copyWith(title: title, body: body);
      _posts[index] = updated;
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure('Update failed'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) async {
    try {
      _posts.removeWhere((p) => p.id == id);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Delete failed'));
    }
  }
}

void main() {
  group('Post Integration Tests', () {
    late MockPostRepository repository;

    setUp(() {
      repository = MockPostRepository();
    });

    test('should create posts and retrieve them', () async {
      // Arrange & Act
      await repository.createPost(
        title: 'First Post',
        body: 'First Body',
        userId: 1,
      );
      await repository.createPost(
        title: 'Second Post',
        body: 'Second Body',
        userId: 1,
      );

      // Act
      final result = await repository.getAllPosts();

      // Assert
      result.fold(
        (failure) => fail('Should return right'),
        (posts) {
          expect(posts.length, 2);
          expect(posts[0].title, 'First Post');
          expect(posts[1].title, 'Second Post');
        },
      );
    });

    test('should update a post', () async {
      // Arrange
      await repository.createPost(
        title: 'Original',
        body: 'Original Body',
        userId: 1,
      );

      // Act
      final updateResult = await repository.updatePost(
        id: 1,
        title: 'Updated',
        body: 'Updated Body',
      );

      // Assert
      updateResult.fold(
        (failure) => fail('Should return right'),
        (post) {
          expect(post.title, 'Updated');
          expect(post.body, 'Updated Body');
        },
      );
    });

    test('should delete a post', () async {
      // Arrange
      await repository.createPost(
        title: 'To Delete',
        body: 'Body',
        userId: 1,
      );

      // Act
      await repository.deletePost(1);
      final result = await repository.getAllPosts();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (posts) => fail('Should be empty'),
      );
    });

    test('should handle multiple CRUD operations', () async {
      // Arrange & Act
      await repository.createPost(
        title: 'Post 1',
        body: 'Body 1',
        userId: 1,
      );
      await repository.createPost(
        title: 'Post 2',
        body: 'Body 2',
        userId: 2,
      );
      await repository.updatePost(
        id: 1,
        title: 'Post 1 Updated',
        body: 'Body 1 Updated',
      );

      // Act
      final result = await repository.getAllPosts();

      // Assert
      result.fold(
        (failure) => fail('Should return right'),
        (posts) {
          expect(posts.length, 2);
          expect(posts[0].title, 'Post 1 Updated');
          expect(posts[1].title, 'Post 2');
        },
      );
    });

    test('should retrieve post by ID', () async {
      // Arrange
      await repository.createPost(
        title: 'Find Me',
        body: 'Body',
        userId: 1,
      );

      // Act
      final result = await repository.getPostById(1);

      // Assert
      result.fold(
        (failure) => fail('Should return right'),
        (post) {
          expect(post.id, 1);
          expect(post.title, 'Find Me');
        },
      );
    });
  });
}
