import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:provider/provider.dart';

class ShowRoute extends StatelessWidget {
  const ShowRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _LeftBar(),
        SizedBox(width: 20),
        Expanded(child: _RightBody())
      ],
    );
  }
}

class _RightBody extends StatefulWidget {
  const _RightBody({Key? key}) : super(key: key);

  @override
  State<_RightBody> createState() => _RightBodyState();
}

class _RightBodyState extends State<_RightBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: ListView(
          padding: const EdgeInsets.only(left: 3, right: 15, top: 3, bottom: 3),
          children: [
            _TopBar(),
            _ContentBody(),
          ]),
    );
  }
}

class _ContentBody extends StatefulWidget {
  const _ContentBody({Key? key}) : super(key: key);

  @override
  State<_ContentBody> createState() => _ContentBodyState();
}

class _ContentBodyState extends State<_ContentBody> {
  int _option = 1;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
          height: 50,
          child: Row(
            children: [
              ClipOval(
                  child: Center(
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  if (_option == 1) {
                                    _option = 2;
                                  } else {
                                    _option = 1;
                                  }
                                });
                              },
                              child: const Icon(Icons.copy,
                                  color: Colors.grey))))),
              Expanded(
                  child: Text('Problem link : ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey)))
            ],
          )),
      const SizedBox(height: 20),
      Container(
        width: double.infinity,
        child: Image(
            fit: BoxFit.fitWidth,
            image: NetworkImage(Config.requestGet,
                headers: {'requestType': 'downloadFile', 'filePath': ''})),
      ),
    ]);
  }
}

class _TopBar extends StatefulWidget {
  const _TopBar({Key? key}) : super(key: key);

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        margin: const EdgeInsets.all(10),
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
                  index == 0 ? '2023-10-10 09:56' : 'Resolved',
                  style: const TextStyle(color: Colors.black38),
                );
              }),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(2, (index) {
                return ClipOval(
                    child: Center(
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: TextButton(
                                onPressed: () async {
                                  if (index == 0) {
                                    setState(() {
                                      _favorite = !_favorite;
                                    });
                                  }
                                },
                                child: Icon(
                                  index == 0
                                      ? (_favorite
                                          ? Icons.favorite
                                          : Icons.favorite_border)
                                      : Icons.messenger,
                                  color: (index == 0
                                      ? (_favorite
                                          ? Colors.red[100]
                                          : Colors.black12)
                                      : Colors.black12),
                                )))));
              }),
            )
          ],
        ));
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
    return Container(
      width: 180,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                const SizedBox(width: 5),
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.person)),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(1, (index) {
                    if (index == 1) {
                      return const SizedBox(height: 5);
                    }
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        index == 0
                            ? context
                                .watch<RootDataModel>()
                                .seekHelpModel
                                .showSeekHelpList[context
                                    .watch<RootDataModel>()
                                    .seekHelpModel
                                    .curSeekHelpIndex]
                                .seekHelperName
                            : 'score : 100',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: index == 0 ? Colors.black : Colors.grey,
                            fontWeight:
                                index == 0 ? FontWeight.w600 : FontWeight.w500,
                            fontSize: index == 0 ? 16 : 13),
                      ),
                    );
                  }),
                ))
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                context.read<RootDataModel>().lendHand(2,list: [-1]);
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
              child: context
                      .watch<RootDataModel>()
                      .lendHandModel
                      .showLendHandList
                      .isEmpty
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
                      itemCount: context
                          .watch<RootDataModel>()
                          .lendHandModel
                          .showLendHandList
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                            onPressed: () async {
                              bool flag = await context
                                  .read<RootDataModel>()
                                  .lendHand(2, list: [index]);
                              if (!flag) {
                                ToastOne.oneToast([
                                  'Request data fail',
                                  'The network is disconnected or the back-end is faulty.'
                                ], duration: 10);
                              }
                            },
                            child: Text('$index',
                                style: const TextStyle(color: Colors.grey)));
                      }))
        ],
      ),
    );
  }
}
