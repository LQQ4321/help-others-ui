import 'package:flutter/material.dart';
import 'package:help_them/data/others/userRank.dart';
import 'package:provider/provider.dart';

const List<int> _proportion = [1, 2, 2, 2, 2, 3];

class UserRankRoute extends StatelessWidget {
  const UserRankRoute({Key? key}) : super(key: key);

  static const List<String> _titles = [
    'Rank',
    'Name',
    'Score',
    'Seek help',
    'Lend hand',
    'Register time'
  ];

  @override
  Widget build(BuildContext context) {
    UserRank userRank = context.watch<UserRank>();
    return SizedBox(
      width: 800,
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8), topLeft: Radius.circular(8))),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: List.generate(_proportion.length, (index) {
                return Expanded(
                    flex: _proportion[index],
                    child: Center(
                      child: Text(_titles[index]),
                    ));
              }),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: userRank.userRankList.length,
                  itemExtent: 40,
                  itemBuilder: (BuildContext context, int index) {
                    return _UserRankItem(
                        userRankItem: userRank.userRankList[index],
                        rowId: index);
                  }))
        ],
      ),
    );
  }
}

class _UserRankItem extends StatelessWidget {
  const _UserRankItem(
      {Key? key, required this.userRankItem, required this.rowId})
      : super(key: key);
  final UserRankItem userRankItem;
  final int rowId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: rowId % 2 == 0 ? Colors.grey[200] : Colors.black12,
      child: Row(
        children: List.generate(_proportion.length, (index) {
          return Expanded(
              flex: _proportion[index],
              child: Center(
                child: Text(_parse(index, userRankItem)),
              ));
        }),
      ),
    );
  }

  String _parse(int columnId, UserRankItem userRankItem) {
    if (columnId == 0) {
      return userRankItem.rankId.toString();
    } else if (columnId == 1) {
      return userRankItem.name;
    } else if (columnId == 2) {
      return userRankItem.score.toString();
    } else if (columnId == 3) {
      return userRankItem.seekHelpNum.toString();
    } else if (columnId == 4) {
      return userRankItem.lendHandNum.toString();
    }
    return userRankItem.registerTime;
  }
}
