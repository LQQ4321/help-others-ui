import 'package:flutter/material.dart';

class ConstantData {
  static const List<String> supportedLanguages = ['C', 'C++', 'Golang'];
  static const List<String> supportedLanguageFiles = ['c', 'cpp', 'go'];
  static const List<String> supportedPictureFiles = ['png', 'jpg', 'jpeg'];

  // 信息框内的颜色
  static List<Color> statusColors = [
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.redAccent[100]!
  ];
}
