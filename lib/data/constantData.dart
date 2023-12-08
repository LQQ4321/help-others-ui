import 'package:flutter/material.dart';

class ConstantData {
  static const List<List<String>> seekAHelpPromptMessage = [
    ['Release success', 'Your help has been posted.'],
    [
      'Publishing failure',
      'This could be due to network problems or server errors.'
    ],
    [
      'Lack of data',
      'Please upload a screenshot of the problem for assistance.'
    ],
    ['Lack of data', 'Please upload a code file that you want to debug.'],
    [
      'Lack of data',
      'Please enter some remarks to facilitate the aid provider to debug.'
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
