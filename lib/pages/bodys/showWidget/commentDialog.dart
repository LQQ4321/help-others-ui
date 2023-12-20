import 'package:flutter/material.dart';
import 'package:help_them/data/comment.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/macroWidgets/dialogOne.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/macroWidgets/widgetTwo.dart';
import 'package:provider/provider.dart';

class CommentDialog extends StatefulWidget {
  const CommentDialog({Key? key}) : super(key: key);

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  @override
  Widget build(BuildContext context) {
    CommentModel commentModel = context.watch<RootDataModel>().commentModel;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.95,
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xffe7e8ec), width: 1.0))),
            child: const _Title(),
          ),
          Expanded(child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth * 0.8,
              color: Colors.grey[100],
              child: ListView.builder(
                  itemCount: commentModel.showCommentList.length,
                  itemExtent: 90,
                  itemBuilder: (BuildContext context, int index) {
                    return _CommentCell(
                      sendTime: commentModel.showCommentList[index].sendTime,
                      senderName: commentModel.showCommentList[index].publisher,
                      sendContent: commentModel.showCommentList[index].text,
                    );
                  }),
            );
          }))
        ],
      ),
    );
  }
}

class _CommentCell extends StatelessWidget {
  const _CommentCell(
      {Key? key,
      required this.sendTime,
      required this.senderName,
      required this.sendContent})
      : super(key: key);
  final String sendTime;
  final String senderName;
  final String sendContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Card(
        child: InkWell(
          onTap: () async {
            await DialogOne.showTextField(context, sendContent);
          },
          child: Column(
            children: [
              Container(
                height: 30,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: List.generate(3, (index) {
                    if (index == 1) {
                      return const SizedBox(width: 20);
                    }
                    return Text(index == 0 ? sendTime : senderName,
                        style: const TextStyle(color: Colors.black45));
                  }),
                ),
              ),
              Container(height: 1, color: Colors.black12),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    sendContent,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 20),
            Text(
              'Comment',
              style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  String text = '';
                  await DialogOne.showMyDialog(
                      context, TextDialog(callBack: (a) => text = a));
                  if (text.isNotEmpty) {
                    bool flag = await context
                        .read<RootDataModel>()
                        .commentOperate(2, text: text);
                    if (!flag) {
                      ToastOne.oneToast([
                        'Comment fail',
                        'This could be due to network problems or server errors.'
                      ]);
                    }
                  }
                },
                splashRadius: 20,
                icon: const Icon(Icons.add)),
            const SizedBox(width: 20)
          ],
        )
      ],
    );
  }
}
