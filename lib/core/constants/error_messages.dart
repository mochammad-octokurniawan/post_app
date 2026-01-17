/// User-friendly error messages for different failure types.
library;

class ErrorMessages {
  /// Error message for network connectivity issues
  static const String networkError = 'No internet connection. Please check your network and try again.';

  /// Error message for server errors
  static const String serverError = 'Server error. Please try again later.';

  /// Error message for cache errors
  static const String cacheError = 'Failed to load cached data. Please try again.';

  /// Error message for validation errors
  static const String validationError = 'Invalid input. Please check your data and try again.';

  /// Error message for post not found
  static const String postNotFound = 'Post not found.';

  /// Error message for post creation failure
  static const String createPostError = 'Failed to create post. Please try again.';

  /// Error message for post update failure
  static const String updatePostError = 'Failed to update post. Please try again.';

  /// Error message for post deletion failure
  static const String deletePostError = 'Failed to delete post. Please try again.';

  /// Error message for unexpected errors
  static const String unexpectedError = 'An unexpected error occurred. Please try again.';

  /// Error message for empty title
  static const String emptyTitle = 'Post title cannot be empty.';

  /// Error message for empty body
  static const String emptyBody = 'Post body cannot be empty.';

  /// Error message for title too long
  static const String titleTooLong = 'Post title must be less than 100 characters.';

  /// Error message for body too long
  static const String bodyTooLong = 'Post body must be less than 5000 characters.';

  /// Error message when refreshing data fails
  static const String refreshError = 'Failed to refresh posts. Please try again.';

  /// Error message for loading posts
  static const String loadPostsError = 'Failed to load posts. Please try again.';

  /// Success message for post creation
  static const String createPostSuccess = 'Post created successfully.';

  /// Success message for post update
  static const String updatePostSuccess = 'Post updated successfully.';

  /// Success message for post deletion
  static const String deletePostSuccess = 'Post deleted successfully.';
}
