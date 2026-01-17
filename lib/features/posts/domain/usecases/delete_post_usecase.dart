import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

/// Use case for deleting a post.
///
/// This use case encapsulates the business logic for deleting a post
/// from the repository.
class DeletePostUseCase extends UseCase<void, DeletePostParams> {

  /// Creates a [DeletePostUseCase] with the given [repository].
  DeletePostUseCase(this.repository);
  /// The repository to delete the post from.
  final PostRepository repository;

  @override
  Future<Either<Failure, void>> call(DeletePostParams params) async => await repository.deletePost(params.id);
}

/// Parameters for the [DeletePostUseCase].
class DeletePostParams extends Equatable {

  /// Creates [DeletePostParams] with the given [id].
  const DeletePostParams({required this.id});
  /// The ID of the post to delete.
  final int id;

  @override
  List<Object?> get props => [id];
}
