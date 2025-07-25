import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/popup-helper.dart';

class CurrencySelection extends StatefulWidget {
  final double? width;
  final double? height;
  final Function? onCurrencyChange;
  final String? selectedCurrency;
  
  const CurrencySelection({
    super.key,
    this.width,
    this.height,
    this.onCurrencyChange,
    this.selectedCurrency,
  });
  
  @override
  _CreateCurrencySelection createState() => _CreateCurrencySelection();
}

class _CreateCurrencySelection extends State<CurrencySelection> {
  String _selectedCurrency = defaultCurrency;

  @override
  void initState() {
    super.initState();

    if (widget.selectedCurrency != null) {
      _selectedCurrency = widget.selectedCurrency!;
    }
  }
  
  Widget _buildOption(BuildContext context, Map<String, String> currencyObj) {
    String currency = currencyObj['code']!;
    String countryName = currencyObj['country']!;

    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedCurrency = currency;
        });

        if (widget.onCurrencyChange != null) {
          widget.onCurrencyChange?.call(currency);
        }

        Navigator.pop(context);
      },
      child: Container(
        color: _selectedCurrency == currency ? AppConfig.buttonSelectedColor : Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                countryName,
                style: AppConfig.fontStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                currency,
                style: AppConfig.fontStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showPopup(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Select a currency",
          style: AppConfig.fontStyle,
        ),
        SizedBox(height: 12),

        SizedBox(
          height:  MediaQuery.of(context).size.height - 12,
          child: SingleChildScrollView(
            child: Column(
              children: currencyList
                  .map((Map<String, String> currencyObj) =>
                      _buildOption(context, currencyObj))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return Container(
          padding: EdgeInsets.only(top: AppConfig.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  PopupHelper.showPopup(context, [_showPopup(context)], isFullWidth: true);
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.buttonSelectedColor,
                  padding: EdgeInsets.all(AppConfig.padding),
                  textStyle: TextStyle(fontSize: AppConfig.fontSize,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width, 60)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedCurrency, style: TextStyle(color: AppConfig.fontColor),),
                    Icon(Icons.arrow_drop_down, size: AppConfig.iconSize, color: AppConfig.fontColor,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}