import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

/// Use case for creating a new post.
///
/// This use case encapsulates the business logic for creating a new post
/// in the repository. Input validation should be done before calling this use case.
class CreatePostUseCase extends UseCase<Post, CreatePostParams> {

  /// Creates a [CreatePostUseCase] with the given [repository].
  CreatePostUseCase(this.repository);
  /// The repository to create the post in.
  final PostRepository repository;

  @override
  Future<Either<Failure, Post>> call(CreatePostParams params) async => await repository.createPost(
      title: params.title,
      body: params.body,
      userId: params.userId,
    );
}

/// Parameters for the [CreatePostUseCase].
class CreatePostParams extends Equatable {

  /// Creates [CreatePostParams] with the given parameters.
  const CreatePostParams({
    required this.title,
    required this.body,
    required this.userId,
  });
  /// The title of the post to create.
  final String title;

  /// The body/content of the post to create.
  final String body;

  /// The ID of the user creating the post.
  final int userId;

  @override
  List<Object?> get props => [title, body, userId];
}
