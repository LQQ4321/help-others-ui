import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogButtons extends StatefulWidget {
  //list包含的数据[前两个按钮的文字，操作失败后的提示信息]
  DialogButtons(
      {Key? key,
      required this.list,
      required this.funcList,
      this.confirmButtonColor = Colors.redAccent})
      : super(key: key);
  final List<String> list;
  final Color confirmButtonColor;
  List<Function> funcList;

  @override
  State<DialogButtons> createState() => _DialogButtonsState();
}

class _DialogButtonsState extends State<DialogButtons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 50)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xfff0f9fe))),
              child: Text(
                widget.list[0],
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              )),
          const SizedBox(width: 20),
          ElevatedButton(
              onPressed: () {
                // if (!widget.funcList[0]()) {
                //   MyDialogs.oneToast([widget.list[2], widget.list[3]],
                //       infoStatus: 2, duration: 5);
                //   return;
                // }
                widget.funcList[1](true);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => widget.confirmButtonColor),
                  minimumSize: MaterialStateProperty.all(const Size(100, 50))),
              child: Text(
                widget.list[1],
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              )),
        ],
      ),
    );
  }
}

class MyPopupMenu extends StatefulWidget {
  const MyPopupMenu(
      {Key? key,
      required this.list,
      required this.callBack,
      this.iconData = Icons.keyboard_arrow_down_sharp})
      : super(key: key);
  final List<String> list;
  final Function(int) callBack;
  final IconData iconData;

  @override
  State<MyPopupMenu> createState() => _MyPopupMenuState();
}

class _MyPopupMenuState extends State<MyPopupMenu> {
  int _item = 0;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        initialValue: _item,
        onSelected: (int item) {
          setState(() {
            _item = item;
          });
          widget.callBack(item);
        },
        tooltip: '',
        child: Container(
          height: 30,
          padding: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.list[_item],
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Icon(
                widget.iconData,
                color: Colors.black,
              )
            ],
          ),
        ),
        itemBuilder: (BuildContext context) {
          return List.generate(widget.list.length, (index) {
            return PopupMenuItem<int>(
                value: index, child: Text(widget.list[index]));
          });
        });
  }
}

//一个圆角输入框，左侧可以添加一个图标
// (输入回车键后，textEditingController的text可能会被清空，
// 这取决于setState被调用后，textEditingController是否在刷新页面的内部被初始化)
class FilletCornerInput extends StatefulWidget {
  const FilletCornerInput(
      {Key? key,
      required this.textEditingController,
      this.iconData = Icons.search,
      required this.hintText,
      required this.callBack})
      : super(key: key);
  final IconData iconData;
  final TextEditingController textEditingController;
  final String hintText;
  final Function(String) callBack;

  @override
  State<FilletCornerInput> createState() => _FilletCornerInputState();
}

class _FilletCornerInputState extends State<FilletCornerInput> {
  Color _color = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _color),
          borderRadius: BorderRadius.circular(4)),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            if (hasFocus) {
              _color = Colors.black; //到底什么情况下Colors.red[200]会是空呢？？？
            } else {
              _color = Colors.black12;
            }
          });
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Icon(widget.iconData),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(bottom: 7),
              child: TextField(
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                maxLength: 50,
                maxLines: 1,
                controller: widget.textEditingController,
                onSubmitted: (value) {
                  widget.callBack(value);
                  //不判断是否为空了，这样上层的数据处理就会更加灵活
                  // if (value.isNotEmpty) {
                  //   widget.callBack(value);
                  // }
                },
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  //如果输入内容为空，就显示提示信息，反之显示输入内容
                  hintText: widget.textEditingController.text.isEmpty
                      ? widget.hintText
                      : widget.textEditingController.text,
                  hintStyle: const TextStyle(color: Colors.black38),
                ),
              ),
            ))
          ],
        ),
      ),
    );
    ;
  }
}

//一个矩形的数据框
class RectangleInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final IconData icon;
  final String labelText;
  final bool eye;

  const RectangleInput(
      {Key? key,
      required this.textEditingController,
      required this.icon,
      required this.labelText,
      this.eye = false})
      : super(key: key);

  @override
  State<RectangleInput> createState() => _RectangleInputState();
}

class _RectangleInputState extends State<RectangleInput> {
  Color _color = Colors.black12;
  bool _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.eye;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: _color)),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            if (hasFocus) {
              _color = Colors.black; //到底什么情况下Colors.red[200]会是空呢？？？
            } else {
              _color = Colors.black12;
            }
          });
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Icon(widget.icon),
            ),
            Expanded(
                child: Center(
              child: TextField(
                inputFormatters: widget.eye
                    ? [FilteringTextInputFormatter.allow(RegExp(r'[ -~]'))]
                    : [],
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
                controller: widget.textEditingController,
                obscureText: _obscureText,
                maxLines: 1,
                maxLength: 50,
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  labelText: widget.labelText,
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            )),
            widget.eye
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    splashRadius: 20,
                    icon: const Icon(Icons.remove_red_eye))
                : Container()
          ],
        ),
      ),
    );
  }
}
