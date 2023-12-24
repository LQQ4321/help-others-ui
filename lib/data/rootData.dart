import 'package:flutter/material.dart';
import 'package:help_them/data/comment.dart';
import 'package:help_them/data/lendHand.dart';
import 'package:help_them/data/macroLendHand.dart';
import 'package:help_them/data/userData.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:intl/intl.dart';

//我们肯定不能将所有的notifyListeners()全部放到一个class里面，所以就需要就进行拆分。
//但是拆分后他们还是有联系的，也就是互相依赖的意思
//那么现在就有两种方法使他们联系在一起

//1.先创建父级变量，然后子级就调用ChangeNotifierProvider.value来监听父级变量内的某个成员变量，
// 但是自己变量调用notifyListeners()的时候，父级变量是感知不到的，这样只能先经过父级，再通过父级调用子级的方法
//2.先创建子级变量，然后父级就调用ChangeNotifierProxyProvider来监听子级变量的改变，
// 父级好像要实现一个void update方法来处理子级变量的更新

//感觉前一种方法会方便一些

//FIXME 感觉调试的时候浏览器时不时崩一下，应该是网页内存溢出了
class RootDataModel extends ChangeNotifier {
  UserData userData = UserData();
  SeekHelpModel seekHelpModel = SeekHelpModel();
  LendHandModel lendHandModel = LendHandModel();
  ShowInfo showInfo = ShowInfo();
  CommentModel commentModel = CommentModel();

