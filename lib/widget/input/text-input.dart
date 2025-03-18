import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';

class TextInput extends StatefulWidget {
  final TextEditingController inputController;
  final String label;
  final TextInputType? inputType;
  final Function onChange;
  final FormFieldValidator? validator;
  final String? hintText;
  final IconButton? suffixIcon;
  final bool? forceValidate;
  final double? topPadding;

  const TextInput({
    super.key,
    required this.inputController,
    required this.label,
    this.inputType,
    required this.onChange,
    this.validator,
    this.hintText,
    this.suffixIcon,
    this.forceValidate,
    this.topPadding,
  });
  
  @override
  _CreateTextInput createState() => _CreateTextInput();
}

class _CreateTextInput extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid ${widget.label}';
        }
        return null;
      },
      initialValue: widget.inputController.text,
      builder: (FormFieldState<String> state) {
        if (widget.forceValidate != null && widget.forceValidate == true) {
          // ignore: invalid_use_of_protected_member
          state.setValue(widget.inputController.text);
          state.validate();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: widget.topPadding ?? AppConfig.padding),
              child: TextFormField(
                controller: widget.inputController,
                style: TextStyle(
                  color: AppConfig.fontColor, 
                  fontSize: AppConfig.fontSize
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hintText,
                  labelStyle: TextStyle(
                    color: AppConfig.fontColor, 
                    fontSize: AppConfig.fontSize
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                    borderSide: BorderSide(
                      color: AppConfig.borderColor, 
                      width: AppConfig.borderWidth
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                    borderSide: BorderSide(color: AppConfig.focusedBorderColor),
                  ),
                  suffixIcon: widget.suffixIcon,
                ),
                keyboardType: widget.inputType ?? TextInputType.text,
                onChanged: (value) {
                  widget.onChange(value);

                  setState(() {
                    state.didChange(value);
                    state.validate();
                  });
                },
              ),
            ),
            if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                state.errorText!,
                style: TextStyle(
                  color: AppConfig.errorFontColor, 
                  fontSize: AppConfig.errorFontSize
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}