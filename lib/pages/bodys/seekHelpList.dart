import 'package:flutter/material.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';

class SeekHelpList extends StatelessWidget {
  const SeekHelpList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(),
        const SizedBox(height: 20),
        Expanded(child: _Body())
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
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Seek help list',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 20)),
        const SizedBox(width: 50),
        SizedBox(
          width: 200,
          height: 40,
          child: FilletCornerInput(
              textEditingController: _textEditingController,
              callBack: (a) {},
              hintText: 'Search help seeker'),
        ),
        const SizedBox(width: 50),
        SizedBox(
          width: 150,
          height: 35,
          child: MyPopupMenu(
              list: const ['All', 'Resolved', 'Unsolved'], callBack: (a) {}),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 150,
          height: 35,
          child: MyPopupMenu(
              list: const ['High score', 'Low score'],
              iconData: Icons.sort,
              callBack: (a) {}),
        ),
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
          _BodyTopTitle(),
          Expanded(child: _BodyInternalList()),
        ],
      ),
    );
  }
}

class _BodyTopTitle extends StatelessWidget {
  _BodyTopTitle({Key? key}) : super(key: key);

  List<String> titleList = ['Status', 'Score', 'Like', 'Help time', 'Language'];
  List<int> proportion = [4, 3, 3, 5, 3];

  @override
  Widget build(BuildContext context) {
    if (false) {
      //  如果是管理员
      titleList.addAll(['']);
    }
    return Container(
      height: 40,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Container(
            width: 150,
            height: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black12))),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Help seeker',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding:
                const EdgeInsets.only(right: 25, left: 10, top: 10, bottom: 10),
            child: Row(
              children: List.generate(titleList.length, (index) {
                return Expanded(
                  flex: proportion[index],
                  child: Text(
                    titleList[index],
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                );
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
  List<String> titleList = ['Status', 'Score', 'Like', 'Help time', 'Language'];
  List<int> proportion = [4, 3, 3, 5, 3];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 60,
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.black12))),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Help seeker',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(
                      right: 25, left: 10, top: 10, bottom: 10),
                  child: Row(
                    children: List.generate(titleList.length, (index) {
                      return Expanded(
                        flex: proportion[index],
                        child: Text(
                          titleList[index],
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      );
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
        itemCount: 10);
  }
}
