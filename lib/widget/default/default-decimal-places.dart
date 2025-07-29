import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/widget/input/radio-group-input.dart';

class DefaultDecimalPlaces extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const DefaultDecimalPlaces({Key? key, required this.onChanged})
      : super(key: key);

  @override
  _DefaultDecimalPlacesState createState() => _DefaultDecimalPlacesState();
}

class _DefaultDecimalPlacesState extends State<DefaultDecimalPlaces> {
  int _decimalPlaces = 0;

  final List<Map<String, String>> options = [0, 1, 2, 3].map((e) {
    return {
      'option': e.toString(),
      'value': e.toString(),
    };
  }).toList();

  @override
  void initState() {
    super.initState();
    _decimalPlaces = UserStateService.instance.defaultDecimalPlace!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppConfig.padding),
          child: Text(
            'Decimal Places',
            style: AppConfig.fontStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        RadioGroupInput(
            options: options,
            initialValue: _decimalPlaces.toString(),
            onChanged: (String value) {
              widget.onChanged(value);
            }),
      ],
    );
  }
}
