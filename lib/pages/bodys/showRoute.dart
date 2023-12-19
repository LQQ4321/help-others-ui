import 'package:flutter/material.dart';
import 'package:help_them/data/lendHand.dart';
import 'package:help_them/data/macroLendHand.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/pages/bodys/showWidget/codeshow.dart';
import 'package:help_them/pages/bodys/showWidget/topBar.dart';
import 'package:provider/provider.dart';

class ShowRoute extends StatelessWidget {
  const ShowRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _LeftBar(),
        const SizedBox(width: 20),
        Expanded(
            child: Column(
          children: [
            Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: const CodeShowTopBar()),
            const SizedBox(height: 20),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: const CodeShow()))
          ],
        ))
      ],
    );
  }
}

class _LeftBar extends StatefulWidget {
  const _LeftBar({Key? key}) : super(key: key);

  @override
  State<_LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<_LeftBar> {
  @override
  Widget build(BuildContext context) {
    LendHandModel lendHandModel = context.watch<RootDataModel>().lendHandModel;
    ShowInfo showInfo = context.watch<RootDataModel>().showInfo;
    return Container(
      width: 180,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                bool flag = await context
                    .read<RootDataModel>()
                    .showOperate(1, list: [-1]);
                if (!flag) {
                  ToastOne.oneToast([
                    'Request data fail',
                    'The network is disconnected or the back-end is faulty.'
                  ], duration: 10);
                }
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(160, 50)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey[200]!)),
              child: const Text(
                'Seek help',
                style: TextStyle(color: Colors.black45),
              )),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 10),
          const Text('Sort by like',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Expanded(
              child: lendHandModel.showLendHandList.isEmpty
                  ? const Center(
                      child: Text(
                        'No helper',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                            fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemExtent: 50,
                      itemCount: lendHandModel.showLendHandList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                            onPressed: () async {
                              bool flag = await context
                                  .read<RootDataModel>()
                                  .showOperate(1, list: [index]);
                              if (!flag) {
                                ToastOne.oneToast([
                                  'Request data fail',
                                  'The network is disconnected or the back-end is faulty.'
                                ], duration: 10);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        showInfo.curRightShowPage == index
                                            ? Colors.grey[200]!
                                            : Colors.white)),
                            child: Text('${index + 1}',
                                style: const TextStyle(color: Colors.grey)));
                      })),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                //在帮助之前应该先判断一下求助和帮助的是不是同一个人
                bool flag = await context.read<RootDataModel>().userOperate(4);
                if (!flag) {
                  ToastOne.oneToast([
                    'Lend hand fail',
                    'The help-seeker and the helper cannot be the same person.'
                  ], duration: 10);
                  return;
                }
                await context
                    .read<RootDataModel>()
                    .userOperate(2, numList: [4]);
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(160, 50)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey[200]!)),
              child: const Text(
                'Help others',
                style: TextStyle(color: Colors.black45),
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
