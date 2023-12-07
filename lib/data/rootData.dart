import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'dart:html' as html;
import 'package:intl/intl.dart';
import 'package:help_them/data/seekHelp.dart';

//我们肯定不能将所有的notifyListeners()全部放到一个class里面，所以就需要就进行拆分。
//但是拆分后他们还是有联系的，也就是互相依赖的意思
//那么现在就有两种方法使他们联系在一起

//1.先创建父级变量，然后子级就调用ChangeNotifierProvider.value来监听父级变量内的某个成员变量，
// 但是自己变量调用notifyListeners()的时候，父级变量是感知不到的，这样只能先经过父级，再通过父级调用子级的方法
//2.先创建子级变量，然后父级就调用ChangeNotifierProxyProvider来监听子级变量的改变，
// 父级好像要实现一个void update方法来处理子级变量的更新

//感觉前一种方法会方便一些

class RootDataModel extends ChangeNotifier {
  bool isLogin = false;
  UserData userData = UserData();
  SeekHelpModel seekHelpModel = SeekHelpModel();

  //注意该方法只执行一遍，
  Future initWebsite() async {
    userData.init();
    // FIXME 这里别忘了：因为调用userData.fromJson,这里的pageId的值会被覆盖,
    // FIXME 所以应该将值暂时保存在这里，最总应该让userData.pageId重新等于_pageId
    final int _pageId = userData.pageId;
    // 请求当前路由所需要的数据
    // 因为定位到之前浏览的路由的过程，相当于从登录界面到指定路由的过程，
    // 只不过一个是手动，一个是自动，该有的网络请求还是得有
    bool flag = false;
    if (_pageId != 0) {
      //调用login后,userData.pageId已经变成 1 了
      flag = (await login(userData.name, userData.password)) == 0;
    }
    //前一步执行正确才有必要执行下一步，相当于stream,所以这一个初始化过程中的网络请求是串行化的,可能有点慢
    if (flag) {
      flag = await seekHelpModel.requestSeekHelpList();
    }
    if (flag) {}
    //感觉没有必要，因为此时还没有任何界面使用到这些数据
    // notifyListeners();
  }

  // 路由列表 1 求助列表 2 编写求助 3 编写帮助 4 求助和帮助展示 5 网站的介绍 6 用户设置
  String? switchRoute(int pageId) {
    userData.switchRoute(pageId);
    notifyListeners();
  }

  void changeRememberMe() {
    userData.rememberMe = !userData.rememberMe;
    notifyListeners();
  }

  // 0 登录成功 1 输入格式错误(包含一个空格或为空) 2 用户名不存在或密码错误
  Future<int> login(String name, String password) async {
    if (name.isEmpty ||
        password.isEmpty ||
        name.contains(' ') ||
        password.contains(' ')) {
      return 1;
    }

    Map request = {
      'requestType': 'verifyUser',
      'info': ['login', name, password]
    };
    int flag =
        await Config.dio.post(Config.requestJson, data: request).then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return 2;
      }
      List<dynamic> configData = value.data['configData'];
      //这里的userData直接被重新赋值，从而导致原本的rememberMe也被重新赋值
      userData = UserData.fromJson(
          value.data['user'], configData, userData.rememberMe);
      userData.saveDataToLocal();
      return 0;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return 2;
    });
    if (flag == 0) {
      isLogin = true;
      userData.pageId = 1;
      notifyListeners();
    }
    return flag;
  }

//  SeekHelp
  Future<dynamic> seekHelp(int option) async {}
}

class UserData {
  bool rememberMe = false;
  late String userId;
  String name = '';
  String password = '';
  late bool isManager; //是否是管理员
  List<String> seekHelpList = [];
  List<String> lendHandList = [];
  late int ban; //用户的权限
  late int score; //用户的总分值
  //网站的配置信息，也放在这里好了，防止RootDataModel太大
  int pageId = 0; //当前浏览的网页
  late int remainingRecourse; //当天剩余的求组机会
  late int loginDuration; //每次最多可以登录的时间，单位是小时
  late String loginTime; //登录时间

  //每次改变路由，都将其写入本地
  void switchRoute(int _pageId) {
    pageId = _pageId;
    html.window.localStorage['pageId'] = pageId.toString();
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
    html.window.localStorage['pageId'] = '1';
    html.window.localStorage['name'] = name;
    html.window.localStorage['password'] = Config.encryptFunc(password);
  }

  UserData();

  factory UserData.fromJson(
      dynamic userData, List<dynamic> configList, bool rememberMe) {
    UserData _userData = UserData();
    //用户信息
    _userData.rememberMe = rememberMe;
    _userData.userId = userData['ID'].toString();
    _userData.name = userData['Name'];
    _userData.password = userData['Password'];
    _userData.isManager = userData['IsManager'];
    //这里的数据应该是空字符串，所以没有报错，但如果是null，估摸会报错
    _userData.seekHelpList = userData['SeekHelp'].toString().split('#');
    _userData.lendHandList = userData['LendHand'].toString().split('#');
    _userData.ban = userData['Ban'];
    _userData.score = userData['Score'];
    //网站配置信息
    _userData.remainingRecourse = configList[0];
    _userData.loginDuration = configList[1];
    _userData.loginTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    return _userData;
  }

  @override
  String toString() {
    return '$userId $name $isManager $seekHelpList $ban $score $remainingRecourse $loginTime';
  }
}
