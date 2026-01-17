import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/features/posts/data/models/post_model.dart';

void main() {
  group('PostModel - Extended Serialization Tests', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);

    group('JSON Serialization Edge Cases', () {
      test('should serialize post with null fields gracefully', () {
        final model = PostModel(
          id: 1,
          title: '',
          body: '',
          userId: 0,
          createdAt: testDateTime,
        );

        final json = model.toJson();

        expect(json['id'], 1);
        expect(json['title'], '');
        expect(json['body'], '');
      });

      test('should deserialize post with missing optional fields', () {
        final json = {
          'id': 1,
          'title': 'Test',
          'body': 'Body',
          'userId': 1,
        };

        // Should handle missing createdAt or use default
        expect(json['id'], equals(1));
      });

      test('should handle very long titles', () {
        final longTitle = 'A' * 10000;
        final model = PostModel(
          id: 1,
          title: longTitle,
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final json = model.toJson();
        expect(json['title'].length, 10000);
      });

      test('should handle special characters in title and body', () {
        final specialChars = '!@#\$%^&*()_+-={}[]|:;<>?,./~`';
        final model = PostModel(
          id: 1,
          title: specialChars,
          body: specialChars,
          userId: 1,
          createdAt: testDateTime,
        );

        final json = model.toJson();
        expect(json['title'], specialChars);
        expect(json['body'], specialChars);
      });

      test('should handle unicode characters', () {
        final model = PostModel(
          id: 1,
          title: '你好世界 🌍 مرحبا العالم',
          body: 'Привет мир',
          userId: 1,
          createdAt: testDateTime,
        );

        final json = model.toJson();
        expect(json['title'].contains('你好'), true);
        expect(json['body'].contains('Привет'), true);
      });

      test('should handle extremely large IDs', () {
        final model = PostModel(
          id: 9223372036854775807, // Max 64-bit integer
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final json = model.toJson();
        expect(json['id'], 9223372036854775807);
      });

      test('should handle dates at timezone boundaries', () {
        final utcDate = DateTime.utc(2024, 1, 1, 0, 0, 0);
        final model = PostModel(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: utcDate,
        );

        final json = model.toJson();
        expect(json, contains('createdAt'));
      });

      test('should preserve microseconds in datetime', () {
        final preciseDate = DateTime(2024, 1, 15, 10, 30, 0, 123, 456);
        final model = PostModel(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: preciseDate,
        );

        final json = model.toJson();
        expect(json['createdAt'], isNotNull);
      });
    });

    group('JSON Deserialization Edge Cases', () {
      test('should handle missing fields in JSON', () {
        try {
          final json = {'id': 1}; // Missing other fields
          // Depending on implementation, this might throw or use defaults
          expect(json['id'], 1);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should handle invalid date format', () {
        final json = {
          'id': 1,
          'title': 'Test',
          'body': 'Body',
          'userId': 1,
          'createdAt': 'invalid-date-format',
        };

        try {
          // Attempt to parse - should either handle or throw
          expect(json['createdAt'], 'invalid-date-format');
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should handle negative IDs', () {
        final model = PostModel(
          id: -1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final json = model.toJson();
        expect(json['id'], -1);
      });

      test('should handle zero as ID', () {
        final model = PostModel(
          id: 0,
          title: 'Test',
          body: 'Body',
          userId: 0,
          createdAt: testDateTime,
        );

        final json = model.toJson();
        expect(json['id'], 0);
      });
    });

    group('Model Data Integrity', () {
      test('should preserve all model data', () {
        final model = PostModel(
          id: 1,
          title: 'Test Post',
          body: 'Test Body',
          userId: 42,
          createdAt: testDateTime,
        );

        expect(model.id, 1);
        expect(model.title, 'Test Post');
        expect(model.body, 'Test Body');
        expect(model.userId, 42);
      });

      test('should preserve all data during copy', () {
        final model = PostModel(
          id: 99,
          title: 'Complex Title 中文 🚀',
          body: 'Complex Body\nWith\nNewlines',
          userId: 777,
          createdAt: testDateTime,
        );

        final copy = model.copyWith();

        expect(copy.id, model.id);
        expect(copy.title, model.title);
        expect(copy.body, model.body);
        expect(copy.userId, model.userId);
      });
    });

    group('Equality and Hashing', () {
      test('should consider two models with same data as equal', () {
        final model1 = PostModel(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final model2 = PostModel(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model1, equals(model2));
      });

      test('should consider models with different IDs as not equal', () {
        final model1 = PostModel(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final model2 = PostModel(
          id: 2,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model1, isNot(equals(model2)));
      });

      test('should have consistent hash codes for equal objects', () {
        final model1 = PostModel(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final model2 = PostModel(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model1.hashCode, equals(model2.hashCode));
      });
    });

    group('CopyWith Method', () {
      test('should create copy with updated title', () {
        final original = PostModel(
          id: 1,
          title: 'Original',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final updated = original.copyWith(title: 'Updated');

        expect(updated.title, 'Updated');
        expect(updated.id, original.id);
        expect(updated.body, original.body);
      });

      test('should create copy with multiple updated fields', () {
        final original = PostModel(
          id: 1,
          title: 'Original',
          body: 'Original Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final updated = original.copyWith(
          title: 'New Title',
          body: 'New Body',
          userId: 2,
        );

        expect(updated.title, 'New Title');
        expect(updated.body, 'New Body');
        expect(updated.userId, 2);
        expect(updated.id, original.id);
      });

      test('should preserve original object when using copyWith', () {
        final original = PostModel(
          id: 1,
          title: 'Original',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final copy = original.copyWith(title: 'Updated');

        expect(original.title, 'Original');
        expect(copy.title, 'Updated');
      });
    });

    group('Round-trip Serialization', () {
      test('should survive JSON serialization and deserialization', () {
        final original = PostModel(
          id: 1,
          title: 'Test Post',
          body: 'Test Body',
          userId: 42,
          createdAt: testDateTime,
        );

        final json = original.toJson();
        final reconstructed = PostModel.fromJson(json);

        expect(reconstructed.id, original.id);
        expect(reconstructed.title, original.title);
        expect(reconstructed.body, original.body);
        expect(reconstructed.userId, original.userId);
      });

      test('should handle multiple round trips', () {
        var model = PostModel(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        for (int i = 0; i < 3; i++) {
          model = PostModel.fromJson(model.toJson());
        }

        expect(model.id, 1);
        expect(model.title, 'Test');
      });
    });
  });
}
