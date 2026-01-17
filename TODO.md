# Post CRUD Application - TODO

A Flutter application implementing Post CRUD operations with Clean Architecture, BLoC state management, and dependency injection using GetIt and Injectable.

## Project Structure

```
lib/
├── main.dart
├── config/
│   ├── di/
│   │   └── injection_container.dart
│   └── routes/
│       └── app_router.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── error_messages.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── usecases/
│   │   └── usecase.dart
│   └── utils/
│       └── validators.dart
├── features/
│   └── posts/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── local/
│       │   │   │   └── post_local_data_source.dart
│       │   │   └── remote/
│       │   │       └── post_remote_data_source.dart
│       │   ├── models/
│       │   │   └── post_model.dart
│       │   ├── repositories/
│       │   │   └── post_repository_impl.dart
│       │   └── datasources/
│       │       └── post_datasource.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── post.dart
│       │   ├── repositories/
│       │   │   └── post_repository.dart
│       │   └── usecases/
│       │       ├── create_post_usecase.dart
│       │       ├── read_post_usecase.dart
│       │       ├── update_post_usecase.dart
│       │       ├── delete_post_usecase.dart
│       │       └── get_all_posts_usecase.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── post_bloc.dart
│           │   ├── post_event.dart
│           │   └── post_state.dart
│           ├── pages/
│           │   ├── posts_list_page.dart
│           │   ├── post_detail_page.dart
│           │   └── create_edit_post_page.dart
│           └── widgets/
│               ├── post_list_item.dart
│               ├── post_form.dart
│               └── error_widget.dart
```

## Phase 1: Setup & Configuration

### 1.1 Project Dependencies
- [ ] Add pubspec.yaml dependencies:
  - `flutter_bloc: ^8.x.x`
  - `get_it: ^7.x.x`
  - `injectable: ^2.x.x`
  - `injectable_generator: ^2.x.x`
  - `build_runner: ^2.x.x`
  - `equatable: ^2.x.x`
  - `dartz: ^0.10.x` (for Either type)
  - `go_router: ^14.x.x` (for routing)
  - `dio: ^5.x.x` (for HTTP)
  - `hive: ^2.x.x` (for local storage)
  - `hive_flutter: ^1.x.x`

### 1.2 Project Configuration
- [ ] Update `analysis_options.yaml` with linting rules
- [ ] Configure build_runner for code generation
- [ ] Set up environment configuration files
- [ ] Initialize Flutter project structure

---

## Phase 2: Core Layer

### 2.1 Error Handling
- [ ] Create `core/error/exceptions.dart`
  - [ ] `AppException` base class
  - [ ] `ServerException`
  - [ ] `CacheException`
  - [ ] `ValidationException`

- [ ] Create `core/error/failures.dart`
  - [ ] `Failure` base class
  - [ ] `ServerFailure`
  - [ ] `CacheFailure`
  - [ ] `ValidationFailure`

### 2.2 Base UseCase
- [ ] Create `core/usecases/usecase.dart`
  - [ ] `UseCase` abstract class with `call()` method
  - [ ] Generic parameters for input and output types

### 2.3 Constants & Utils
- [ ] Create `core/constants/app_constants.dart`
  - [ ] API endpoints
  - [ ] Database names
  - [ ] Timeout durations
  - [ ] Cache keys

- [ ] Create `core/constants/error_messages.dart`
  - [ ] User-friendly error messages

- [ ] Create `core/utils/validators.dart`
  - [ ] Post title validation
  - [ ] Post content validation
  - [ ] Email validation (if needed)

---

## Phase 3: Data Layer

### 3.1 Models
- [ ] Create `features/posts/data/models/post_model.dart`
  - [ ] Extend Post entity with JSON serialization
  - [ ] Implement `toJson()` method
  - [ ] Implement `fromJson()` factory
  - [ ] Add `copyWith()` method

### 3.2 Data Sources
- [ ] Create `features/posts/data/datasources/post_local_data_source.dart`
  - [ ] Abstract class defining local data operations
  - [ ] Implementation using Hive
  - [ ] `getAllPosts()`
  - [ ] `getPostById()`
  - [ ] `createPost()`
  - [ ] `updatePost()`
  - [ ] `deletePost()`
  - [ ] `deleteAllPosts()`

