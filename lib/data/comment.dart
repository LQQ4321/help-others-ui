import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';

class SingleComment {
  late String commentId;
  late String text;
  late String sendTime;
  late int type;
  late String seekOrLendId;
  late String publisher;
  late String publisherId;
  late int like;

  SingleComment();

  factory SingleComment.fromJson(dynamic data) {
    SingleComment singleComment = SingleComment();
    singleComment.commentId = data['ID'].toString();
    singleComment.text = data['Text'];
    singleComment.sendTime = data['SendTime'];
    singleComment.type = data['Type'];
    singleComment.seekOrLendId = data['SeekOrLendId'].toString();
    singleComment.publisher = data['Publisher'];
    singleComment.publisherId = data['PublisherId'].toString();
    singleComment.like = data['Like'];
    return singleComment;
  }
}

class CommentModel {
  //跟其他组件交互不多，本地修改的次数较少，可以弄一个缓存
  //key = type.toString()+seekOrLendId
  Map<String, List<SingleComment>> commentMap = {};
  List<SingleComment> showCommentList = [];

  // list = [type,seekOrLendId,text,sendTime,publisher,publisherId]
  Future<bool> sendAComment(List<String> list) async {
    Map request = {'requestType': 'sendAComment', 'info': list};
    return await Config.dio
        .post(Config.requestJson, data: request)
        .then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      String key = list[0] + list[1];
      if (commentMap.containsKey(key)) {
        commentMap[key]!
            .insert(0, SingleComment.fromJson(value.data['comment']));
        showCommentList = commentMap[key]!;
      } else {
        debugPrint('func sendAComment : 讲道理应该包含才对的呀');
      }
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }

  Future<bool> requestCommentList(int type, String seekOrLendId) async {
    String key = type.toString() + seekOrLendId;
    if (commentMap.containsKey(key)) {
      //这里就不使用 showCommentList = [...commentMap[key]!];
      //就让它变成引用，到时候修改showCommentList,commentMap也就修改了
      //是我想的这样吗？感觉跟golang的切片一样，没那么想当然呀(底层数组改变，会影响到它们)
      showCommentList = commentMap[key]!;
      return true;
    }
    if (commentMap.length > 4) {
      for (final entry in commentMap.entries) {
        commentMap.remove(entry.key);
        break;
      }
    }
    Map request = {
      'requestType': 'requestList',
      'info': ['comment', type.toString(), seekOrLendId]
    };
    return await Config.dio
        .post(Config.requestJson, data: request)
        .then((value) {
      if (value.data[Config.status] != Config.succeedStatus) {
        return false;
      }
      List<dynamic> tempList = value.data['commentList'];
      commentMap[key] = List.generate(tempList.length, (index) {
        return SingleComment.fromJson(tempList[index]);
      });
      commentMap[key]!.sort((a, b) {
        return DateTime.parse(a.sendTime)
                .difference(DateTime.parse(b.sendTime))
                .inSeconds *
            -1;
      });
      showCommentList = commentMap[key]!;
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
