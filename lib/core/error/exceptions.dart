/// Custom exceptions for the application.

/// Base exception class for all application exceptions.
class AppException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// Creates an [AppException] with the given [message].
  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when a server-side error occurs.
class ServerException extends AppException {
  /// The HTTP status code, if available.
  final int? statusCode;

  /// Creates a [ServerException] with the given [message] and optional [statusCode].
  ServerException(super.message, {this.statusCode});
}

/// Exception thrown when a cache operation fails.
class CacheException extends AppException {
  /// Creates a [CacheException] with the given [message].
  CacheException(super.message);
}

/// Exception thrown when validation of input data fails.
class ValidationException extends AppException {
  /// Creates a [ValidationException] with the given [message].
  ValidationException(super.message);
}

/// Exception thrown when a network connectivity issue occurs.
class NetworkException extends AppException {
  /// Creates a [NetworkException] with the given [message].
  NetworkException(super.message);
}
