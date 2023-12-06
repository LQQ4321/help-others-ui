import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/functions/functionOne.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SingleSeekHelp {
  late String seekHelpId; //求组id
  late String problemLink; //题目链接
  late String topicRemark; //题目文字描述或备注
  late String uploadTime; //该求助上传的时间
  late String language; //语言类型
  late int maxHelp; //最多可以发布多少个帮助
  late int maxCommit; //最多发布多少评论
  late int score; //悬赏的分值
  late int like; //点赞数
  late int ban; //求助的权限
  late int status; //求助的状态

  SingleSeekHelp();

  factory SingleSeekHelp.fromJson(dynamic data) {
    SingleSeekHelp singleSeekHelp = SingleSeekHelp();
    singleSeekHelp.seekHelpId = data['ID'].toString();
    singleSeekHelp.problemLink = data['ProblemLink'];
    singleSeekHelp.topicRemark = data['TopicRemark'];
    singleSeekHelp.uploadTime = data['UploadTime'];
    singleSeekHelp.language = data['Language'];
    singleSeekHelp.maxHelp = data['MaxHelp'];
    singleSeekHelp.maxCommit = data['MaxComment'];
    singleSeekHelp.score = data['Score'];
    singleSeekHelp.like = data['Like'];
    singleSeekHelp.ban = data['Ban'];
    singleSeekHelp.status = data['Status'];
    return singleSeekHelp;
  }

  @override
  String toString() {
    return '$seekHelpId $problemLink $topicRemark $uploadTime $language $maxHelp $maxCommit $score $like $ban $status';
  }
}

class SeekHelpModel extends ChangeNotifier {
  // key 是日期，value是当天的求助列表。
  // 之前访问过的日期的求助列表数据，可以暂存在这个map里面，
  // 但是为了防止内存溢出，这里最多可以暂存5天的求助列表数据，
  // 当超过暂存上限的时候，就应该随便删除一天的求助数据，但不是当前正在浏览的日期
  Map<String, List<SingleSeekHelp>> seekHelpMap = {};

  // 展示的列表
  List<SingleSeekHelp> showSeekHelpList = [];

  // 当前正在浏览的日期
  String currentDate = '';
  int filterStatus = 0; //All Unsolved Resolved
  int filterScore = 0; //High Low
  int filterLike = 0; //High low
  int filterTime = 0; //Early Late
  int filterLanguage = 0; //All C C++ Golang
  int filterOrder = 0; //score like time

  void filterFromRule({int order = -1}) {
    showSeekHelpList.clear();
    for (int i = 0; i < seekHelpMap[currentDate]!.length; i++) {
      if (filterStatus != 0 &&
          seekHelpMap[currentDate]![i].status + 1 != filterStatus) {
        continue;
      }
      if (filterLanguage != 0 &&
          seekHelpMap[currentDate]![i].language !=
              FunctionOne.switchLanguage(filterLanguage)) {
        continue;
      }
      showSeekHelpList.add(seekHelpMap[currentDate]![i]);
    }
    if (order != -1) {
      filterOrder = order;
      if (filterOrder == 0) {
        showSeekHelpList.sort((a, b) {
          return (a.score - b.score) * (filterScore == 0 ? -1 : 1);
        });
      } else if (filterOrder == 1) {
        showSeekHelpList.sort((a, b) {
          return (a.like - b.like) * (filterLike == 0 ? -1 : 1);
        });
      } else if (filterOrder == 2) {
        showSeekHelpList.sort((a, b) {
          return (DateTime.parse(a.uploadTime)
                  .difference(DateTime.parse(b.uploadTime))
                  .inSeconds) *
              (filterTime == 0 ? -1 : 1);
        });
      }
    }
    notifyListeners();
  }

  Future<bool> requestSeekHelpList({String? newDate}) async {
    if (newDate != null) {
      currentDate = newDate;
    }
    //判断内存中是否包含准备要请求的日期数据
    if (seekHelpMap.containsKey(currentDate)) {
      showSeekHelpList = seekHelpMap[currentDate]!;
      filterFromRule();
      return true;
    }
    Map request = {
      'requestType': 'requestList',
      'info': ['seekHelp', currentDate]
    };
    bool flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      debugPrint(value.data.toString());
      List<dynamic> tempList = value.data['seekHelpList'];
      seekHelpMap[currentDate] = List.generate(tempList.length, (index) {
        return SingleSeekHelp.fromJson(tempList[index]);
      });
      showSeekHelpList = seekHelpMap[currentDate]!;
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    filterFromRule();
    debugPrint(showSeekHelpList.toString());
    return flag;
  }

  // 0 成功 1 失败(网络或者服务器的问题) 2 image is null 3 code is null 4 remark is empty
  // 5 money reward >= 100 | 6  < 0 | 7  > own score | 8 is not number
  //texts = [problem link,money reward,remark,image type,code type,name]
  Future<int> seekAHelp(List<String> texts, List<int>? codeContent,
      List<int>? imageContent) async {
    if (imageContent == null) {
      return 2;
    } else if (codeContent == null) {
      return 3;
    } else if (texts[2].isEmpty) {
      return 4;
    }
    int moneyReward = 0;
    try {
      moneyReward = int.parse(texts[1]);
    } catch (e) {
      debugPrint(e.toString());
      return 8;
    }
    //FIXME 这里的10应该修改为用户的总score
    if (moneyReward >= 100) {
      return 5;
    } else if (moneyReward < 0) {
      return 6;
    } else if (moneyReward > 10) {
      return 7;
    }
    FormData formData = FormData.fromMap({
      'requestType': 'seekAHelp',
      //这里好像有坑，好像下面的key，在后端看到好像是files[]
      'files': [
        MultipartFile.fromBytes(codeContent),
        MultipartFile.fromBytes(imageContent)
      ],
      'problemLink': texts[0],
      'remark': texts[2],
      'score': moneyReward.toString(),
      'imageType': texts[3],
      'codeType': texts[4],
      'language':texts[5],
      'userId': texts[6],
      'date': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
    });
    int flag =
        await Config.dio.post(Config.requestForm, data: formData).then((value) {
      return value.data[Config.status] == Config.succeedStatus ? 0 : 1;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 1;
    });
    return flag;
  }
}
