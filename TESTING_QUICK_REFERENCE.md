# Testing Quick Reference

## Run All Tests
```bash
flutter test
```
**Result:** 63 tests pass ✅

## Test Categories

### Unit Tests (58)
```bash
flutter test test/unit/
```

**Domain Layer** (12 tests)
```bash
flutter test test/unit/domain/
```

**Data Layer** (22 tests)
```bash
flutter test test/unit/data/
```

**Presentation Layer** (24 tests)
```bash
flutter test test/unit/presentation/
```

### Integration Tests (5)
```bash
flutter test test/integration/
```

## Run Specific Tests

```bash
# Run use case tests
flutter test test/unit/domain/usecases/

# Run data source tests
flutter test test/unit/data/datasources/

# Run BLoC tests
flutter test test/unit/presentation/bloc/post_bloc_test.dart

# Run integration tests
flutter test test/integration/post_integration_test.dart
```

## Test by Name Filter

```bash
# Run tests matching "create"
flutter test --name "create"

# Run tests matching "posts"
flutter test --name "posts"

# Run tests matching "error"
flutter test --name "error"
```

## Coverage Report

```bash
# Generate coverage
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Debugging Tests

```bash
# Verbose output
flutter test -v

# Run single test file with verbose
flutter test -v test/unit/domain/usecases/get_all_posts_test.dart

# With print statements visible
flutter test --verbose
```

## Test Structure Summary

| Layer | Tests | Key Areas |
|-------|-------|-----------|
| **Domain** | 12 | Entities, Use Cases |
| **Data** | 22 | Data Sources, Models, Repository |
| **Presentation** | 24 | BLoC Events, States, Transitions |
| **Integration** | 5 | End-to-End Workflows |
| **TOTAL** | **63** | **✅ All Passing** |

## Common Test Scenarios

### Test Use Case
```dart
test('should return posts', () async {
  final result = await useCase.call();
  result.fold(
    (f) => fail('Should succeed'),
    (posts) => expect(posts.length, greaterThan(0)),
  );
});
```

### Test Error Handling
```dart
test('should return failure', () async {
  // Setup error condition
  final result = await useCase.call();
  result.fold(
    (failure) => expect(failure, isA<ServerFailure>()),
    (_) => fail('Should fail'),
  );
});
```

### Test BLoC State
```dart
test('should emit PostsLoaded', () {
  expectLater(
    bloc.stream,
    emitsInOrder([PostLoading(), PostsLoaded(posts: [])]),
  );
  bloc.add(GetAllPostsEvent());
});
```

## Key Files

- **Test Guide:** `TESTING.md`
- **Phase Summary:** `PHASE8_TESTING.md`
- **Mock Setup:** `test/mocks/mock_datasources.dart`
- **All Tests:** `flutter test` from root

## Verify Installation

```bash
# Check Flutter version
flutter --version

# Run doctor
flutter doctor

# Get dependencies
flutter pub get

# Run tests
flutter test
```

## Success Criteria

✅ All 63 tests pass  
✅ No compilation errors  
✅ No runtime errors  
✅ All layers tested  
✅ Complete error coverage  
✅ Ready for CI/CD integration  

---

**For detailed documentation, see: `TESTING.md`**

