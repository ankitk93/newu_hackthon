import 'package:dio/dio.dart';
import 'package:newu_health/core/utils/app_logger.dart';

/// Interceptor that logs request and response details for debugging.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(
      'HTTP',
      '→ ${options.method} ${options.baseUrl}${options.path}',
    );
    return handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      'HTTP',
      '← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}',
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'HTTP',
      '✗ ${err.response?.statusCode ?? 'unknown'} ${err.requestOptions.method} ${err.requestOptions.path}',
      err.message,
    );
    return handler.next(err);
  }
}
