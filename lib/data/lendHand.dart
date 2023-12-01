import 'package:flutter/material.dart';

class SingleLendHand {
  late String lendHandId; //帮助id
  late String seekHelpId; //对应的求助id
  late String uploadTime; //发布时间
  late String remark; //附带的解释信息
  late int like; //点赞数
  late int ban; //权限
  late int status; //状态

  SingleLendHand();

  factory SingleLendHand.fromJson(dynamic data) {
    SingleLendHand singleLendHand = SingleLendHand();
    singleLendHand.lendHandId = data['ID'].toString();
    singleLendHand.seekHelpId = data['SeekHelpId'].toString();
    singleLendHand.uploadTime = data['UploadTime'];
    singleLendHand.remark = data['Remark'];
    singleLendHand.like = data['Like'];
    singleLendHand.ban = data['Ban'];
    singleLendHand.status = data['Status'];
    return singleLendHand;
  }

  @override
  String toString() {
    return '$lendHandId $seekHelpId $uploadTime $remark $like $ban $status';
  }
}

class LendHandModel extends ChangeNotifier {
  // key 是求助id，value是
  Map<String,List<SingleLendHand>> lendHandMap = {};

}
