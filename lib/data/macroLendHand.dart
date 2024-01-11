import 'dart:convert';
import 'dart:typed_data';
import 'package:help_them/data/config.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SingleLendHand {
  late String lendHandId; //帮助id
  late String seekHelpId; //对应的求助id
  late String lendHanderId;
  late String lendHanderName;
  late String uploadTime; //发布时间
  // late String remark; //附带的解释信息
  late int like; //点赞数
  late int ban; //权限
  late int status; //状态

  SingleLendHand();

  factory SingleLendHand.fromJson(dynamic data) {
    SingleLendHand singleLendHand = SingleLendHand();
    singleLendHand.lendHandId = data['ID'].toString();
    singleLendHand.seekHelpId = data['SeekHelpId'].toString();
    singleLendHand.lendHanderId = data['LendHanderId'];
    singleLendHand.lendHanderName = data['LendHanderName'];
    singleLendHand.uploadTime = data['UploadTime'];
    // singleLendHand.remark = data['Remark'];
    singleLendHand.like = data['Like'];
    singleLendHand.ban = data['Ban'];
    singleLendHand.status = data['Status'];
    return singleLendHand;
  }

  @override
  String toString() {
    return '$lendHandId $seekHelpId $uploadTime $like $status';
  }
}

class SingleRowCodeInfo {
  late int originIndex;
  late int copyIndex;
  late int status; //0 ' ' 1 '-' 2 '+'
  late String text;

  SingleRowCodeInfo();

  factory SingleRowCodeInfo.fromString(
      int originIndex, int copyIndex, String singleText) {
    SingleRowCodeInfo singleRowCodeInfo = SingleRowCodeInfo();
    singleRowCodeInfo.originIndex = originIndex;
    singleRowCodeInfo.copyIndex = copyIndex;
    if (singleText[0] == ' ') {
      singleRowCodeInfo.status = 0;
      singleRowCodeInfo.originIndex = originIndex + 1;
      singleRowCodeInfo.copyIndex = copyIndex + 1;
    } else if (singleText[0] == '-') {
      singleRowCodeInfo.status = 1;
      singleRowCodeInfo.originIndex = originIndex + 1;
    } else {
      singleRowCodeInfo.status = 2;
      singleRowCodeInfo.copyIndex = copyIndex + 1;
    }
    singleRowCodeInfo.text = singleText.substring(1);
    return singleRowCodeInfo;
  }
}

// 展示信息的网络请求流程，点击某位用户的名字按钮，
//  通过seekHelpId开始第一次请求，获取到lendHand的列表信息，
// 下面的方法是每次点击按钮后的通式
// 1. 通过已有信息去获取相关文件的地址信息
// 2. 通过前一次请求得到的文件地址信息，去请求文件
class ShowInfo {
  // (应该请求数据成功才改变它)
  int curRightShowPage = -1; //-1 求助 >0 帮助
  // 0 seekHelpCode 正常一行一行展示 1 lendHandCode 正常一行一行展示
  // 2 seekHelpCode 和 lendHandCode 一起展示，
  // 3 seekHelpCode 和 lendHandCode 分开展示，(暂时不实现，有点难度)
  int codeShowStatus = 0;
  List<SingleRowCodeInfo> rowCodes = [];

  //seekHelper 和 lendHander 共有的一些东西
  // late String codePath; //代码文件的地址
  List<String> codeContent = []; //代码文件 origin.txt diff.txt (按行读取也许不错)
  String remark = ''; //备注信息

  // late int ban;
//seekHelper私有
  String problemLink = ''; //题目链接
  ImageProvider imageProvider = MemoryImage(kTransparentImage);

//lendHander私有

  void cleanCacheData() {
    curRightShowPage = -1;
    codeShowStatus = 0;
    rowCodes.clear();
    codeContent.clear();
    remark = '';
    problemLink = '';
  }

  //对代码进行处理
  void switchCodeShowStatus(int codeShowStatus) {
    this.codeShowStatus = codeShowStatus;
  }

  void parseRawCodeContent() {
    //FIXME 暂时代码的组件是不是报错的原因：是不是有界面的渲染正需要这些数据，所以不可以删除(给需要数据的地方拷贝一份过去)
    rowCodes.clear();
    //spj 可能会出现原代码和修改代码一样的情况，此时的diff.txt是一个空文件,应该特殊处理
    for (int i = 3, originIndex = 0, copyIndex = 0;
        i < codeContent.length;
        i++) {
      //正常来说第一个条件是肯定满足的，这里只是为了以防万一
      if (codeContent[i].isNotEmpty && codeContent[i][0] == r'\') {
        continue;
      }
      rowCodes.add(
          SingleRowCodeInfo.fromString(originIndex, copyIndex, codeContent[i]));
      originIndex = rowCodes.last.originIndex;
      copyIndex = rowCodes.last.copyIndex;
    }
  }

  //获取要展示的数据 _curRightShowPage == -2 需要请求图片 > -1 不需要请求图片
  Future<bool> requestShowData(int _curRightShowPage, String dbId) async {
    //  每次跳入lendHand页面后，showInfo.curRightShowPage的都应该设置为 < -1的值，表示还没有请求成功
    if (curRightShowPage == _curRightShowPage) {
      return true;
    }
    //一阶段，获取文件地址
    Map request = {
      'requestType': 'requestShowDataOne',
      'info': [_curRightShowPage < 0 ? 'seekHelp' : 'lendHand', dbId]
    };
    String? codePath;
    String? imagePath;
    bool flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      codePath = value.data['codePath'];
      remark = value.data['remark'];
      if (_curRightShowPage < 0) {
        problemLink = value.data['problemLink'];
        imagePath = value.data['imagePath'];
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    //二阶段，根据之前得到的文件地址去获取真正的文件,这里是获取code文件,image直接通过前端获取
    List<Future<bool>> funcList = [];
    if (flag && codePath != null) {
      funcList.add(getCodeFile(codePath!));
    }
    if (flag && imagePath != null && _curRightShowPage < -1) {
      funcList.add(getImageFile(imagePath!));
    }
    await Future.wait(funcList).then((value) {
      flag = !value.contains(false);
    });
    if (flag) {
      curRightShowPage = _curRightShowPage <= -1 ? -1 : _curRightShowPage;
      codeShowStatus = _curRightShowPage <= -1 ? 0 : 2;
      if (_curRightShowPage >= 0) {
        parseRawCodeContent();
      }
    }
    return flag;
  }

  Future<bool> getCodeFile(String codePath) async {
    Map request = {
      'requestType': 'downloadFile',
      'info': [codePath]
    };
    return await Config.dio
        .post(Config.requestJson,
            data: request, options: Options(responseType: ResponseType.plain))
        .then((value) {
      if (value.statusCode != 200) {
        return false;
      }
      codeContent = const LineSplitter().convert(value.data.toString());
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<bool> getImageFile(String imagePath) async {
    Map request = {
      'requestType': 'downloadFile',
      'info': [imagePath]
    };
    return await Config.dio
        .post(Config.requestJson,
            data: request, options: Options(responseType: ResponseType.bytes))
        .then((value) {
      if (value.statusCode != 200) {
        return false;
      }
      final imageData = value.data as List<int>;
      imageProvider = MemoryImage(Uint8List.fromList(imageData));
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
