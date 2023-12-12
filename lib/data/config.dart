import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';

class Config {
  static final dio =
      Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8080', headers: {
    'Access-Control-Allow-Origin': '*', // 允许来自任何域名的请求
  }));
  static const String requestJson = '/requestJson';
  static const String requestForm = '/requestForm';
  static const String requestGet = '/requestGet';
  static const String status = 'status';
  static const String succeedStatus = 'succeed';

  // 得满足16位
  static String secretKey = 'help' * 4;
  static final securityKey = encrypt.Key.fromUtf8(secretKey);
  static final securityIV = encrypt.IV.fromUtf8(secretKey);
  static final encrypter = encrypt.Encrypter(encrypt.AES(securityKey));

  static String encryptFunc(String plainText) {
    return encrypter.encrypt(plainText, iv: securityIV).base64;
  }

  static String decryptFunc(String secretText) {
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(secretText),
        iv: securityIV);
  }

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


/*
package main

import(
	"fmt"
)

func main(){
	var a,b int
	fmt.Scanf("%d %d",&a,&b)
	fmt.Println(a + b)
}

* */
