import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/data/rootData.dart';
import 'package:help_them/functions/functionOne.dart';
import 'package:help_them/macroWidgets/dialogOne.dart';
import 'package:help_them/macroWidgets/toastOne.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class SeekAHelp extends StatefulWidget {
  const SeekAHelp({Key? key, required this.isSeekHelp}) : super(key: key);
  final bool isSeekHelp;

  @override
  State<SeekAHelp> createState() => _SeekAHelpState();
}

class _SeekAHelpState extends State<SeekAHelp> {
  late List<TextEditingController> textEditingControllers;
  Color _color = Colors.black12;
  String _imageFileInfo = 'Please select a screenshot of the problem';
  String _codeFileInfo = 'Please select the code file';

  //FIXME 试着连续提交两次看看,会不会出现上一次的缓存，这一次还存在的情况,需要每次提交成功后，手动清空吗？
  List<int>? _imageContent;
  List<int>? _codeContent;
  String _imageType = '';
  String _codeType = '';
  String language = '';

  @override
  void initState() {
    textEditingControllers = List.generate(
        widget.isSeekHelp ? 3 : 1, (index) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < textEditingControllers.length; i++) {
      textEditingControllers[i].dispose();
    }
    //数组需要手动清除吗？
    _imageContent?.clear();
    _codeContent?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSeekHelp) {
      int curSeekHelpIndex =
          context.watch<RootDataModel>().seekHelpModel.curSeekHelpIndex;
      language = context
          .watch<RootDataModel>()
          .seekHelpModel
          .showSeekHelpList[curSeekHelpIndex]
          .language;
    }
    return Container(
      margin: const EdgeInsets.only(left: 150, right: 150),
      child: Column(
        children: [
          widget.isSeekHelp
              ? RectangleInput(
                  textEditingController: textEditingControllers[0],
                  icon: Icons.link,
                  labelText: 'Problem link')
              : Container(),
          Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.isSeekHelp ? 2 : 1, (index) {
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 5),
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(color: Colors.black12)),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    index == 0 ? _codeFileInfo : _imageFileInfo,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  )))),
                      const SizedBox(width: 20),
                      ClipOval(
                        child: Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: TextButton(
                                onPressed: () async {
                                  List<String> fileType = [];
                                  if (widget.isSeekHelp) {
                                    if (index == 0) {
                                      fileType.addAll(
                                          ConstantData.supportedLanguageFiles);
                                    } else {
                                      fileType.addAll(
                                          ConstantData.supportedPictureFiles);
                                    }
                                  } else {
                                    fileType.add(
                                        FunctionOne.switchFileTypeAndLang(
                                            false, language));
                                  }
                                  FilePickerResult? filePickerResult =
                                      await Config.selectAFile(fileType);
                                  if (filePickerResult == null) {
                                    return;
                                  }
                                  String fileInfo =
                                      '${filePickerResult.files.single.name}  ( ${filePickerResult.files.single.size} bytes )';
                                  setState(() {
                                    if (index == 1) {
                                      _imageType = filePickerResult
                                          .files.single.name
                                          .split('.')
                                          .last;
                                      _imageFileInfo = fileInfo;
                                      _imageContent = filePickerResult
                                          .files.single.bytes as List<int>;
                                      debugPrint(_imageType);
                                      debugPrint(_imageFileInfo);
                                    } else {
                                      _codeType = filePickerResult
                                          .files.single.name
                                          .split('.')
                                          .last;
                                      _codeFileInfo = fileInfo;
                                      _codeContent = filePickerResult
                                          .files.single.bytes as List<int>;
                                      debugPrint(_codeType);
                                      debugPrint(_codeFileInfo);
                                    }
                                  });
                                },
                                child: Icon(
                                  index == 0 ? Icons.file_open : Icons.image,
                                  color: Colors.black38,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              })),
          const SizedBox(height: 20),
          widget.isSeekHelp
              ? Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: RectangleInput(
                        textEditingController: textEditingControllers[1],
                        icon: Icons.attach_money,
                        labelText: 'Money reward',
                      ),
                    )
                  ],
                )
              : Container(),
          const SizedBox(height: 20),
          Expanded(
              child: Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: _color)),
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  if (hasFocus) {
                    _color = Colors.black;
                  } else {
                    _color = Colors.black12;
                  }
                });
              },
              child: Expanded(
                child: TextField(
                  controller: textEditingControllers[widget.isSeekHelp ? 2 : 0],
                  maxLines: 100,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      helperText: 'Remark'),
                ),
              ),
            ),
          )),
          const SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                if (index == 1) {
                  return const SizedBox(width: 50);
                }
                return ElevatedButton(
                    onPressed: () async {
                      if (index == 0) {
                        bool isConfirm = false;
                        await DialogOne.confirmInfoDialog(
                            context,
                            [
                              'Warn',
                              'Your action will not be saved, do you still want to exit ?'
                            ],
                            (p0) => isConfirm = p0);
                        if (isConfirm) {
                          context
                              .read<RootDataModel>()
                              .switchRoute(widget.isSeekHelp ? 1 : 3);
                        }
                      } else {
                        int flag = 0;
                        if (!widget.isSeekHelp) {
                          flag = await context.read<RootDataModel>().lendHand(3,
                              list: _codeContent,
                              list2: [
                                textEditingControllers[0].text,
                                _codeType
                              ]);
                        } else {
                          flag = await context.read<RootDataModel>().seekHelp(2,
                              texts: [
                                textEditingControllers[0].text,
                                textEditingControllers[1].text,
                                textEditingControllers[2].text,
                                _imageType,
                                _codeType
                              ],
                              list1: _codeContent,
                              list2: _imageContent);
                        }
                        if (flag == 0) {
                          context
                              .read<RootDataModel>()
                              .switchRoute(widget.isSeekHelp ? 1 : 3);
                        }
                        ToastOne.oneToast(
                            ConstantData.seekAHelpPromptMessage[flag],
                            infoStatus: flag == 0 ? 0 : 2,
                            duration: 8);
                      }
                    },
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(100, 40)),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => index == 0
                                ? Colors.redAccent
                                : Colors.blueAccent)),
                    child: Text(index == 0 ? 'CANCEL' : 'SAVE'));
              }))
        ],
      ),
    );
  }
}