- [ ] Create `features/posts/data/datasources/post_remote_data_source.dart`
  - [ ] Abstract class defining remote data operations
  - [ ] Implementation using Dio
  - [ ] `getAllPosts()`
  - [ ] `getPostById()`
  - [ ] `createPost()`
  - [ ] `updatePost()`
  - [ ] `deletePost()`

### 3.3 Repository Implementation
- [ ] Create `features/posts/data/repositories/post_repository_impl.dart`
  - [ ] Implement domain repository interface
  - [ ] Use Either type for error handling
  - [ ] Implement retry logic with exponential backoff
  - [ ] Handle network connectivity checks
  - [ ] Implement caching strategy
  - [ ] `getAllPosts()` - Try remote first, fallback to cache
  - [ ] `getPostById()`
  - [ ] `createPost()`
  - [ ] `updatePost()`
  - [ ] `deletePost()`

---

## Phase 4: Domain Layer

### 4.1 Entities
- [ ] Create `features/posts/domain/entities/post.dart`
  - [ ] Post entity with id, title, body, userId, timestamp
  - [ ] Make it immutable (equatable)
  - [ ] Override `==` and `hashCode`

### 4.2 Repository Abstract
- [ ] Create `features/posts/domain/repositories/post_repository.dart`
  - [ ] Abstract repository interface
  - [ ] Define CRUD operation signatures returning `Either<Failure, T>`

### 4.3 Use Cases
- [ ] Create `features/posts/domain/usecases/create_post_usecase.dart`
  - [ ] Extend `UseCase<Post, CreatePostParams>`
  - [ ] Validate input parameters
  - [ ] Call repository method

- [ ] Create `features/posts/domain/usecases/get_all_posts_usecase.dart`
  - [ ] Extend `UseCase<List<Post>, NoParams>`
  - [ ] Retrieve all posts with pagination option

- [ ] Create `features/posts/domain/usecases/read_post_usecase.dart`
  - [ ] Extend `UseCase<Post, GetPostParams>`
  - [ ] Retrieve single post by ID

- [ ] Create `features/posts/domain/usecases/update_post_usecase.dart`
  - [ ] Extend `UseCase<Post, UpdatePostParams>`
  - [ ] Validate input parameters
  - [ ] Call repository method

- [ ] Create `features/posts/domain/usecases/delete_post_usecase.dart`
  - [ ] Extend `UseCase<void, DeletePostParams>`
  - [ ] Remove post by ID

---

## Phase 5: Presentation Layer - BLoC

### 5.1 Events
- [ ] Create `features/posts/presentation/bloc/post_event.dart`
  - [ ] `PostEvent` base class
  - [ ] `GetAllPostsEvent`
  - [ ] `GetPostByIdEvent` with post ID
  - [ ] `CreatePostEvent` with title and body
  - [ ] `UpdatePostEvent` with id, title, body
  - [ ] `DeletePostEvent` with post ID
  - [ ] `RefreshPostsEvent`
  - [ ] Make all events equatable

### 5.2 States
- [ ] Create `features/posts/presentation/bloc/post_state.dart`
  - [ ] `PostState` base class
  - [ ] `PostInitial` state
  - [ ] `PostLoading` state
  - [ ] `PostLoaded` state with posts data
  - [ ] `PostError` state with error message
  - [ ] `PostCreated` state with new post
  - [ ] `PostUpdated` state
  - [ ] `PostDeleted` state
  - [ ] Make all states equatable with properties

### 5.3 BLoC
- [ ] Create `features/posts/presentation/bloc/post_bloc.dart`
  - [ ] Inject all use cases
  - [ ] Implement event handlers:
    - [ ] `_onGetAllPosts()` - Fetch and emit posts
    - [ ] `_onGetPostById()` - Fetch single post
    - [ ] `_onCreatePost()` - Create post with validation
    - [ ] `_onUpdatePost()` - Update post with validation
    - [ ] `_onDeletePost()` - Delete post with confirmation
    - [ ] `_onRefreshPosts()` - Refresh posts list
  - [ ] Error handling with user-friendly messages
  - [ ] Initial state initialization

---

## Phase 6: Presentation Layer - UI

### 6.1 Pages
- [ ] Create `features/posts/presentation/pages/posts_list_page.dart`
  - [ ] Display paginated list of posts
  - [ ] Pull-to-refresh functionality
  - [ ] Navigate to detail/edit on tap
  - [ ] Floating action button to create post
  - [ ] Show loading indicator
  - [ ] Show error state with retry button
  - [ ] Show empty state

