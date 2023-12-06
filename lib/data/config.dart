import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Config {
  static final dio =
      Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8080', headers: {
    'Access-Control-Allow-Origin': '*', // 允许来自任何域名的请求
  }));
  static const String requestJson = '/requestJson';
  static const String requestForm = '/requestForm';
  static const String status = 'status';
  static const String succeedStatus = 'succeed';
  static const String securityKey = 'help others';

  //根据给定的后缀，选择一个文件
  static Future<FilePickerResult?> selectAFile(List<String> fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: fileType,
      allowMultiple: false,
      withData: true,
    );
    return result;
  }
}

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // if(RootDataModel.name == null){
    //   debugPrint('name is null');
    //   return;
    // }
    // return;
    handler.next(options);
  }
}
