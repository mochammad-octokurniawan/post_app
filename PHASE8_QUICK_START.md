# Phase 8: Testing - Quick Start

**Status**: Ready to start | **Duration**: 2-3 weeks | **Target**: 85%+ coverage

---

## 🚀 Phase 8 Roadmap

### Week 1: Unit Tests - Foundation
- Day 1-2: Domain layer tests (entities, use cases)
- Day 3-4: Data layer tests (models, data sources)
- Day 5: Repository tests

### Week 2: Unit Tests - Presentation
- Day 1-2: BLoC state/event tests
- Day 3-4: BLoC event handler tests
- Day 5: Mock verification

### Week 3: Widget & Integration Tests
- Day 1-2: Widget tests for reusable components
- Day 3-4: Page widget tests
- Day 5: Integration tests + coverage analysis

---

## 📋 Phase 8 Checklist

### Setup
- [ ] Add testing dependencies (mockito, bloc_test)
- [ ] Create test directory structure
- [ ] Create mock classes
- [ ] Setup test helpers

### Domain Layer (15 tests)
- [ ] Post entity tests (3)
- [ ] Use case tests (12)

### Data Layer (30 tests)
- [ ] Post model tests (5)
- [ ] Local data source tests (8)
- [ ] Remote data source tests (12)
- [ ] Repository tests (5)

### Presentation Layer (25 tests)
- [ ] State/Event equality (5)
- [ ] BLoC event handlers (20)

### Widget Tests (15 tests)
- [ ] Reusable widgets (5)
- [ ] Pages (10)

### Integration Tests (5 tests)
- [ ] Navigation flows (3)
- [ ] API integration (2)

**Total: 90+ tests expected**

---

## 🎯 Critical Path Tests (Must Have)

These are the highest priority tests:

### 1. Use Cases (5 tests)
```
✅ GetAllPostsUseCase - success & failure
✅ ReadPostUseCase - success & failure
✅ CreatePostUseCase - success & failure
✅ UpdatePostUseCase - success & failure
✅ DeletePostUseCase - success & failure
```

### 2. Repository (5 tests)
```
✅ GetAll with remote success
✅ GetAll with remote failure, cache fallback
✅ Create/Update/Delete sync to cache
✅ Cache expiration logic
✅ Error mapping
```

### 3. BLoC (10 tests)
```
✅ GetAllPostsEvent emits states
✅ GetPostByIdEvent emits states
✅ CreatePostEvent emits states
✅ UpdatePostEvent emits states
✅ DeletePostEvent emits states
✅ Error state on failure
✅ Loading state transitions
✅ State recovery on error
✅ Multiple events queued
✅ BLoC closure
```

### 4. Navigation (3 tests)
```
✅ List → Detail navigation
✅ Detail → Create navigation
✅ Create → List after success
```

---

## 💡 Implementation Strategy

### Phase 1: Setup (1 day)

```bash
# 1. Add dependencies
flutter pub add dev:mockito dev:bloc_test dev:fake_async

# 2. Create directory structure
mkdir -p test/{unit/{domain,data,presentation},widget/{pages,widgets},integration}

# 3. Run code generation
flutter pub run build_runner build
```

### Phase 2: Mock Classes (1 day)

Create in `test/mocks/`:
```
mock_repositories.dart
mock_data_sources.dart
mock_use_cases.dart
test_helpers.dart
mock_data.dart
```

### Phase 3: Unit Tests (5-7 days)

```
Day 1-2: Domain layer
  - test/unit/domain/usecases/
  - test/unit/domain/entities/

Day 3-4: Data layer
  - test/unit/data/models/
  - test/unit/data/datasources/
  - test/unit/data/repositories/

Day 5-7: Presentation layer
  - test/unit/presentation/bloc/
```

### Phase 4: Widget Tests (2-3 days)

```
Day 1: Reusable widgets
  - test/widget/widgets/

Day 2-3: Pages
  - test/widget/pages/
```

### Phase 5: Integration Tests (1-2 days)

```
Day 1-2: Full flows
  - test/integration/
```

---

## 📊 Estimated Test Count

| Layer | Type | Count | Time |
|-------|------|-------|------|
| Domain | Unit | 15 | 1 day |
| Data | Unit | 30 | 2 days |
| Presentation | Unit | 25 | 2 days |
| Widgets | Widget | 15 | 1 day |
| Navigation | Integration | 5 | 0.5 days |
| **Total** | **Multiple** | **90+** | **6.5 days** |

---

## 🎓 First Test Example

