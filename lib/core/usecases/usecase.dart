import 'package:dartz/dartz.dart';
import 'package:post_app/core/error/failures.dart';

/// Base class for all use cases in the application.
///
/// Use cases encapsulate business logic and should return [Either<Failure, Type>]
/// to handle errors in a functional programming style.
///
/// Type parameters:
/// - [Type] is the success return type
/// - [Params] is the parameter type, use [NoParams] if the use case takes no parameters
abstract class UseCase<Type, Params> {
  /// Executes the use case with the given parameters.
  ///
  /// Returns an [Either] containing either a [Failure] or the success [Type].
  Future<Either<Failure, Type>> call(Params params);
}

/// Represents no parameters for a use case.
///
/// Use this class when a use case doesn't require any input parameters.
class NoParams {
  /// Creates a [NoParams] instance.
  const NoParams();
}
