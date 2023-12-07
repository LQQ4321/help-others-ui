import 'package:flutter/material.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';

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

  static Future<dynamic> confirmInfoDialog(
      BuildContext context, List<String> texts, Function(bool) callBack) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(texts[0],
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
            Container(
                color: const Color(0xffe7ecf6),
                height: 2,
                margin: const EdgeInsets.only(top: 10, bottom: 10)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(texts[1],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                      fontSize: 12)),
            ),
            const SizedBox(height: 10),
            DialogButtons(
              list: const ['CANCEL', 'CONFIRM'],
              funcList: [
                <bool>() {
                  return true;
                },
                callBack
              ],
            )
          ],
        ),
      );
    }), isBarrierDismissible: true);
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
