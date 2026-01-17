import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';

void main() {
  final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);

  group('Post Entity', () {
    test('should create a Post with valid parameters', () {
      // Arrange
      const id = 1;
      const title = 'Test Post';
      const body = 'Test Body';
      const userId = 1;

      // Act
      final post = Post(
        id: id,
        title: title,
        body: body,
        userId: userId,
        createdAt: testDateTime,
      );

      // Assert
      expect(post.id, id);
      expect(post.title, title);
      expect(post.body, body);
      expect(post.userId, userId);
      expect(post.createdAt, testDateTime);
    });

    test('should support equality comparison', () {
      // Arrange
      final post1 = Post(id: 1, title: 'Title', body: 'Body', userId: 1, createdAt: testDateTime);
      final post2 = Post(id: 1, title: 'Title', body: 'Body', userId: 1, createdAt: testDateTime);
      final post3 = Post(id: 2, title: 'Title', body: 'Body', userId: 1, createdAt: testDateTime);

      // Act & Assert
      expect(post1 == post2, true);
      expect(post1 == post3, false);
    });

    test('should support copyWith to create modified copy', () {
      // Arrange
      final originalPost = Post(
        id: 1,
        title: 'Original Title',
        body: 'Original Body',
        userId: 1,
        createdAt: testDateTime,
      );

      // Act
      final modifiedPost = originalPost.copyWith(title: 'New Title');

      // Assert
      expect(modifiedPost.id, originalPost.id);
      expect(modifiedPost.title, 'New Title');
      expect(modifiedPost.body, originalPost.body);
      expect(modifiedPost.userId, originalPost.userId);
      // Original should be unchanged
      expect(originalPost.title, 'Original Title');
    });

    test('copyWith should allow multiple fields to be changed', () {
      // Arrange
      final originalPost = Post(
        id: 1,
        title: 'Original Title',
        body: 'Original Body',
        userId: 1,
        createdAt: testDateTime,
      );

      // Act
      final modifiedPost = originalPost.copyWith(
        title: 'New Title',
        body: 'New Body',
      );

      // Assert
      expect(modifiedPost.title, 'New Title');
      expect(modifiedPost.body, 'New Body');
      expect(modifiedPost.id, 1);
      expect(modifiedPost.userId, 1);
    });

    test('copyWith with null values should use original values', () {
      // Arrange
      final originalPost = Post(
        id: 1,
        title: 'Original Title',
        body: 'Original Body',
        userId: 1,
        createdAt: testDateTime,
      );

      // Act
      final modifiedPost = originalPost.copyWith();

      // Assert
      expect(modifiedPost, originalPost);
    });

    test('should have proper toString representation', () {
      // Arrange
      final post = Post(id: 1, title: 'Title', body: 'Body', userId: 1, createdAt: testDateTime);

      // Act
      final stringRepresentation = post.toString();

      // Assert
      expect(stringRepresentation, contains('Post'));
      expect(stringRepresentation.isNotEmpty, true);
    });

    test('posts with same data should have same hash', () {
      // Arrange
      final post1 = Post(id: 1, title: 'Title', body: 'Body', userId: 1, createdAt: testDateTime);
      final post2 = Post(id: 1, title: 'Title', body: 'Body', userId: 1, createdAt: testDateTime);

      // Act & Assert
      expect(post1.hashCode, post2.hashCode);
    });
  });
}

