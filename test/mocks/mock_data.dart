import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/data/models/post_model.dart';

/// Test data - Post entity
final testPost = Post(
  id: 1,
  title: 'Test Post Title',
  body: 'This is a test post body with some content.',
  userId: 1,
);

final testPost2 = Post(
  id: 2,
  title: 'Second Test Post',
  body: 'This is the second test post body.',
  userId: 1,
);

/// Test data - Post model (for JSON serialization tests)
final testPostModel = PostModel(
  id: 1,
  title: 'Test Post Title',
  body: 'This is a test post body with some content.',
  userId: 1,
);

final testPostModelJson = {
  'id': 1,
  'title': 'Test Post Title',
  'body': 'This is a test post body with some content.',
  'userId': 1,
};

/// List of test posts
final testPostsList = [
  Post(id: 1, title: 'Post 1', body: 'Body 1', userId: 1),
  Post(id: 2, title: 'Post 2', body: 'Body 2', userId: 1),
  Post(id: 3, title: 'Post 3', body: 'Body 3', userId: 1),
];

final testPostModelsList = [
  PostModel(id: 1, title: 'Post 1', body: 'Body 1', userId: 1),
  PostModel(id: 2, title: 'Post 2', body: 'Body 2', userId: 1),
  PostModel(id: 3, title: 'Post 3', body: 'Body 3', userId: 1),
];
