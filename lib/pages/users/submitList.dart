import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/macroUserData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:provider/provider.dart';

class UserSubmitList extends StatefulWidget {
  const UserSubmitList({Key? key}) : super(key: key);

  @override
  State<UserSubmitList> createState() => _UserSubmitListState();
}

class _UserSubmitListState extends State<UserSubmitList> {
  bool _isSeekHelp = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 50,
            child: Row(
              children: [
                const SizedBox(width: 20),
                const Text('Seek help'),
                const SizedBox(width: 10),
                Switch(
                    value: _isSeekHelp,
                    activeColor: Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        _isSeekHelp = !_isSeekHelp;
                      });
                    }),
                const SizedBox(width: 10),
                const Text('Lend hand'),
              ],
            )),
        const SizedBox(height: 10),
        Expanded(child: _isSeekHelp ? const _SeekHelpList() : Container())
      ],
    );
  }
}

class _SeekHelpList extends StatefulWidget {
  const _SeekHelpList({Key? key}) : super(key: key);

  @override
  State<_SeekHelpList> createState() => _SeekHelpListState();
}

class _SeekHelpListState extends State<_SeekHelpList> {
  @override
  Widget build(BuildContext context) {
    Contributions contributions = context.watch<RootDataModel>().contributions;
    List<UserSeekHelp> showUserSeekHelpList = contributions.seekHelpFilter();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          const _SeekHelpListTopBar(),
          Expanded(
              child: ListView.builder(
                  itemExtent: 50,
                  itemCount: showUserSeekHelpList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _SeekHelpListBody(
                      userSeekHelp: showUserSeekHelpList[index],
                    );
                  }))
        ],
      ),
    );
  }
}

class _SeekHelpListTopBar extends StatefulWidget {
  const _SeekHelpListTopBar({Key? key}) : super(key: key);

  @override
  State<_SeekHelpListTopBar> createState() => _SeekHelpListTopBarState();
}

class _SeekHelpListTopBarState extends State<_SeekHelpListTopBar> {
  @override
  Widget build(BuildContext context) {
    Contributions contributions = context.watch<RootDataModel>().contributions;
    return Container(
      height: 50,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
          children:
              List.generate(ConstantData.seekHelpOptionList.length, (index) {
        return Expanded(
            child: Align(
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            if (index > 0 && index < 4) {
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: 130,
                child: ElevatedButton(
                    onPressed: () async {
                      await context
                          .read<RootDataModel>()
                          .contributionOperate(2, numList: [index, 0]);
                    },
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity, 40)),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blueGrey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(index == 1
                            ? 'Score'
                            : (index == 2)
                                ? 'Like'
                                : 'Date'),
                        Icon(contributions.seekHelpIsHigh(index)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    )),
              );
            }
            return SizedBox(
              width: 130,
              child: MyPopupMenu(
                  list: ConstantData.seekHelpOptionList[index],
                  iconData: Icons.sort,
                  callBack: (a) async {
                    await context
                        .read<RootDataModel>()
                        .contributionOperate(2, numList: [index, a]);
                  }),
            );
          }),
        ));
      })),
    );
  }
}

class _SeekHelpListBody extends StatefulWidget {
  const _SeekHelpListBody({Key? key, required this.userSeekHelp})
      : super(key: key);
  final UserSeekHelp userSeekHelp;

  @override
  State<_SeekHelpListBody> createState() => _SeekHelpListBodyState();
}

class _SeekHelpListBodyState extends State<_SeekHelpListBody> {
  @override
  Widget build(BuildContext context) {
    String parseValue(int option) {
      if (option == 0) {
        return widget.userSeekHelp.status == 0 ? 'Unsolved' : 'Resolved';
      } else if (option == 1) {
        return widget.userSeekHelp.score.toString();
      } else if (option == 2) {
        return widget.userSeekHelp.like.toString();
      } else if (option == 3) {
        return widget.userSeekHelp.uploadTime;
      }
      return widget.userSeekHelp.language;
    }

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                  const Size(double.infinity, double.infinity))),
          child: Row(
            children:
                List.generate(ConstantData.seekHelpOptionList.length, (index) {
              return Expanded(child: Center(child: Text(parseValue(index))));
            }),
          )),
    );
  }
}
