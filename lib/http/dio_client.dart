import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer2/dio_flutter_transformer2.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retry/retry.dart';
import 'package:weather/http/connection_provider.dart';
import 'package:weather/http/http_exception.dart';
import 'package:weather/http/interceptor/http_interceptor.dart';
import 'package:weather/utils/log_utils.dart';

class DioClient {
  late Dio _dio;

  final CancelToken cancelToken = CancelToken();

  final bool inProduct = bool.fromEnvironment("dart.vm.product");

  DioClient._internal() {
    final _baseOptions = BaseOptions();
    _baseOptions.connectTimeout = 30 * 1000;
    _baseOptions.receiveTimeout = 30 * 1000;
    _baseOptions.contentType = Headers.jsonContentType;
    _dio = Dio(_baseOptions);
    _dio.interceptors.add(HttpInterceptor());
    //json decoding will be background
    _dio.transformer = FlutterTransformer();

    if (!inProduct) {
      _dio.interceptors.add(
        PrettyDioLogger(
          request: false,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: true,
          error: false,
        ),
      );
    }
  }

  static final DioClient instance = DioClient._internal();

  final Function() _defaultStart = () {};

  _defaultError(HttpException exception) {
    LogUtil.e("DioClient..异常信息：" + exception.toString());
  }

  Future<Response?> get(
    String path, {
    Function()? onStart,
    Function(HttpException exception)? onError,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = onRetry(
        () => _dio.get(path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress),
        onStart: onStart ?? _defaultStart,
        onError: onError ?? _defaultError);

    return response;
  }

  Future<Response?> post(
    String path, {
    Function()? onStart,
    Function(HttpException exception)? onError,
    Map<String, dynamic>? queryParameters,
    data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = await onRetry(
        () => _dio.post(path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
        onStart: onStart ?? _defaultStart,
        onError: onError ?? _defaultError);

    return response;
  }

  Future<Response?> download(
    String urlPath,
    savePath, {
    Function()? onStart,
    Function(HttpException exception)? onError,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    data,
    Options? options,
  }) async {
    final Response? response = await onRetry(
        () => _dio.download(urlPath, savePath,
            onReceiveProgress: onReceiveProgress,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            deleteOnError: deleteOnError,
            lengthHeader: lengthHeader,
            data: data,
            options: options),
        onStart: onStart ?? _defaultStart,
        onError: onError ?? _defaultError);

    return response;
  }

  Future<T>? onRetry<T>(
    FutureOr<T> Function() fn, {
    required Function() onStart,
    required Function(HttpException exception) onError,
  }) {
    try {
      onStart();
      if (ConnectionProvider().isNetworkConnected()) {
        return retry(fn,
            maxAttempts: 3,
            retryIf: (err) =>
                err is DioError &&
                err.type != DioErrorType.other &&
                !CancelToken.isCancel(err));
      } else {
        onError(HttpException(HttpException.networkOffline, "网络未连接"));
      }
    } on DioError catch (error) {
      onError(error.error);
      return null;
    }
  }
}
