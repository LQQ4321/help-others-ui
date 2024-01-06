import 'package:flutter/material.dart';
import 'package:help_them/pages/users/showWidget/lendHandList.dart';
import 'package:help_them/pages/users/showWidget/seekHelpList.dart';

class UserSubmitList extends StatefulWidget {
  const UserSubmitList({Key? key}) : super(key: key);

  @override
  State<UserSubmitList> createState() => _UserSubmitListState();
}

class _UserSubmitListState extends State<UserSubmitList> {
  bool _isSeekHelp = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 50,
            child: Row(
              children: [
                const SizedBox(width: 20),
                const Text('Seek help'),
                const SizedBox(width: 10),
                Switch(
                    value: !_isSeekHelp,
                    activeColor: Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        _isSeekHelp = !_isSeekHelp;
                      });
                    }),
                const SizedBox(width: 10),
                const Text('Lend hand'),
              ],
            )),
        const SizedBox(height: 10),
        Expanded(
            child: _isSeekHelp
                ? const UserSeekHelpList()
                : const UserLendHandList())
      ],
    );
  }
}
