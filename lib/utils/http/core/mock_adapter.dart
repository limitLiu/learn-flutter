import 'package:learn_flutter/utils/http/core/net_adapter.dart';
import 'package:learn_flutter/utils/http/request/base_request.dart';

class MockAdapter extends NetAdapter {
  @override
  Future<NetResponse<T>> send<T>(BaseRequest request) {
    return Future<NetResponse<T>>.delayed(const Duration(milliseconds: 3000),
        () {
      return NetResponse(
        request: request,
          data: {
            "code": 0,
            "message": "success",
          } as T,
          statusCode: 401);
    });
  }
}
