import 'package:dio/dio.dart';
import 'package:newu_health/core/utils/app_logger.dart';

/// Interceptor that retries failed requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

      if (retryCount < maxRetries) {
        final delay = initialDelay * (retryCount + 1); // Linear backoff
        AppLogger.warning(
          'RetryInterceptor',
          'Retrying request (${retryCount + 1}/$maxRetries) after ${delay.inSeconds}s: ${err.requestOptions.path}',
        );

        await Future<void>.delayed(delay);

        err.requestOptions.extra['retryCount'] = retryCount + 1;

        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
    }

    AppLogger.error(
      'RetryInterceptor',
      'Request failed after $maxRetries retries: ${err.requestOptions.path}',
      err,
    );
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
