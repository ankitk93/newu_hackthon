/// Base class for all failures in the app.
/// Each data layer should map exceptions to specific Failure types.
abstract class Failure {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Network related failures.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// No internet connection.
class NoConnectionFailure extends Failure {
  const NoConnectionFailure()
      : super(message: 'No internet connection. Please check your network.');
}

/// Server returned an error (5xx).
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Request timeout.
class TimeoutFailure extends Failure {
  const TimeoutFailure()
      : super(message: 'Request timed out. Please try again.');
}

/// Local DB failures.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Unknown / unexpected failure.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({String? message})
      : super(message: message ?? 'An unexpected error occurred.');
}
