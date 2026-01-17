# Domain Layer - Use Cases Quick Reference

## All 5 Use Cases

### 1. GetAllPostsUseCase

**Purpose**: Retrieve all posts

**File**: `lib/features/posts/domain/usecases/get_all_posts_usecase.dart`

**Parameters**: `NoParams` (no input required)

**Return Type**: `Future<Either<Failure, List<Post>>>`

**Usage**:
```dart
final getAllPosts = GetAllPostsUseCase(repository);
final result = await getAllPosts(NoParams());

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (posts) => print('Got ${posts.length} posts'),
);
```

**Response**:
- **Success**: Returns list of Post entities (may be empty)
- **Failure**: Returns Failure object (ServerFailure, CacheFailure, etc.)

---

### 2. ReadPostUseCase

**Purpose**: Retrieve a single post by ID

**File**: `lib/features/posts/domain/usecases/read_post_usecase.dart`

**Parameters**: `GetPostParams`
```dart
class GetPostParams extends Equatable {
  final int id;  // Post ID to retrieve
  const GetPostParams({required this.id});
}
```

**Return Type**: `Future<Either<Failure, Post>>`

**Usage**:
```dart
final readPost = ReadPostUseCase(repository);
final result = await readPost(GetPostParams(id: 1));

result.fold(
  (failure) => print('Post not found'),
  (post) => print('Post: ${post.title}'),
);
```

**Response**:
- **Success**: Returns single Post entity
- **Failure**: Returns Failure (ServerFailure, PostNotFoundFailure, etc.)

---

### 3. CreatePostUseCase

**Purpose**: Create a new post

**File**: `lib/features/posts/domain/usecases/create_post_usecase.dart`

**Parameters**: `CreatePostParams`
```dart
class CreatePostParams extends Equatable {
  final String title;    // Post title (validated)
  final String body;     // Post body (validated)
  final int userId;      // User ID of creator
  
  const CreatePostParams({
    required this.title,
    required this.body,
    required this.userId,
  });
}
```

**Return Type**: `Future<Either<Failure, Post>>`

**Usage**:
```dart
// Step 1: Validate inputs
final title = Validators.validatePostTitle(userInput);
final body = Validators.validatePostBody(userInput);

// Step 2: Create params
final params = CreatePostParams(
  title: title,
  body: body,
  userId: currentUserId,
);

// Step 3: Call use case
final createPost = CreatePostUseCase(repository);
final result = await createPost(params);

// Step 4: Handle result
result.fold(
  (failure) => print('Failed to create: ${failure.message}'),
  (newPost) => print('Created post with ID: ${newPost.id}'),
);
```

**Response**:
- **Success**: Returns newly created Post (with assigned ID)
- **Failure**: Returns Failure (ServerFailure, ValidationFailure, etc.)

**Important**: Always validate inputs using Validators before creating params!

---

### 4. UpdatePostUseCase

**Purpose**: Update an existing post

**File**: `lib/features/posts/domain/usecases/update_post_usecase.dart`

**Parameters**: `UpdatePostParams`
```dart
class UpdatePostParams extends Equatable {
  final int id;          // Post ID to update
  final String title;    // New title (validated)
  final String body;     // New body (validated)
  
  const UpdatePostParams({
    required this.id,
    required this.title,
    required this.body,
  });
}
```

**Return Type**: `Future<Either<Failure, Post>>`

**Usage**:
```dart
// Step 1: Validate inputs
final title = Validators.validatePostTitle(userInput);
final body = Validators.validatePostBody(userInput);

// Step 2: Create params
final params = UpdatePostParams(
  id: postId,
  title: title,
  body: body,
);

// Step 3: Call use case
final updatePost = UpdatePostUseCase(repository);
final result = await updatePost(params);

// Step 4: Handle result
result.fold(
  (failure) => print('Update failed: ${failure.message}'),
  (updatedPost) => print('Updated: ${updatedPost.title}'),
);
```

**Response**:
- **Success**: Returns updated Post entity
- **Failure**: Returns Failure (ServerFailure, PostNotFoundFailure, etc.)

**Important**: Always validate inputs using Validators before creating params!

---

### 5. DeletePostUseCase

**Purpose**: Delete a post

**File**: `lib/features/posts/domain/usecases/delete_post_usecase.dart`

**Parameters**: `DeletePostParams`
```dart
class DeletePostParams extends Equatable {
  final int id;  // Post ID to delete
  const DeletePostParams({required this.id});
}
```

**Return Type**: `Future<Either<Failure, void>>`

**Usage**:
```dart
// Create params
final params = DeletePostParams(id: postId);

// Call use case
final deletePost = DeletePostUseCase(repository);
final result = await deletePost(params);

// Handle result
result.fold(
  (failure) => print('Delete failed: ${failure.message}'),
  (_) => print('Post deleted successfully'),
);
```

**Response**:
- **Success**: Returns void (unit value)
- **Failure**: Returns Failure (ServerFailure, PostNotFoundFailure, etc.)

---

## Parameter Classes Summary

