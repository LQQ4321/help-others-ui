import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/macroLendHand.dart';
import 'package:help_them/data/macroUserData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:help_them/functions/functionTwo.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:provider/provider.dart';

class UserLendHandList extends StatefulWidget {
  const UserLendHandList({Key? key}) : super(key: key);

  @override
  State<UserLendHandList> createState() => _UserLendHandListState();
}

class _UserLendHandListState extends State<UserLendHandList> {
  @override
  Widget build(BuildContext context) {
    Contributions contributions = context.watch<RootDataModel>().contributions;
    List<dynamic> tempList = contributions.lendHandFilter();
    //FIXME 这里可能还是有问题的，因为其实SingleLendHand和SingleSeekHelp还没有解析
    List<dynamic> lendHandList = tempList[0];
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          const _LendHandListTopBar(),
          Expanded(
              child: ListView.builder(
                  itemExtent: 50,
                  itemCount: lendHandList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _LendHandListBody(
                        //不懂能不能直接转换
                        // singleLendHand: tempList[0][index],
                        singleLendHand: lendHandList[index],
                        singleSeekHelp: tempList[1][index],
                        listId: index);
                  }))
        ],
      ),
    );
  }
}

class _LendHandListTopBar extends StatefulWidget {
  const _LendHandListTopBar({Key? key}) : super(key: key);

  @override
  State<_LendHandListTopBar> createState() => _LendHandListTopBarState();
}

class _LendHandListTopBarState extends State<_LendHandListTopBar> {
  @override
  Widget build(BuildContext context) {
    Contributions contributions = context.watch<RootDataModel>().contributions;
    return Container(
      height: 50,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
          children: List.generate(ConstantData.seekHelpOptionList.length + 1,
              (index) {
        return Expanded(child: Center(
          child: Builder(builder: (context) {
            if (index == 0) {
              return const Text('Help seeker');
            }
            if (index > 1 && index < 5) {
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: 130,
                child: ElevatedButton(
                    onPressed: () async {
                      await context
                          .read<RootDataModel>()
                          .contributionOperate(3, numList: [index, 0]);
                    },
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity, 40)),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blueGrey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(index == 2
                            ? 'Score'
                            : (index == 3)
                                ? 'Like'
                                : 'Date'),
                        Icon(contributions.lendHandIsHigh(index - 1)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    )),
              );
            }
            return SizedBox(
              width: 130,
              child: MyPopupMenu(
                  list: ConstantData.seekHelpOptionList[index - 1],
                  iconData: Icons.sort,
                  callBack: (a) async {
                    await context
                        .read<RootDataModel>()
                        .contributionOperate(3, numList: [index, a]);
                  }),
            );
          }),
        ));
      })),
    );
  }
}

class _LendHandListBody extends StatefulWidget {
  const _LendHandListBody(
      {Key? key,
      required this.singleLendHand,
      required this.singleSeekHelp,
      required this.listId})
      : super(key: key);
  final SingleLendHand singleLendHand;
  final SingleSeekHelp singleSeekHelp;
  final int listId;

  @override
  State<_LendHandListBody> createState() => _LendHandListBodyState();
}

class _LendHandListBodyState extends State<_LendHandListBody> {
  @override
  Widget build(BuildContext context) {
    String parseValue(int option) {
      if (option == 0) {
        return widget.singleSeekHelp.seekHelperName;
      } else if (option == 1) {
        return widget.singleLendHand.status == 0 ? 'Not adopted' : 'Adopted';
      } else if (option == 2) {
        return widget.singleSeekHelp.score.toString();
      } else if (option == 3) {
        return widget.singleLendHand.like.toString();
      } else if (option == 4) {
        return widget.singleLendHand.uploadTime;
      }
      return widget.singleSeekHelp.language;
    }

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: TextButton(
          onPressed: () async {
            bool flag = await context
                .read<RootDataModel>()
                .lendHand(5, list: [widget.listId]);
            if (!flag) {
              ToastOne.oneToast(ErrorParse.getErrorMessage(1));
            }
          },
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                  const Size(double.infinity, double.infinity))),
          child: Row(
            children: List.generate(ConstantData.seekHelpOptionList.length + 1,
                (index) {
              return Expanded(child: Center(child: Text(parseValue(index))));
            }),
          )),
    );
  }
}
