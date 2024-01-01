import 'package:flutter/material.dart';
import 'package:help_them/pages/users/submitList.dart';
import 'package:help_them/pages/users/userInfo.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  int _leftButtonId = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 180,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0,
                )
              ],
              borderRadius: BorderRadius.circular(12)),
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
          child: Column(
            children: List.generate(3, (index) {
              if (index % 2 == 1) {
                return const SizedBox(height: 5);
              }
              return TextButton(
                  onPressed: () {
                    setState(() {
                      _leftButtonId = index;
                    });
                  },
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(100, 50)),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.black12),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => _leftButtonId == index
                              ? Colors.black12
                              : Colors.transparent)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(index == 0 ? Icons.person_outline : Icons.list,
                          color: Colors.blueGrey, weight: 0.1),
                      Text(
                        index == 0 ? 'User info' : 'Submit list',
                        style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ));
            }),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
            child:
                _leftButtonId == 0 ? const UserInfo() : const UserSubmitList())
      ],
    );
  }
}
