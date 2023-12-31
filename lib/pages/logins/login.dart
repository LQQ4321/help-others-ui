import 'package:flutter/material.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/pages/logins/loginRoute.dart';
import 'package:help_them/pages/logins/registerRoute.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    int loginRouteId = context.watch<RootDataModel>().userData.loginRouteId;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.grey, Colors.black54])),
      child: Center(
        child: Container(
          width: 900,
          height: 500,
          color: Colors.white,
          child: Row(
            children: [
              const Expanded(child: _LeftShowField()),
              Container(width: 1, color: Colors.black12),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(20),
                child: loginRouteId == 0
                    ? const LoginRoute()
                    : const RegisterRoute(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _LeftShowField extends StatelessWidget {
  const _LeftShowField({Key? key}) : super(key: key);

  final String _title = 'Patience';
  final String _motto =
      '        Dripping water can penetrate stone, but it takes time. Three feet of ice does not form in a single day.';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          if (index == 1) {
            return const SizedBox(height: 10);
          }
          return Text(index == 0 ? _title : _motto,
              style: TextStyle(
                  color: index == 0 ? Colors.black87 : Colors.black45,
                  fontSize: index == 0 ? 25 : 15,
                  fontWeight: index == 0 ? FontWeight.w900 : FontWeight.w500));
        }),
      )),
    );
  }
}
