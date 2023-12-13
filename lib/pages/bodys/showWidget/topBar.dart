import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/lendHand.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:help_them/macroWidgets/dialogOne.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:provider/provider.dart';

class SeekHelpTopBar extends StatefulWidget {
  const SeekHelpTopBar({Key? key}) : super(key: key);

  @override
  State<SeekHelpTopBar> createState() => _SeekHelpTopBarState();
}

class _SeekHelpTopBarState extends State<SeekHelpTopBar> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    LendHandModel lendHandModel = context.watch<RootDataModel>().lendHandModel;
    SeekHelpModel seekHelpModel = context.watch<RootDataModel>().seekHelpModel;
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
                      ? seekHelpModel
                          .showSeekHelpList[seekHelpModel.curSeekHelpIndex]
                          .uploadTime
                      : (seekHelpModel
                                  .showSeekHelpList[
                                      seekHelpModel.curSeekHelpIndex]
                                  .status ==
                              0
                          ? 'Unsolved'
                          : 'Resolved'),
                  style: const TextStyle(color: Colors.black38),
                );
              }),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(ConstantData.showRouteTopBarIcons.length,
                  (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                        child: Center(
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Builder(
                                  //套一层，免得ToastOne.smallTip定位不到具体的位置
                                  builder: (context) {
                                    return TextButton(
                                        onPressed: () async {
                                          if (index == 0) {
                                            ToastOne.smallTip(
                                                context, 'Copied');
                                            Clipboard.setData(ClipboardData(
                                                text: lendHandModel
                                                    .showInfo.problemLink));
                                          } else if (index == 1) {
                                            DialogOne.showAPicture(
                                                context,
                                                lendHandModel
                                                    .showInfo.imageProvider);
                                          } else if (index == 2) {
                                            DialogOne.showTextField(context,
                                                lendHandModel.showInfo.remark);
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
                                )))),
                    index < 3
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  index == 0
                                      ? 'Link'
                                      : (index == 1 ? 'Screenshot' : 'Remark'),
                                  style:
                                      const TextStyle(color: Colors.black38)),
                              const SizedBox(width: 5)
                            ],
                          )
                        : Container()
                  ],
                );
              }),
            )
          ],
        ));
  }
}

class LendHandTopBar extends StatefulWidget {
  const LendHandTopBar({Key? key}) : super(key: key);

  @override
  State<LendHandTopBar> createState() => _LendHandTopBarState();
}

class _LendHandTopBarState extends State<LendHandTopBar> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    LendHandModel lendHandModel = context.watch<RootDataModel>().lendHandModel;
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
                      ? lendHandModel
                          .showLendHandList[
                              lendHandModel.showInfo.curRightShowPage]
                          .uploadTime
                      : (lendHandModel
                                  .showLendHandList[
                                      lendHandModel.showInfo.curRightShowPage]
                                  .status ==
                              0
                          ? 'Not adopted'
                          : 'Adopted'),
                  style: const TextStyle(color: Colors.black38),
                );
              }),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  ConstantData.showRouteTopBarIcons.length - 3, (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                        child: Center(
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Builder(
                                  builder: (context) {
                                    return TextButton(
                                        onPressed: () async {
                                          if (index == 0) {
                                            setState(() {
                                              _favorite = !_favorite;
                                            });
                                          } else {}
                                        },
                                        child: Icon(
                                          index == 0 && !_favorite
                                              ? Icons.favorite_border
                                              : ConstantData
                                                      .showRouteTopBarIcons[
                                                  index + 3],
                                          color: index == 0 && _favorite
                                              ? Colors.red[200]
                                              : Colors.black12,
                                          size: 20,
                                        ));
                                  },
                                ))))
                  ],
                );
              }),
            )
          ],
        ));
  }
}
