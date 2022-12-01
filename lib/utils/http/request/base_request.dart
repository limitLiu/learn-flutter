import 'package:flutter/foundation.dart';

enum Method {
  get,
  post,
  delete,
}

abstract class BaseRequest {
  dynamic api;
  bool isHttps = true;

  bool hasAuth();

  Map<String, String> params = {};
  Map<String, String> header = {};

  String authority() {
    return "api.devio.org";
  }

  Method method();

  String path();

  String url() {
    Uri uri;
    var str = path();
    if (api != null) {
      str = "${path()}$api";
    }
    if (isHttps) {
      uri = Uri.https(authority(), str, params);
    } else {
      uri = Uri.http(authority(), str, params);
    }
    if (kDebugMode) {
      print("url: ${uri.toString()}");
    }
    return uri.toString();
  }

  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
