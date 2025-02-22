import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/widget/input/text-input.dart';

class DateInput extends StatefulWidget {
  final TextEditingController dateController;
  final Function onChange;

  const DateInput({
    required this.dateController,
    required this.onChange,
  });

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    setState(() {
      widget.dateController.text = "${pickedDate?.year}-${pickedDate?.month.toString().padLeft(2, '0')}-${pickedDate?.day.toString().padLeft(2, '0')}";
    });

    widget.onChange(pickedDate);
    }

  void _formatDate(String value) {
    String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (newValue.length > 8) newValue = newValue.substring(0, 8);

    String formatted = "";
    for (int i = 0; i < newValue.length; i++) {
      if (i == 4 || i == 6) formatted += "-";
      formatted += newValue[i];
    }

    widget.dateController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    DateTime? parsedDate;
    if (formatted.length == 10) { // Only parse if it's a full YYYY-MM-DD
      parsedDate = DateTime.tryParse(formatted);
      widget.onChange(parsedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextInput(
      inputController: widget.dateController,
      label: 'Date',
      onChange: (value) {
        _formatDate(value);
      },
      validator: (value) {
        return null;
      },
      hintText: "YYYY-MM-DD",
      inputType: TextInputType.datetime,
        suffixIcon: IconButton(
        icon: Icon(Icons.calendar_today, color: AppConfig.fontColor),
        onPressed: () => _selectDate(context),
      ),
    );
  }
}
