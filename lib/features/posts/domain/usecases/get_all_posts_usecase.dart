import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/core/usecases/usecase.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/entities/post_sort_type.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

/// Use case for retrieving all posts with optional sorting.
///
/// This use case encapsulates the business logic for fetching all posts
/// from the repository with support for different sorting options.
class GetAllPostsUseCase extends UseCase<List<Post>, GetAllPostsParams> {

  /// Creates a [GetAllPostsUseCase] with the given [repository].
  GetAllPostsUseCase(this.repository);
  /// The repository to fetch posts from.
  final PostRepository repository;

  @override
  Future<Either<Failure, List<Post>>> call(GetAllPostsParams params) async {
    final result = await repository.getAllPosts();
    
    // Apply sorting to the result
    return result.fold(
      (failure) => Left(failure),
      (posts) {
        final sortedPosts = _sortPosts(posts, params.sortType);
        return Right(sortedPosts);
      },
    );
  }

  /// Sorts the list of posts based on the sort type
  /// 
  /// Parameters:
  /// - [posts]: List of posts to sort
  /// - [sortType]: Type of sorting to apply
  /// 
  /// Returns: Sorted list of posts
  List<Post> _sortPosts(List<Post> posts, PostSortType sortType) {
    final sortedPosts = List<Post>.from(posts);
    
    switch (sortType) {
      case PostSortType.idAscending:
        sortedPosts.sort((a, b) => a.id.compareTo(b.id));
        
      case PostSortType.idDescending:
        sortedPosts.sort((a, b) => b.id.compareTo(a.id));
        
      case PostSortType.titleAscending:
        sortedPosts.sort((a, b) => a.title.compareTo(b.title));
        
      case PostSortType.titleDescending:
        sortedPosts.sort((a, b) => b.title.compareTo(a.title));
        
      case PostSortType.userIdAscending:
        sortedPosts.sort((a, b) => a.userId.compareTo(b.userId));
        
      case PostSortType.userIdDescending:
        sortedPosts.sort((a, b) => b.userId.compareTo(a.userId));
    }
    
    return sortedPosts;
  }
}

/// Parameters for the [GetAllPostsUseCase].
/// 
/// Includes sorting options for retrieving and ordering posts.
class GetAllPostsParams extends Equatable {

  /// Creates [GetAllPostsParams] with optional sorting.
  /// 
  /// Parameters:
  /// - [sortType]: Type of sorting to apply (defaults to ID ascending)
  const GetAllPostsParams({
    this.sortType = PostSortType.idAscending,
  });
  
  /// The sorting type to apply when fetching posts
  final PostSortType sortType;

  @override
  List<Object?> get props => [sortType];
}
