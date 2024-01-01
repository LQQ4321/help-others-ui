import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/lendHand.dart';
import 'package:help_them/data/macroLendHand.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/data/seekHelp.dart';
import 'package:help_them/macroWidgets/dialogOne.dart';
import 'package:help_them/pages/bodys/showWidget/commentDialog.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:provider/provider.dart';

class CodeShowTopBar extends StatefulWidget {
  const CodeShowTopBar({Key? key}) : super(key: key);

  @override
  State<CodeShowTopBar> createState() => _CodeShowTopBarState();
}

class _CodeShowTopBarState extends State<CodeShowTopBar> {
  @override
  Widget build(BuildContext context) {
    ShowInfo showInfo = context.watch<RootDataModel>().showInfo;
    bool isSeekHelp = showInfo.curRightShowPage < 0;
    //看一下监听方法会不会报错
    // SeekHelpModel seekHelpModel = context.watch<RootDataModel>().seekHelpModel;
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          //  左边是特性，右边是共有
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: isSeekHelp
                      ? const _SeekHelpInfo()
                      : const _LendHandInfo()),
              const _LikeAndComment()
            ],
          )),
          const SizedBox(width: 20),
          Container(width: 1, color: Colors.black12),
          const SizedBox(width: 20),
          Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(2, (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                        child: Center(
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Builder(
                                  //套一层，免得ToastOne.smallTip定位不到具体的位置
                                  builder: (context) {
                                    return TextButton(
                                        onPressed: () async {
                                          if (index == 0) {
                                            ToastOne.smallTip(
                                                context, 'Copied');
                                            Clipboard.setData(ClipboardData(
                                                text: showInfo.problemLink));
                                          } else if (index == 1) {
                                            DialogOne.showAPicture(context,
                                                showInfo.imageProvider);
                                          }
                                        },
                                        child: Icon(
                                          ConstantData
                                              .showRouteTopBarIcons[index],
                                          color: Colors.black12,
                                          size: 20,
                                        ));
                                  },
                                )))),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(index == 0 ? 'Link' : 'Screenshot',
                            style: const TextStyle(color: Colors.black38)),
                        const SizedBox(width: 5)
                      ],
                    )
                  ],
                );
              }))
        ],
      ),
    );
  }
}

class _LikeAndComment extends StatefulWidget {
  const _LikeAndComment({Key? key}) : super(key: key);

  @override
  State<_LikeAndComment> createState() => _LikeAndCommentState();
}

class _LikeAndCommentState extends State<_LikeAndComment> {
  late bool favorite;

  @override
  Widget build(BuildContext context) {
    //TODO 如果还调用notifyListeners，这里好像就死循环了,可能是更新不能及时显示的原因
    favorite = context.watch<RootDataModel>().syncUserOperate(1);
    ShowInfo showInfo = context.watch<RootDataModel>().showInfo;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
                child: Center(
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Builder(
                          //套一层，免得ToastOne.smallTip定位不到具体的位置
                          builder: (context) {
                            return TextButton(
                                onPressed: () async {
                                  if (index == 0) {
                                    DialogOne.showTextField(
                                        context, showInfo.remark);
                                  } else if (index == 1) {
                                    //连续点两下会怎么样？？？
                                    //点赞不能取消
                                    if (favorite) {
                                      ToastOne.oneToast([
                                        'Cancel fail',
                                        'Once you like, you can not cancel it.'
                                      ], duration: 10);
                                      return;
                                    }
                                    //不能自己给自己点赞
                                    //FIXME 为什么seekHelp和lendHand可以是同一个人2023-12-21，
                                    //可能的原因是下面的方法是异步的？没有等他执行完就执行下面的代码了？(个人感觉不是)
                                    if (!context
                                        .read<RootDataModel>()
                                        .syncUserOperate(2)) {
                                      ToastOne.oneToast([
                                        'Like fail',
                                        'Can not give yourself a like.'
                                      ], duration: 10);
                                      return;
                                    }
                                    bool flag = await context
                                        .read<RootDataModel>()
                                        .userOperate(5);
                                    if (!flag) {
                                      ToastOne.oneToast([
                                        'Like fail',
                                        'The network is disconnected or the back-end is faulty.'
                                      ], duration: 10);
                                    }
                                  } else {
                                    bool flag = await context
                                        .read<RootDataModel>()
                                        .commentOperate(1);
                                    if (!flag) {
                                      ToastOne.oneToast([
                                        'Request data fail',
                                        'This could be due to network problems or server errors.'
                                      ]);
                                      return;
                                    }
                                    await DialogOne.showMyDialog(
                                        context, const CommentDialog(),
                                        padding: EdgeInsets.zero);
                                  }
                                },
                                child: Icon(
                                  index == 1 && !favorite
                                      ? Icons.favorite_border
                                      : ConstantData
                                          .showRouteTopBarIcons[index + 2],
                                  color: index == 1 && favorite
                                      ? Colors.red[200]
                                      : Colors.black12,
                                  size: 20,
                                ));
                          },
                        )))),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(index == 0 ? 'Remark' : (index == 1 ? 'Like' : 'Comment'),
                    style: const TextStyle(color: Colors.black38)),
                const SizedBox(width: 5)
              ],
            )
          ],
        );
      }),
    );
  }
}

class _LendHandInfo extends StatelessWidget {
  const _LendHandInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LendHandModel lendHandModel = context.watch<RootDataModel>().lendHandModel;
    ShowInfo showInfo = context.watch<RootDataModel>().showInfo;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index % 2 == 1) {
          return const SizedBox(width: 20);
        }
        return Text(
          index == 0
              ? lendHandModel
                  .showLendHandList[showInfo.curRightShowPage].lendHanderName
              : (index == 2
                  ? lendHandModel
                      .showLendHandList[showInfo.curRightShowPage].uploadTime
                  : (lendHandModel.showLendHandList[showInfo.curRightShowPage]
                              .status ==
                          0
                      ? 'Not adopted'
                      : 'Adopted')),
          style: const TextStyle(color: Colors.black38),
        );
      }),
    );
  }
}

class _SeekHelpInfo extends StatelessWidget {
  const _SeekHelpInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SeekHelpModel seekHelpModel = context.watch<RootDataModel>().seekHelpModel;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index % 2 == 1) {
          return const SizedBox(width: 20);
        }
        return Text(
          index == 0
              ? seekHelpModel.singleSeekHelp.seekHelperName
              : (index == 2
                  ? seekHelpModel.singleSeekHelp.uploadTime
                  : (seekHelpModel.singleSeekHelp.status == 0
                      ? 'Unsolved'
                      : 'Resolved')),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(color: Colors.black38),
        );
      }),
    );
  }
}
