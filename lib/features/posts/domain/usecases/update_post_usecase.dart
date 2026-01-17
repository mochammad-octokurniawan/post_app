import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

/// Use case for updating an existing post.
///
/// This use case encapsulates the business logic for updating a post
/// in the repository. Input validation should be done before calling this use case.
class UpdatePostUseCase extends UseCase<Post, UpdatePostParams> {

  /// Creates an [UpdatePostUseCase] with the given [repository].
  UpdatePostUseCase(this.repository);
  /// The repository to update the post in.
  final PostRepository repository;

  @override
  Future<Either<Failure, Post>> call(UpdatePostParams params) async => await repository.updatePost(
      id: params.id,
      title: params.title,
      body: params.body,
    );
}

/// Parameters for the [UpdatePostUseCase].
class UpdatePostParams extends Equatable {

  /// Creates [UpdatePostParams] with the given parameters.
  const UpdatePostParams({
    required this.id,
    required this.title,
    required this.body,
  });
  /// The ID of the post to update.
  final int id;

  /// The new title of the post.
  final String title;

  /// The new body/content of the post.
  final String body;

  @override
  List<Object?> get props => [id, title, body];
}
