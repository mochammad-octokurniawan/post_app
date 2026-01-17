import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/features/posts/data/models/post_model.dart';

void main() {
  group('PostModel - Comprehensive Edge Case Tests', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);

    group('Boundary Value Tests', () {
      test('should handle maximum integer ID', () {
        final model = PostModel(
          id: 9223372036854775807, // Max 64-bit int
          title: 'Max ID Test',
          body: 'Testing maximum integer value',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.id, 9223372036854775807);
      });

      test('should handle minimum integer ID', () {
        final model = PostModel(
          id: -9223372036854775808, // Min 64-bit int
          title: 'Min ID Test',
          body: 'Testing minimum integer value',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.id, -9223372036854775808);
      });

      test('should handle zero ID', () {
        final model = PostModel(
          id: 0,
          title: 'Zero ID',
          body: 'Testing zero ID',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.id, 0);
      });

      test('should handle very large user ID', () {
        final model = PostModel(
          id: 1,
          title: 'Large User ID',
          body: 'Body',
          userId: 999999999,
          createdAt: testDateTime,
        );

        expect(model.userId, 999999999);
      });
    });

    group('String Content Tests', () {
      test('should handle empty title', () {
        final model = PostModel(
          id: 1,
          title: '',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.title, '');
      });

      test('should handle empty body', () {
        final model = PostModel(
          id: 1,
          title: 'Title',
          body: '',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.body, '');
      });

      test('should handle very long title', () {
        final longTitle = 'A' * 10000;
        final model = PostModel(
          id: 1,
          title: longTitle,
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.title.length, 10000);
      });

      test('should handle very long body', () {
        final longBody = 'B' * 100000;
        final model = PostModel(
          id: 1,
          title: 'Title',
          body: longBody,
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.body.length, 100000);
      });

      test('should handle special characters in title', () {
        final special = '!@#\$%^&*()_+-=[]{}|:;<>?,./~`';
        final model = PostModel(
          id: 1,
          title: special,
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.title, special);
      });

      test('should handle special characters in body', () {
        final special = '!@#\$%^&*()_+-=[]{}|:;<>?,./~`';
        final model = PostModel(
          id: 1,
          title: 'Title',
          body: special,
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.body, special);
      });

      test('should handle unicode characters', () {
        final model = PostModel(
          id: 1,
          title: '你好世界 🌍',
          body: 'مرحبا Привет',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.title.contains('你好'), true);
        expect(model.body.contains('Привет'), true);
      });

      test('should handle emoji in content', () {
        final model = PostModel(
          id: 1,
          title: '🚀 Rocket Post 🎉',
          body: '😊 Happy content 😄',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.title.contains('🚀'), true);
        expect(model.body.contains('😊'), true);
      });

      test('should handle newlines and tabs in content', () {
        final contentWithWhitespace = 'Line1\nLine2\tTabbed\rCarriage';
        final model = PostModel(
          id: 1,
          title: 'Title with\nnewlines',
          body: contentWithWhitespace,
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.title.contains('\n'), true);
        expect(model.body.contains('\t'), true);
      });

      test('should handle HTML-like content', () {
        final html = '<div><p>HTML Content</p></div>';
        final model = PostModel(
          id: 1,
          title: 'HTML Title',
          body: html,
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.body, html);
      });

      test('should handle JSON-like content', () {
        final json = '{"key":"value","number":123}';
        final model = PostModel(
          id: 1,
          title: 'JSON Title',
          body: json,
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.body, json);
      });
    });

    group('DateTime Tests', () {
      test('should handle UTC time', () {
        final utcTime = DateTime.utc(2024, 1, 1, 0, 0, 0);
        final model = PostModel(
          id: 1,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: utcTime,
        );

        expect(model.createdAt, utcTime);
      });

      test('should handle local time', () {
        final localTime = DateTime(2024, 12, 31, 23, 59, 59);
        final model = PostModel(
          id: 1,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: localTime,
        );

        expect(model.createdAt, localTime);
      });

      test('should preserve milliseconds', () {
        final timeWithMs = DateTime(2024, 1, 15, 10, 30, 0, 123);
        final model = PostModel(
          id: 1,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: timeWithMs,
        );

        expect(model.createdAt.millisecond, 123);
      });

      test('should preserve microseconds', () {
        final timeWithMicros = DateTime(2024, 1, 15, 10, 30, 0, 123, 456);
        final model = PostModel(
          id: 1,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: timeWithMicros,
        );

        expect(model.createdAt.microsecond, 456);
      });

      test('should handle year boundaries', () {
        final oldDate = DateTime(1970, 1, 1);
        final futureDate = DateTime(2099, 12, 31);
        
        final oldModel = PostModel(
          id: 1,
          title: 'Old',
          body: 'Body',
          userId: 1,
          createdAt: oldDate,
        );
        
        final futureModel = PostModel(
          id: 2,
          title: 'Future',
          body: 'Body',
          userId: 1,
          createdAt: futureDate,
        );

        expect(oldModel.createdAt.year, 1970);
        expect(futureModel.createdAt.year, 2099);
      });
    });

    group('JSON Round-trip Tests', () {
      test('should survive JSON conversion with all field types', () {
        final original = PostModel(
          id: 42,
          title: 'Complex Title 中文',
          body: 'Body with\nnewlines\tand\ttabs',
          userId: 999,
          createdAt: DateTime(2024, 6, 15, 12, 30, 45, 500, 250),
        );

        final json = original.toJson();
        final restored = PostModel.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.title, original.title);
        expect(restored.body, original.body);
        expect(restored.userId, original.userId);
      });

      test('should handle JSON with extra fields', () {
        final json = {
          'id': 1,
          'title': 'Title',
          'body': 'Body',
          'userId': 1,
          'extraField': 'Should be ignored',
          'anotherExtra': 12345,
        };

        final model = PostModel.fromJson(json);
        expect(model.id, 1);
        expect(model.title, 'Title');
      });
    });

    group('CopyWith Immutability Tests', () {
      test('should preserve immutability with copyWith', () {
        final original = PostModel(
          id: 1,
          title: 'Original',
          body: 'Original Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final updated = original.copyWith(
          title: 'Updated',
          body: 'Updated Body',
        );

        expect(original.title, 'Original');
        expect(original.body, 'Original Body');
        expect(updated.title, 'Updated');
        expect(updated.body, 'Updated Body');
      });

      test('should chain multiple copyWith operations', () {
        var model = PostModel(
          id: 1,
          title: 'Step1',
          body: 'Body1',
          userId: 1,
          createdAt: testDateTime,
        );

        model = model.copyWith(title: 'Step2');
        model = model.copyWith(body: 'Body2');
        model = model.copyWith(userId: 2);

        expect(model.title, 'Step2');
        expect(model.body, 'Body2');
        expect(model.userId, 2);
      });
    });

    group('Equality and Hashing Tests', () {
      test('identical models should have equal hash codes', () {
        final m1 = PostModel(
          id: 1,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final m2 = PostModel(
          id: 1,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(m1.hashCode, m2.hashCode);
      });

      test('different models should generally have different hashes', () {
        final m1 = PostModel(
          id: 1,
          title: 'Title1',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final m2 = PostModel(
          id: 2,
          title: 'Title2',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(m1.hashCode, isNot(equals(m2.hashCode)));
      });

      test('models should work correctly in collections', () {
        final m1 = PostModel(
          id: 1,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final m2 = PostModel(
          id: 2,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final set = {m1, m2};
        expect(set.length, 2);
        expect(set.contains(m1), true);
      });
    });

    group('toString Tests', () {
      test('should have meaningful toString output', () {
        final model = PostModel(
          id: 1,
          title: 'Title',
          body: 'Body',
          userId: 1,
          createdAt: testDateTime,
        );

        final string = model.toString();
        expect(string, isNotEmpty);
        expect(string, contains('id'));
      });

      test('toString should work with special characters', () {
        final model = PostModel(
          id: 1,
          title: '特殊文字',
          body: 'محتوى عربي',
          userId: 1,
          createdAt: testDateTime,
        );

        expect(model.toString(), isNotEmpty);
      });
    });
  });
}
