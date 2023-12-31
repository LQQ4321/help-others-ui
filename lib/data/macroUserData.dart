import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/constantData.dart';
import 'package:intl/intl.dart' as intl;

class StatusOfDay {
  int seekHelp = 0;
  int lendHand = 0;
  bool isBlank = true;
}

class Contributions {
  bool isRequest = false;
  int curYear = 0;
  late int registerYear;
  late int nowYear;
  late int startId;
  late int endId;

  //这里可以优化，可以等到需要的时候再初始化
  List<StatusOfDay> contributionTable =
      List.generate(7 * 54, (index) => StatusOfDay());
  List<List<int>> seekHelpTimeList = [];
  List<List<int>> lendHandTimeList = [];

  Future<bool> getContributions(String userId, {String? registerTime}) async {
    if (registerTime != null) {
      registerYear = int.parse(registerTime.split('-')[0]);
      nowYear = int.parse(intl.DateFormat('yyyy').format(DateTime.now()));
    }
    if (isRequest) {
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
      isRequest = true;
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
    newYear += registerYear;
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
    for (int i = 0; i < seekHelpTimeList.length; i++) {
      if (curYear.toString() !=
          intl.DateFormat('yyyy').format(DateTime(seekHelpTimeList[i][0]))) {
        continue;
      }
      int offsetDay = DateTime(seekHelpTimeList[i][0], seekHelpTimeList[i][1],
              seekHelpTimeList[i][2])
          .difference(DateTime(curYear))
          .inDays;
      contributionTable[offsetDay + startId].seekHelp++;
    }
    for (int i = 0; i < lendHandTimeList.length; i++) {
      if (curYear.toString() !=
          intl.DateFormat('yyyy').format(DateTime(lendHandTimeList[i][0]))) {
        continue;
      }
      int offsetDay = DateTime(lendHandTimeList[i][0], lendHandTimeList[i][1],
              lendHandTimeList[i][2])
          .difference(DateTime(curYear))
          .inDays;
      contributionTable[offsetDay + startId].lendHand++;
    }
  }

  void _fromJson(dynamic data) {
    List<dynamic> tempList = data['seekHelpTimeList'];
    seekHelpTimeList = List.generate(tempList.length, (index) {
      String uploadTime = tempList[index];
      List<String> dateList = uploadTime.split(' ')[0].split('-');
      return List.generate(
          dateList.length, (index) => int.parse(dateList[index]));
    });
    tempList = data['lendHandTimeList'];
    lendHandTimeList = List.generate(tempList.length, (index) {
      String uploadTime = tempList[index];
      List<String> dateList = uploadTime.split(' ')[0].split('-');
      return List.generate(
          dateList.length, (index) => int.parse(dateList[index]));
    });
  }
}
