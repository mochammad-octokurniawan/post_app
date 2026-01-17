# Phase 8: Testing - Implementation Guide

**Status**: Ready to implement | **Target**: Comprehensive test coverage 85%+

---

## 📚 Overview

Phase 8 implements three levels of testing:
1. **Unit Tests** - Test individual functions/classes in isolation
2. **Widget Tests** - Test UI components
3. **Integration Tests** - Test complete user flows

---

## 🛠️ Testing Setup

### Step 1: Add Test Dependencies

Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  bloc_test: ^9.1.0
  fake_async: ^1.3.1
```

### Step 2: Run Setup

```bash
flutter pub get
flutter pub run build_runner build  # For mockito annotations
```

### Step 3: Create Test Directory

```
test/
├── unit/
│   ├── domain/
│   ├── data/
│   └── presentation/
├── widget/
│   ├── pages/
│   └── widgets/
└── integration/
```

---

## 📝 Test File Template

### Unit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:post_app/features/posts/domain/usecases/get_all_posts_usecase.dart';

void main() {
  group('GetAllPostsUseCase', () {
    late MockPostRepository mockRepository;
    late GetAllPostsUseCase useCase;

    setUp(() {
      mockRepository = MockPostRepository();
      useCase = GetAllPostsUseCase(mockRepository);
    });

    test('should return list of posts', () async {
      // Arrange
      final mockPosts = [
        Post(id: 1, title: 'Post 1', body: 'Body 1', userId: 1),
      ];
      when(mockRepository.getAllPosts()).thenAnswer(
        (_) async => Right(mockPosts),
      );

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, Right(mockPosts));
      verify(mockRepository.getAllPosts()).called(1);
    });
  });
}
```

### Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/features/posts/presentation/widgets/widgets.dart';

void main() {
  group('LoadingWidget', () {
    testWidgets('should display spinner', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### Integration Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/main.dart';

void main() {
  group('Post List Flow', () {
    testWidgets('navigate to detail and back', (tester) async {
      // Arrange
      await tester.pumpWidget(const PostApp());
      await tester.pumpAndSettle();

      // Act - Tap first post
      await tester.tap(find.byType(PostTile).first);
      await tester.pumpAndSettle();

      // Assert - Should be on detail page
      expect(find.byType(PostDetailPage), findsOneWidget);

      // Act - Go back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Assert - Back to list
      expect(find.byType(PostListPage), findsOneWidget);
    });
  });
}
```

---

## 🎯 Test Writing Guide

### 1. Unit Tests - Use Cases

```dart
test('GetAllPostsUseCase returns posts on success', () async {
  // Mock
  when(mockRepository.getAllPosts()).thenAnswer(
    (_) async => Right([mockPost]),
  );

  // Execute
  final result = await useCase(NoParams());

  // Verify
  expect(result.isRight(), true);
  result.fold(
    (failure) => fail('Should not fail'),
    (posts) => expect(posts.length, 1),
  );
});

test('GetAllPostsUseCase returns failure on error', () async {
  // Mock
  when(mockRepository.getAllPosts()).thenAnswer(
    (_) async => Left(ServerFailure()),
  );

  // Execute
  final result = await useCase(NoParams());

  // Verify
  expect(result.isLeft(), true);
});
```

### 2. Unit Tests - Repository

```dart
test('repository uses remote on success and caches', () async {
  // Mock
  when(mockRemoteDataSource.getAllPosts()).thenAnswer(
    (_) async => [mockPostModel],
  );

  // Execute
  final result = await repository.getAllPosts();

  // Verify
  verify(mockRemoteDataSource.getAllPosts()).called(1);
  verify(mockLocalDataSource.cachePosts([mockPostModel])).called(1);
  expect(result.isRight(), true);
});

test('repository uses cache on remote failure', () async {
  // Mock
  when(mockRemoteDataSource.getAllPosts())
    .thenThrow(ServerException());
  when(mockLocalDataSource.getCachedPosts()).thenAnswer(
    (_) async => [mockPostModel],
  );

  // Execute
  final result = await repository.getAllPosts();

  // Verify
  verify(mockRemoteDataSource.getAllPosts()).called(1);
  verify(mockLocalDataSource.getCachedPosts()).called(1);
  expect(result.isRight(), true);
});
```

### 3. Unit Tests - BLoC

```dart
blocTest<PostBloc, PostState>(
  'emit Loading then Loaded on GetAllPostsEvent',
  build: () {
    when(mockGetAllPostsUseCase(NoParams())).thenAnswer(
      (_) async => Right([mockPost]),
    );
    return PostBloc(
      getAllPostsUseCase: mockGetAllPostsUseCase,
      // ... other use cases
    );
  },
  act: (bloc) => bloc.add(GetAllPostsEvent()),
  expect: () => [
    PostLoading(),
    PostLoaded([mockPost]),
  ],
  verify: (_) {
    verify(mockGetAllPostsUseCase(NoParams())).called(1);
  },
);
```

### 4. Widget Tests

```dart
testWidgets('LoadingWidget shows spinner and message', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: LoadingWidget(message: 'Loading posts...'),
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.text('Loading posts...'), findsOneWidget);
});

testWidgets('PostTile triggers onTap callback', (tester) async {
  var tapped = false;
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PostTile(
          post: mockPost,
          onTap: () => tapped = true,
        ),
      ),
    ),
  );

  await tester.tap(find.byType(PostTile));
  expect(tapped, true);
});
```

### 5. Integration Tests

```dart
testWidgets('create post flow works end-to-end', (tester) async {
  await tester.pumpWidget(const PostApp());
  await tester.pumpAndSettle();

  // Tap FAB to create
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  // Fill form
  await tester.enterText(find.byType(TextField).first, 'New Post');
  await tester.enterText(find.byType(TextField).at(1), 'Post body');

  // Submit
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

  // Verify back to list
  expect(find.byType(PostListPage), findsOneWidget);
  
  // Verify post in list
  expect(find.text('New Post'), findsOneWidget);
});
```

---

## 🎪 Mock Classes

### Repository Mock

```dart
import 'package:mockito/mockito.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

