/// Application-wide constants.
library;

/// API configuration constants
class ApiConstants {
  /// Base URL for the API
  static const String baseUrl = 'https://www.jsonplaceholder.typicode.com';

  /// Posts endpoint
  static const String postsEndpoint = '/posts';

  /// Connection timeout duration in milliseconds
  static const int connectTimeoutMs = 30000;

  /// Receive timeout duration in milliseconds
  static const int receiveTimeoutMs = 30000;

  /// Send timeout duration in milliseconds
  static const int sendTimeoutMs = 30000;

  /// Maximum retries for failed requests
  static const int maxRetries = 3;

  /// Initial retry delay in milliseconds
  static const int initialRetryDelayMs = 500;
}

/// Local storage constants
class LocalStorageConstants {
  /// Hive database name for posts
  static const String postsBoxName = 'posts_box';

  /// Hive database name for cache metadata
  static const String cacheMetadataBoxName = 'cache_metadata_box';

  /// Cache expiration time in hours
  static const int cacheExpirationHours = 24;
}

/// UI constants
class UiConstants {
  /// Default page size for pagination
  static const int defaultPageSize = 20;

  /// Animation duration in milliseconds
  static const int animationDurationMs = 300;

  /// Debounce duration for search in milliseconds
  static const int searchDebounceMs = 500;
}

/// String constants for cache keys
class CacheKeys {
  /// Cache key for posts list
  static const String postsList = 'posts_list';

  /// Cache key prefix for individual post details
  static const String postDetail = 'post_detail_';

  /// Cache key for last updated timestamp
  static const String lastUpdated = 'last_updated';
}
