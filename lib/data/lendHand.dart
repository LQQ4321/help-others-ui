import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:dio/dio.dart';

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

// 展示信息的网络请求流程，点击某位用户的名字按钮，
//  通过seekHelpId开始第一次请求，获取到lendHand的列表信息，
// 下面的方法是每次点击按钮后的通式
// 1. 通过已有信息去获取相关文件的地址信息
// 2. 通过前一次请求得到的文件地址信息，去请求文件
class ShowInfo {
  //应该请求数据成功才改变它
  int curRightShowPage = -1; //-1 求助 >0 帮助
  //seekHelper 和 lendHander 共有的一些东西
  // late String codePath; //代码文件的地址
  late List<String> codeContent; //代码文件 origin.txt diff.txt (按行读取也许不错)
  late String remark; //备注信息

  // late int ban;
//seekHelper私有
  late String problemLink; //题目链接
  String? imagePath; //图片的地址
//lendHander私有

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
    bool flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      codePath = value.data['codePath'];
      remark = value.data['remark'];
      if (_curRightShowPage < 0) {
        problemLink = value.data['ProblemLink'];
        imagePath = value.data['ImagePath'];
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    //二阶段，根据之前得到的文件地址去获取真正的文件,这里是获取code文件,image直接通过前端获取
    if (flag && codePath != null) {
      flag = await Config.dio
          .get(Config.requestGet,
              options: Options(
                  headers: {'filePath': codePath},
                  responseType: ResponseType.plain))
          .then((value) {
        debugPrint(value.data);
        if (value.statusCode != 200) {
          return false;
        }
        codeContent = value.data.toString().split(r'\n');
        debugPrint("${codeContent.length} lines");
        return true;
      });
    }
    if (flag) {
      curRightShowPage = _curRightShowPage < -1 ? -1 : _curRightShowPage;
    }
    return flag;
  }
}

class LendHandModel extends ChangeNotifier {
  String curSeekHelpId = '';

  //key 是SeekHelpId
  Map<String, List<SingleLendHand>> lendHandMap = {};

  List<SingleLendHand> showLendHandList = [];
  ShowInfo showInfo = ShowInfo();

  //请求LendHand的基本数据，具体的文件信息在本次请求中还没有获取
  Future<bool> requestLendHandList(String seekHelpId) async {
    if (lendHandMap.containsKey(seekHelpId)) {
      showLendHandList.clear();
      showLendHandList = [...lendHandMap[seekHelpId]!];
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
      lendHandMap[seekHelpId] = List.generate(tempList.length, (index) {
        return SingleLendHand.fromJson(tempList[index]);
      });
      lendHandMap[seekHelpId]!.sort((a, b) {
        return b.like - a.like;
      });
      //FIXME dart需要手动清理吗，应该有gc吧，还是说clear可以标记一下用不到的数据，方便gc回收
      showLendHandList.clear();
      showLendHandList = [...lendHandMap[seekHelpId]!];
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
    } else {
      lendHandMap.remove(seekHelpId);
    }
    return flag;
  }
}
