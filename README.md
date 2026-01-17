# Post App

A modern Flutter application demonstrating clean architecture principles with comprehensive testing, featuring a posts management system built with BLoC state management.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Testing](#testing)
- [Development Workflow](#development-workflow)

## 🎯 Overview

Post App is a full-featured Flutter application that demonstrates:
- **Clean Architecture** with Domain, Data, and Presentation layers
- **BLoC Pattern** for state management
- **Comprehensive Testing** (176+ unit, widget, and integration tests)
- **Dependency Injection** with GetIt service locator
- **Functional Error Handling** with dartz Either type
- **Local Caching** with Hive
- **HTTP Client** with Dio
- **Routing** with go_router

The app allows users to:
- View all posts from an API
- View individual post details
- Create new posts
- Edit existing posts
- Delete posts
- Cache posts locally for offline access

## 🏗️ Architecture

The project follows **Clean Architecture** principles, separated into three main layers:

### Domain Layer (`lib/features/posts/domain/`)
- **Entities**: Core business objects (Post)
- **Repositories**: Abstract repository interfaces
- **UseCases**: Business logic encapsulation
  - `GetAllPostsUseCase`: Fetch all posts
  - `ReadPostUseCase`: Fetch a single post by ID
  - `CreatePostUseCase`: Create a new post
  - `UpdatePostUseCase`: Update an existing post
  - `DeletePostUseCase`: Delete a post

### Data Layer (`lib/features/posts/data/`)
- **Models**: Data transfer objects extending domain entities
- **DataSources**: Abstract interfaces for local and remote data access
  - `RemoteDataSource`: API calls via Dio
  - `LocalDataSource`: Hive cache operations
- **Repositories**: Implementation of domain repositories with error handling
- **Mappers**: Convert between models and entities

### Presentation Layer (`lib/features/posts/presentation/`)
- **BLoC**: State management for posts operations
  - Events: `GetAllPostsEvent`, `GetPostByIdEvent`, `CreatePostEvent`, `UpdatePostEvent`, `DeletePostEvent`, `RefreshPostsEvent`
  - States: `PostInitial`, `PostLoading`, `PostLoaded`, `PostError`, `PostCreated`, `PostUpdated`, `PostDeleted`
- **Pages**: Full-screen widgets (`PostListPage`, `PostDetailPage`, `PostFormPage`)
- **Widgets**: Reusable UI components (`PostTile`, `PostCard`, state widgets)

## ✨ Features

### Core Functionality
- ✅ **CRUD Operations**: Create, Read, Update, Delete posts
- ✅ **List Management**: View all posts with infinite scrolling support
- ✅ **Detail View**: View full post content with author information
- ✅ **Form Handling**: Comprehensive form validation for create/edit
- ✅ **Responsive Design**: Works on mobile, tablet, and web

### Data Management
- ✅ **Local Caching**: Hive-based offline storage
- ✅ **Network Requests**: Dio HTTP client with error handling
- ✅ **Error Handling**: Functional error handling with Either type
- ✅ **Failure Types**: ServerFailure, CacheFailure with descriptive messages

### User Experience
- ✅ **Loading States**: Visual feedback during operations
- ✅ **Error States**: Clear error messages and recovery options
- ✅ **Success Feedback**: Toast notifications on successful operations
- ✅ **Form Validation**: Real-time validation with helpful error messages
- ✅ **Navigation**: Smooth page transitions with go_router

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── config/
│   ├── di/                      # Dependency injection configuration
│   └── routes/                  # GoRouter configuration
├── core/
│   ├── constants/               # App-wide constants
│   ├── error/                   # Failure classes and error handling
│   ├── usecases/                # Base UseCase class
│   └── utils/                   # Validators and utilities
├── features/
│   └── posts/
│       ├── domain/
│       │   ├── entities/        # Post entity
│       │   ├── repositories/    # Repository interfaces
│       │   └── usecases/        # UseCase implementations
│       ├── data/
│       │   ├── datasources/     # Remote and local data sources
│       │   ├── models/          # Post model (extends entity)
│       │   └── repositories/    # Repository implementations
│       └── presentation/
│           ├── bloc/            # BLoC state management
│           ├── pages/           # Full-screen pages
│           └── widgets/         # Reusable UI components
└── service_locator/             # GetIt service locator setup

test/
├── unit/                        # Unit tests
│   ├── domain/
│   ├── data/
│   └── presentation/
├── widget/                      # Widget and page tests
└── mocks/                       # Mock objects and repositories
```

## 🛠️ Tech Stack

| Category | Package | Version |
|----------|---------|---------|
| **State Management** | flutter_bloc | Latest |
| **Service Locator** | get_it | Latest |
| **Routing** | go_router | Latest |
| **HTTP Client** | dio | Latest |
| **Local Storage** | hive, hive_flutter | Latest |
| **Functional Programming** | dartz | Latest |
| **Utilities** | equatable | Latest |
| **Testing** | flutter_test, mocktail | Latest |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio or Xcode

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd post_app
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (if needed)
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

The app uses `jsonplaceholder.typicode.com` API by default. To use a different API:

1. Update `lib/features/posts/data/datasources/remote_data_source.dart`
2. Modify the base URL in the Dio configuration

## 🧪 Testing

### Test Coverage

The project includes **176+ tests** across multiple categories:

- **Domain Layer Tests** (21 tests)
  - Entity tests (6 tests)
  - UseCase tests (15 tests)
    - GetAllPostsUseCase (8 tests)
    - ReadPostUseCase (2 tests)
    - CreatePostUseCase (2 tests)
    - UpdatePostUseCase (9 tests)
    - DeletePostUseCase (11 tests)

- **Data Layer Tests** (49 tests)
  - Model tests (57 tests)
    - Basic model tests (5 tests)
    - Extended model tests (22 tests)
    - Boundary value tests (30 tests)
  - DataSource tests (20 tests)
  - Repository tests (3 tests)

- **Presentation Layer Tests** (54 tests)
  - BLoC tests (24 tests)
  - Integration tests (5 tests)
  - Widget tests (30 tests)
  - Page tests (19 tests)

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/domain/entities/post_test.dart

# Run tests matching a pattern
flutter test --name "UpdatePostUseCase"
```

### Test Examples

**Unit Test (UseCase)**
```dart
test('should update a post when repository succeeds', () async {
  // Arrange
  final updatedPost = testPost.copyWith(title: 'Updated Title');
  when(() => mockRepository.updatePost(...))
      .thenAnswer((_) async => Right(updatedPost));

  // Act
  final result = await useCase(UpdatePostParams(...));

  // Assert
  result.fold(
    (failure) => fail('Should return right side'),
    (post) => expect(post.title, 'Updated Title'),
  );
});
```

**Widget Test**
```dart
testWidgets('PostCard displays post information', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: PostCard(post: testPost))),
  );

  expect(find.text(testPost.title), findsOneWidget);
  expect(find.text(testPost.body), findsOneWidget);
});
```

## 📱 Development Workflow

### Code Style & Standards

- Follow Dart style guide
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Keep functions small and focused

### Adding a New Feature

1. **Create domain layer**
   - Define entity
   - Create repository interface
   - Implement UseCase

2. **Create data layer**
   - Create model extending entity
   - Implement data sources
   - Implement repository

3. **Create presentation layer**
   - Define BLoC events and states
   - Implement event handlers
   - Create UI pages and widgets

4. **Add tests**
   - Unit tests for domain layer
   - Mock-based tests for data layer
   - Widget tests for UI

### Debugging

Enable debug logging:
```dart
// In main.dart
void setupServiceLocator() {
  // ... existing setup
  if (kDebugMode) {
    print('Service Locator initialized');
  }
}
```

Use Flutter DevTools:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## 📊 Performance Considerations

- **Caching**: Posts are cached locally to reduce API calls
- **Pagination**: Implement for better performance with large datasets
- **Image Optimization**: Consider lazy loading for post thumbnails
- **BLoC Optimization**: Events are efficiently processed with proper state separation

## 🤝 Contributing

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit changes (`git commit -m 'Add amazing feature'`)
3. Push to branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- BLoC library for state management
- JSONPlaceholder for the mock API
- Community contributors and testers

## 📞 Support

For questions or issues:
1. Check existing documentation
2. Review test examples for usage patterns
3. Open an issue on the repository
4. Refer to [Flutter Documentation](https://flutter.dev/docs)
