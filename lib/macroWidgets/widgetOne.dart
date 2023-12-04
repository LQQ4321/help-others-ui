import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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