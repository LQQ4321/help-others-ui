import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_them/data/macroLendHand.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/pages/bodys/showWidget/codeHighLight.dart';
import 'package:provider/provider.dart';

class CodeShow extends StatefulWidget {
  const CodeShow({Key? key}) : super(key: key);

  @override
  State<CodeShow> createState() => _CodeShowState();
}

class _CodeShowState extends State<CodeShow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8), topLeft: Radius.circular(8))),
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: const _TopBar(),
        ),
        Container(height: 1, color: Colors.black12),
        const Expanded(child: CodeHighLight())
      ],
    );
  }
}

class _TopBar extends StatefulWidget {
  const _TopBar({Key? key}) : super(key: key);

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  @override
  Widget build(BuildContext context) {
    ShowInfo showInfo = context.watch<RootDataModel>().showInfo;
    bool isSeekHelp = showInfo.curRightShowPage < 0;
    int codeShowStatus = showInfo.codeShowStatus;
    int codeLines = 0;
    String codeText = '';
    if (isSeekHelp) {
      codeLines = showInfo.codeContent.length;
      codeText = showInfo.codeContent.join('\n');
    } else {
      if (showInfo.rowCodes.isEmpty) {
        codeText = 'The modified file is the same as the original file';
      }
      for (int i = 0; i < showInfo.rowCodes.length; i++) {
        if (showInfo.rowCodes[i].status == 1) {
          continue;
        }
        codeText += '${showInfo.rowCodes[i].text}\n';
      }
      if (codeShowStatus == 1) {
        for (int i = 0; i < showInfo.rowCodes.length; i++) {
          if (showInfo.rowCodes[i].status != 1) {
            codeLines++;
          }
        }
      } else {
        codeLines = showInfo.rowCodes.length;
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$codeLines lines', style: const TextStyle(color: Colors.grey)),
        isSeekHelp
            ? Container()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 50),
                  const Text('Unified', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 10),
                  Switch(
                      value: showInfo.codeShowStatus == 1,
                      activeColor: Colors.black45,
                      onChanged: (value) async {
                        await context
                            .read<RootDataModel>()
                            .showOperate(2, list: [(value ? 1 : 2)]);
                      }),
                  const SizedBox(width: 10),
                  const Text('Only succor',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 50),
                ],
              ),
        ClipOval(
            child: Center(
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Builder(
                      builder: (context) {
                        return TextButton(
                            onPressed: () async {
                              ToastOne.smallTip(context, 'Copied');
                              Clipboard.setData(ClipboardData(text: codeText));
                            },
                            child: const Icon(Icons.copy,
                                size: 20, color: Colors.grey));
                      },
                    ))))
      ],
    );
  }
}
