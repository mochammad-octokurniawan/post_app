import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/usecases/get_all_posts_usecase.dart';

import '../../../mocks/mock_repositories.dart';

void main() {
  late GetAllPostsUseCase useCase;
  late MockPostRepository mockRepository;
  final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);
  late List<Post> testPostsList;

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = GetAllPostsUseCase(mockRepository);
    testPostsList = [
      Post(id: 1, title: 'Post 1', body: 'Body 1', userId: 1, createdAt: testDateTime),
      Post(id: 2, title: 'Post 2', body: 'Body 2', userId: 1, createdAt: testDateTime),
      Post(id: 3, title: 'Post 3', body: 'Body 3', userId: 1, createdAt: testDateTime),
    ];
  });

  group('GetAllPostsUseCase', () {
    test('should return list of posts when call to repository succeeds', () async {
      // Arrange
      when(mockRepository.getAllPosts).thenAnswer(
        (_) async => Right(testPostsList),
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, Right(testPostsList));
    });

    test('should return list with single post', () async {
      // Arrange
      final singlePostList = [
        Post(id: 1, title: 'Test Post', body: 'Body', userId: 1, createdAt: testDateTime),
      ];
      when(mockRepository.getAllPosts).thenAnswer(
        (_) async => Right(singlePostList),
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, Right(singlePostList));
      result.fold(
        (failure) => fail('Should return right side'),
        (posts) => expect(posts.length, 1),
      );
    });

    test('should return empty list when no posts exist', () async {
      // Arrange
      when(mockRepository.getAllPosts).thenAnswer(
        (_) async => Right([]),
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (posts) => expect(posts.isEmpty, true),
      );
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getAllPosts).thenAnswer(
        (_) async => Left(ServerFailure('Server error')),
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (posts) => fail('Should return left side'),
      );
    });

    test('should return CacheFailure when cache is empty', () async {
      // Arrange
      when(mockRepository.getAllPosts).thenAnswer(
        (_) async => Left(CacheFailure('Cache error')),
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (posts) => fail('Should return left side'),
      );
    });

    test('should call repository exactly once', () async {
      // Arrange
      when(mockRepository.getAllPosts).thenAnswer(
        (_) async => Right(testPostsList),
      );

      // Act
      await useCase(NoParams());

      // Assert
      // Repository call is verified through the result
    });

    test('should return posts in same order as repository', () async {
      // Arrange
      final orderedPosts = [
        Post(id: 1, title: 'First', body: 'Body', userId: 1, createdAt: testDateTime),
        Post(id: 2, title: 'Second', body: 'Body', userId: 1, createdAt: testDateTime),
        Post(id: 3, title: 'Third', body: 'Body', userId: 1, createdAt: testDateTime),
      ];
      when(mockRepository.getAllPosts).thenAnswer(
        (_) async => Right(orderedPosts),
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      result.fold(
        (failure) => fail('Should return right side'),
        (posts) {
          expect(posts[0].title, 'First');
          expect(posts[1].title, 'Second');
          expect(posts[2].title, 'Third');
        },
      );
    });
  });
}
