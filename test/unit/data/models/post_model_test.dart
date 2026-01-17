import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/features/posts/data/models/post_model.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';

void main() {
  final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);

  group('PostModel', () {
    test('should be a subclass of Post entity', () {
      // Act & Assert
      final model = PostModel(
        id: 1,
        title: 'Test',
        body: 'Body',
        userId: 1,
        createdAt: testDateTime,
      );
      expect(model, isA<Post>());
    });

    test('should create instance from JSON with all fields', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Test Post',
        'body': 'Test Body',
        'userId': 1,
        'createdAt': testDateTime.toIso8601String(),
        'updatedAt': testDateTime.toIso8601String(),
      };

      // Act
      final model = PostModel.fromJson(json);

      // Assert
      expect(model.id, 1);
      expect(model.title, 'Test Post');
      expect(model.body, 'Test Body');
      expect(model.userId, 1);
    });

    test('should convert to JSON', () {
      // Arrange
      final model = PostModel(
        id: 1,
        title: 'Test',
        body: 'Body',
        userId: 1,
        createdAt: testDateTime,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['title'], 'Test');
      expect(json['body'], 'Body');
      expect(json['userId'], 1);
    });

    test('should create from entity', () {
      // Arrange
      final post = Post(
        id: 1,
        title: 'Test',
        body: 'Body',
        userId: 1,
        createdAt: testDateTime,
      );

      // Act
      final model = PostModel.fromEntity(post);

      // Assert
      expect(model.id, post.id);
      expect(model.title, post.title);
      expect(model.body, post.body);
      expect(model.userId, post.userId);
    });

    test('should serialize and deserialize correctly', () {
      // Arrange
      final original = PostModel(
        id: 1,
        title: 'Test',
        body: 'Body',
        userId: 1,
        createdAt: testDateTime,
      );

      // Act
      final json = original.toJson();
      final restored = PostModel.fromJson(json);

      // Assert
      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.body, original.body);
      expect(restored.userId, original.userId);
    });
  });
}
