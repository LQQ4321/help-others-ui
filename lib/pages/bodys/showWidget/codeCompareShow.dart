import 'dart:math';

import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/macroLendHand.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/functions/functionOne.dart';
import 'package:provider/provider.dart';

class CodeRowShow extends StatefulWidget {
  const CodeRowShow({Key? key}) : super(key: key);

  @override
  State<CodeRowShow> createState() => _CodeRowShowState();
}

class _CodeRowShowState extends State<CodeRowShow> {
  final ScrollController _hCtrl = ScrollController();
  final ScrollController _vCtrl = ScrollController();

  @override
  void dispose() {
    _hCtrl.dispose();
    _vCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //这些复杂数据类型应该都是引用
    ShowInfo showInfo = context.watch<RootDataModel>().showInfo;
    int codeLines = 0;
    if (showInfo.codeShowStatus == 0) {
      codeLines = showInfo.codeContent.length;
    } else if (showInfo.codeShowStatus == 2) {
      codeLines = showInfo.rowCodes.length;
    } else if (showInfo.codeShowStatus == 1) {
      for (int i = 0; i < showInfo.rowCodes.length; i++) {
        if (showInfo.rowCodes[i].status != 1) {
          codeLines++;
        }
      }
    }
    return Scrollbar(
      thumbVisibility: true,
      notificationPredicate: (ScrollNotification notification) =>
          notification.depth == 1,
      key: const Key('debuggerCodeViewVerticalScrollbarKey'),
      controller: _vCtrl,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double textWidth = 0;
            if (showInfo.codeShowStatus == 0) {
              for (int i = 0; i < showInfo.codeContent.length; i++) {
                textWidth = max(
                    textWidth,
                    FunctionOne.calculateText(
                        showInfo.codeContent[i], ConstantData.textStyle[0]));
              }
            } else if (showInfo.codeShowStatus == 2 ||
                showInfo.codeShowStatus == 1) {
              for (int i = 0; i < showInfo.rowCodes.length; i++) {
                if (showInfo.codeShowStatus == 1 &&
                    showInfo.rowCodes[i].status == 1) {
                  continue;
                }
                textWidth = max(
                    textWidth,
                    FunctionOne.calculateText(
                        showInfo.rowCodes[i].text, ConstantData.textStyle[0]));
              }
            }
            return Scrollbar(
                key: const Key('debuggerCodeViewHorizontalScrollbarKey'),
                thumbVisibility: true,
                controller: _hCtrl,
                child: SingleChildScrollView(
                  controller: _hCtrl,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: constraints.maxHeight,
                    width: max(
                        textWidth + (showInfo.codeShowStatus == 2 ? 120 : 50),
                        constraints.maxWidth),
                    child: Scrollbar(
                      thumbVisibility: false,
                      notificationPredicate:
                          (ScrollNotification notification) => false,
                      controller: _vCtrl,
                      child: ListView.builder(
                        controller: _vCtrl,
                        itemCount: codeLines,
                        itemExtent: 18,
                        itemBuilder: (BuildContext context, int index) {
                          return (showInfo.codeShowStatus == 0 ||
                                  showInfo.codeShowStatus == 1)
                              ? _SimpleRowShow(
                                  text: _getRowText(showInfo, index),
                                  rowIndex: index + 1)
                              : _RowUnifiedShow(
                                  singleRowCodeInfo: showInfo.rowCodes[index]);
                        },
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  //这里为了不提前额外构建一个字符串数组，而是使用的时候再获取，有点耗费时间 时间复杂度 : n ^ 2
  String _getRowText(ShowInfo showInfo, int index) {
    if (showInfo.codeShowStatus == 0) {
      return showInfo.codeContent[index];
    }
    for (int i = 0, count = 0; i < showInfo.rowCodes.length; i++) {
      if (showInfo.rowCodes[i].status == 1) {
        continue;
      }
      if (count == index) {
        return showInfo.rowCodes[i].text;
      }
      count++;
    }
    return 'Parse error';
  }
}

class _RowUnifiedShow extends StatelessWidget {
  const _RowUnifiedShow({Key? key, required this.singleRowCodeInfo})
      : super(key: key);
  final SingleRowCodeInfo singleRowCodeInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: singleRowCodeInfo.status == 0
              ? Colors.grey[200]
              : (ConstantData.codeShowColors[singleRowCodeInfo.status + 2]),
          width: 100,
          child: Row(
            children: List.generate(3, (index) {
              if (index == 2) {
                return SizedBox(
                    width: 20,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          singleRowCodeInfo.status == 0
                              ? ''
                              : (singleRowCodeInfo.status == 1 ? '-' : '+'),
                          style: ConstantData.textStyle[0],
                        )));
              }
              return Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          '${index == 0 ? (singleRowCodeInfo.status != 2 ? singleRowCodeInfo.originIndex : '') : (singleRowCodeInfo.status != 1 ? singleRowCodeInfo.copyIndex : '')}',
                          style: ConstantData.textStyle[1])));
            }),
          ),
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.only(left: 20),
          color: singleRowCodeInfo.status == 0
              ? Colors.white
              : (ConstantData.codeShowColors[singleRowCodeInfo.status - 1]),
          child: Text(
            singleRowCodeInfo.text,
            style: ConstantData.textStyle[0],
          ),
        ))
      ],
    );
  }
}

//showInfo.codeShowStatus == 0 和 1
class _SimpleRowShow extends StatelessWidget {
  const _SimpleRowShow({Key? key, required this.text, required this.rowIndex})
      : super(key: key);
  final String text;
  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$rowIndex',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Expanded(child: EqualWidthText(text: text, characterWidth: 10))
        Expanded(child: Text(text, style: ConstantData.textStyle[0]))
      ],
    );
  }
}

// class _SimpleRowShow extends StatelessWidget {
//   const _SimpleRowShow({Key? key, required this.text, required this.rowIndex})
//       : super(key: key);
//   final String text;
//   final int rowIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 50,
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               '$rowIndex',
//               style: const TextStyle(color: Colors.grey, fontSize: 13),
//             ),
//           ),
//         ),
//         const SizedBox(width: 20),
//         Expanded(child: Text(text, style: ConstantData.textStyle[0]))
//       ],
//     );
//   }
// }
