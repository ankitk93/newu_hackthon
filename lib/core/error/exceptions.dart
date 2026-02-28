/// Base class for all exceptions in the app.
class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Thrown when there is no internet connectivity.
class NoInternetException extends AppException {
  const NoInternetException()
      : super(message: 'No internet connection');
}

/// Thrown when a server error occurs (5xx).
class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

/// Thrown when a request times out.
class TimeoutException extends AppException {
  const TimeoutException()
      : super(message: 'Request timed out');
}

/// Thrown when local cache operation fails.
class CacheException extends AppException {
  const CacheException({required super.message});
}
