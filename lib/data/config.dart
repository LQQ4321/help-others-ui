import 'package:dio/dio.dart';

class Config {
  static final dio = Dio();
  static const String requestJson = '/requestJson';
  static const String requestFrom = '/requestFrom';
  static const String status = 'status';
  static const String succeedStatus = 'succeed';
  static const String securityKey = 'help others';
}

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // if(RootDataModel.name == null){
    //   debugPrint('name is null');
    //   return;
    // }
    return;
    handler.next(options);
  }
}
