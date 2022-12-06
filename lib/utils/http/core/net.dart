import 'package:flutter/foundation.dart';
import 'package:learn_flutter/utils/http/core/error.dart';
import 'package:learn_flutter/utils/http/core/mock_adapter.dart';
import 'package:learn_flutter/utils/http/core/net_adapter.dart';
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
      var adapter = MockAdapter();
      return adapter.send(request);
    }
  }

  Future fire(BaseRequest request) async {
    NetResponse? response;
    dynamic error;
    try {
      response = await send(request);
    } on NetError catch (e) {
      error = e;
      response = e.data;
      log(e.message);
    } catch (e) {
      error = e;
      log(e);
    }
    if (response == null) {
      log(error);
    }
    var result = response?.data;
    log(result);
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw NetError(status ?? -1, result.toString(), data: result);
    }
  }

  void log(log) {
    if (kDebugMode) {
      print("net: ${log.toString()}");
    }
  }
}
