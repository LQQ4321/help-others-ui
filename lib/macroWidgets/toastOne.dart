import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:help_them/data/constantData.dart';

class ToastOne {
  //  创建一个右上角的Toast，方便显示一条不需要选手作出回复的消息，只需要选手知道即可，一段事件后会自己消失
  static VoidCallback oneToast(List<String> texts,
      {int infoStatus = 2,
      int duration = 5,
      double dx = 0.98,
      double dy = -0.98}) {
    return BotToast.showCustomText(
        toastBuilder: (context) {
          return Container(
              height: 80,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black45,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0)
                  ]),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: 7,
                      margin: const EdgeInsets.only(
                          left: 5, right: 10, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                          color: ConstantData.statusColors[infoStatus],
                          borderRadius: BorderRadius.circular(4))),
                  Column(
                      children: List.generate(texts.length, (index) {
                    return Container(
                      height: index == 0 ? 30 : 50,
                      width: 270,
                      padding: EdgeInsets.only(
                          top: index == 0 ? 3 : 0, bottom: index == 0 ? 0 : 3),
                      child: Text(
                        texts[index],
                        maxLines: index == 0 ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: index == 0 ? Colors.black87 : Colors.grey,
                            fontSize: index == 0 ? 16 : 15,
                            fontWeight:
                                index == 0 ? FontWeight.w500 : FontWeight.w300),
                      ),
                    );
                  }))
                ],
              ));
        },
        align: Alignment(dx, dy),
        duration: Duration(seconds: duration));
  }
}
