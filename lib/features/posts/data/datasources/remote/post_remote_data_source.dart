import 'package:dio/dio.dart';
import 'package:post_app/core/constants/app_constants.dart';
import 'package:post_app/core/error/exceptions.dart';
import 'package:post_app/features/posts/data/models/post_model.dart';

/// Abstract interface for remote post data operations.
///
/// Defines the contract for remote API operations.
abstract class PostRemoteDataSource {
  /// Retrieves all posts from the remote API.
  ///
  /// Returns a list of PostModels from the server.
  /// Throws [ServerException] if the request fails.
  Future<List<PostModel>> getAllPosts();

  /// Retrieves a single post by ID from the remote API.
  ///
  /// Throws [ServerException] if the request fails or post is not found.
  Future<PostModel> getPostById(int id);

  /// Creates a new post on the remote API.
  ///
  /// Parameters:
  ///   - title: Post title
  ///   - body: Post content
  ///   - userId: User ID of the creator
  ///
  /// Returns the created PostModel with assigned ID from server.
  /// Throws [ServerException] if the request fails.
  Future<PostModel> createPost({
    required String title,
    required String body,
    required int userId,
  });

  /// Updates an existing post on the remote API.
  ///
  /// Parameters:
  ///   - id: ID of the post to update
  ///   - title: New title
  ///   - body: New content
  ///
  /// Returns the updated PostModel.
  /// Throws [ServerException] if the request fails.
  Future<PostModel> updatePost({
    required int id,
    required String title,
    required String body,
  });

  /// Deletes a post from the remote API.
  ///
  /// Throws [ServerException] if the request fails.
  Future<void> deletePost(int id);
}

/// Implementation of [PostRemoteDataSource] using Dio.
class PostRemoteDataSourceImpl implements PostRemoteDataSource {

  /// Creates a [PostRemoteDataSourceImpl] with the given Dio instance.
  PostRemoteDataSourceImpl(this._dio);
  /// The Dio HTTP client instance.
  final Dio _dio;

  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}',
        options: Options(
          sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeoutMs),
          receiveTimeout:
              const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        return jsonList
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to get posts: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}/$id',
        options: Options(
          sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeoutMs),
          receiveTimeout:
              const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        ),
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw ServerException('Post not found', statusCode: 404);
      } else {
        throw ServerException(
          'Failed to get post: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<PostModel> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}',
        data: {
          'title': title,
          'body': body,
          'userId': userId,
        },
        options: Options(
          sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeoutMs),
          receiveTimeout:
              const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PostModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          'Failed to create post: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<PostModel> updatePost({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}/$id',
        data: {
          'title': title,
          'body': body,
          'id': id,
        },
        options: Options(
          sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeoutMs),
          receiveTimeout:
              const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        ),
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw ServerException('Post not found', statusCode: 404);
      } else {
        throw ServerException(
          'Failed to update post: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      final response = await _dio.delete(
        '${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}/$id',
        options: Options(
          sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeoutMs),
          receiveTimeout:
              const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw ServerException('Post not found', statusCode: 404);
      } else {
        throw ServerException(
          'Failed to delete post: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Handles Dio exceptions and converts them to application exceptions.
  AppException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Network timeout: ${e.message}');
      case DioExceptionType.connectionError:
        return NetworkException('Network error: ${e.message}');
      case DioExceptionType.badResponse:
        return ServerException(
          'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      default:
        return NetworkException('Request failed: ${e.message}');
    }
  }
}
