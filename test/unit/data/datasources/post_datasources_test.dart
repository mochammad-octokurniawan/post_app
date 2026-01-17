import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:post_app/core/error/exceptions.dart';
import 'package:post_app/features/posts/data/models/post_model.dart';
import '../../../mocks/mock_datasources.dart';

class FakePostModel extends Fake implements PostModel {}

void main() {
  late MockPostLocalDataSource mockLocalDataSource;
  late MockPostRemoteDataSource mockRemoteDataSource;
  final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);
  late PostModel testPost;
  late List<PostModel> testPostList;

  setUpAll(() {
    registerFallbackValue(1);
    registerFallbackValue(FakePostModel());
    registerFallbackValue(<PostModel>[]);
  });

  setUp(() {
    mockLocalDataSource = MockPostLocalDataSource();
    mockRemoteDataSource = MockPostRemoteDataSource();
    testPost = PostModel(
      id: 1,
      title: 'Test Post',
      body: 'Test Body',
      userId: 1,
    );
    testPostList = [
      testPost,
      PostModel(
        id: 2,
        title: 'Post 2',
        body: 'Body 2',
        userId: 1,
      ),
    ];
  });

  group('PostLocalDataSource', () {
    test('should return list of posts from cache', () async {
      // Arrange
      when(() => mockLocalDataSource.getAllPosts())
          .thenAnswer((_) async => testPostList);

      // Act
      final result = await mockLocalDataSource.getAllPosts();

      // Assert
      expect(result, testPostList);
      expect(result.length, 2);
    });

    test('should return empty list when cache is empty', () async {
      // Arrange
      when(() => mockLocalDataSource.getAllPosts())
          .thenAnswer((_) async => []);

      // Act
      final result = await mockLocalDataSource.getAllPosts();

      // Assert
      expect(result, isEmpty);
    });

    test('should throw CacheException when getAllPosts fails', () async {
      // Arrange
      when(() => mockLocalDataSource.getAllPosts())
          .thenThrow(CacheException('Cache error'));

      // Act & Assert
      expect(
        () => mockLocalDataSource.getAllPosts(),
        throwsA(isA<CacheException>()),
      );
    });

    test('should get post by ID from cache', () async {
      // Arrange
      when(() => mockLocalDataSource.getPostById(any()))
          .thenAnswer((_) async => testPost);

      // Act
      final result = await mockLocalDataSource.getPostById(1);

      // Assert
      expect(result.id, 1);
      expect(result.title, 'Test Post');
    });

    test('should throw CacheException when post not found', () async {
      // Arrange
      when(() => mockLocalDataSource.getPostById(any()))
          .thenThrow(CacheException('Post not found'));

      // Act & Assert
      expect(
        () => mockLocalDataSource.getPostById(999),
        throwsA(isA<CacheException>()),
      );
    });

    test('should save a post to cache', () async {
      // Arrange
      when(() => mockLocalDataSource.savePost(any()))
          .thenAnswer((_) async => {});

      // Act
      await mockLocalDataSource.savePost(testPost);

      // Assert
      verify(() => mockLocalDataSource.savePost(testPost)).called(1);
    });

    test('should save multiple posts to cache', () async {
      // Arrange
      when(() => mockLocalDataSource.savePosts(any()))
          .thenAnswer((_) async => {});

      // Act
      await mockLocalDataSource.savePosts(testPostList);

      // Assert
      verify(() => mockLocalDataSource.savePosts(testPostList)).called(1);
    });

    test('should delete post from cache', () async {
      // Arrange
      when(() => mockLocalDataSource.deletePost(any()))
          .thenAnswer((_) async => {});

      // Act
      await mockLocalDataSource.deletePost(1);

      // Assert
      verify(() => mockLocalDataSource.deletePost(1)).called(1);
    });

    test('should clear all posts from cache', () async {
      // Arrange
      when(() => mockLocalDataSource.clearAllPosts())
          .thenAnswer((_) async => {});

      // Act
      await mockLocalDataSource.clearAllPosts();

      // Assert
      verify(() => mockLocalDataSource.clearAllPosts()).called(1);
    });

    test('should get last update time', () async {
      // Arrange
      when(() => mockLocalDataSource.getLastUpdateTime())
          .thenAnswer((_) async => testDateTime);

      // Act
      final result = await mockLocalDataSource.getLastUpdateTime();

      // Assert
      expect(result, testDateTime);
    });
  });

  group('PostRemoteDataSource', () {
    test('should return list of posts from API', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAllPosts())
          .thenAnswer((_) async => testPostList);

      // Act
      final result = await mockRemoteDataSource.getAllPosts();

      // Assert
      expect(result, testPostList);
      expect(result.length, 2);
    });

    test('should throw ServerException when getAllPosts fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAllPosts())
          .thenThrow(ServerException('Server error'));

      // Act & Assert
      expect(
        () => mockRemoteDataSource.getAllPosts(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should get post by ID from API', () async {
      // Arrange
      when(() => mockRemoteDataSource.getPostById(any()))
          .thenAnswer((_) async => testPost);

      // Act
      final result = await mockRemoteDataSource.getPostById(1);

      // Assert
      expect(result.id, 1);
      expect(result.title, 'Test Post');
    });

    test('should throw ServerException when post not found on API', () async {
      // Arrange
      when(() => mockRemoteDataSource.getPostById(any()))
          .thenThrow(ServerException('Not found'));

      // Act & Assert
      expect(
        () => mockRemoteDataSource.getPostById(999),
        throwsA(isA<ServerException>()),
      );
    });

    test('should create post on API', () async {
      // Arrange
      final newPost = PostModel(
        id: 100,
        title: 'New Post',
        body: 'New Body',
        userId: 1,
      );
      when(() => mockRemoteDataSource.createPost(
            title: any(named: 'title'),
            body: any(named: 'body'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => newPost);

      // Act
      final result = await mockRemoteDataSource.createPost(
        title: 'New Post',
        body: 'New Body',
        userId: 1,
      );

      // Assert
      expect(result.id, 100);
      expect(result.title, 'New Post');
    });

    test('should throw ServerException when create fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.createPost(
            title: any(named: 'title'),
            body: any(named: 'body'),
            userId: any(named: 'userId'),
          )).thenThrow(ServerException('Creation failed'));

      // Act & Assert
      expect(
        () => mockRemoteDataSource.createPost(
          title: 'New Post',
          body: 'New Body',
          userId: 1,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('should update post on API', () async {
      // Arrange
      final updatedPost = testPost.copyWith(title: 'Updated');
      when(() => mockRemoteDataSource.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => updatedPost);

      // Act
      final result = await mockRemoteDataSource.updatePost(
        id: 1,
        title: 'Updated',
        body: 'Test Body',
      );

      // Assert
      expect(result.title, 'Updated');
    });

    test('should throw ServerException when update fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.updatePost(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenThrow(ServerException('Update failed'));

      // Act & Assert
      expect(
        () => mockRemoteDataSource.updatePost(
          id: 1,
          title: 'Updated',
          body: 'Test Body',
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('should delete post on API', () async {
      // Arrange
      when(() => mockRemoteDataSource.deletePost(any()))
          .thenAnswer((_) async => null);

      // Act
      await mockRemoteDataSource.deletePost(1);

      // Assert
      verify(() => mockRemoteDataSource.deletePost(1)).called(1);
    });

    test('should throw ServerException when delete fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.deletePost(any()))
          .thenThrow(ServerException('Delete failed'));

      // Act & Assert
      expect(
        () => mockRemoteDataSource.deletePost(1),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
