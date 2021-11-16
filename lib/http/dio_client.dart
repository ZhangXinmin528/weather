import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retry/retry.dart';
import 'package:weather/http/interceptor/http_interceptor.dart';

class DioClient {
  late Dio _dio;

  final CancelToken cancelToken = CancelToken();

  final bool inProduct = bool.fromEnvironment("dart.vm.product");

  DioClient._internal() {
    final _baseOptions = BaseOptions();
    _baseOptions.connectTimeout = 30 * 1000;
    _baseOptions.receiveTimeout = 30 * 1000;
    _dio = Dio(_baseOptions);
    _dio.interceptors.add(HttpInterceptor());
    if (!inProduct) {
      _dio.interceptors.add(PrettyDioLogger());
    }
  }

  static final DioClient instance = DioClient._internal();

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final Response<T> response = await onRetry(
      () => _dio.get<T>(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress),
    );
    return response;
  }

  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = await onRetry(
      () => _dio.post<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress),
    );

    return response;
  }

  Future<Response> download(
    String urlPath,
    savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    data,
    Options? options,
  }) async {
    final Response response = await onRetry(
      () => _dio.download(urlPath, savePath,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          deleteOnError: deleteOnError,
          lengthHeader: lengthHeader,
          data: data,
          options: options),
    );

    return response;
  }

  Future<T> onRetry<T>(FutureOr<T> Function() fn) {
    return retry(fn,
        maxAttempts: 3,
        retryIf: (err) => err is DioError && !CancelToken.isCancel(err));
  }
}
