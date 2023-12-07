import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:help_them/pages/bodys/seekAHelp.dart';
import 'package:help_them/pages/bodys/seekHelpList.dart';
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
              const EdgeInsets.only(right: 50, left: 50, top: 20, bottom: 20),
          child: Builder(
            builder: (BuildContext context) {
              int pageId = context.watch<RootDataModel>().userData.pageId;
              if (pageId == 1) {
                return const SeekHelpList();
              } else if (pageId == 2) {
                return const SeekAHelp();
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
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const SizedBox(width: 20),
                Text(
                  'help others',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(120, 40)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey[200]!)),
              child: Text(
                '2023-07-10',
                style: const TextStyle(color: Colors.black45),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      Config.selectAFile(['png', 'jpg', 'jpeg']);
                      // Config.selectAFile(['go', 'c', 'c++']);
                      // context.read<SeekHelpModel>().requestSeekHelpList();
                    },
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
