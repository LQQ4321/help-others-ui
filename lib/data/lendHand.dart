import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:help_them/data/macroLendHand.dart';

class LendHandModel {
  //当前浏览的lendHand和哪个seekHelp有关
  String curSeekHelpId = '';

  List<SingleLendHand> showLendHandList = [];

  void cleanCacheData() {
    curSeekHelpId = '';
    showLendHandList.clear();
  }

  Future<bool> changeBan(int rowId) async {
    Map request = {
      'requestType': 'changeBan',
      'info': [
        'lendHand',
        showLendHandList[rowId].lendHandId,
        showLendHandList[rowId].ban == 0 ? '1' : '0'
      ]
    };
    return await Config.dio
        .post(Config.requestJson, data: request)
        .then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      showLendHandList[rowId].ban = (showLendHandList[rowId].ban == 0 ? 1 : 0);
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

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
  Future<bool> requestLendHandList(bool isManager, String seekHelpId) async {
    // if (curSeekHelpId == seekHelpId) {
    //   return true;
    // }
    Map request = {
      'requestType': 'requestList',
      'info': ['lendHand', isManager.toString(), seekHelpId]
    };
    return await Config.dio
        .post(Config.requestJson, data: request)
        .then((value) {
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
  }
}
