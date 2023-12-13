import 'dart:convert';
import 'dart:typed_data';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SingleLendHand {
  late String lendHandId; //帮助id
  late String seekHelpId; //对应的求助id
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
    singleLendHand.uploadTime = data['UploadTime'];
    // singleLendHand.remark = data['Remark'];
    singleLendHand.like = data['Like'];
    singleLendHand.ban = data['Ban'];
    singleLendHand.status = data['Status'];
    return singleLendHand;
  }

  @override
  String toString() {
    return '$lendHandId $seekHelpId $uploadTime $like $ban $status';
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
  late List<String> codeContent; //代码文件 origin.txt diff.txt (按行读取也许不错)
  late String remark; //备注信息

  // late int ban;
//seekHelper私有
  late String problemLink; //题目链接
  ImageProvider imageProvider = MemoryImage(kTransparentImage);

//lendHander私有

  //对代码进行处理
  void switchCodeShowStatus(int codeShowStatus) {
    if (this.codeShowStatus == codeShowStatus) {
      return;
    }
    this.codeShowStatus = codeShowStatus;
  }

  void parseRawCodeContent() {
    rowCodes.clear();
    for (int i = 0, originIndex = 0, copyIndex = 0;
        i < codeContent.sublist(3).length;
        i++) {
      if (i != 0) {
        originIndex = rowCodes[i - 1].originIndex;
        copyIndex = rowCodes[i - 1].copyIndex;
      }
      rowCodes.add(SingleRowCodeInfo.fromString(
          originIndex, copyIndex, codeContent[i + 3]));
    }
  }

  //获取要展示的数据
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
    if (flag && imagePath != null) {
      funcList.add(getImageFile(imagePath!));
    }
    await Future.wait(funcList).then((value) {
      flag = !value.contains(false);
    });
    if (flag) {
      curRightShowPage = _curRightShowPage < -1 ? -1 : _curRightShowPage;
      codeShowStatus = _curRightShowPage <= -1 ? 0 : 2;
      parseRawCodeContent();
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

class LendHandModel extends ChangeNotifier {
  String curSeekHelpId = '';

  List<SingleLendHand> showLendHandList = [];
  ShowInfo showInfo = ShowInfo();

  //0 成功 1 失败 2 codeContent is null 3 remark is empty
  //texts [remark,code type,date,userId]
  Future<int> lendAHand(List<String> texts, List<int>? codeContent) async {
    if (texts[0].isEmpty) {
      return 3;
    }
    if (codeContent == null) {
      return 2;
    }
    FormData formData = FormData.fromMap({
      'requestType': 'lendAHand',
      'remark': texts[0],
      'codeType': texts[1],
      'seekHelpId': curSeekHelpId,
      'date': texts[2],
      'userId': texts[3],
      'uploadTime': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
    });
    formData.files.add(MapEntry('file1',
        MultipartFile.fromBytes(codeContent, filename: 'copy.${texts[1]}')));
    debugPrint(formData.fields.toString());
    int flag =
        await Config.dio.post(Config.requestForm, data: formData).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return 1;
      }
      showLendHandList
          .add(SingleLendHand.fromJson(value.data['singleLendHand']));
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 1;
    });
    return flag;
  }

  //请求LendHand的基本数据，具体的文件信息在本次请求中还没有获取
  Future<bool> requestLendHandList(String seekHelpId) async {
    if (curSeekHelpId == seekHelpId) {
      return true;
    }
    Map request = {
      'requestType': 'requestList',
      'info': ['lendHand', seekHelpId]
    };
    bool flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['lendHandList'];
      showLendHandList = List.generate(tempList.length, (index) {
        return SingleLendHand.fromJson(tempList[index]);
      });
      showLendHandList.sort((a, b) {
        return b.like - a.like;
      });
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    if (flag) {
      flag = await showInfo.requestShowData(-2, seekHelpId);
    }
    if (flag) {
      curSeekHelpId = seekHelpId;
    }
    return flag;
  }
}
