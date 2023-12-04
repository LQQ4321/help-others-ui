import 'package:flutter/material.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  late List<TextEditingController> textEditingControllers;

  @override
  void initState() {
    textEditingControllers =
        List.generate(2, (index) => TextEditingController());
    textEditingControllers[0].text =
        context.read<RootDataModel>().localStorageData.name;
    textEditingControllers[1].text =
        context.read<RootDataModel>().localStorageData.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 500,
        width: 400,
        child: Column(
          children: [
            const Text('Help others',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
            const SizedBox(height: 30),
            RectangleInput(
              textEditingController: textEditingControllers[0],
              icon: Icons.person_outline,
              labelText: 'User name',
            ),
            const SizedBox(height: 20),
            RectangleInput(
              textEditingController: textEditingControllers[1],
              icon: Icons.password,
              labelText: 'Password',
              eye: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                        value: context
                            .watch<RootDataModel>()
                            .localStorageData
                            .rememberMe,
                        activeColor: Colors.black45,
                        onChanged: (_) {
                          context.read<RootDataModel>().changeRememberMe();
                        }),
                    const Text('Remember me')
                  ],
                ),
                TextButton(
                    onPressed: () {},
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
            const SizedBox(height: 20),
            SizedBox(
                width: 400,
                child: ElevatedButton(
                    onPressed: () async {
                      ToastOne.oneToast([
                        'Formal error' * 10,
                        'contains a space or text is empty' * 10
                      ]);
                      return;
                      await context.read<RootDataModel>().login(
                          textEditingControllers[0].text,
                          textEditingControllers[1].text);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.black),
                        minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity, 55))),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don‘t have an account?'),
                TextButton(
                    onPressed: () {},
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
        ),
      ),
    );
  }
}
