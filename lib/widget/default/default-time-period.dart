import 'package:flutter/material.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/widget/input/radio-group-input.dart';

class DefaultTimePeriod extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const DefaultTimePeriod({Key? key, required this.onChanged})
      : super(key: key);

  @override
  _DefaultTimePeriodState createState() => _DefaultTimePeriodState();
}

class _DefaultTimePeriodState extends State<DefaultTimePeriod> {
  String _selectedOption = '';

  final List<Map<String, String>> options =
      TimePeriod.values.where((e) => e != TimePeriod.custom).map((e) {
    return {
      'option': capitalizeFirstLetter(e.displayName),
      'value': e.displayName,
    };
  }).toList();

  @override
  void initState() {
    super.initState();

    _selectedOption = UserStateService.instance.defaultTimePeriod!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppConfig.padding),
          child: Text(
            'Default Time Period',
            style: AppConfig.fontStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        // SizedBox(height: 10),
        RadioGroupInput(
            options: options,
            initialValue: _selectedOption,
            onChanged: (String value) {
              widget.onChanged(value);
            }),
        rednerHorizontalLine(),
      ],
    );
  }

  Widget rednerHorizontalLine() {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }
}
