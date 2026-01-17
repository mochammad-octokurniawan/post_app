import 'package:dartz/dartz.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

/// Use case for retrieving all posts.
///
/// This use case encapsulates the business logic for fetching all posts
/// from the repository.
class GetAllPostsUseCase extends UseCase<List<Post>, NoParams> {
  /// The repository to fetch posts from.
  final PostRepository repository;

  /// Creates a [GetAllPostsUseCase] with the given [repository].
  GetAllPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await repository.getAllPosts();
  }
}
