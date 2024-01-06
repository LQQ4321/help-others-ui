import 'dart:math';

import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/macroLendHand.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:help_them/functions/functionOne.dart';
import 'package:intl/intl.dart' as intl;

class StatusOfDay {
  int seekHelp = 0;
  int lendHand = 0;
  bool isBlank = true;
}

class Contributions {
  int curYear = 0;
  int registerYear = -1;
  late int nowYear;
  late int startId;
  late int endId;
  late int contributionsOfYear;

  //这里可以优化，可以等到需要的时候再初始化
  List<StatusOfDay> contributionTable = [];
  List<SingleSeekHelp> seekHelpList = [];
  List<SingleLendHand> lendHandList = [];
  List<SingleSeekHelp> seekHelpList2 = [];

  //不弄展示列表了，等到需要的时候再生成，不需要的时候就销毁
  //seek help
  int seekHelpFilterStatus = 0;
  int seekHelpFilterLanguage = 0;
  bool seekHelpFilterScore = false;
  bool seekHelpFilterLike = false;
  bool seekHelpFilterDate = false;
  int seekHelpMainFilter = 1; //1 score 2 like 3 date

  //lend hand
  int lendHandFilterStatus = 0;
  int lendHandFilterLanguage = 0;
  bool lendHandFilterScore = false;
  bool lendHandFilterLike = false;
  bool lendHandFilterDate = false;
  int lendHandMainFilter = 1; //1 score 1 like 2 date

  void cleanCacheData() {
    curYear = 0;
    registerYear = -1;
    contributionTable.clear();
    seekHelpList.clear();
    lendHandList.clear();
    seekHelpList2.clear();
    seekHelpFilterStatus = 0;
    seekHelpFilterLanguage = 0;
    seekHelpFilterScore = false;
    seekHelpFilterLike = false;
    seekHelpFilterDate = false;
    seekHelpMainFilter = 1;
    lendHandFilterStatus = 0;
    lendHandFilterLanguage = 0;
    lendHandFilterScore = false;
    lendHandFilterLike = false;
    lendHandFilterDate = false;
    lendHandMainFilter = 1;
  }

  bool seekHelpIsHigh(int option) {
    if (option == 1) {
      return seekHelpFilterScore;
    } else if (option == 2) {
      return seekHelpFilterLike;
    }
    return seekHelpFilterDate;
  }

  void setSeekHelpFilterRule(int option, int value) {
    if (option == 0) {
      seekHelpFilterStatus = value;
    } else if (option == 1) {
      seekHelpMainFilter = 1;
      seekHelpFilterScore = !seekHelpFilterScore;
    } else if (option == 2) {
      seekHelpMainFilter = 2;
      seekHelpFilterLike = !seekHelpFilterLike;
    } else if (option == 3) {
      seekHelpMainFilter = 3;
      seekHelpFilterDate = !seekHelpFilterDate;
    } else {
      seekHelpFilterLanguage = value;
    }
  }

  List<SingleSeekHelp> seekHelpFilter() {
    List<SingleSeekHelp> tempList = [];
    for (int i = 0; i < seekHelpList.length; i++) {
      if (seekHelpFilterStatus != 0 &&
          seekHelpList[i].status + 1 != seekHelpFilterStatus) {
        continue;
      }
      //FIXME 是语言的问题导致状态筛选出现问题的
      if (seekHelpFilterLanguage != 0 &&
          seekHelpList[i].language !=
              FunctionOne.switchLanguage(seekHelpFilterLanguage)) {
        continue;
      }
      tempList.add(seekHelpList[i]);
    }
    if (seekHelpMainFilter == 1) {
      tempList
          .sort((a, b) => (a.score - b.score) * (seekHelpFilterScore ? -1 : 1));
    } else if (seekHelpMainFilter == 2) {
      tempList
          .sort((a, b) => (a.like - b.like) * (seekHelpFilterLike ? -1 : 1));
    } else {
      tempList.sort((a, b) =>
          (DateTime.parse(a.uploadTime)
                  .difference(DateTime.parse(b.uploadTime)))
              .inSeconds *
          (seekHelpFilterDate ? -1 : 1));
    }
    return tempList;
  }

