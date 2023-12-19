import 'package:flutter/material.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/seekHelp.dart';

class FunctionOne {
  //判断是否具有某种权限
  // static bool judgeBan(int option,int ban,{int userBan = 0}) {
  //
  // }
  // 0 default 1 green 2 red
  static Map<String, TextStyle> getCodeTextStyle({int option = 0}) {
    //这里也是引用
    Map<String, TextStyle> theme = ConstantData.githubTheme;
    if (option == 0) {
      theme['root'] = const TextStyle(
          color: Color(0xff333333), backgroundColor: Color(0xffffffff));
    } else if (option == 1) {
      theme['root'] = const TextStyle(
          color: Color(0xff333333), backgroundColor: Color(0xffffebe9));
    } else if (option == 2) {
      theme['root'] = const TextStyle(
          color: Color(0xff333333), backgroundColor: Color(0xffe6ffec));
    }
    return theme;
  }

  //FIXME 计算文字宽度(有个问题,就是'\t'当作空格计算了，导致某些包含较多'\t'的行显示不完)
  static double calculateText(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style));
    textPainter.layout();
    return textPainter.width;
  }

  //划分每一行
  static List<String> splitTextIntoLines(
      BuildContext context, String text, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: DefaultTextStyle.of(context).style,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    textPainter.layout(maxWidth: maxWidth);

    final List<String> lines = [];
    final int textLength = text.length;

    int startIndex = 0;
    int endIndex = textLength;

    while (startIndex < endIndex) {
      final endPosition = textPainter.getPositionForOffset(
        Offset(maxWidth, textPainter.height),
      );

      String line = text.substring(startIndex, endIndex);

      if (endPosition.offset < textLength) {
        final lastSpaceIndex = line.lastIndexOf(' ');

        if (lastSpaceIndex != -1) {
          endIndex = startIndex + lastSpaceIndex;
          line = text.substring(startIndex, endIndex);
        }
      }
      lines.add(line);
      startIndex = endIndex;
      endIndex = textLength;
    }
    return lines;
  }

  static String switchFileTypeAndLang(bool isFileType, String arg) {
    if (isFileType) {
      for (int i = 0; i < ConstantData.supportedLanguageFiles.length; i++) {
        if (ConstantData.supportedLanguageFiles[i] == arg) {
          return ConstantData.supportedLanguages[i];
        }
      }
    } else {
      for (int i = 0; i < ConstantData.supportedLanguages.length; i++) {
        if (ConstantData.supportedLanguages[i] == arg) {
          return ConstantData.supportedLanguageFiles[i];
        }
      }
    }
    return 'Not selected';
  }

  static dynamic switchLanguage(dynamic option) {
    if (option is int) {
      return ConstantData.supportedLanguages[option - 1];
    } else {
      for (int i = 0; i < ConstantData.supportedLanguages.length; i++) {
        if (ConstantData.supportedLanguages[i] == option) {
          return i + 1;
        }
      }
      return 0;
    }
  }

  static String parseSeekHelpListData(int option, SingleSeekHelp data) {
    if (option == 0) {
      return data.status == 0 ? 'Unsolved' : 'Resolved';
    } else if (option == 1) {
      return data.score.toString();
    } else if (option == 2) {
      return data.like.toString();
    } else if (option == 3) {
      return data.uploadTime.split(' ')[1];
    }
    return data.language;
  }
}
