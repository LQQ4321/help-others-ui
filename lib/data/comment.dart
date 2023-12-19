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
  List<SingleComment> showCommentList = [];

  Future<bool> requestCommentList(int type, String seekOrLendId) async {
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
      showCommentList = List.generate(tempList.length, (index) {
        return SingleComment.fromJson(tempList[index]);
      });
      return true;
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      return false;
    });
  }
}
