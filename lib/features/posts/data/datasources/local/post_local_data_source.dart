import 'package:hive_flutter/hive_flutter.dart';
import 'package:post_app/core/constants/app_constants.dart';
import 'package:post_app/core/error/exceptions.dart';
import 'package:post_app/features/posts/data/models/post_model.dart';

/// Abstract interface for local post data operations.
///
/// Defines the contract for local storage operations (Hive).
abstract class PostLocalDataSource {
  /// Retrieves all posts from local storage.
  ///
  /// Returns a list of PostModels from the cache.
  /// Throws [CacheException] if operation fails.
  Future<List<PostModel>> getAllPosts();

  /// Retrieves a single post by ID from local storage.
  ///
  /// Throws [CacheException] if the post is not found or operation fails.
  Future<PostModel> getPostById(int id);

  /// Saves a post to local storage.
  ///
  /// Creates or updates the post in cache.
  /// Throws [CacheException] if operation fails.
  Future<void> savePost(PostModel post);

  /// Saves multiple posts to local storage.
  ///
  /// Replaces all cached posts with the given list.
  /// Useful for caching entire lists from remote sources.
  /// Throws [CacheException] if operation fails.
  Future<void> savePosts(List<PostModel> posts);

  /// Deletes a post from local storage by ID.
  ///
  /// Throws [CacheException] if operation fails.
  Future<void> deletePost(int id);

  /// Clears all posts from local storage.
  ///
  /// Useful for cache invalidation.
  /// Throws [CacheException] if operation fails.
  Future<void> clearAllPosts();

  /// Gets the timestamp of the last cache update.
  ///
  /// Returns null if cache has never been populated.
  Future<DateTime?> getLastUpdateTime();

  /// Sets the timestamp of the last cache update.
  ///
  /// Used to implement cache expiration strategy.
  Future<void> setLastUpdateTime(DateTime dateTime);
}

/// Implementation of [PostLocalDataSource] using Hive.
class PostLocalDataSourceImpl implements PostLocalDataSource {
  /// Reference to the Hive box for posts.
  late final Box<Map> _postsBox;

  /// Reference to the Hive box for cache metadata.
  late final Box<dynamic> _metadataBox;

  /// Creates a [PostLocalDataSourceImpl].
  ///
  /// Must call [initialize] before using this instance.
  PostLocalDataSourceImpl();

  /// Initializes the Hive boxes.
  ///
  /// Must be called before any other methods.
  /// Opens or creates the necessary Hive boxes.
  Future<void> initialize() async {
    try {
      _postsBox = await Hive.openBox<Map>(LocalStorageConstants.postsBoxName);
      _metadataBox =
          await Hive.openBox(LocalStorageConstants.cacheMetadataBoxName);
    } catch (e) {
      throw CacheException('Failed to initialize Hive boxes: $e');
    }
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      final postMaps = _postsBox.values.toList();
      return postMaps
          .map((map) => PostModel.fromJson(Map<String, dynamic>.from(map)))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get all posts from cache: $e');
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final postMap = _postsBox.get(id.toString());
      if (postMap == null) {
        throw CacheException('Post with id $id not found in cache');
      }
      return PostModel.fromJson(Map<String, dynamic>.from(postMap));
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get post $id from cache: $e');
    }
  }

  @override
  Future<void> savePost(PostModel post) async {
    try {
      await _postsBox.put(post.id.toString(), post.toJson());
    } catch (e) {
      throw CacheException('Failed to save post ${post.id} to cache: $e');
    }
  }

  @override
  Future<void> savePosts(List<PostModel> posts) async {
    try {
      final Map<String, Map<String, dynamic>> postMap = {};
      for (final post in posts) {
        postMap[post.id.toString()] = post.toJson();
      }
      await _postsBox.putAll(postMap);
    } catch (e) {
      throw CacheException('Failed to save posts to cache: $e');
    }
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      await _postsBox.delete(id.toString());
    } catch (e) {
      throw CacheException('Failed to delete post $id from cache: $e');
    }
  }

  @override
  Future<void> clearAllPosts() async {
    try {
      await _postsBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear posts cache: $e');
    }
  }

  @override
  Future<DateTime?> getLastUpdateTime() async {
    try {
      final timestamp = _metadataBox.get(CacheKeys.lastUpdated);
      return timestamp != null ? DateTime.parse(timestamp as String) : null;
    } catch (e) {
      throw CacheException('Failed to get last update time: $e');
    }
  }

  @override
  Future<void> setLastUpdateTime(DateTime dateTime) async {
    try {
      await _metadataBox.put(CacheKeys.lastUpdated, dateTime.toIso8601String());
    } catch (e) {
      throw CacheException('Failed to set last update time: $e');
    }
  }

  /// Checks if cache is still valid based on expiration time.
  ///
  /// Returns true if cache is valid, false if expired.
  Future<bool> isCacheValid() async {
    try {
      final lastUpdate = await getLastUpdateTime();
      if (lastUpdate == null) return false;

      final now = DateTime.now();
      final expirationDuration =
          Duration(hours: LocalStorageConstants.cacheExpirationHours);
      return now.difference(lastUpdate) < expirationDuration;
    } catch (e) {
      return false;
    }
  }

  /// Closes all Hive boxes.
  ///
  /// Should be called when the app shuts down.
  Future<void> close() async {
    await _postsBox.close();
    await _metadataBox.close();
  }
}
