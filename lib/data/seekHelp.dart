import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/functions/functionOne.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SingleSeekHelp {
  late String seekHelpId; //求组id
  late String seekHelperId; //求助人id
  late String seekHelperName; //求组人姓名
  // late String problemLink; //题目链接
  // late String topicRemark; //题目文字描述或备注
  late String uploadTime; //该求助上传的时间
  late String language; //语言类型
  // late int maxHelp; //最多可以发布多少个帮助
  // late int maxCommit; //最多发布多少评论
  late int score; //悬赏的分值
  late int like; //点赞数
  // late int ban; //求助的权限
  late int status; //求助的状态

  SingleSeekHelp();

  factory SingleSeekHelp.fromJson(dynamic data) {
    SingleSeekHelp singleSeekHelp = SingleSeekHelp();
    singleSeekHelp.seekHelpId = data['ID'].toString();
    singleSeekHelp.seekHelperId = data['SeekHelperId'];
    singleSeekHelp.seekHelperName = data['SeekHelperName'];
    // singleSeekHelp.problemLink = data['ProblemLink'];
    // singleSeekHelp.topicRemark = data['TopicRemark'];
    singleSeekHelp.uploadTime = data['UploadTime'];
    singleSeekHelp.language = data['Language'];
    // singleSeekHelp.maxHelp = data['MaxHelp'];
    // singleSeekHelp.maxCommit = data['MaxComment'];
    singleSeekHelp.score = data['Score'];
    singleSeekHelp.like = data['Like'];
    // singleSeekHelp.ban = data['Ban'];
    singleSeekHelp.status = data['Status'];
    return singleSeekHelp;
  }

  @override
  String toString() {
    return '$seekHelpId $uploadTime $language $score $like $status';
  }
}

class SeekHelpModel {
  // 只保存一天的数据，以免数据更新不同步
  // 真正的列表
  List<SingleSeekHelp> seekHelpList = [];

  // 展示的列表
  List<SingleSeekHelp> showSeekHelpList = [];

  //当前正在浏览的seekHelp
  SingleSeekHelp singleSeekHelp = SingleSeekHelp();

  //当前正在浏览的是哪个seekHelp的详细信息
  // int curSeekHelpIndex = -1;

  // 当前正在浏览的日期
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int filterStatus = 0; //All Unsolved Resolved
  int filterScore = 0; //High Low
  int filterLike = 0; //High low
  int filterTime = 0; //Late Early
  int filterLanguage = 0; //All C C++ Golang
  int filterOrder = 0; //score like time

  // 为了新添加的seekHelp能够显示在列表的第一个，
  // 但是这样子就会导致筛选条件和筛选结果不匹配，因为MyPopupMenu没有依赖外部状态
  void resetFilterRule() {
    filterOrder = 2;
    filterTime = 0;
    filterLanguage = 0;
    filterStatus = 0;
  }

  // 根据筛选条件过滤
  void filterFromRule({int order = -1, int filterRule = 0}) {
    //需要手动删除吗?
    showSeekHelpList.clear();
    showSeekHelpList = [...seekHelpList];
    if (order == 0) {
      filterStatus = filterRule;
    } else if (order == 4) {
      filterLanguage = filterRule;
    }
    showSeekHelpList.removeWhere((element) {
      if (filterStatus != 0 && element.status + 1 != filterStatus) {
        return true;
      }
      if (filterLanguage != 0 &&
          element.language != FunctionOne.switchLanguage(filterLanguage)) {
        return true;
      }
      return false;
    });
    if (order > 0 && order < 4) {
      filterOrder = order - 1;
      if (filterOrder == 0) {
        filterScore = filterRule;
      } else if (filterOrder == 1) {
        filterLike = filterRule;
      } else if (filterOrder == 2) {
        filterTime = filterRule;
      }
    }
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

  Future<bool> requestSeekHelpList({String? newDate}) async {
    //请求成功以后才应该改变当前currentDate
    String requestDate = newDate ?? currentDate;
    Map request = {
      'requestType': 'requestList',
      'info': ['seekHelp', requestDate]
    };
    bool flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['seekHelpList'];
      seekHelpList = List.generate(tempList.length, (index) {
        return SingleSeekHelp.fromJson(tempList[index]);
      });
      currentDate = requestDate;
      resetFilterRule();
      filterFromRule();
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
    return flag;
  }

  // 0 成功 1 失败(网络或者服务器的问题) 2 code is null 3 remark is empty 4 image is null
  // 5 money reward >= 100 | 6  < 0 | 7  > own score | 8 is not number
  //texts = [problem link,money reward,remark,image type,code type,userId]
  Future<int> seekAHelp(List<String> texts, int userScore,
      List<int>? codeContent, List<int>? imageContent) async {
    if (imageContent == null) {
      return 4;
    } else if (codeContent == null) {
      return 2;
    } else if (texts[2].isEmpty) {
      return 3;
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
    } else if (moneyReward <= 0) {
      return 6;
    } else if (moneyReward > 10) {
      return 7;
    }
    FormData formData = FormData.fromMap({
      'requestType': 'seekAHelp',
      'problemLink': texts[0],
      'remark': texts[2],
      'score': moneyReward.toString(),
      'imageType': texts[3],
      'codeType': texts[4],
      'userId': texts[5],
      'uploadTime': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())
    });
    //TODO 好像还真得有文件名
    formData.files.add(MapEntry('file1',
        MultipartFile.fromBytes(codeContent, filename: 'origin.${texts[4]}')));
    formData.files.add(MapEntry('file2',
        MultipartFile.fromBytes(imageContent, filename: 'image.${texts[3]}')));
    int flag =
        await Config.dio.post(Config.requestForm, data: formData).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return 1;
      }
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 1;
    });
    //如果请求成功，并且当前浏览列表的日期就是当天，那么就向数据申请更新后的数据，而不是本地更新(容易出错)
    if (flag == 0 &&
        currentDate == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      flag = (await requestSeekHelpList()) ? 0 : 1;
    }
    return flag;
  }
}