  bool lendHandIsHigh(int option) {
    if (option == 1) {
      return lendHandFilterScore;
    } else if (option == 2) {
      return lendHandFilterLike;
    }
    return lendHandFilterDate;
  }

  void setLendHandFilterRule(int option, int value) {
    option -= 1;
    if (option == 0) {
      lendHandFilterStatus = value;
    } else if (option == 1) {
      lendHandFilterScore = !lendHandFilterScore;
    } else if (option == 2) {
      lendHandFilterLike = !lendHandFilterLike;
    } else if (option == 3) {
      lendHandFilterDate = !lendHandFilterDate;
    } else {
      lendHandFilterLanguage = value;
    }
  }

  List<dynamic> lendHandFilter() {
    List<SingleLendHand> tempList = [];
    List<SingleSeekHelp> tempList2 = [];
    for (int i = 0; i < lendHandList.length; i++) {
      if (lendHandFilterStatus != 0 &&
          lendHandFilterStatus != lendHandList[i].status + 1) {
        continue;
      }
      //这里依赖一个默认的事实，lendHandList和seekHelpList2是一一对应的
      if (lendHandFilterLanguage != 0 &&
          seekHelpList2[i].language !=
              FunctionOne.switchLanguage(lendHandFilterLanguage)) {
        continue;
      }
      tempList.add(lendHandList[i]);
    }
    if (lendHandMainFilter == 1) {
      tempList.sort((a, b) {
        int aScore = 0;
        int bScore = 0;
        for (int i = 0; i < seekHelpList2.length; i++) {
          if (seekHelpList2[i].seekHelpId == a.seekHelpId) {
            aScore = seekHelpList2[i].score;
          }
          if (seekHelpList2[i].seekHelpId == b.seekHelpId) {
            bScore = seekHelpList2[i].score;
          }
        }
        return (aScore - bScore) * (lendHandFilterScore ? -1 : 1);
      });
    } else if (lendHandMainFilter == 2) {
      tempList
          .sort((a, b) => (a.like - b.like) * (lendHandFilterLike ? -1 : 1));
    } else {
      tempList.sort((a, b) =>
          (DateTime.parse(a.uploadTime)
                  .difference(DateTime.parse(b.uploadTime)))
              .inSeconds *
          (seekHelpFilterDate ? -1 : 1));
    }
    for (int i = 0; i < tempList.length; i++) {
      for (int j = 0; j < seekHelpList2.length; j++) {
        if (seekHelpList2[j].seekHelpId == tempList[i].seekHelpId) {
          tempList2.add(seekHelpList2[j]);
          break;
        }
      }
    }
    List<dynamic> result = [];
    result.add(tempList);
    result.add(tempList2);
    return result;
  }

