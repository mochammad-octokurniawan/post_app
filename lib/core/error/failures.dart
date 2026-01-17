import 'package:equatable/equatable.dart';

/// Base failure class for all application failures.
///
/// Failures are used instead of throwing exceptions to represent
/// error conditions in a functional programming style.
abstract class Failure extends Equatable {
  /// The error message describing the failure.
  final String message;

  /// Creates a [Failure] with the given [message].
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure representing a server-side error.
class ServerFailure extends Failure {
  /// The HTTP status code, if available.
  final int? statusCode;

  /// Creates a [ServerFailure] with the given [message] and optional [statusCode].
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure representing a cache operation error.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure] with the given [message].
  const CacheFailure(super.message);
}

/// Failure representing a validation error.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure] with the given [message].
  const ValidationFailure(super.message);
}

/// Failure representing a network connectivity error.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure] with the given [message].
  const NetworkFailure(super.message);
}

/// Failure representing an unexpected or unknown error.
class UnexpectedFailure extends Failure {
  /// Creates an [UnexpectedFailure] with the given [message].
  const UnexpectedFailure(super.message);
}
