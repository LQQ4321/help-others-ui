import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/seekHelp.dart';

class FunctionOne {
  //判断是否具有某种权限
  // static bool judgeBan(int option,int ban,{int userBan = 0}) {
  //
  // }

  static dynamic switchLanguage(dynamic option) {
    if (option is int) {
      return ConstantData.supportedLanguages[option - 1];
    } else {
      for (int i = 0; i < ConstantData.supportedLanguages.length; i++) {
        if (ConstantData.supportedLanguages[i] == option) {
          return i + 1;
        }
      }
      return 0;
    }
  }

  static String parseSeekHelpListData(int option, SingleSeekHelp data) {
    if (option == 0) {
      return data.status == 0 ? 'Unsolved' : 'Resolved';
    } else if (option == 1) {
      return data.score.toString();
    } else if (option == 2) {
      return data.like.toString();
    } else if (option == 3) {
      return data.uploadTime.split(' ')[1];
    }
    return data.language;
  }
}