- [ ] Create `features/posts/presentation/pages/post_detail_page.dart`
  - [ ] Display post details with title and body
  - [ ] Edit button to navigate to edit page
  - [ ] Delete button with confirmation
  - [ ] Back navigation
  - [ ] Share post functionality (optional)

- [ ] Create `features/posts/presentation/pages/create_edit_post_page.dart`
  - [ ] Form for creating new post
  - [ ] Form for editing existing post
  - [ ] Title input field with validation
  - [ ] Body input field with validation
  - [ ] Submit button with loading state
  - [ ] Cancel button
  - [ ] Error message display
  - [ ] Pre-populate form for edit mode

### 6.2 Widgets
- [ ] Create `features/posts/presentation/widgets/post_list_item.dart`
  - [ ] Display post card with title and preview
  - [ ] Show timestamp
  - [ ] Tap handling for navigation
  - [ ] Long-press for delete option

- [ ] Create `features/posts/presentation/widgets/post_form.dart`
  - [ ] Reusable form widget for create/edit
  - [ ] Title input field
  - [ ] Body input field
  - [ ] Validation display
  - [ ] Submit button
  - [ ] Loading state

- [ ] Create `features/posts/presentation/widgets/error_widget.dart`
  - [ ] Display error message
  - [ ] Retry button with callback
  - [ ] Styled error UI

- [ ] Create `features/posts/presentation/widgets/loading_widget.dart`
  - [ ] Show loading shimmer/skeleton
  - [ ] Loading progress indicator

- [ ] Create `features/posts/presentation/widgets/empty_state_widget.dart`
  - [ ] Display when no posts available
  - [ ] Create button to add first post

---

## Phase 7: Dependency Injection & Configuration

### 7.1 Injectable Configuration
- [ ] Create `config/di/injection_container.dart`
  - [ ] Annotate data sources with `@injectable`
  - [ ] Annotate repositories with `@singleton`
  - [ ] Annotate use cases with `@injectable`
  - [ ] Annotate BLoCs with `@injectable`
  - [ ] Configure GetIt:
    - [ ] Register remote data source
    - [ ] Register local data source
    - [ ] Register repository
    - [ ] Register all use cases
    - [ ] Register BLoCs
  - [ ] Create `setup()` function to initialize all dependencies

### 7.2 Code Generation
- [ ] Run `flutter pub run build_runner build` to generate injection code
- [ ] Verify `injection_container.config.dart` is generated
- [ ] Update `injection_container.dart` with generated code

### 7.3 Main Configuration
- [ ] Update `main.dart`:
  - [ ] Initialize Hive for local storage
  - [ ] Call dependency injection setup
  - [ ] Initialize Dio with interceptors
  - [ ] Configure GoRouter with route definitions
  - [ ] Set up error handling for uncaught exceptions

---

## Phase 8: Routing

### 8.1 Route Configuration
- [ ] Create `config/routes/app_router.dart`
  - [ ] Define named routes for:
    - [ ] Posts list page (home)
    - [ ] Post detail page
    - [ ] Create post page
    - [ ] Edit post page
  - [ ] Configure GoRouter with named routes
  - [ ] Set up route transitions
  - [ ] Handle navigation parameters

---

## Phase 9: Testing

### 9.1 Unit Tests
- [ ] Create tests for use cases:
  - [ ] `test/features/posts/domain/usecases/create_post_usecase_test.dart`
  - [ ] `test/features/posts/domain/usecases/get_all_posts_usecase_test.dart`
  - [ ] `test/features/posts/domain/usecases/update_post_usecase_test.dart`
  - [ ] `test/features/posts/domain/usecases/delete_post_usecase_test.dart`

- [ ] Create tests for repository:
  - [ ] `test/features/posts/data/repositories/post_repository_impl_test.dart`
  - [ ] Test network success/failure scenarios
  - [ ] Test cache fallback
  - [ ] Test retry logic

- [ ] Create tests for BLoC:
  - [ ] `test/features/posts/presentation/bloc/post_bloc_test.dart`
  - [ ] Test all event handlers
  - [ ] Test state transitions
  - [ ] Test error handling

### 9.2 Widget Tests
- [ ] Create tests for pages and widgets:
  - [ ] `test/features/posts/presentation/pages/posts_list_page_test.dart`
  - [ ] `test/features/posts/presentation/widgets/post_list_item_test.dart`
  - [ ] `test/features/posts/presentation/widgets/post_form_test.dart`

