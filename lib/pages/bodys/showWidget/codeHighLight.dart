import 'dart:math';

import 'package:flutter/material.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/macroLendHand.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:help_them/functions/functionOne.dart';
import 'package:provider/provider.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

class CodeHighLight extends StatefulWidget {
  const CodeHighLight({Key? key}) : super(key: key);

  @override
  State<CodeHighLight> createState() => _CodeHighLightState();
}

class _CodeHighLightState extends State<CodeHighLight> {
  late ScrollController verticalScroll;
  late ScrollController horizontalScroll;
  final double width = 10;

  @override
  void initState() {
    verticalScroll = ScrollController();
    horizontalScroll = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    verticalScroll.dispose();
    horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //这些复杂数据类型应该都是引用
    ShowInfo showInfo = context.watch<RootDataModel>().showInfo;
    SeekHelpModel seekHelpModel = context.watch<RootDataModel>().seekHelpModel;
    String language = seekHelpModel.singleSeekHelp.language;
    language = language[0].toLowerCase() + language.substring(1);
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
    return LayoutBuilder(
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
        return AdaptiveScrollbar(
            controller: verticalScroll,
            width: width,
            scrollToClickDelta: 75,
            scrollToClickFirstDelay: 200,
            scrollToClickOtherDelay: 50,
            sliderSpacing: const EdgeInsets.all(0),
            sliderDecoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            sliderActiveDecoration: const BoxDecoration(
                color: Color.fromRGBO(206, 206, 206, 100),
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            underColor: Colors.transparent,
            child: AdaptiveScrollbar(
                underSpacing: EdgeInsets.only(bottom: width),
                controller: horizontalScroll,
                width: width,
                position: ScrollbarPosition.bottom,
                sliderDecoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(0.0))),
                sliderActiveDecoration: const BoxDecoration(
                    color: Color.fromRGBO(206, 206, 206, 100),
                    borderRadius: BorderRadius.all(Radius.circular(0.0))),
                underColor: Colors.transparent,
                child: SingleChildScrollView(
                    controller: horizontalScroll,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                        width: max(
                            textWidth +
                                (showInfo.codeShowStatus == 0 ||
                                        showInfo.codeShowStatus == 1
                                    ? 70
                                    : 120),
                            constraints.maxWidth),
                        child: ListView.builder(
                            controller: verticalScroll,
                            itemCount: codeLines,
                            itemExtent: 20,
                            itemBuilder: (BuildContext context, int index) {
                              return (showInfo.codeShowStatus == 0 ||
                                      showInfo.codeShowStatus == 1)
                                  ? _SimpleRowShow(
                                      text: _getRowText(showInfo, index),
                                      rowIndex: index + 1,
                                      lang: language)
                                  : _RowUnifiedShow(
                                      singleRowCodeInfo:
                                          showInfo.rowCodes[index],
                                      lang: language);
                            })))));
      },
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
  const _RowUnifiedShow(
      {Key? key, required this.singleRowCodeInfo, required this.lang})
      : super(key: key);
  final SingleRowCodeInfo singleRowCodeInfo;
  final String lang;

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
          height: double.infinity,
          padding: const EdgeInsets.only(left: 20),
          color: singleRowCodeInfo.status == 0
              ? Colors.white
              : (ConstantData.codeShowColors[singleRowCodeInfo.status - 1]),
          child: HighlightView(
            singleRowCodeInfo.text,
            language: lang,
            theme:
                FunctionOne.getCodeTextStyle(option: singleRowCodeInfo.status),
            textStyle: ConstantData.textStyle[0],
          ),
        ))
      ],
    );
  }
}

//showInfo.codeShowStatus == 0 和 1
class _SimpleRowShow extends StatelessWidget {
  const _SimpleRowShow(
      {Key? key,
      required this.text,
      required this.rowIndex,
      required this.lang})
      : super(key: key);
  final String text;
  final int rowIndex;
  final String lang;

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
        Expanded(
            child: HighlightView(
          text,
          language: lang,
          theme: FunctionOne.getCodeTextStyle(),
          textStyle: ConstantData.textStyle[0],
        ))
      ],
    );
  }
}
