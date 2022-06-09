import 'package:dio/dio.dart';

class HttpException implements Exception {
  static final int defaultErrorCode = -1;
  static final int networkOffline = -2;
  final int code;
  final String message;

  HttpException(this.code, this.message);

  @override
  String toString() {
    return 'HttpException{_code: $code,_message: $message}';
  }

  factory HttpException.generate(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return HttpException(defaultErrorCode, "网络连接超时");
      case DioErrorType.receiveTimeout:
        return HttpException(defaultErrorCode, "网络响应超时");
      case DioErrorType.sendTimeout:
        return HttpException(defaultErrorCode, "网络请求超时");
      case DioErrorType.cancel:
        return HttpException(defaultErrorCode, "网络请求取消");
      case DioErrorType.other:
        return HttpException(defaultErrorCode, "其他错误：${error.message}");
      case DioErrorType.response:
        {
          final response = error.response;
          final statusCode = response?.statusCode;
          switch (statusCode) {
            case 400:
              return HttpException(statusCode!, "Bad Request：请求参数有误~");
            case 401:
              return HttpException(statusCode!, "Unauthorized：当前请求需要用户验证~");
            case 403:
              return HttpException(statusCode!, "Forbidden：服务器拒绝执行该请求~");
            case 404:
              return HttpException(
                  statusCode!, "Not Found：请求失败，请求所希望得到的资源未被在服务器上发现~");
            case 405:
              return HttpException(
                  statusCode!, "Method Not Allowed：请求行中指定的请求方法不能被用于请求相应的资源~");
            case 500:
              return HttpException(
                  statusCode!, "Internal Server Error：服务器遇到了一个未曾预料的状况~");
            case 502:
              return HttpException(statusCode!, "Bad Gateway：网管或者代理服务器无法收到响应~");
            case 503:
              return HttpException(statusCode!, "Service Unavailable：服务器正在维护~");
            case 505:
              return HttpException(statusCode!,
                  "HTTP Version Not Supported：服务器不支持，或者拒绝支持在请求中使用的HTTP 版本~");
            default:
              return HttpException(
                  statusCode!, "异常信息：${response?.statusMessage}");
          }
        }
      default:
        return HttpException(defaultErrorCode, "异常信息：${error.message}");
    }
  }
}
