import 'package:flutter/material.dart';

class DialogOne {
  //代码复用
  static Future<dynamic> showMyDialog(BuildContext context, Widget widget,
      {bool isBarrierDismissible = false}) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: isBarrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(content: widget);
        });
  }

  //进度显示器，但是进度只是给用户看的，消除用户的等待疲劳
  static Future<dynamic> processingBar(BuildContext context, String text) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 300,
        height: 100,
        child: Column(
          children: [
            Text(text,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 20)),
            const SizedBox(height: 30),
            LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.grey))
          ],
        ),
      );
    }));
  }
}
