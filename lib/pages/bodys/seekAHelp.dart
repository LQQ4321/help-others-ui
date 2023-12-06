import 'package:flutter/material.dart';
import 'package:help_them/data/config.dart';
import 'package:help_them/data/constantData.dart';
import 'package:help_them/macroWidgets/widgetOne.dart';
import 'package:file_picker/file_picker.dart';

class SeekAHelp extends StatefulWidget {
  const SeekAHelp({Key? key}) : super(key: key);

  @override
  State<SeekAHelp> createState() => _SeekAHelpState();
}

class _SeekAHelpState extends State<SeekAHelp> {
  late List<TextEditingController> textEditingControllers;
  Color _color = Colors.black12;
  String _imageFileInfo = 'Please select a screenshot of the problem';
  String _codeFileInfo = 'Please select the code file';
  List<int>? _imageContent;
  List<int>? _codeContent;

  @override
  void initState() {
    textEditingControllers =
        List.generate(3, (index) => TextEditingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 150, right: 150),
      child: Column(
        children: [
          RectangleInput(
              textEditingController: textEditingControllers[0],
              icon: Icons.link,
              labelText: 'Problem link'),
          Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(2, (index) {
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
                                    index == 0 ? _imageFileInfo : _codeFileInfo,
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
                                  FilePickerResult? filePickerResult =
                                      await Config.selectAFile(index == 0
                                          ? ConstantData.supportedPictureFiles
                                          : ConstantData
                                              .supportedLanguageFiles);
                                  if (filePickerResult == null) {
                                    return;
                                  }
                                  String fileInfo =
                                      '${filePickerResult.files.single.name}  ( ${filePickerResult.files.single.size} bytes )';
                                  setState(() {
                                    if (index == 0) {
                                      _imageFileInfo = fileInfo;
                                      _imageContent = filePickerResult
                                          .files.single.bytes as List<int>;
                                    } else {
                                      _codeFileInfo = fileInfo;
                                      _codeContent = filePickerResult
                                          .files.single.bytes as List<int>;
                                    }
                                  });
                                },
                                child: Icon(
                                  index == 0 ? Icons.image : Icons.file_open,
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
          Row(
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
          ),
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
                  controller: textEditingControllers[2],
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
                    onPressed: () {
                      if (index == 0) {
                      } else {}
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