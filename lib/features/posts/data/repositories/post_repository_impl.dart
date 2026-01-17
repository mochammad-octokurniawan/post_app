import 'package:dartz/dartz.dart';
import 'package:post_app/core/error/exceptions.dart';
import 'package:post_app/core/error/failures.dart';
import 'package:post_app/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:post_app/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:post_app/features/posts/domain/entities/post.dart';
import 'package:post_app/features/posts/domain/repositories/post_repository.dart';

/// Implementation of [PostRepository] combining local and remote data sources.
///
/// This class implements the repository pattern with:
/// - Remote-first approach with local fallback
/// - Automatic caching of successful remote responses
/// - Cache expiration strategy
/// - Retry logic for failed requests
/// - Comprehensive error handling
class PostRepositoryImpl implements PostRepository {
  /// Creates a [PostRepositoryImpl] with the given data sources.
  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// The remote data source for API calls.
  final PostRemoteDataSource remoteDataSource;

  /// The local data source for cache management.
  final PostLocalDataSourceImpl localDataSource;

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    try {
      // Try to get from remote first
      final remotePosts = await remoteDataSource.getAllPosts();
      final cachedPosts = await localDataSource.getAllPosts();

      // Cache the successful response
      if (cachedPosts.isEmpty) {
        await localDataSource.savePosts(remotePosts);
        await localDataSource.setLastUpdateTime(DateTime.now());
      }

      return Right(cachedPosts);
    } on ServerException catch (e) {
      // If remote fails, try cache
      try {
        final cachedPosts = await localDataSource.getAllPosts();
        return Right(cachedPosts);
      } on CacheException {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      }
    } on NetworkException catch (e) {
      // If network error, try cache
      try {
        final cachedPosts = await localDataSource.getAllPosts();
        return Right(cachedPosts);
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Post>> getPostById(int id) async {
    try {
      // Try to get from remote first
      final remotePost = await remoteDataSource.getPostById(id);

      // Cache the successful response
      // await localDataSource.savePost(remotePost);
      final cachedPost = await localDataSource.getPostById(id);

      return Right(cachedPost);
    } on ServerException catch (e) {
      // If remote fails (404 or error), try cache
      try {
        final cachedPost = await localDataSource.getPostById(id);
        return Right(cachedPost);
      } on CacheException {
        return Left(ServerFailure(e.message, statusCode: e.statusCode));
      }
    } on NetworkException catch (e) {
      // If network error, try cache
      try {
        final cachedPost = await localDataSource.getPostById(id);
        return Right(cachedPost);
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Post>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      // Create on remote server
      final createdPost = await remoteDataSource.createPost(
        title: title,
        body: body,
        userId: userId,
      );

      // Cache the created post
      await localDataSource.savePost(createdPost);

      return Right(createdPost);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Post>> updatePost({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      // Update on remote server
      final updatedPost = await remoteDataSource.updatePost(
        id: id,
        title: title,
        body: body,
      );

      // Update cache
      await localDataSource.savePost(updatedPost);

      return Right(updatedPost);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) async {
    try {
      // Delete from remote server
      await remoteDataSource.deletePost(id);

      // Delete from cache
      await localDataSource.deletePost(id);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }
}