| Use Case | Parameter Class | Fields |
|----------|-----------------|--------|
| GetAllPosts | `NoParams` | (none) |
| ReadPost | `GetPostParams` | `id` |
| CreatePost | `CreatePostParams` | `title`, `body`, `userId` |
| UpdatePost | `UpdatePostParams` | `id`, `title`, `body` |
| DeletePost | `DeletePostParams` | `id` |

All parameter classes extend `Equatable` for testing.

---

## Error Handling Pattern

All use cases return `Either<Failure, T>`:

```dart
// Successful result
Either<Failure, Post> result = Right(post);

// Failed result
Either<Failure, Post> result = Left(ServerFailure("Error message"));

// Handle both cases
result.fold(
  (failure) => handleError(failure),      // Left case
  (post) => handleSuccess(post),          // Right case
);
```

---

## Common Failure Types

All use cases can return these failures:

- `ServerFailure` - HTTP/API errors
- `NetworkFailure` - Network connectivity issues
- `CacheFailure` - Local cache issues
- `ValidationFailure` - Input validation failed
- `UnexpectedFailure` - Unknown/unexpected errors

---

## Dependency Injection Pattern (Phase 5)

```dart
// In dependency injection setup
getIt.registerSingleton<GetAllPostsUseCase>(
  GetAllPostsUseCase(getIt<PostRepository>()),
);
getIt.registerSingleton<ReadPostUseCase>(
  ReadPostUseCase(getIt<PostRepository>()),
);
// ... etc for all use cases

// In BLoC
class PostBloc extends Bloc<PostEvent, PostState> {
  final GetAllPostsUseCase getAllPostsUseCase = getIt();
  final ReadPostUseCase readPostUseCase = getIt();
  final CreatePostUseCase createPostUseCase = getIt();
  final UpdatePostUseCase updatePostUseCase = getIt();
  final DeletePostUseCase deletePostUseCase = getIt();
  
  // ...
}
```

---

## Testing Pattern

```dart
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  group('GetAllPostsUseCase', () {
    late GetAllPostsUseCase usecase;
    late MockPostRepository mockRepository;

    setUp(() {
      mockRepository = MockPostRepository();
      usecase = GetAllPostsUseCase(mockRepository);
    });

    test('should return list of posts', () async {
      // Arrange
      final posts = [
        Post(id: 1, title: 'Post 1', body: 'Body 1', userId: 1, createdAt: DateTime.now()),
        Post(id: 2, title: 'Post 2', body: 'Body 2', userId: 1, createdAt: DateTime.now()),
      ];
      
      when(() => mockRepository.getAllPosts())
          .thenAnswer((_) async => Right(posts));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(posts));
      verify(() => mockRepository.getAllPosts()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getAllPosts())
          .thenAnswer((_) async => Left(ServerFailure('Error')));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, isA<Left<Failure, dynamic>>());
    });
  });
}
```

---

## BLoC Integration Pattern (Phase 4)

```dart
class PostBloc extends Bloc<PostEvent, PostState> {
  final GetAllPostsUseCase _getAllPostsUseCase;
  final ReadPostUseCase _readPostUseCase;
  final CreatePostUseCase _createPostUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  PostBloc({
    required GetAllPostsUseCase getAllPostsUseCase,
    required ReadPostUseCase readPostUseCase,
    required CreatePostUseCase createPostUseCase,
    required UpdatePostUseCase updatePostUseCase,
    required DeletePostUseCase deletePostUseCase,
  })  : _getAllPostsUseCase = getAllPostsUseCase,
        _readPostUseCase = readPostUseCase,
        _createPostUseCase = createPostUseCase,
        _updatePostUseCase = updatePostUseCase,
        _deletePostUseCase = deletePostUseCase,
        super(PostInitial()) {
    on<GetAllPostsEvent>(_onGetAllPosts);
    on<ReadPostEvent>(_onReadPost);
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
  }

  FutureOr<void> _onGetAllPosts(GetAllPostsEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await _getAllPostsUseCase(NoParams());
    
    result.fold(
      (failure) => emit(PostError(failure.message)),
      (posts) => emit(PostLoaded(posts)),
    );
  }

  FutureOr<void> _onCreatePost(CreatePostEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    
    // Validate inputs first
    try {
      final title = Validators.validatePostTitle(event.title);
      final body = Validators.validatePostBody(event.body);
      
      final result = await _createPostUseCase(
        CreatePostParams(title: title, body: body, userId: event.userId),
      );
      
      result.fold(
        (failure) => emit(PostError(failure.message)),
        (newPost) => emit(PostCreated(newPost)),
      );
    } on ValidationException catch (e) {
      emit(PostError(e.message));
    }
  }

  // ... implement other handlers
}
```

---

## Key Points to Remember

1. **Always validate before creating params** - Use Validators from core layer
2. **Handle Either properly** - Use fold, map, or getOrElse
3. **All params are equatable** - Makes testing easier
4. **Immutable by design** - All classes are const
5. **No side effects** - Use cases only return results
6. **Repository pattern** - Domain only knows about interface, not implementation
7. **Type-safe** - All parameters are strongly typed
8. **Fully documented** - Read dartdoc for details

---

**Last Updated**: January 16, 2026
**Phase**: 2 - Domain Layer Complete
