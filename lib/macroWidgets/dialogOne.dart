import 'package:flutter/material.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:help_them/macroWidgets/widgetTwo.dart';

class DialogOne {
  //代码复用
  static Future<dynamic> showMyDialog(BuildContext context, Widget widget,
      {bool isBarrierDismissible = true, EdgeInsetsGeometry? padding}) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: isBarrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(content: widget, contentPadding: padding);
        });
  }

  //展示一段文本
  static Future<dynamic> showTextField(BuildContext context, String text) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8)),
              child: ListView(
                children: [
                  Text(
                    text,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              )));
    }));
  }

  //展示一张图片
  static Future<dynamic> showAPicture(
      BuildContext context, ImageProvider imageProvider) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.9,
          child: ListView(
            padding: const EdgeInsets.only(right: 10),
            children: [
              SizedBox(
                width: double.infinity,
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: imageProvider,
                ),
              )
            ],
          ));
    }));
  }

  static Future<dynamic> timeSelectDialog(
      BuildContext context, String oldDate, List<Function> funcList) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DateTimePicker(
                oldDate: oldDate, callBack: funcList[0] as Function(String)),
            Container(
                height: 2,
                color: Colors.grey,
                margin: const EdgeInsets.only(bottom: 10, top: 10)),
            DialogButtons(
              list: const ['CANCEL', 'CONFIRM'],
              callBack: funcList[1] as Function(bool),
            )
          ],
        ),
      );
    }), isBarrierDismissible: true);
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
              callBack: callBack,
            )
          ],
        ),
      );
    }), isBarrierDismissible: true);
  }
}
