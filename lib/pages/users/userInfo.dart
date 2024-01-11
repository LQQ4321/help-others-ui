import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/macroUserData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/data/userData.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: _UserBasicInfo()),
        SizedBox(height: 20),
        _Contributions()
      ],
    );
  }
}

class _UserBasicInfo extends StatefulWidget {
  const _UserBasicInfo({Key? key}) : super(key: key);

  @override
  State<_UserBasicInfo> createState() => _UserBasicInfoState();
}

class _UserBasicInfoState extends State<_UserBasicInfo> {
  @override
  Widget build(BuildContext context) {
    UserData userData = context.watch<RootDataModel>().userData;
    Contributions contributions = context.watch<RootDataModel>().contributions;
    String parseUserInfo(int option) {
      if (option == 0) {
        return '${userData.name} (${userData.ban == 1 ? 'free' : 'ban'})';
      } else if (option == 1) {
        return userData.email;
      } else if (option == 2) {
        return userData.registerTime;
      } else if (option == 3) {
        return userData.score.toString();
      } else if (option == 4) {
        return contributions.seekHelpList.length.toString();
      } else {
        return contributions.lendHandList.length.toString();
      }
    }

    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Expanded(
                child: Column(
              children:
                  List.generate(ConstantData.userInfoIcons.length, (index) {
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10),
                            Icon(ConstantData.userInfoIcons[index]),
                            const SizedBox(width: 10),
                            Text(ConstantData.userInfoMean[index]),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(':'),
                      const SizedBox(width: 20),
                      Text(parseUserInfo(index))
                    ],
                  ),
                );
              }),
            )),
            Expanded(
                child: Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<RootDataModel>().logoutWebsite();
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red)),
                child: const Text('Log out'),
              ),
            ))
          ],
        ));
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
    Contributions contributions = context.watch<RootDataModel>().contributions;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)),
      height: 230,
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
                                .contributionOperate(1, numList: [index]);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => (index ==
                                        contributions.nowYear -
                                            contributions.curYear)
                                    ? Colors.blue
                                    : Colors.grey),
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, double.infinity)),
                          ),
                          child: Text(
                            '${contributions.nowYear - index}',
                            style: TextStyle(
                                color: (index ==
                                        contributions.nowYear -
                                            contributions.curYear)
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
                Text(
                  '${contributions.contributionsOfYear} contributions in the year,thanks for your hard work',
                  style: const TextStyle(color: Colors.black38),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Less  ',
                        style: TextStyle(fontSize: 12, color: Colors.black38)),
                    Row(
                      children: List.generate(
                          ConstantData.contributionColors.length, (index) {
                        return MouseRegion(
                          child: Tooltip(
                            verticalOffset: 10,
                            preferBelow: false,
                            message: 'Contributions ${_parseOptions(index)}',
                            child: Container(
                              width: 15,
                              height: 15,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffdfe1e4)),
                                  color: ConstantData.contributionColors[index],
                                  borderRadius: BorderRadius.circular(2)),
                            ),
                          ),
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

  String _parseOptions(int option) {
    if (option == 0) {
      return '= 0';
    } else if (option >= 4) {
      return '>= 4';
    }
    return '= $option';
  }
}

class _ContributionCells extends StatelessWidget {
  const _ContributionCells({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Contributions contributions = context.watch<RootDataModel>().contributions;
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
                        ? Container(
                            width: 15,
                            height: 15,
                            margin: const EdgeInsets.only(right: 2, top: 2),
                          )
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
                                                statusOfDay.seekHelp +
                                                1 >=
                                            ConstantData
                                                .contributionColors.length
                                        ? ConstantData.contributionColors.last
                                        : ConstantData.contributionColors[
                                            statusOfDay.lendHand +
                                                statusOfDay.seekHelp],
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
