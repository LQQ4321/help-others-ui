import 'package:flutter/material.dart';

class SingleSeekHelp {
  late String seekHelpId; //求组id
  late String problemLink; //题目链接
  late String topicRemark; //题目文字描述或备注
  late String uploadTime; //该求助上传的时间
  late String language; //语言类型
  late int maxHelp; //最多可以发布多少个帮助
  late int maxCommit; //最多发布多少评论
  late int score; //悬赏的分值
  late int like; //点赞数
  late int ban; //求助的权限
  late int status; //求助的状态

  SingleSeekHelp();

  factory SingleSeekHelp.fromJson(dynamic data) {
    SingleSeekHelp singleSeekHelp = SingleSeekHelp();
    singleSeekHelp.seekHelpId = data['ID'].toString();
    singleSeekHelp.problemLink = data['ProblemLink'];
    singleSeekHelp.topicRemark = data['TopicRemark'];
    singleSeekHelp.uploadTime = data['UploadTime'];
    singleSeekHelp.language = data['Language'];
    singleSeekHelp.maxHelp = data['MaxHelp'];
    singleSeekHelp.maxCommit = data['MaxComment'];
    singleSeekHelp.score = data['Score'];
    singleSeekHelp.like = data['Like'];
    singleSeekHelp.ban = data['Ban'];
    singleSeekHelp.status = data['Status'];
    return singleSeekHelp;
  }

  @override
  String toString() {
    return '$seekHelpId $problemLink $topicRemark $uploadTime $language $maxHelp $maxCommit $score $like $ban $status';
  }
}

class SeekHelpModel extends ChangeNotifier {
  // key 是日期，value是当天的求助列表。
  // 之前访问过的日期的求助列表数据，可以暂存在这个map里面，
  // 但是为了防止内存溢出，这里最多可以暂存5天的求助列表数据，
  // 当超过暂存上限的时候，就应该随便删除一天的求助数据，但不是当前正在浏览的日期
  Map<String, List<SingleSeekHelp>> seekHelpMap = {};

  // 展示的列表
  List<SingleSeekHelp> showSeekHelpList = [];

  // 当前正在浏览的日期
  String currentDate = '';

// Future<bool> request
}
