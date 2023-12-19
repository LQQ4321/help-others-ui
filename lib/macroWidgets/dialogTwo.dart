import 'package:flutter/material.dart';
import 'package:help_them/macroWidgets/dialogOne.dart';

class DialogTwo {
// 该对话框展示评论
  static Future<dynamic> showTextField(BuildContext context) {
    return DialogOne.showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.95,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(8)),
          ));
    }), padding: EdgeInsets.zero);
  }
}