  //这个函数应该只调用一次
  Future<bool> getContributions(String userId, String registerTime) async {
    if (registerYear == -1) {
      registerYear = int.parse(registerTime.split('-')[0]);
      nowYear = int.parse(intl.DateFormat('yyyy').format(DateTime.now()));
      //等到需要的时候再分配
      contributionTable = List.generate(7 * 54, (index) => StatusOfDay());
    } else {
      return true;
    }
    Map request = {
      'requestType': 'getContributions',
      'info': [userId]
    };
    return Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      _fromJson(value.data);
      parseContributions(nowYear - registerYear);
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  String getTooltip(int givenDayOfYear) {
    DateTime giveDate =
        DateTime(curYear).add(Duration(days: givenDayOfYear - startId));
    String tooltip = '';
    if (contributionTable[givenDayOfYear].seekHelp == 0 &&
        contributionTable[givenDayOfYear].lendHand == 0) {
      tooltip = 'No contributions on';
    } else if (contributionTable[givenDayOfYear].seekHelp == 0) {
      tooltip = 'Lend hand : ${contributionTable[givenDayOfYear].lendHand} on';
    } else if (contributionTable[givenDayOfYear].lendHand == 0) {
      tooltip = 'Seek help : ${contributionTable[givenDayOfYear].seekHelp} on';
    } else {
      tooltip =
          'Lend hand : ${contributionTable[givenDayOfYear].lendHand},seek help : ${contributionTable[givenDayOfYear].seekHelp} on';
    }
    return '$tooltip ${ConstantData.monthName[giveDate.month - 1]} ${giveDate.day}th.';
  }

  void parseContributions(int newYear) {
    contributionsOfYear = 0;
    newYear += registerYear;
    newYear = nowYear - newYear;
    if (curYear == newYear) {
      return;
    }
    curYear = newYear;
    //重置每个格子的状态为空
    for (int i = 0; i < contributionTable.length; i++) {
      contributionTable[i].isBlank = true;
    }
    //计算一月一日是星期几，从而知道前面有几个空格子
    final String dayOfWeek = intl.DateFormat('EEEE').format(DateTime(curYear));
    startId = 0;
    for (int i = 0; i < ConstantData.dayOfWeek.length; i++) {
      if (ConstantData.dayOfWeek[i] == dayOfWeek) {
        startId = i;
        break;
      }
    }
    // [startId,endId]，左闭右闭区间
    endId = startId;
    if (curYear.toString() != intl.DateFormat('yyyy').format(DateTime.now())) {
      //  浏览的年份是今年的年份
      endId +=
          DateTime(curYear + 1, 1, 1).difference(DateTime(curYear)).inDays - 1;
    } else {
      endId += DateTime.now().difference(DateTime(curYear)).inDays;
    }
    //  初始化[startId,endId]区间为有数据
    for (int i = startId; i <= endId; i++) {
      contributionTable[i].seekHelp = 0;
      contributionTable[i].lendHand = 0;
      contributionTable[i].isBlank = false;
    }
    for (int i = 0; i < seekHelpList.length; i++) {
      List<String> date = seekHelpList[i].uploadTime.split(' ')[0].split('-');
      final List<int> numDate =
          List.generate(date.length, (index) => int.parse(date[index]));
      if (curYear.toString() !=
          intl.DateFormat('yyyy').format(DateTime(numDate[0]))) {
        continue;
      }
      int offsetDay = DateTime(numDate[0], numDate[1], numDate[2])
          .difference(DateTime(curYear))
          .inDays;
      contributionTable[offsetDay + startId].seekHelp++;
      contributionsOfYear++;
    }
    for (int i = 0; i < lendHandList.length; i++) {
      List<String> date = seekHelpList[i].uploadTime.split(' ')[0].split('-');
      final List<int> numDate =
          List.generate(date.length, (index) => int.parse(date[index]));
      if (curYear.toString() !=
          intl.DateFormat('yyyy').format(DateTime(numDate[0]))) {
        continue;
      }
      int offsetDay = DateTime(numDate[0], numDate[1], numDate[2])
          .difference(DateTime(curYear))
          .inDays;
      contributionTable[offsetDay + startId].lendHand++;
      contributionsOfYear++;
    }
  }

  void _fromJson(dynamic data) {
    List<dynamic> tempList = data['seekHelpList'];
    seekHelpList = List.generate(tempList.length, (index) {
      return SingleSeekHelp.fromJson(tempList[index]);
    });
    tempList = data['seekHelpList2'];
    seekHelpList2 = List.generate(tempList.length, (index) {
      return SingleSeekHelp.fromJson(tempList[index]);
    });

    tempList = data['lendHandList'];
    lendHandList = List.generate(tempList.length, (index) {
      return SingleLendHand.fromJson(tempList[index]);
    });
  }
}
