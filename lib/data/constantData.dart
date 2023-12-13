import 'package:flutter/material.dart';

class ConstantData {
  static const List<TextStyle> textStyle = [
    TextStyle(
        fontSize: 15,
        color: Color(0xff0a3069),
        letterSpacing: 1,
        fontWeight: FontWeight.w500),
    TextStyle(color: Colors.grey, fontSize: 13)
  ];

  static const List<Color> codeShowColors = [
    Color(0xffffebe9),
    Color(0xffe6ffec),
    Color(0xffddf4ff),
    Color(0xffffd7d5),
    Color(0xffccffd8),
    Color(0xffbbdfff),
    Color(0xfff6f8fa)
  ];

  static const List<IconData> showRouteTopBarIcons = [
    Icons.copy,
    Icons.image,
    Icons.topic,
    Icons.favorite,
    Icons.message
  ];

  static const List<List<String>> seekAHelpPromptMessage = [
    ['Release success', 'Your help has been posted.'],
    [
      'Publishing failure',
      'This could be due to network problems or server errors.'
    ],
    ['Lack of data', 'Please upload a code file that you want to debug.'],
    [
      'Lack of data',
      'Please enter some remarks to facilitate the aid provider to debug.'
    ],
    [
      'Lack of data',
      'Please upload a screenshot of the problem for assistance.'
    ],
    ['Money reward error', 'The money reward should be less than 100.'],
    ['Money reward error', 'The money reward should be greater than zero.'],
    ['Money reward error', 'The money reward is beyond your reach.'],
    ['Money reward error', 'The money reward is not an integer.']
  ];

  static const List<List<String>> seekHelpOptionList = [
    ['All', 'Unsolved', 'Resolved'],
    ['High score', 'Low score'],
    ['High like', 'Low like'],
    ['Late', 'Early'],
    ['All', 'C', 'C++', 'Golang']
  ];
  static const List<int> seekHelpProportion = [1, 1, 1, 1, 1];
  static const List<int> seekHelpManagerProportion = [2, 2, 2, 2, 2, 1, 1, 1];

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
