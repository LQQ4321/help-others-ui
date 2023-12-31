import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/macroUserData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container()),
        const SizedBox(height: 20),
        const _Contributions()
      ],
    );
  }
}

class _ContributionCells extends StatelessWidget {
  const _ContributionCells({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Contributions contributions =
        context.watch<RootDataModel>().userData.contributions;
    return Column(
      children: [
        Container(
          height: 25,
          width: 54 * (15 + 2),
          margin: const EdgeInsets.only(left: 50),
          padding: const EdgeInsets.only(right: 4 * 17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(ConstantData.monthName.length, (index) {
              return Text(ConstantData.monthName[index]);
            }),
          ),
        ),
        Expanded(
            child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Column(
                children: List.generate(ConstantData.dayOfWeek.length, (index) {
                  if (index % 2 == 0) {
                    return const SizedBox(height: 18);
                  }
                  return Text(ConstantData.dayOfWeek[index].substring(0, 3));
                }),
              ),
            ),
            Expanded(
                child: Row(
              children: List.generate(54, (columnIndex) {
                return Column(
                  children: List.generate(7, (rowIndex) {
                    StatusOfDay statusOfDay = contributions
                        .contributionTable[columnIndex * 7 + rowIndex];
                    return statusOfDay.isBlank
                        ? Container()
                        : MouseRegion(
                            child: Tooltip(
                              verticalOffset: 10,
                              preferBelow: false,
                              message: contributions
                                  .getTooltip(columnIndex * 7 + rowIndex),
                              child: Container(
                                width: 15,
                                height: 15,
                                margin: const EdgeInsets.only(right: 2, top: 2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xffdfe1e4)),
                                    color: statusOfDay.lendHand +
                                                statusOfDay.seekHelp >=
                                            ConstantData
                                                .contributionColors.length
                                        ? ConstantData.contributionColors.last
                                        : ConstantData.contributionColors[0],
                                    borderRadius: BorderRadius.circular(2)),
                              ),
                            ),
                          );
                  }),
                );
              }),
            ))
          ],
        ))
      ],
    );
  }
}

class _Contributions extends StatefulWidget {
  const _Contributions({Key? key}) : super(key: key);

  @override
  State<_Contributions> createState() => _ContributionsState();
}

class _ContributionsState extends State<_Contributions> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Contributions contributions =
        context.watch<RootDataModel>().userData.contributions;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)),
      height: 240,
      child: Column(
        children: [
          Scrollbar(
            controller: scrollController,
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  itemCount:
                      contributions.nowYear - contributions.registerYear + 1,
                  itemExtent: 80,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 8, top: 5, bottom: 5),
                      child: ElevatedButton(
                          onPressed: () async {
                            await context
                                .read<RootDataModel>()
                                .userOperate(10, numList: [index]);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => (index ==
                                        contributions.curYear -
                                            contributions.registerYear)
                                    ? Colors.blue
                                    : Colors.grey),
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, double.infinity)),
                          ),
                          child: Text(
                            '${contributions.registerYear + index}',
                            style: TextStyle(
                                color: (index ==
                                        contributions.curYear -
                                            contributions.registerYear)
                                    ? Colors.white
                                    : Colors.black),
                          )),
                    );
                  }),
            ),
          ),
          const Expanded(child: _ContributionCells()),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Learn how we count contributions',
                      style: TextStyle(color: Colors.black38),
                    )),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Less  ',
                        style: TextStyle(fontSize: 12, color: Colors.black38)),
                    Row(
                      children: List.generate(
                          ConstantData.contributionColors.length, (index) {
                        return Container(
                          width: 15,
                          height: 15,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xffdfe1e4)),
                              color: ConstantData.contributionColors[index],
                              borderRadius: BorderRadius.circular(2)),
                        );
                      }),
                    ),
                    const Text('More',
                        style: TextStyle(fontSize: 12, color: Colors.black38))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
