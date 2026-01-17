import 'package:mocktail/mocktail.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

/// Mock repository for testing using mocktail
class MockPostRepository extends Mock implements PostRepository {}
