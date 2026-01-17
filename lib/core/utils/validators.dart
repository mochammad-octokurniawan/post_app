import 'package:post_app/core/constants/error_messages.dart';
import 'package:post_app/core/error/exceptions.dart';

/// Utility class for input validation across the application.
class Validators {
  /// Maximum length for post title
  static const int maxTitleLength = 100;

  /// Maximum length for post body
  static const int maxBodyLength = 5000;

  /// Minimum length for post title
  static const int minTitleLength = 1;

  /// Validates a post title.
  ///
  /// Throws [ValidationException] if validation fails.
  /// - Title cannot be empty
  /// - Title cannot exceed [maxTitleLength] characters
  static String validatePostTitle(String title) {
    if (title.trim().isEmpty) {
      throw ValidationException(ErrorMessages.emptyTitle);
    }

    if (title.length > maxTitleLength) {
      throw ValidationException(ErrorMessages.titleTooLong);
    }

    return title.trim();
  }

  /// Validates a post body.
  ///
  /// Throws [ValidationException] if validation fails.
  /// - Body cannot be empty
  /// - Body cannot exceed [maxBodyLength] characters
  static String validatePostBody(String body) {
    if (body.trim().isEmpty) {
      throw ValidationException(ErrorMessages.emptyBody);
    }

    if (body.length > maxBodyLength) {
      throw ValidationException(ErrorMessages.bodyTooLong);
    }

    return body.trim();
  }

  /// Validates a post ID.
  ///
  /// Throws [ValidationException] if validation fails.
  /// - ID must be greater than 0
  static int validatePostId(int id) {
    if (id <= 0) {
      throw ValidationException('Post ID must be greater than 0');
    }

    return id;
  }

  /// Validates a user ID.
  ///
  /// Throws [ValidationException] if validation fails.
  /// - ID must be greater than 0
  static int validateUserId(int id) {
    if (id <= 0) {
      throw ValidationException('User ID must be greater than 0');
    }

    return id;
  }

  /// Checks if a string is a valid email format.
  ///
  /// Returns true if valid, false otherwise.
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Checks if a string is not empty after trimming.
  ///
  /// Returns true if not empty, false otherwise.
  static bool isNotEmpty(String value) => value.trim().isNotEmpty;

  /// Checks if a number is positive.
  ///
  /// Returns true if positive, false otherwise.
  static bool isPositive(num value) => value > 0;

  /// Checks if a value is within a range.
  ///
  /// Returns true if [value] is >= [min] and <= [max].
  static bool isInRange(num value, num min, num max) => value >= min && value <= max;
}
