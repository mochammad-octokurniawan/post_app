import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/usecases/read_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/update_post_usecase.dart';
import 'package:post_app/features/posts/domain/usecases/delete_post_usecase.dart';

import '../../../mocks/mock_repositories.dart';

void main() {
  late MockPostRepository mockRepository;
  final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);
  late Post testPost;

  setUp(() {
    mockRepository = MockPostRepository();
    testPost = Post(
      id: 1,
      title: 'Test Post',
      body: 'Test Body',
      userId: 1,
      createdAt: testDateTime,
    );
  });

  group('ReadPostUseCase', () {
    late ReadPostUseCase useCase;

    setUp(() {
      useCase = ReadPostUseCase(mockRepository);
      // Register any required parameters for mocktail
      registerFallbackValue(1);
    });

    test('should return a post when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.getPostById(any()))
          .thenAnswer((_) async => Right(testPost));

      // Act
      final result = await useCase(GetPostParams(id: 1));

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (post) {
          expect(post.id, 1);
          expect(post.title, 'Test Post');
        },
      );
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getPostById(any()))
          .thenAnswer((_) async => Left(ServerFailure('Not found')));

      // Act
      final result = await useCase(GetPostParams(id: 1));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should return left side'),
      );
    });
  });

  group('CreatePostUseCase', () {
    late CreatePostUseCase useCase;

    setUp(() {
      useCase = CreatePostUseCase(mockRepository);
    });

    test('should create a post when repository succeeds', () async {
      // Arrange
      final newPost = Post(
        id: 2,
        title: 'New Post',
        body: 'New Body',
        userId: 1,
        createdAt: testDateTime,
      );
      when(() => mockRepository.createPost(
            title: any(named: 'title'),
            body: any(named: 'body'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => Right(newPost));

      // Act
      final result = await useCase(CreatePostParams(
        title: 'New Post',
        body: 'New Body',
        userId: 1,
      ));

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (post) {
          expect(post.id, 2);
          expect(post.title, 'New Post');
        },
      );
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(() => mockRepository.createPost(
            title: any(named: 'title'),
            body: any(named: 'body'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => Left(ServerFailure('Creation failed')));

      // Act
      final result = await useCase(CreatePostParams(
        title: 'New Post',
        body: 'New Body',
        userId: 1,
      ));

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('UpdatePostUseCase', () {
    late UpdatePostUseCase useCase;

    setUp(() {
      useCase = UpdatePostUseCase(mockRepository);
    });

    test('should update a post when repository succeeds', () async {
      // Arrange
      final updatedPost = testPost.copyWith(title: 'Updated Title');
      when(() => mockRepository.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Right(updatedPost));

      // Act
      final result = await useCase(UpdatePostParams(
        id: 1,
        title: 'Updated Title',
        body: 'Test Body',
      ));

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (post) {
          expect(post.title, 'Updated Title');
          expect(post.id, 1);
          expect(post.body, 'Test Body');
        },
      );
    });

    test('should update only title while preserving other fields', () async {
      // Arrange
      final updatedPost = testPost.copyWith(title: 'New Title');
      when(() => mockRepository.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Right(updatedPost));

      // Act
      final result = await useCase(UpdatePostParams(
        id: 1,
        title: 'New Title',
        body: 'Test Body',
      ));

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (post) {
          expect(post.title, 'New Title');
          expect(post.userId, testPost.userId);
          expect(post.createdAt, testPost.createdAt);
        },
      );
    });

    test('should update only body while preserving other fields', () async {
      // Arrange
      final updatedPost = testPost.copyWith(body: 'New Body');
      when(() => mockRepository.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Right(updatedPost));

      // Act
      final result = await useCase(UpdatePostParams(
        id: 1,
        title: 'Test Post',
        body: 'New Body',
      ));

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (post) {
          expect(post.body, 'New Body');
          expect(post.title, testPost.title);
          expect(post.userId, testPost.userId);
        },
      );
    });

    test('should update with long title and body', () async {
      // Arrange
      final longTitle = 'A' * 200;
      final longBody = 'B' * 1000;
      final updatedPost = testPost.copyWith(
        title: longTitle,
        body: longBody,
      );
      when(() => mockRepository.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Right(updatedPost));

      // Act
      final result = await useCase(UpdatePostParams(
        id: 1,
        title: longTitle,
        body: longBody,
      ));

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (post) {
          expect(post.title, longTitle);
          expect(post.body, longBody);
          expect(post.title.length, 200);
          expect(post.body.length, 1000);
        },
      );
    });

    test('should return ServerFailure when update fails', () async {
      // Arrange
      when(() => mockRepository.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Left(ServerFailure('Update failed')));

      // Act
      final result = await useCase(UpdatePostParams(
        id: 1,
        title: 'Updated Title',
        body: 'Test Body',
      ));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should return left side'),
      );
    });

    test('should return CacheFailure when cache operation fails', () async {
      // Arrange
      when(() => mockRepository.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer(
              (_) async => Left(CacheFailure('Cache operation failed')));

      // Act
      final result = await useCase(UpdatePostParams(
        id: 1,
        title: 'Updated Title',
        body: 'Test Body',
      ));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return left side'),
      );
    });

    test('should update post with special characters in title', () async {
      // Arrange
      final specialTitle = 'Post @#\$% & Title!';
      final updatedPost = testPost.copyWith(title: specialTitle);
      when(() => mockRepository.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Right(updatedPost));

      // Act
      final result = await useCase(UpdatePostParams(
        id: 1,
        title: specialTitle,
        body: 'Test Body',
      ));

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (post) => expect(post.title, specialTitle),
      );
    });

    test('should call repository with correct parameters', () async {
      // Arrange
      when(() => mockRepository.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => Right(testPost));

      // Act
      await useCase(UpdatePostParams(
        id: 5,
        title: 'New Title',
        body: 'New Body',
      ));

      // Assert
      verify(() => mockRepository.updatePost(
            id: 5,
            title: 'New Title',
            body: 'New Body',
          )).called(1);
    });
  });

  group('DeletePostUseCase', () {
    late DeletePostUseCase useCase;

    setUp(() {
      useCase = DeletePostUseCase(mockRepository);
      registerFallbackValue(1);
    });

    test('should delete a post when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.deletePost(any()))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await useCase(DeletePostParams(id: 1));

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (_) => expect(true, true), // Just verify no exception
      );
    });

    test('should successfully delete multiple different posts', () async {
      // Arrange
      when(() => mockRepository.deletePost(any()))
          .thenAnswer((_) async => Right(null));

      // Act
      final result1 = await useCase(DeletePostParams(id: 1));
      final result2 = await useCase(DeletePostParams(id: 2));
      final result3 = await useCase(DeletePostParams(id: 100));

      // Assert
      expect(result1.isRight(), true);
      expect(result2.isRight(), true);
      expect(result3.isRight(), true);
    });

    test('should return ServerFailure when delete fails', () async {
      // Arrange
      when(() => mockRepository.deletePost(any()))
          .thenAnswer((_) async => Left(ServerFailure('Delete failed')));

      // Act
      final result = await useCase(DeletePostParams(id: 1));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should return left side'),
      );
    });

    test('should return CacheFailure when cache operation fails', () async {
      // Arrange
      when(() => mockRepository.deletePost(any()))
          .thenAnswer((_) async => Left(CacheFailure('Cache clear failed')));

      // Act
      final result = await useCase(DeletePostParams(id: 1));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return left side'),
      );
    });

    test('should call repository with correct post id', () async {
      // Arrange
      when(() => mockRepository.deletePost(any()))
          .thenAnswer((_) async => Right(null));

      // Act
      await useCase(DeletePostParams(id: 42));

      // Assert
      verify(() => mockRepository.deletePost(42)).called(1);
    });

    test('should delete post with id 0', () async {
      // Arrange
      when(() => mockRepository.deletePost(any()))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await useCase(DeletePostParams(id: 0));

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.deletePost(0)).called(1);
    });

    test('should delete post with large id value', () async {
      // Arrange
      when(() => mockRepository.deletePost(any()))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await useCase(DeletePostParams(id: 999999));

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.deletePost(999999)).called(1);
    });

    test('should handle ServerFailure with error message', () async {
      // Arrange
      when(() => mockRepository.deletePost(any())).thenAnswer((_) async =>
          Left(ServerFailure('Post not found', statusCode: 404)));

      // Act
      final result = await useCase(DeletePostParams(id: 1));

      // Assert
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Post not found');
        },
        (_) => fail('Should return left side'),
      );
    });

    test('should handle ServerFailure with different status codes', () async {
      // Arrange
      when(() => mockRepository.deletePost(any())).thenAnswer((_) async =>
          Left(ServerFailure('Internal server error', statusCode: 500)));

      // Act
      final result = await useCase(DeletePostParams(id: 1));

      // Assert
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Internal server error');
        },
        (_) => fail('Should return left side'),
      );
    });
  });
}
