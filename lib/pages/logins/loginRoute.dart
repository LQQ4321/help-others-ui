import 'dart:async';

import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/data/userData.dart';
import 'package:help_them/functions/functionTwo.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  late List<TextEditingController> textEditingControllers;
  int _loginMode = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Help others',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
        const SizedBox(height: 10),
        const Text('Give someone a rose, leave fragrance in your hand',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black38)),
        const SizedBox(height: 30),
        Row(
            children: List.generate(5, (index) {
          if (index % 2 == 1) {
            return const SizedBox(width: 10);
          }
          return Expanded(
            child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _loginMode = index;
                    if(_loginMode != 0){
                      textEditingControllers[0].clear();
                      textEditingControllers[1].clear();
                    }else{
                      UserData userData = context.read<RootDataModel>().userData;
                      if (userData.rememberMe) {
                        textEditingControllers[0].text = userData.name;
                        textEditingControllers[1].text = userData.password;
                      }
                    }
                  });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) =>
                        _loginMode == index ? Colors.black12 : Colors.white),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(ConstantData.loginOptionIcons[index ~/ 2],
                        color: Colors.black54),
                    Text(ConstantData.loginOptionTopics[index ~/ 2],
                        style: const TextStyle(color: Colors.black54))
                  ],
                )),
          );
        })),
        const SizedBox(height: 20),
        SizedBox(
          height: 55,
          child: RectangleInput(
              textEditingController: textEditingControllers[0],
              icon: ConstantData.loginOptionIcons[_loginMode == 0 ? 0 : 1],
              labelText:
                  ConstantData.loginOptionTopics[_loginMode == 0 ? 0 : 1]),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 55,
          child: Row(
            children: [
              _loginMode < 3
                  ? Container()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SendAuthCode(callBack: <int>() async {
                          return await context
                              .read<RootDataModel>()
                              .userOperate(6,
                                  strList: [textEditingControllers[0].text],
                                  numList: [1]);
                        }),
                        const SizedBox(width: 20)
                      ],
                    ),
              Expanded(
                child: RectangleInput(
                  textEditingController: textEditingControllers[1],
                  icon: Icons.password,
                  labelText: _loginMode < 3 ? 'Password' : 'Auth code',
                  eye: _loginMode < 3 ? true : false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                    value: context.watch<RootDataModel>().userData.rememberMe,
                    activeColor: Colors.black45,
                    onChanged: (_) async {
                      await context.read<RootDataModel>().userOperate(3);
                    }),
                const Text('Remember me')
              ],
            ),
            TextButton(
                onPressed: () async {
                  await context
                      .read<RootDataModel>()
                      .userOperate(7, numList: [1]);
                },
                style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black12)),
                child: const Text('Forgot password',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)))
          ],
        ),
        const SizedBox(height: 40),
        ElevatedButton(
            onPressed: () async {
              int flag = await context.read<RootDataModel>().userOperate(1,
                  numList: [_loginMode],
                  strList: [
                    textEditingControllers[0].text,
                    textEditingControllers[1].text
                  ]);
              if (flag == 0) {
                return;
              }
              List<String> list = ErrorParse.getErrorMessage(flag);
              ToastOne.oneToast(list);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black),
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 55))),
            child: const Text(
              'Sign in',
              style: TextStyle(color: Colors.white),
            )),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don‘t have an account?'),
            TextButton(
                onPressed: () async {
                  await context
                      .read<RootDataModel>()
                      .userOperate(7, numList: [2]);
                },
                style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black12)),
                child: const Text('Register here.',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)))
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    textEditingControllers =
        List.generate(2, (index) => TextEditingController());
    UserData userData = context.read<RootDataModel>().userData;
    if (userData.rememberMe) {
      textEditingControllers[0].text = userData.name;
      textEditingControllers[1].text = userData.password;
    }
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < textEditingControllers.length; i++) {
      textEditingControllers[i].dispose();
    }
    super.dispose();
  }
}

class SendAuthCode extends StatefulWidget {
  const SendAuthCode({Key? key, required this.callBack}) : super(key: key);
  final Function<int>() callBack;

  @override
  State<SendAuthCode> createState() => _SendAuthCodeState();
}

class _SendAuthCodeState extends State<SendAuthCode> {
  Timer? _timer;
  int _time = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (_countdownTimer()) {
            int flag = await widget.callBack();
            List<String> list = [];
            if (flag == 0) {
              list.add('Send succeed');
              list.add('Please open your email to get the verification code');
            } else {
              list = ErrorParse.getErrorMessage(flag);
            }
            ToastOne.oneToast(list, infoStatus: flag == 0 ? 0 : 2);
          }
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.black),
            minimumSize: MaterialStateProperty.all(const Size(110, 55))),
        child: Text(_time <= 0 ? 'Send code' : '$_time'));
  }

  bool _countdownTimer() {
    if (_time > 0) {
      ToastOne.oneToast([
        'Send fail',
        'Operation is too frequent, please wait for the countdown to end.'
      ], infoStatus: 1);
      return false;
    }
    _time = 60;
    _timer?.cancel();
    //这里是异步的
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_time <= 0) {
        timer.cancel();
      }
      setState(() {
        _time--;
      });
    });
    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
