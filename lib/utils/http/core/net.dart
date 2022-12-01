import 'package:flutter/foundation.dart';
import 'package:learn_flutter/utils/http/request/base_request.dart';

class Net {
  Net._();

  static Net? _instance;

  static Net? shared() {
    _instance ??= Net._();
    return _instance;
  }

  Future<dynamic> send(BaseRequest request) async {
    if (kDebugMode) {
      log("url: ${request.url()}");
      log("method: ${request.method()}");
      request.addHeader("token", "123");
      log("header: ${request.header}");
      return Future.value({
        "statusCode": 200,
        "data": {"code": 0, "message": "success"}
      });
    }
  }

  Future fire(BaseRequest request) async {
    var response = await send(request);
    var result = response["data"];
    log(result);
    return result;
  }

  void log(log) {
    if (kDebugMode) {
      print("net: ${log.toString()}");
    }
  }
}
