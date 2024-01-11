import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:help_them/functions/functionOne.dart';
import 'package:help_them/functions/functionTwo.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:provider/provider.dart';

class SeekHelpList extends StatelessWidget {
  const SeekHelpList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [_TopBar(), SizedBox(height: 20), Expanded(child: _Body())],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Seek help list',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 20)),
        ClipOval(
          child: Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: TextButton(
                  onPressed: () async {
                    await context
                        .read<RootDataModel>()
                        .userOperate(2, numList: [2]);
                  },
                  child: const Icon(
                    Icons.add_box,
                    color: Colors.black38,
                  )),
            ),
          ),
        )
      ],
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          const _BodyTopTitle(),
          Expanded(
              child: context
                      .watch<RootDataModel>()
                      .seekHelpModel
                      .showSeekHelpList
                      .isEmpty
                  ? const Center(
                      child: Text(
                        'No call for help today',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : const _BodyInternalList()),
        ],
      ),
    );
  }
}

class _BodyTopTitle extends StatelessWidget {
  const _BodyTopTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> proportion = ConstantData.seekHelpProportion;
    if (context.watch<RootDataModel>().userData.isManager) {
      proportion = ConstantData.seekHelpManagerProportion;
    }
    return Container(
      height: 50,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Container(
            width: 150,
            height: double.infinity,
            padding: const EdgeInsets.all(10),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Help seeker',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(width: 1, color: Colors.black12),
          Expanded(
              child: Container(
            padding:
                const EdgeInsets.only(right: 25, left: 10, top: 10, bottom: 10),
            child: Row(
              children: List.generate(proportion.length, (index) {
                return Expanded(
                    flex: proportion[index],
                    child: Builder(
                      builder: (context) {
                        if (index > 4) {
                          return const Center(
                            child: Text('Ban',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          );
                        }
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 130,
                            child: MyPopupMenu(
                                list: ConstantData.seekHelpOptionList[index],
                                iconData: Icons.sort,
                                selected: context
                                            .watch<RootDataModel>()
                                            .seekHelpModel
                                            .filterOrder +
                                        1 ==
                                    index,
                                callBack: (a) {
                                  context
                                      .read<RootDataModel>()
                                      .seekHelp(3, list1: [index, a]);
                                }),
                          ),
                        );
                      },
                    ));
              }),
            ),
          ))
        ],
      ),
    );
  }
}

class _BodyInternalList extends StatefulWidget {
  const _BodyInternalList({Key? key}) : super(key: key);

  @override
  State<_BodyInternalList> createState() => _BodyInternalListState();
}

class _BodyInternalListState extends State<_BodyInternalList> {
  @override
  Widget build(BuildContext context) {
    List<int> proportion = ConstantData.seekHelpProportion;
    if (context.watch<RootDataModel>().userData.isManager) {
      proportion = ConstantData.seekHelpManagerProportion;
    }
    return ListView.separated(
        itemBuilder: (BuildContext context, int rowIndex) {
          SingleSeekHelp singleSeekHelp = context
              .watch<RootDataModel>()
              .seekHelpModel
              .showSeekHelpList[rowIndex];
          return SizedBox(
            height: 60,
            child: Row(
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey[300]!),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                    ),
                    onPressed: () async {
                      bool flag = await context
                          .read<RootDataModel>()
                          .lendHand(1, list: [rowIndex]);
                      if (!flag) {
                        ToastOne.oneToast([
                          'Request data fail',
                          'This could be due to network problems or server errors.'
                        ]);
                      }
                    },
                    child: Container(
                        width: 150,
                        height: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(singleSeekHelp.seekHelperName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13))))),
                Container(width: 1, color: Colors.black12),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(
                      right: 25, left: 10, top: 10, bottom: 10),
                  child: Row(
                    children: List.generate(proportion.length, (index) {
                      return Expanded(
                          flex: proportion[index],
                          child: Builder(builder: (BuildContext context) {
                            if (index <= 4) {
                              return Text(
                                FunctionOne.parseSeekHelpListData(
                                    index, singleSeekHelp),
                                maxLines: 1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 13),
                              );
                            }
                            return Switch(
                                value: singleSeekHelp.ban == 1,
                                activeColor: Colors.redAccent,
                                onChanged: (value) async {
                                  bool flag = await context
                                      .read<RootDataModel>()
                                      .seekHelp(5, list1: [rowIndex]);
                                  if (!flag) {
                                    ToastOne.oneToast(
                                        ErrorParse.getErrorMessage(1));
                                  }
                                });
                          }));
                    }),
                  ),
                ))
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 1, color: Colors.black12);
        },
        itemCount: context
            .watch<RootDataModel>()
            .seekHelpModel
            .showSeekHelpList
            .length);
  }
}
