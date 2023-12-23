import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(child: _LeftShowField()),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(20),
                child: const _RightOperateField(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _RightOperateField extends StatefulWidget {
  const _RightOperateField({Key? key}) : super(key: key);

  @override
  State<_RightOperateField> createState() => _RightOperateFieldState();
}

class _RightOperateFieldState extends State<_RightOperateField> {
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
        const SizedBox(height: 30),
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
                        ElevatedButton(
                            onPressed: () {

                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.black),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 55))),
                            child: const Text('Send code')),
                        const SizedBox(width: 20)
                      ],
                    ),
              Expanded(
                child: RectangleInput(
                  textEditingController: textEditingControllers[1],
                  icon: Icons.password,
                  labelText: _loginMode < 3 ? 'Password' : 'Auth code',
                  eye: true,
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
                    value: false,
                    // context.watch<RootDataModel>().userData.rememberMe,
                    activeColor: Colors.black45,
                    onChanged: (_) async {
                      // await context.read<RootDataModel>().userOperate(3);
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
                onPressed: () {},
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
    );
  }

  @override
  void initState() {
    textEditingControllers =
        List.generate(2, (index) => TextEditingController());
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

class _LeftShowField extends StatelessWidget {
  const _LeftShowField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
