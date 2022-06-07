class HttpResult<T> {
  int code = 0;
  String? message = "";
  T? data;

  HttpResult(this.code, this.message, this.data);

  factory HttpResult.fromJson(Map<String, dynamic> srcJson) {
    return HttpResult(
        srcJson["code"] as int, srcJson["message"] as String, srcJson["data"]);
  }
}
