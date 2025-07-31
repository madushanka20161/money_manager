import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';

class RadioGroupInput extends StatefulWidget {
  final List<Map<String, String>>
      options; // [{option:'Option 01', value: 'oprion01'}]
  final String? initialValue; // need to equal to value
  final ValueChanged<String> onChanged;

  const RadioGroupInput({
    Key? key,
    required this.options,
    this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _RadioGroupInputState createState() => _RadioGroupInputState();
}

class _RadioGroupInputState extends State<RadioGroupInput> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((option) {
        return RadioListTile<String>(
          title: Text(
            option['option']!,
            style: AppConfig.fontStyle,
          ),
          value: option['value']!,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });

            widget.onChanged(value!);
          },
          activeColor: Colors.white,
          dense: true,
          visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
        );
      }).toList(),
    );
  }
}
