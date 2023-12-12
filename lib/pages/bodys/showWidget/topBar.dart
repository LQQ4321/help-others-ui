import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/dialogOne.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:provider/provider.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    int curRightShowPage =
        context.watch<RootDataModel>().lendHandModel.showInfo.curRightShowPage;
    int curSeekHelpIndex =
        context.watch<RootDataModel>().seekHelpModel.curSeekHelpIndex;
    String problemLink =
        context.watch<RootDataModel>().lendHandModel.showInfo.problemLink;
    return Container(
        height: 40,
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                if (index == 1) {
                  return const SizedBox(width: 20);
                }
                return Text(
                  index == 0
                      ? (curRightShowPage < 0
                          ? context
                              .watch<RootDataModel>()
                              .seekHelpModel
                              .showSeekHelpList[curSeekHelpIndex]
                              .uploadTime
                          : context
                              .watch<RootDataModel>()
                              .lendHandModel
                              .showLendHandList[curRightShowPage]
                              .uploadTime)
                      : (curRightShowPage < 0
                          ? (context
                                      .watch<RootDataModel>()
                                      .seekHelpModel
                                      .showSeekHelpList[curSeekHelpIndex]
                                      .status ==
                                  0
                              ? 'Unsolved'
                              : 'Resolved')
                          : (context
                                      .watch<RootDataModel>()
                                      .lendHandModel
                                      .showLendHandList[curRightShowPage]
                                      .status ==
                                  0
                              ? 'Not adopted'
                              : 'Adopted')),
                  style: const TextStyle(color: Colors.black38),
                );
              }),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(ConstantData.showRouteTopBarIcons.length,
                  (index) {
                return ClipOval(
                    child: Center(
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Builder(//套一层，免得ToastOne.smallTip定位不到具体的位置
                              builder: (context) {
                                return TextButton(
                                    onPressed: () async {
                                      if (index == 0) {
                                        ToastOne.smallTip(context, 'Copied');
                                        Clipboard.setData(
                                            ClipboardData(text: problemLink));
                                      } else if (index == 1) {
                                        DialogOne.showAPicture(
                                            context,
                                            context
                                                .read<RootDataModel>()
                                                .lendHandModel
                                                .showInfo
                                                .imageProvider);
                                      } else if (index == 2) {
                                        DialogOne.showTextField(
                                            context,
                                            context
                                                .read<RootDataModel>()
                                                .lendHandModel
                                                .showInfo
                                                .remark);
                                      } else if (index == 3) {
                                        setState(() {
                                          _favorite = !_favorite;
                                        });
                                      } else {}
                                    },
                                    child: Icon(
                                      index == 3 && !_favorite
                                          ? Icons.favorite_border
                                          : ConstantData
                                              .showRouteTopBarIcons[index],
                                      color: index == 3 && _favorite
                                          ? Colors.red[200]
                                          : Colors.black12,
                                      size: 20,
                                    ));
                              },
                            ))));
              }),
            )
          ],
        ));
  }
}
