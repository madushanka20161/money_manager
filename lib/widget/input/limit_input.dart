import 'package:flutter/material.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/widget/input/text-input.dart';

class LimitInput extends StatefulWidget {
  final CategoryLimitType limitType;
  final double limitValue;
  final Function onTypeChange;
  final Function onValueChange;

  LimitInput({
    required this.limitType,
    required this.limitValue,
    required this.onTypeChange,
    required this.onValueChange,
  });

  @override
  _LimitInputState createState() => _LimitInputState();
}

class _LimitInputState extends State<LimitInput> {
  late CategoryLimitType _limitType;
  double _limitValue = 0.0;
  final TextEditingController _limitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _limitType = widget.limitType;
    _limitValue = widget.limitValue;
    _limitController.text = _limitValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
              padding: EdgeInsets.only(top: AppConfig.padding),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(10, 55),
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _limitType = _limitType == CategoryLimitType.value
                        ? CategoryLimitType.percentage
                        : CategoryLimitType.value;
                  });

                  widget.onTypeChange(_limitType);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(capitalizeFirstLetter(_limitType.displayName),
                        style: AppConfig.fontStyle),
                    Icon(Icons.unfold_more_sharp, color: AppConfig.iconColor),
                  ],
                ),
              )),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: AppConfig.padding),
            // TODO [V2 - once user click the input need to clear the value]
            child: TextInput(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }

                final number = num.tryParse(value);
                if (number == null) {
                  return 'Please enter a valid number';
                }

                if (_limitType == CategoryLimitType.percentage &&
                    (number < 0 || number > 100)) {
                  return 'The percentage must be between 0 and 100';
                }

                if (_limitType == CategoryLimitType.value && number < 0) {
                  return 'The value must be greater than 0';
                }

                return null;
              },
              inputController: _limitController,
              label: 'Limit',
              inputType: TextInputType.number,
              onChange: (value) {
                setState(() {
                  _limitValue = double.tryParse(value) ?? 0.0;
                });

                widget.onValueChange(_limitValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}
