import 'dart:math';

import 'package:help_them/data/config.dart';
import 'package:flutter/material.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:help_them/functions/functionOne.dart';
import 'dart:html' as html;
import 'package:intl/intl.dart';

class UserData {
  int loginRouteId = 0;
  bool isLogin = false;
  bool rememberMe = false;
  late String userId;
  String name = '';
  String email = '';
  String password = '';
  late String registerTime;
  late bool isManager; //是否是管理员
  List<String> seekHelpLikeList = [];
  List<String> lendHandLikeList = [];

  //还未解决的seekHelpId列表,到时候random就从里面选
  List<SingleSeekHelp> unsolvedSeekHelpList = [];

  // late int ban; //用户的权限
  late int score; //用户的总分值
  //网站的配置信息，也放在这里好了，防止RootDataModel太大
  int pageId = 0; //当前浏览的网页
  late int loginDuration; //每次最多可以登录的时间，单位是小时
  late int maxUploadFileSize;
  late int maxUploadImageSize;
  late String loginTime; //登录时间

  void cleanCacheData() {
    loginRouteId = 0;
    isLogin = false;
    seekHelpLikeList.clear();
    lendHandLikeList.clear();
    unsolvedSeekHelpList.clear();
    switchRoute(0);
  }

  bool isLike(bool isSeekHelp, String dbId) {
    if (isSeekHelp) {
      return seekHelpLikeList.contains(dbId);
    }
    return lendHandLikeList.contains(dbId);
  }

