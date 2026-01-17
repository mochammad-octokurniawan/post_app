import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

/// Use case for retrieving a single post by ID.
///
/// This use case encapsulates the business logic for fetching a post
/// by its unique identifier.
class ReadPostUseCase extends UseCase<Post, GetPostParams> {

  /// Creates a [ReadPostUseCase] with the given [repository].
  ReadPostUseCase(this.repository);
  /// The repository to fetch the post from.
  final PostRepository repository;

  @override
  Future<Either<Failure, Post>> call(GetPostParams params) async => await repository.getPostById(params.id);
}

/// Parameters for the [ReadPostUseCase].
class GetPostParams extends Equatable {

  /// Creates [GetPostParams] with the given [id].
  const GetPostParams({required this.id});
  /// The ID of the post to retrieve.
  final int id;

  @override
  List<Object?> get props => [id];
}
