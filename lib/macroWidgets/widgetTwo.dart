import 'package:flutter/material.dart';
import 'package:help_them/macroWidgets/toastOne.dart';

class FlexInputField extends StatefulWidget {
  const FlexInputField(
      {Key? key, required this.textEditingController, required this.helperText})
      : super(key: key);
  final TextEditingController textEditingController;
  final String? helperText;

  @override
  State<FlexInputField> createState() => _FlexInputFieldState();
}

class _FlexInputFieldState extends State<FlexInputField> {
  Color _color = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
        //FIXME flutter run 可以输入，但flutter build 无法输入
        child: TextField(
          controller: widget.textEditingController,
          maxLines: 100,
          maxLength: 1000,
          decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              helperText: widget.helperText),
        ),
      ),
    ));
  }
}

class TextDialog extends StatefulWidget {
  const TextDialog({Key? key, required this.callBack}) : super(key: key);
  final Function(String) callBack;

  @override
  State<TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<TextDialog> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          FlexInputField(
              textEditingController: textEditingController, helperText: null),
          const SizedBox(height: 20),
          SizedBox(
              height: 50,
              child: Row(
                children: List.generate(3, (index) {
                  if (index == 1) {
                    return const SizedBox(width: 20);
                  }
                  return Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (index == 0) {
                            Navigator.pop(context);
                          } else {
                            if (textEditingController.text.isEmpty) {
                              ToastOne.oneToast([
                                'Format error',
                                'The input cannot be empty.'
                              ]);
                            } else {
                              widget.callBack(textEditingController.text);
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, double.infinity)),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => index == 0
                                    ? Colors.redAccent
                                    : Colors.blueAccent)),
                        child: Text(
                          index == 0 ? 'Cancel' : 'Confirm',
                          style: const TextStyle(color: Colors.white),
                        )),
                  );
                }),
              ))
        ],
      ),
    );
  }
}

class DateTimePicker extends StatefulWidget {
  const DateTimePicker(
      {Key? key, required this.oldDate, required this.callBack})
      : super(key: key);
  final String oldDate;
  final Function(String) callBack;

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    initTime();
    super.initState();
  }

  void initTime() {
    selectedDate = DateTime.parse(widget.oldDate);
  }

  void setDate() {
    widget.callBack(selectedDate.toString().split(' ')[0]);
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        setDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              _selectDate(context);
            },
            icon: const Icon(Icons.date_range)),
        const SizedBox(width: 20),
        Text(
          selectedDate.toString().split(' ')[0],
          style: const TextStyle(
              fontSize: 14, color: Colors.black38, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
