import 'package:flutter/material.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/dialogOne.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/pages/bodys/seekAHelp.dart';
import 'package:help_them/pages/bodys/seekHelpList.dart';
import 'package:help_them/pages/bodys/showRoute.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopBar(),
        Expanded(
            child: Container(
          color: const Color(0xfff6f6f6),
          padding:
              const EdgeInsets.only(right: 40, left: 40, top: 20, bottom: 20),
          child: Builder(
            builder: (BuildContext context) {
              int pageId = context.watch<RootDataModel>().userData.pageId;
              if (pageId == 1) {
                return const SeekHelpList();
              } else if (pageId == 2) {
                return const SeekAHelp(isSeekHelp: true);
              } else if (pageId == 3) {
                return const ShowRoute();
              } else if (pageId == 4) {
                return const SeekAHelp(isSeekHelp: false);
              }
              return Container();
            },
          ),
        ))
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xffe7e8ec), width: 1.0))),
      child: Stack(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Row(children: [
                SizedBox(width: 20),
                Text(
                  'help others',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                )
              ])),
          Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () async {
                    String selectDate =
                        context.read<RootDataModel>().seekHelpModel.currentDate;
                    bool isConfirm = false;
                    await DialogOne.timeSelectDialog(context, selectDate, [
                      (a) {
                        selectDate = a;
                      },
                      (a) {
                        isConfirm = a;
                      }
                    ]);
                    if (!isConfirm) {
                      return;
                    }
                    bool flag = await context
                        .read<RootDataModel>()
                        .seekHelp(4, texts: [selectDate]);
                    if (!flag) {
                      ToastOne.oneToast([
                        'Request data fail',
                        'This could be due to network problems or server errors.'
                      ]);
                    }
                  },
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(120, 40)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey[200]!)),
                  child: Text(
                      context.watch<RootDataModel>().seekHelpModel.currentDate,
                      style: const TextStyle(color: Colors.black45)))),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {},
                    splashRadius: 20,
                    icon: const Icon(Icons.person_outline)),
                const SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