### Create test file: `test/unit/domain/usecases/get_all_posts_usecase_test.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';
import 'package:post_app/features/posts/domain/usecases/get_all_posts_usecase.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetAllPostsUseCase useCase;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    useCase = GetAllPostsUseCase(mockRepository);
  });

  group('GetAllPostsUseCase', () {
    final testPosts = [
      Post(
        id: 1,
        title: 'Test Post',
        body: 'Test Body',
        userId: 1,
      ),
    ];

    test(
      'should return list of posts when call succeeds',
      () async {
        // Arrange
        when(mockRepository.getAllPosts())
          .thenAnswer((_) async => Right(testPosts));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result, Right(testPosts));
        verify(mockRepository.getAllPosts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return ServerFailure when repository fails',
      () async {
        // Arrange
        when(mockRepository.getAllPosts())
          .thenAnswer((_) async => Left(ServerFailure()));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result.isLeft(), true);
      },
    );
  });
}
```

### Run the test
```bash
flutter test test/unit/domain/usecases/get_all_posts_usecase_test.dart
```

---

## 🛠️ Helper Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/domain/usecases/get_all_posts_usecase_test.dart

# Run tests matching pattern
flutter test --name "GetAllPostsUseCase"

# Run tests with verbose output
flutter test -v

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Watch mode (re-run on file changes)
flutter test --watch

# Fail on warnings
flutter test --fail-on-warnings
```

---

## 📈 Progress Tracking

Create `PHASE8_PROGRESS.md` to track:

```
## Unit Tests Progress

### Domain Layer
- [ ] PostEntity (3 tests)
- [ ] GetAllPostsUseCase (2 tests)
- [ ] ReadPostUseCase (2 tests)
- [ ] CreatePostUseCase (2 tests)
- [ ] UpdatePostUseCase (2 tests)
- [ ] DeletePostUseCase (2 tests)

### Data Layer
- [ ] PostModel (3 tests)
- [ ] PostLocalDataSource (5 tests)
- [ ] PostRemoteDataSource (8 tests)
- [ ] PostRepository (5 tests)

### Presentation Layer
- [ ] PostEvent/State (5 tests)
- [ ] PostBLoC Handlers (15 tests)

### Widget Tests
- [ ] LoadingWidget (2 tests)
- [ ] ErrorWidget (2 tests)
- [ ] EmptyWidget (2 tests)
- [ ] PostTile (2 tests)
- [ ] PostCard (2 tests)
- [ ] PostListPage (3 tests)
- [ ] PostDetailPage (3 tests)
- [ ] PostFormPage (3 tests)

### Integration Tests
- [ ] Navigation flow (3 tests)
- [ ] Create post flow (2 tests)
```

---

## ✅ Daily Standup Questions

- How many tests did I write today?
- What's the current coverage %?
- Which layer am I testing?
- Are there flaky tests?
- Is anything blocking progress?

---

## 🎯 Success Criteria

Phase 8 is complete when:

1. ✅ 90+ tests written
2. ✅ 85%+ code coverage
3. ✅ All tests pass consistently
4. ✅ No flaky tests
5. ✅ Critical paths 100% covered
6. ✅ Full documentation
7. ✅ CI/CD integration ready

---

## 🚀 Getting Started

### Right Now

1. Create test directory structure
2. Add test dependencies
3. Write first mock class
4. Write first unit test
5. Run and verify it passes

### Today

- Complete at least 5 unit tests
- Verify mocks work correctly
- Ensure tests are independent

### This Week

- Complete all domain layer tests
- Complete all data layer tests
- Start presentation layer tests

---

## 📞 Testing Tips

✅ **Start Simple**
- Write tests for utilities first
- Build up to complex logic
- Gain confidence with patterns

✅ **Test Behavior**
- Test what, not how
- Focus on outputs
- Mock internals

✅ **Keep Tests Fast**
- Unit tests < 10ms
- Widget tests < 100ms
- Integration tests < 1s

✅ **Use Meaningful Names**
- Describe scenario
- Include expected result
- Make purpose clear

---

## 📚 Resources

- [Phase8_Testing_TODO.md](PHASE8_TESTING_TODO.md) - Complete checklist
- [Phase8_Testing_Guide.md](PHASE8_TESTING_GUIDE.md) - Detailed guide
- [Flutter Testing Docs](https://flutter.dev/docs/testing)
- [Mockito Docs](https://pub.dev/packages/mockito)
- [bloc_test Docs](https://pub.dev/packages/bloc_test)

---

**Phase 8 - Start testing today! 🧪**
