import 'package:flutter/material.dart';

//我们肯定不能将所有的notifyListeners()全部放到一个class里面，所以就需要就进行拆分。
//但是拆分后他们还是有联系的，也就是互相依赖的意思
//那么现在就有两种方法使他们联系在一起

//1.先创建父级变量，然后子级就调用ChangeNotifierProvider.value来监听父级变量内的某个成员变量，
// 但是自己变量调用notifyListeners()的时候，父级变量是感知不到的，这样只能先经过父级，再通过父级调用子级的方法
//2.先创建子级变量，然后父级就调用ChangeNotifierProxyProvider来监听子级变量的改变，
// 父级好像要实现一个void update方法来处理子级变量的更新

//感觉前一种方法会方便一些

class RootDataModel extends ChangeNotifier {
  late String name; //登录人名称
  late bool isManager; //是否是管理员
  late int loginDuration; //每次最多可以登录的时间，单位是小时
  late DateTime loginTime; //登录时间，超过规定时间就应该
  late int ban; //改名用户的权限
}
