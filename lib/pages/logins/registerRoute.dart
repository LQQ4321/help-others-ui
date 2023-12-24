import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/functions/functionTwo.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:help_them/pages/logins/loginRoute.dart';
import 'package:provider/provider.dart';

class RegisterRoute extends StatefulWidget {
  const RegisterRoute({Key? key}) : super(key: key);

  @override
  State<RegisterRoute> createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  late List<TextEditingController> textEditingControllers;

  @override
  Widget build(BuildContext context) {
    int loginRouteId = context.watch<RootDataModel>().userData.loginRouteId;
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Row(
            children: [
              OutlinedButton(
                  onPressed: () async {
                    await context
                        .read<RootDataModel>()
                        .userOperate(7, numList: [0]);
                  },
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(60, 60))),
                  child: const Icon(Icons.arrow_back, color: Colors.black54)),
              const SizedBox(width: 30),
              const Icon(Icons.person, size: 60, color: Colors.black87),
              const SizedBox(width: 5),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    if (index == 1) {
                      return const SizedBox(height: 5);
                    }
                    return Text(
                        index == 0
                            ? (loginRouteId == 1
                                ? 'Forgot password'
                                : 'Create account')
                            : 'Fill in the form below',
                        style: TextStyle(
                            color: index == 0 ? Colors.black : Colors.black45,
                            fontSize: index == 0 ? 18 : 15,
                            fontWeight: index == 0
                                ? FontWeight.w800
                                : FontWeight.w600));
                  }))
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: RectangleInput(
              textEditingController: textEditingControllers[0],
              icon: ConstantData.loginOptionIcons[1],
              labelText: ConstantData.loginOptionTopics[1]),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              SendAuthCode(callBack: <int>() async {
                return await context.read<RootDataModel>().userOperate(6,
                    strList: [textEditingControllers[0].text],
                    numList: [loginRouteId - 2]);
              }),
              const SizedBox(width: 20),
              Expanded(
                child: RectangleInput(
                    textEditingController: textEditingControllers[1],
                    icon: Icons.password,
                    labelText: 'Auth code'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        loginRouteId == 1
            ? Container()
            : SizedBox(
                height: 50,
                child: RectangleInput(
                    textEditingController: textEditingControllers[2],
                    icon: ConstantData.loginOptionIcons[0],
                    labelText: ConstantData.loginOptionTopics[0]),
              ),
        const SizedBox(height: 10),
        SizedBox(
            height: 50,
            child: RectangleInput(
                textEditingController: textEditingControllers[3],
                icon: Icons.password,
                labelText: loginRouteId == 1 ? 'New password' : 'Password',
                eye: true)),
        const SizedBox(height: 10),
        SizedBox(
            height: 50,
            child: RectangleInput(
                textEditingController: textEditingControllers[4],
                icon: ConstantData.loginOptionIcons[2],
                labelText: 'Confirm password',
                eye: true)),
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: () async {
              List<String> list = [];
              int flag = 0;
              list.addAll([
                textEditingControllers[0].text,
                textEditingControllers[3].text,
                textEditingControllers[4].text,
                textEditingControllers[1].text,
              ]);
              if (loginRouteId == 2) {
                list.insert(0, textEditingControllers[2].text);
                flag = await context
                    .read<RootDataModel>()
                    .userOperate(8, strList: list);
              } else {
                flag = await context
                    .read<RootDataModel>()
                    .userOperate(9, strList: list);
              }
              list.clear();
              if (flag == 0) {
                if (loginRouteId == 1) {
                  list.add('Update succeed');
                  list.add('Change password succeed');
                } else {
                  list.add('Operate successfully');
                  list.add('You have successfully registered an account');
                }
              } else {
                list = ErrorParse.getErrorMessage(flag);
              }
              ToastOne.oneToast(list, infoStatus: flag == 0 ? 0 : 2);
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black),
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 55))),
            child: Text(
              loginRouteId == 1 ? 'Update' : 'Register',
              style: const TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  @override
  void initState() {
    textEditingControllers =
        List.generate(5, (index) => TextEditingController());
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
