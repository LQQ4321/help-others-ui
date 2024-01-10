import 'package:flutter/material.dart';

class ConstantData {
  static Map<String, TextStyle> githubTheme = {
    'root': const TextStyle(
        color: Color(0xff333333), backgroundColor: Color(0xffffffff)),
    'comment':
        const TextStyle(color: Color(0xff999988), fontStyle: FontStyle.italic),
    'quote':
        const TextStyle(color: Color(0xff999988), fontStyle: FontStyle.italic),
    'keyword':
        const TextStyle(color: Color(0xff333333), fontWeight: FontWeight.bold),
    'selector-tag':
        const TextStyle(color: Color(0xff333333), fontWeight: FontWeight.bold),
    'subst': const TextStyle(
        color: Color(0xff333333), fontWeight: FontWeight.normal),
    'number': const TextStyle(color: Color(0xff008080)),
    'literal': const TextStyle(color: Color(0xff008080)),
    'variable': const TextStyle(color: Color(0xff008080)),
    'template-variable': const TextStyle(color: Color(0xff008080)),
    'string': const TextStyle(color: Color(0xffdd1144)),
    'doctag': const TextStyle(color: Color(0xffdd1144)),
    'title':
        const TextStyle(color: Color(0xff990000), fontWeight: FontWeight.bold),
    'section':
        const TextStyle(color: Color(0xff990000), fontWeight: FontWeight.bold),
    'selector-id':
        const TextStyle(color: Color(0xff990000), fontWeight: FontWeight.bold),
    'type':
        const TextStyle(color: Color(0xff445588), fontWeight: FontWeight.bold),
    'tag': const TextStyle(
        color: Color(0xff000080), fontWeight: FontWeight.normal),
    'name': const TextStyle(
        color: Color(0xff000080), fontWeight: FontWeight.normal),
    'attribute': const TextStyle(
        color: Color(0xff000080), fontWeight: FontWeight.normal),
    'regexp': const TextStyle(color: Color(0xff009926)),
    'link': const TextStyle(color: Color(0xff009926)),
    'symbol': const TextStyle(color: Color(0xff990073)),
    'bullet': const TextStyle(color: Color(0xff990073)),
    'built_in': const TextStyle(color: Color(0xff0086b3)),
    'builtin-name': const TextStyle(color: Color(0xff0086b3)),
    'meta':
        const TextStyle(color: Color(0xff999999), fontWeight: FontWeight.bold),
    'deletion': const TextStyle(backgroundColor: Color(0xffffdddd)),
    'addition': const TextStyle(backgroundColor: Color(0xffddffdd)),
    'emphasis': const TextStyle(fontStyle: FontStyle.italic),
    'strong': const TextStyle(fontWeight: FontWeight.bold),
  };

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

  static const List<String> loginOptionTopics = [
    'Username',
    'Mailbox',
    'Auth code'
  ];

  static const List<IconData> loginOptionIcons = [
    Icons.person_outline,
    Icons.mail_lock_outlined,
    Icons.verified_user_outlined
  ];

  static const List<IconData> showRouteTopBarIcons = [
    Icons.copy,
    Icons.image,
    Icons.topic,
    Icons.favorite,
    Icons.message
  ];

  static const List<String> errorTitle = [
    'Internal error',
    'Send code fail',
    'Logical error',
    'Operate fail',
    'Request fail',
  ];

  static const List<String> errorMessage = [
    'The network is disconnected or the back-end is faulty.',
    'Mailbox already exist',
    'Mailbox does not exist',
    'Mailbox format incorrect',
    'The presence input field is empty',
    'Content of the presence input field contain spaces',
    'The two passwords are different',
    'The verification code has expired',
    'verification code error',
    'The user name or password already exists',
    'The user name or password not exists',
    'Send too often, please wait 10 minutes',
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

  static const List<String> whyHelpOthers = [
    '这个网站是干嘛的',
    '我可以只求助别人而不帮助别人吗',
    '为什么创建该网站'
  ];

  static const List<String> answerHelpOthers = [
    '这是一个面向算法竞赛初学者的网站，可以将自己找不出问题的代码提交上来，会有志愿者们帮助你寻找程序中的潜在bugs',
    '这是不被允许的，用户创建账号后，会有数值为3的基础分，每次寻求帮助都要至少消耗数值为一的分数，当你的分值为零后，将不能求助',
    '目的是帮助算法初学者寻找bugs，有学习算法的朋友应该能够体会，有时候写完一个不太长的程序，然后提交运行，'
        '往往会得到一个不是Accepted的返回结果，然后开始debug，但是这对于初学者而言往往需要大量的时间，'
        '如果有高水平的人能够帮忙，那么debug的时间将会大大减少'
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

  static List<IconData> userInfoIcons = [
    Icons.person_outline,
    Icons.email_outlined,
    Icons.app_registration_outlined,
    Icons.attach_money,
    Icons.live_help_outlined,
    Icons.handshake,
  ];

  static List<String> userInfoMean = [
    'User name',
    'Email',
    'Register',
    'Score',
    'Seek help',
    'Lend hand',
  ];

  static const List<String> monthName = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static const List<String> dayOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  //contribution colors
  static const List<Color> contributionColors = [
    Color(0xffebedf0),
    Color(0xff9be9a8),
    Color(0xff40c463),
    Color(0xff2f9a4b),
    Color(0xff216e39)
  ];

  // 信息框内的颜色
  static List<Color> statusColors = [
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.redAccent[100]!
  ];
}