class MockPostRepository extends Mock implements PostRepository {}
```

### Use Case Mock

```dart
import 'package:mockito/mockito.dart';
import 'package:post_app/features/posts/domain/usecases/get_all_posts_usecase.dart';

class MockGetAllPostsUseCase extends Mock implements GetAllPostsUseCase {}
```

### Data Source Mocks

```dart
class MockPostLocalDataSource extends Mock 
  implements PostLocalDataSource {}

class MockPostRemoteDataSource extends Mock 
  implements PostRemoteDataSource {}
```

---

## 📊 Test Organization

### By Feature
```
test/
├── domain/
│   └── posts/
│       ├── usecases/
│       ├── entities/
│       └── repositories/
├── data/
│   └── posts/
│       ├── datasources/
│       ├── models/
│       └── repositories/
├── presentation/
│   └── posts/
│       ├── bloc/
│       ├── pages/
│       └── widgets/
```

### By Test Type
```
test/
├── unit/        # Logic tests
├── widget/      # UI component tests
└── integration/ # Full flow tests
```

---

## 🚀 Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/domain/usecases/get_all_posts_usecase_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Generate Coverage Report
```bash
# Install lcov if needed
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## ✅ Test Checklist

Before marking a feature complete:

- [ ] Unit tests written and passing
- [ ] Widget tests written and passing
- [ ] Integration tests written and passing
- [ ] Edge cases tested
- [ ] Error cases tested
- [ ] Mocks are realistic
- [ ] Tests are independent
- [ ] No flaky tests
- [ ] Coverage > 85%

---

## 🎯 Test First Approach

### For Each Feature

1. **Write Tests First**
   ```dart
   test('feature should do X', () {
     // Test code
   });
   ```

2. **Run Tests** (should fail)
   ```bash
   flutter test
   ```

3. **Write Code** (implement feature)

4. **Run Tests** (should pass)

5. **Refactor**

---

## 📚 Common Testing Patterns

### Testing Async Code
```dart
test('async operation completes', () async {
  final future = someAsyncFunction();
  await expectLater(future, completes);
});
```

### Testing Exceptions
```dart
test('throws exception on error', () async {
  expect(
    () => functionThatThrows(),
    throwsA(isA<CustomException>()),
  );
});
```

### Testing Streams
```dart
test('stream emits values', () async {
  expect(
    stream,
    emitsInOrder([value1, value2, emitsDone]),
  );
});
```

### Testing Navigation
```dart
testWidgets('navigation works', (tester) async {
  await tester.pumpWidget(app);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  expect(find.byType(FormPage), findsOneWidget);
});
```

---

## 🔧 Best Practices

✅ **Clear Test Names**
- Describe what is being tested
- Include expected outcome
- Example: `test('should return list when fetch succeeds')`

✅ **Single Assertion Focus**
- Test one behavior per test
- Multiple related assertions OK
- Example: Create, update, verify

✅ **DRY Test Code**
- Use setUp/tearDown
- Create test helpers
- Reuse mock data

✅ **Independent Tests**
- No test depends on another
- Tests can run in any order
- Clear data setup

✅ **Realistic Mocks**
- Use real-like data
- Match actual API responses
- Test edge cases

---

## 📈 Coverage Goals

| Category | Target | Priority |
|----------|--------|----------|
| Critical Paths | 100% | ⭐⭐⭐ |
| Use Cases | 95%+ | ⭐⭐⭐ |
| Repository | 90%+ | ⭐⭐⭐ |
| BLoC | 90%+ | ⭐⭐ |
| Data Sources | 85%+ | ⭐⭐ |
| Widgets | 70%+ | ⭐ |
| Overall | 85%+ | ⭐⭐⭐ |

---

## 🎓 Learning Resources

### Official Docs
- [Flutter Testing](https://flutter.dev/docs/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [bloc_test](https://pub.dev/packages/bloc_test)

### Example Tests
- Check existing Dart/Flutter projects
- Study test patterns
- Learn from open source

---

**Phase 8 - Ready to implement comprehensive testing!**
