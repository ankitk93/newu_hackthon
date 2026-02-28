import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:newu_health/core/utils/app_logger.dart';

/// Interceptor that checks internet connectivity before making a request.
/// Throws a [DioException] with type [DioExceptionType.connectionError]
/// if no connectivity is detected.
class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      AppLogger.warning('ConnectivityInterceptor', 'No internet connection');
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet connection. Please check your network settings.',
        ),
      );
    }

    return handler.next(options);
  }
}
