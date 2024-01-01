import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/constantData.dart';
import 'package:intl/intl.dart' as intl;

class UserSeekHelp {
  late String seekHelpId;
  late String uploadTime;
  late String language;
  late int score;
  late int like;
  late int status;

  UserSeekHelp();

  factory UserSeekHelp.fromJson(dynamic data) {
    UserSeekHelp userSeekHelp = UserSeekHelp();
    userSeekHelp.seekHelpId = data['ID'].toString();
    userSeekHelp.uploadTime = data['UploadTime'];
    userSeekHelp.language = data['Language'];
    userSeekHelp.score = data['Score'];
    userSeekHelp.like = data['Like'];
    userSeekHelp.status = data['Status'];
    return userSeekHelp;
  }
}

class UserLendHand {
  late String lendHandId;
  late String seekHelpId;
  late String uploadTime;
  late int like;
  late int status;

  UserLendHand();

  factory UserLendHand.fromJson(dynamic data) {
    UserLendHand userLendHand = UserLendHand();
    userLendHand.lendHandId = data['ID'].toString();
    userLendHand.seekHelpId = data['SeekHelpId'].toString();
    userLendHand.uploadTime = data['UploadTime'];
    userLendHand.like = data['Like'];
    userLendHand.status = data['Status'];
    return userLendHand;
  }
}

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
  List<UserSeekHelp> seekHelpList = [];
  List<UserLendHand> lendHandList = [];

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
      return UserSeekHelp.fromJson(tempList[index]);
    });
    tempList = data['lendHandList'];
    lendHandList = List.generate(tempList.length, (index) {
      return UserLendHand.fromJson(tempList[index]);
    });
  }
}
