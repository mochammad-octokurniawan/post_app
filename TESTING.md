# Testing Guide

## Overview

This project implements comprehensive unit and integration testing following clean architecture principles and TDD (Test-Driven Development) practices.

## Test Structure

```
test/
├── unit/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── post_test.dart
│   │   └── usecases/
│   │       ├── get_all_posts_test.dart
│   │       ├── get_post_by_id_test.dart
│   │       ├── create_post_test.dart
│   │       ├── update_post_test.dart
│   │       └── delete_post_test.dart
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── post_local_data_source_test.dart
│   │   │   └── post_remote_data_source_test.dart
│   │   ├── models/
│   │   │   └── post_model_test.dart
│   │   └── repositories/
│   │       └── post_repository_test.dart
│   └── presentation/
│       └── bloc/
│           └── post_bloc_test.dart
├── integration/
│   └── post_integration_test.dart
└── mocks/
    └── mock_datasources.dart
```

## Unit Tests

### Domain Layer Tests

#### Entities (`domain/entities/post_test.dart`)
- Tests Post entity equality and immutability
- Validates copyWith functionality
- Ensures all required fields are present

#### Usecases (`domain/usecases/*_test.dart`)
- Tests each use case in isolation
- Validates input parameters
- Ensures correct repository method invocation
- Tests both success and failure scenarios

**Test Files:**
- `get_all_posts_test.dart` - Tests fetching all posts
- `get_post_by_id_test.dart` - Tests fetching a specific post
- `create_post_test.dart` - Tests post creation
- `update_post_test.dart` - Tests post updates
- `delete_post_test.dart` - Tests post deletion

### Data Layer Tests

#### Data Sources
- `post_local_data_source_test.dart` - Tests local storage operations
- `post_remote_data_source_test.dart` - Tests API operations

#### Models (`data/models/post_model_test.dart`)
- Tests model serialization/deserialization
- Validates JSON conversion (fromJson/toJson)
- Tests model equality

#### Repository (`data/repositories/post_repository_test.dart`)
- Tests Either<Failure, T> return type contracts
- Validates failure handling (ServerFailure, CacheFailure)
- Ensures proper data flow between layers

### Presentation Layer Tests

#### BLoC Tests (`presentation/bloc/post_bloc_test.dart`)
- Tests state transitions
- Validates event handling
- Tests stream emissions
- Ensures proper error handling

## Integration Tests

### `test/integration/post_integration_test.dart`

End-to-end testing of complete workflows:

1. **Create and Retrieve Posts**
   - Creates multiple posts
   - Retrieves them successfully
   - Validates post data integrity

2. **Update Posts**
   - Creates a post
   - Updates it with new data
   - Verifies changes persist

3. **Delete Posts**
   - Creates a post
   - Deletes it
   - Verifies it's removed

4. **Multiple CRUD Operations**
   - Chains create, update operations
   - Validates final state correctness

5. **Retrieve by ID**
   - Creates a post
   - Fetches it by ID
   - Validates correct post returned

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/domain/usecases/get_all_posts_test.dart
```

### Run All Unit Tests
```bash
flutter test test/unit/
```

### Run All Integration Tests
```bash
flutter test test/integration/
```

### Run with Coverage
```bash
flutter test --coverage
```

### Run Tests with Filter
```bash
flutter test --name "should create posts"
```

## Mocking Strategy

The project uses `mocktail` for mocking:

```dart
// Example: Creating a mock
class MockPostRepository extends Mock implements PostRepository {}

// Example: Setting up expectations
when(() => mockRepository.getAllPosts())
    .thenAnswer((_) async => Right([testPost]));

// Example: Verifying calls
verify(() => mockRepository.getAllPosts()).called(1);
```

### Mock Datasources (`test/mocks/mock_datasources.dart`)

Pre-configured mocks for:
- `MockPostLocalDataSource` - Local storage operations
- `MockPostRemoteDataSource` - API operations
- `MockPostRepository` - Repository interface

## Test Coverage

Current coverage statistics:
- **Unit Tests**: 58 tests covering domain, data, and presentation layers
- **Integration Tests**: 5 tests covering end-to-end workflows
- **Total**: 63 tests

### Coverage by Layer:

1. **Domain Layer**
   - Entities: Entity tests
   - Use Cases: 5 use case tests (one per operation)

2. **Data Layer**
   - Data Sources: Remote and local data source tests
   - Models: Serialization/deserialization tests
   - Repository: Contract validation tests

3. **Presentation Layer**
   - BLoC: State management tests
   - Event handling: Comprehensive event tests

## Best Practices

### 1. Arrange-Act-Assert (AAA) Pattern
```dart
test('description', () async {
  // Arrange - Set up test conditions
  when(() => mock.method()).thenAnswer((_) async => value);
  
  // Act - Execute the code being tested
  final result = await sut.execute();
  
  // Assert - Verify the results
  expect(result, expectedValue);
});
```

### 2. One Assertion Per Test
- Each test should verify one specific behavior
- Makes failures clear and easy to debug

### 3. Descriptive Test Names
- Use clear, specific names
- Follow pattern: "should [expected behavior]"

### 4. Mock External Dependencies
- Only mock external dependencies
- Test real implementations when possible

### 5. Test Error Conditions
- Always test failure paths
- Validate error handling

## Common Test Scenarios

### Testing Async Methods
```dart
test('should return posts', () async {
  // Arrange
  when(() => mock.getPosts())
      .thenAnswer((_) async => [post]);
  
  // Act
  final result = await useCase.call();
  
  // Assert
  expect(result, isA<Right<Failure, List<Post>>>());
});
```

### Testing State Changes
```dart
test('should emit correct states', () {
  expectLater(
    bloc.stream,
    emitsInOrder([
      PostLoading(),
      PostLoaded(posts: []),
    ]),
  );
  
  bloc.add(GetAllPostsEvent());
});
```

### Testing Error Handling
```dart
test('should return failure on error', () async {
  // Arrange
  when(() => mock.getPosts())
      .thenThrow(ServerException());
  
  // Act
  final result = await useCase.call();
  
  // Assert
  result.fold(
    (failure) => expect(failure, isA<ServerFailure>()),
    (_) => fail('Should return left'),
  );
});
```

## Debugging Tests

### Print Debug Information
```dart
print('Debug: $value');
// Visible when running with -v flag
flutter test -v
```

### Run Single Test
```bash
flutter test test/path/to/test.dart -n "test name"
```

### Run with Additional Output
```bash
flutter test --verbose test/path/to/test.dart
```

## Continuous Integration

Tests can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions
- name: Run Tests
  run: flutter test
  
- name: Collect Coverage
  run: flutter test --coverage
```

## Future Improvements

- [ ] Increase coverage to 90%+
- [ ] Add widget tests for UI components
- [ ] Implement E2E tests with test drivers
- [ ] Add performance benchmarks
- [ ] Implement golden tests for UI

## Troubleshooting

### Test Timeouts
- Increase timeout: `testWidgets('...', (tester) async {}, timeout: Timeout(Duration(seconds: 10)))`

### Mock Not Working
- Verify mock setup order
- Check import statements
- Ensure correct parameter matching

### Async Test Issues
- Always use `async/await` properly
- Verify future completion before assertions

## Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
- [Clean Architecture in Flutter](https://resocoder.com/blog/flutter-tdd-clean-architecture-course-1-entities-and-repository)