  Future<bool> likeOperate(List<String> list) async {
    list.add(userId);
    Map request = {'requestType': 'likeOperate', 'info': list};
    return Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      if (list[0] == 'seekHelp') {
        seekHelpLikeList.add(list[1]);
      } else {
        lendHandLikeList.add(list[1]);
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<int> forgotPassword(List<String> list) async {
    for (int i = 0; i < list.length; i++) {
      if (list[i].isEmpty) {
        return 5;
      }
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].contains(' ')) {
        return 6;
      }
    }
    if (list[1] != list[2]) {
      return 7;
    }
    list.removeAt(2);
    Map request = {'requestType': 'forgotPassword', 'info': list};
    int flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        int errorCode = value.data['errorCode'];
        if (errorCode == 2) {
          errorCode = 8;
        } else if (errorCode == 3) {
          errorCode = 9;
        } else if (errorCode == 4) {
          errorCode = 3;
        }
        return errorCode;
      }
      loginRouteId = 0;
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 1;
    });
    return flag;
  }

  Future<int> register(List<String> list) async {
    for (int i = 0; i < list.length; i++) {
      if (list[i].isEmpty) {
        return 5;
      }
    }
    for (int i = 0; i < list.length; i++) {
      if (list[i].contains(' ')) {
        return 6;
      }
    }
    if (list[2] != list[3]) {
      return 7;
    }
    list.removeAt(2);
    list.add(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    Map request = {'requestType': 'register', 'info': list};
    int flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        int errorCode = value.data['errorCode'];
        if (errorCode == 2) {
          errorCode = 8;
        } else if (errorCode == 3) {
          errorCode = 9;
        } else if (errorCode == 4) {
          errorCode = 10;
        }
        return errorCode;
      }
      loginRouteId = 0;
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 1;
    });
    return flag;
  }

  // 0 发送验证码成功 1 网络或服务器内部错误 2 邮箱已存在(想对于注册) 3 邮箱不存在(相对于忘记密码)
  // 4 邮箱地址格式不正确 5 邮箱地址为空 6 邮箱地址包含空格
  Future<int> sendVerificationCode(bool isRegister, String mailbox) async {
    if (mailbox.isEmpty) {
      return 5;
    }
    if (mailbox.contains(' ')) {
      return 6;
    }
    if (!FunctionOne.isEmailValid(mailbox)) {
      return 4;
    }
    Map request = {
      'requestType': 'sendVerificationCode',
      'info': [isRegister ? 'register' : 'forgotPassword', mailbox]
    };
    int flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        int errorCode = value.data['errorCode'];
        if (errorCode == 4) {
          errorCode = 13;
        }
        return errorCode;
      }
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 1;
    });
    return flag;
  }

  // 0 登录成功 1 内部错误 2 验证码过期 3 验证码或密码错误 4 邮箱地址或者用户名不存在
  // 5 输入内容不能为空 6 输入内容不能包含空格 7 邮箱格式不正确
  Future<int> login(
      int loginModel, String userIdentity, String password) async {
    if (userIdentity.isEmpty || password.isEmpty) {
      return 5;
    }
    if (userIdentity.contains(' ') || password.contains(' ')) {
      return 6;
    }
    //TODO 如果时用邮箱登录，检测一下邮箱的格式
    Map request = {
      'requestType': 'login',
      'info': [
        loginModel == 0
            ? 'username'
            : (loginModel < 3 ? 'mailbox' : 'authcode'),
        userIdentity,
        password
      ]
    };
    int flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        int errorCode = value.data['errorCode'];
        if (errorCode == 2) {
          errorCode = 8;
        } else if (errorCode == 3) {
          errorCode = 9;
        } else if (errorCode == 4) {
          errorCode = 11;
        }
        return errorCode;
      }

      List<dynamic> configData = value.data['configData'];
      List<dynamic> tempUnsolvedList = value.data['unsolvedList'];
      fromJson(value.data['user'], configData, tempUnsolvedList);
      saveDataToLocal();
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 1;
    });
    if (flag == 0) {
      // TODO 测试 管理员和用户的区别
      isManager = false;
      isLogin = true;
      pageId = 1;
    }
    return flag;
  }

  // 路由列表 : 1 求助列表 2 编写求助 3 编写帮助 4 求助和帮助展示 5 网站的介绍 6 用户设置
  // 每次改变路由，都将其写入本地
  void switchRoute(int _pageId) {
    pageId = _pageId;
    html.window.localStorage['pageId'] = pageId.toString();
  }

  void changeRememberMe() {
    rememberMe = !rememberMe;
  }

  void switchLoginRoute(int pageId) {
    loginRouteId = pageId;
  }

  SingleSeekHelp? getRandomSeekHelpId() {
    if (unsolvedSeekHelpList.isEmpty) {
      return null;
    }
    return unsolvedSeekHelpList[Random().nextInt(unsolvedSeekHelpList.length)];
  }

  // 在打开网站的时候就去读取本地数据，本地只应该保存用户和密码这一类方便用户登录的数据，
  // 其他数据就再发起一次网络请求来获取，这样减少本地缓存的数据，同时数据也是最新的.
  // 如果每次用户点击到浏览器的刷新按钮，那么本地可以保存刷新之前正在浏览的是哪一个页面，
  // 然后去发起网络请求，去获取当前页面进行操作和展示所必须要用到的数据(有些数据可以等到需要的时候再去获取)
  void init() {
    //如果上一次登录的时候设置记住用户名和密码，那么就获取它
    if (html.window.localStorage['rememberMe'] != null) {
      rememberMe = bool.parse(html.window.localStorage['rememberMe']!);
    }
    // 就算用户没用要求记住用户名和密码，我们也应该将其存在本地，
    // 因为定位到指定路由的时候要调用login方法，而login方法要用到
    name = html.window.localStorage['name'] ?? '';
    email = html.window.localStorage['email'] ?? '';
    if (html.window.localStorage['password'] != null) {
      password = Config.decryptFunc(html.window.localStorage['password']!);
    }
    //如果登录超过期限，那么就不能再定位到之前的路由了，而是要重新登录
    if (html.window.localStorage.containsKey('loginDuration') &&
        html.window.localStorage.containsKey('loginTime')) {
      int loginDuration = int.parse(html.window.localStorage['loginDuration']!);
      String loginTime = html.window.localStorage['loginTime']!;
      if (DateTime.now().difference(DateTime.parse(loginTime)).inSeconds <
          loginDuration * 60 * 60) {
        //  没有超出登录期限，可以直接将路由定位到之前的位置
        //获取上一次浏览的路由，这样就不用每次刷新都显示登录界面了
        //例 0 登录界面  1 seek help 2 lend hand 3 user setting ...
        if (html.window.localStorage['pageId'] != null) {
          pageId = int.parse(html.window.localStorage['pageId']!);
        }
      }
    }
  }

  //登录成功后就调用这一个方法将必要的数据保存到本地
  void saveDataToLocal() {
    html.window.localStorage['loginDuration'] = loginDuration.toString();
    html.window.localStorage['loginTime'] = loginTime;
    html.window.localStorage['rememberMe'] = rememberMe.toString();
    html.window.localStorage['pageId'] = '1'; //seek help
    html.window.localStorage['name'] = name;
    html.window.localStorage['email'] = email;
    html.window.localStorage['password'] = Config.encryptFunc(password);
  }

  void fromJson(dynamic userData, List<dynamic> configList,
      List<dynamic> tempUnsolvedList) {
    //用户信息
    userId = userData['ID'].toString();
    name = userData['Name'];
    email = userData['Mailbox'];
    password = userData['Password'];
    isManager = userData['IsManager'];
    registerTime = userData['RegisterTime'];
    //这里的数据是空字符串，所以没有报错，但如果是null，会报错
    seekHelpLikeList = userData['SeekHelpLikeList'].toString().split('#');
    lendHandLikeList = userData['LendHandLikeList'].toString().split('#');
    unsolvedSeekHelpList = List.generate(tempUnsolvedList.length, (index) {
      return SingleSeekHelp.fromJson(tempUnsolvedList[index]);
    });
    // ban = userData['Ban'];
    score = userData['Score'];
    //网站配置信息
    loginDuration = configList[0];
    maxUploadFileSize = configList[1];
    maxUploadImageSize = configList[2];
    loginTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  @override
  String toString() {
    return '$userId $name $isManager $score $loginTime';
  }
}
