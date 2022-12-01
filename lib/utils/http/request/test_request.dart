import 'base_request.dart';

class TestRequest extends BaseRequest {
  @override
  bool hasAuth() {
    return false;
  }

  @override
  Method method() {
    return Method.get;
  }

  @override
  String path() {
    return "/uapi/test/test";
  }
}
