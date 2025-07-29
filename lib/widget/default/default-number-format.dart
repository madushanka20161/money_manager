import 'package:flutter/material.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/widget/input/radio-group-input.dart';

class DefaultNumberFormat extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const DefaultNumberFormat({Key? key, required this.onChanged})
      : super(key: key);

  @override
  _DefaultNumberFormatState createState() => _DefaultNumberFormatState();
}

class _DefaultNumberFormatState extends State<DefaultNumberFormat> {
  String _numberFormat = '';

  final List<Map<String, String>> options =
      NumberSelectionStyleType.values.map((e) {
    return {
      'option': e.displayName,
      'value': e.toString(),
    };
  }).toList();

  @override
  void initState() {
    super.initState();
    _numberFormat = UserStateService.instance.defaultNumberSeperationStyle!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppConfig.padding),
          child: Text(
            'Number Format',
            style: AppConfig.fontStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        RadioGroupInput(
            options: options,
            initialValue: _numberFormat,
            onChanged: (String value) {
              widget.onChanged(value);
            }),
      ],
    );
  }
}
