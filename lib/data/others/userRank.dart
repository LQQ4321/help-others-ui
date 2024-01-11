import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';

class UserRankItem {
  late String userId;
  int rankId = 1;
  late String name;
  late int seekHelpNum;
  late int lendHandNum;
  late int score;
  late String registerTime;

  UserRankItem();

  factory UserRankItem.fromJson(dynamic data) {
    UserRankItem userRankItem = UserRankItem();
    userRankItem.userId = data['ID'].toString();
    userRankItem.name = data['Name'];
    userRankItem.seekHelpNum = data['SeekHelp'].toString().split('#').length;
    userRankItem.lendHandNum = data['LendHand'].toString().split('#').length;
    userRankItem.score = data['Score'];
    userRankItem.registerTime = data['RegisterTime'];
    return userRankItem;
  }

  int compare(UserRankItem b) {
    return b.score - score;
  }
}

class UserRank extends ChangeNotifier {
  List<UserRankItem> userRankList = [];

  Future<bool> requestUserRank() async {
    Map request = {'requestType': 'requestUserRank'};
    return await Config.dio
        .post(Config.requestJson, data: request)
        .then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['users'];
      userRankList = List.generate(tempList.length, (index) {
        return UserRankItem.fromJson(tempList[index]);
      });
      userRankList.sort((a, b) => a.compare(b));
      for (int i = 1; i < userRankList.length; i++) {
        if (userRankList[i].score == userRankList[i - 1].score) {
          userRankList[i].rankId = userRankList[i - 1].rankId;
        } else {
          userRankList[i].rankId = userRankList[i - 1].rankId + 1;
        }
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
