import 'package:flutter/material.dart';

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