  //Comment
  Future<dynamic> commentOperate(int option, {String text = ''}) async {
    dynamic flag;
    if (option == 1) {
      int type = 0;
      String seekOrLendId = seekHelpModel.singleSeekHelp.seekHelpId;
      if (showInfo.curRightShowPage >= 0) {
        type = 1;
        seekOrLendId = lendHandModel
            .showLendHandList[showInfo.curRightShowPage].lendHandId;
      }
      flag = await commentModel.requestCommentList(type, seekOrLendId);
    } else if (option == 2) {
      List<String> list = [];
      list.add('0');
      list.add(seekHelpModel.singleSeekHelp.seekHelpId);
      if (showInfo.curRightShowPage >= 0) {
        list[0] = '1';
        list[1] = lendHandModel
            .showLendHandList[showInfo.curRightShowPage].lendHandId;
      }
      list.add(text);
      list.add(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()));
      list.add(userData.name);
      list.add(userData.userId);
      flag = await commentModel.sendAComment(list);
    }
    notifyListeners();
    return flag;
  }

  // SeekHelp
  Future<dynamic> seekHelp(int option,
      {List<String>? texts, List<int>? list1, List<int>? list2}) async {
    dynamic flag;
    if (option == 1) {
      flag = await seekHelpModel.requestSeekHelpList();
    } else if (option == 2) {
      texts!.add(userData.userId);
      flag = await seekHelpModel.seekAHelp(texts, userData.score, list1, list2);
    } else if (option == 3) {
      seekHelpModel.filterFromRule(order: list1![0], filterRule: list1[1]);
    } else if (option == 4) {
      flag = await seekHelpModel.requestSeekHelpList(newDate: texts![0]);
      if (flag) {
        userData.switchRoute(1);
      }
    }
    notifyListeners();
    return flag;
  }

  // LendHand
  Future<dynamic> lendHand(int option,
      {List<int>? list, List<String>? list2}) async {
    dynamic flag;
    if (option == 1) {
      //从列表里面选择seekHelp
      String seekHelpId = seekHelpModel.showSeekHelpList[list![0]].seekHelpId;
      flag = await lendHandModel.requestLendHandList(seekHelpId);
      if (flag) {
        flag = await showInfo.requestShowData(-2, seekHelpId);
      }
      if (flag) {
        //操作成功后，才应该修改特定的标志变量
        lendHandModel.curSeekHelpId = seekHelpId;
        //TODO 这里算是引用吗？
        seekHelpModel.singleSeekHelp = seekHelpModel.showSeekHelpList[list[0]];
        userData.switchRoute(3);
      }
    } else if (option == 2) {
      //FIXME 为什么seekHelp和lendHand可以是同一个人2023-12-21
      list2!.add(seekHelpModel.singleSeekHelp.uploadTime.split(' ')[0]);
      list2.add(userData.userId);
      flag = await lendHandModel.lendAHand(list2, list);
    } else if (option == 3) {
      //  random，跟option == 1差不多
      //  从random选择seekHelp
      SingleSeekHelp? tempSingleSeekHelp = userData.getRandomSeekHelpId();
      if (tempSingleSeekHelp == null) {
        //不存在未解决的求助
        flag = 2;
      } else {
        debugPrint(
            '${tempSingleSeekHelp.seekHelpId} ${tempSingleSeekHelp.status} ${tempSingleSeekHelp.seekHelperName} ${tempSingleSeekHelp.uploadTime}');
        flag = await lendHandModel
            .requestLendHandList(tempSingleSeekHelp.seekHelpId);
        if (flag) {
          flag =
              await showInfo.requestShowData(-2, tempSingleSeekHelp.seekHelpId);
        }
        if (flag) {
          //操作成功后，才应该修改特定的标志变量
          lendHandModel.curSeekHelpId = tempSingleSeekHelp.seekHelpId;
          //TODO 这里算是引用吗？
          seekHelpModel.singleSeekHelp = tempSingleSeekHelp;
          userData.switchRoute(3);
        }
      }
    }
    notifyListeners();
    return flag;
  }

  //ShowInfo
  Future<dynamic> showOperate(int option,
      {List<int>? list, List<String>? list2}) async {
    dynamic flag;
    if (option == 1) {
      String dbId = '';
      if (list![0] == -1) {
        //加载seekHelp
        dbId = seekHelpModel.singleSeekHelp.seekHelpId;
      } else {
        //加载lendHand #id
        dbId = lendHandModel.showLendHandList[list[0]].lendHandId;
      }
      flag = await showInfo.requestShowData(list[0], dbId);
    } else if (option == 2) {
      showInfo.switchCodeShowStatus(list![0]);
    }
    notifyListeners();
    return flag;
  }

  // UserData
  //如何需要用到除了自己以外的其他数据，就需要经过RootDataModel，否则直接调用就可以了
  Future<dynamic> userOperate(int option,
      {List<String>? strList, List<int>? numList}) async {
    dynamic flag;
    if (option == 1) {
      flag = await userData.login(numList![0],strList![0], strList[1]);
    } else if (option == 2) {
      userData.switchRoute(numList![0]);
    } else if (option == 3) {
      userData.changeRememberMe();
    } else if (option == 4) {
      ////求助和帮助不能同一个人
      if (userData.userId == seekHelpModel.singleSeekHelp.seekHelperId) {
        flag = false;
      } else {
        flag = true;
      }
    } else if (option == 5) {
      List<String> list = [];
      if (showInfo.curRightShowPage < 0) {
        list.add('seekHelp');
        list.add(seekHelpModel.singleSeekHelp.seekHelpId);
      } else {
        list.add('lendHand');
        list.add(lendHandModel
            .showLendHandList[showInfo.curRightShowPage].lendHandId);
      }
      flag = await userData.likeOperate(list);
      //修改本地信息
      if (flag &&
          userData.userId == seekHelpModel.singleSeekHelp.seekHelperId) {
        //这里如果是引用得来的，那么会不会连原本的地方也改变了？？？
        seekHelpModel.singleSeekHelp.status = 1;
        if (showInfo.curRightShowPage >= 0) {
          lendHandModel.showLendHandList[showInfo.curRightShowPage].status = 1;
        }
      }
    } else if (option == 6) {
      flag = await userData.sendVerificationCode(numList![0] == 0, strList![0]);
    } else if (option == 7) {
      userData.switchLoginRoute(numList![0]);
    } else if (option == 8) {
      flag = await userData.register(strList!);
    } else if (option == 9) {
      flag = await userData.forgotPassword(strList!);
    }
    notifyListeners();
    return flag;
  }

  dynamic syncUserOperate(int option) {
    dynamic flag;
    if (option == 1) {
      String dbId = '';
      if (showInfo.curRightShowPage < 0) {
        dbId = seekHelpModel.singleSeekHelp.seekHelpId;
      } else {
        dbId = lendHandModel
            .showLendHandList[showInfo.curRightShowPage].lendHandId;
      }
      flag = userData.isLike(showInfo.curRightShowPage < 0, dbId);
      //免得造成死循环
    } else if (option == 2) {
      flag = true;
      if (showInfo.curRightShowPage < 0) {
        if (userData.userId == seekHelpModel.singleSeekHelp.seekHelperId) {
          flag = false;
        }
      } else {
        if (userData.userId ==
            lendHandModel
                .showLendHandList[showInfo.curRightShowPage].lendHanderId) {
          flag = false;
        }
      }
    }
    //不应该调用，理论上来说是会造成死循环的
    // notifyListeners();
    return flag;
  }

  //注意该方法只执行一遍，
  Future initWebsite() async {
    userData.init();
    // 请求当前路由所需要的数据
    // 因为定位到之前浏览的路由的过程，相当于从登录界面到指定路由的过程，
    // 只不过一个是手动，一个是自动，该有的网络请求还是得有
    bool flag = false;
    if (userData.pageId != 0) {
      //调用login后,userData.pageId已经变成 1 了
      flag = (await userData.login(0, userData.name, userData.password)) == 0;
    }
    //前一步执行正确才有必要执行下一步，相当于stream,所以这一个初始化过程中的网络请求是串行化的,可能有点慢
    if (flag) {
      flag = await seekHelpModel.requestSeekHelpList();
    }
    if (flag) {}
    //感觉没有必要，因为此时还没有任何界面使用到这些数据
    // notifyListeners();
  }
}