### 9.3 Integration Tests
- [ ] Create integration tests:
  - [ ] `test_driver/app.dart`
  - [ ] `integration_test/post_crud_flow_test.dart`
  - [ ] Test complete CRUD workflows
  - [ ] Test navigation between screens

---

## Phase 10: Documentation & Polish

### 10.1 Code Documentation
- [ ] Add dartdoc comments to all public classes and methods
- [ ] Document complex business logic
- [ ] Add README with setup instructions
- [ ] Add ARCHITECTURE.md explaining Clean Architecture

### 10.2 Performance & Optimization
- [ ] Implement pagination for large post lists
- [ ] Add image caching for post thumbnails (if applicable)
- [ ] Optimize BLoC listener usage to prevent rebuilds
- [ ] Profile and optimize widget builds
- [ ] Implement lazy loading for lists

### 10.3 Error Handling & Logging
- [ ] Add logging throughout the application
- [ ] Implement crash reporting
- [ ] Add user-friendly error messages for all failure scenarios
- [ ] Implement retry mechanisms for network requests

### 10.4 UI/UX Polish
- [ ] Add smooth animations for page transitions
- [ ] Add loading shimmer effects
- [ ] Implement dark mode support
- [ ] Add haptic feedback for interactions
- [ ] Test on multiple screen sizes
- [ ] Add accessibility features (semantic labels, contrast ratios)

---

## Phase 11: Advanced Features

### 11.1 Offline Support
- [ ] Implement offline queue for create/update/delete operations
- [ ] Sync operations when connectivity returns
- [ ] Show offline indicator

### 11.2 Search & Filtering
- [ ] Add search functionality for posts
- [ ] Add filter by date/author
- [ ] Implement local search in cached posts

### 11.3 Notifications
- [ ] Add push notifications for post updates
- [ ] Implement local notifications for sync completion

### 11.4 Advanced Caching
- [ ] Implement cache expiration strategy
- [ ] Add cache statistics display
- [ ] Manual cache clear functionality

---

## Dependencies Reference

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.x.x
  equatable: ^2.x.x
  
  # Dependency Injection
  get_it: ^7.x.x
  injectable: ^2.x.x
  
  # Functional Programming
  dartz: ^0.10.x
  
  # Routing
  go_router: ^14.x.x
  
  # Networking
  dio: ^5.x.x
  
  # Local Storage
  hive: ^2.x.x
  hive_flutter: ^1.x.x

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.x.x
  
  # Code Generation
  build_runner: ^2.x.x
  injectable_generator: ^2.x.x
  
  # Testing
  mocktail: ^1.x.x
  bloc_test: ^9.x.x
  flutter_driver:
    sdk: flutter
  integration_test:
    sdk: flutter
```

---

## Key Principles

### Clean Architecture
- **Separation of Concerns**: Data, Domain, and Presentation layers are independent
- **Dependency Rule**: Dependencies point inward; domain layer has no external dependencies
- **Testability**: Each layer can be tested in isolation

### BLoC Pattern
- **Single Responsibility**: Each BLoC manages one feature
- **Event-Driven**: All state changes triggered by events
- **Immutable States**: States are immutable for predictability
- **Error Handling**: Proper error states for user feedback

### Dependency Injection
- **Centralized**: All dependencies defined in one place
- **Lazy Initialization**: Use `@lazySingleton` for expensive resources
- **Testability**: Easy to swap implementations for testing

---

## Git Workflow

- [ ] Initial commit: Project setup and dependencies
- [ ] Commit: Core layer implementation
- [ ] Commit: Data layer implementation
- [ ] Commit: Domain layer implementation
- [ ] Commit: Dependency injection configuration
- [ ] Commit: BLoC presentation layer
- [ ] Commit: UI pages and widgets
- [ ] Commit: Routing configuration
- [ ] Commit: Unit and widget tests
- [ ] Commit: Integration tests
- [ ] Commit: Documentation and polish

---

## Resources

- [Flutter BLoC Documentation](https://bloclibrary.dev)
- [GetIt Package](https://pub.dev/packages/get_it)
- [Injectable Package](https://pub.dev/packages/injectable)
- [Resocoder Clean Architecture](https://youtu.be/KjE2IDphA_E)
- [Reso Coder BLoC Tutorial](https://youtu.be/IJ_ENXwQmB0)

---

**Last Updated**: January 16, 2026
